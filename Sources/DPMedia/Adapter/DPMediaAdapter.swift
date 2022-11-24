//
//  DPMediaAdapter.swift
//  Demo
//
//  Created by Дмитрий Поляков on 20.11.2022.
//

import Foundation
import UIKit
import Photos
import PhotosUI

open class DPMediaAdapter: NSObject, DPMediaAdapterInterface {
    
    // MARK: - Init
    public init(
        viewController: UIViewController? = nil,
        picker: DPMediaPickerFactory = DPMediaPicker(),
        videoProcessor: DPMediaVideoProcessorFactory = DPMediaVideoProcessor(),
        imageProcessor: DPMediaImageProcessorFactory = DPMediaImagePNGProcessor(),
        didFinish: ((Result<[DPMedia], Error>) -> Void)? = nil
    ) {
        self.viewController = viewController
        self.picker = picker
        self.imageProcessor = imageProcessor
        self.videoProcessor = videoProcessor
        self.didFinish = didFinish
    }
    
    // MARK: - Props
    open weak var viewController: UIViewController?
    open var picker: DPMediaPickerFactory
    open var imageProcessor: DPMediaImageProcessorFactory
    open var videoProcessor: DPMediaVideoProcessorFactory
    open var didFinish: ((Result<[DPMedia], Error>) -> Void)?
    
    // MARK: - Methods
    open func start() {
        self.requestAuthorization { [weak self] error in
            DispatchQueue.main.async { [weak self] in
                if let error = error {
                    self?.didFinish?(.failure(error))
                } else {
                    DispatchQueue.main.async { [weak self] in
                        self?.showPicker()
                    }
                }
            }
        }
    }
    
    open func authorizationStatus() -> PHAuthorizationStatus {
        if #available(iOS 14, *) {
            return PHPhotoLibrary.authorizationStatus(for: .readWrite)
        } else {
            return PHPhotoLibrary.authorizationStatus()
        }
    }
    
    open func requestAuthorization(_ completion: @escaping (Error?) -> Void) {
        let authorizationStatus = self.authorizationStatus()
        
        switch authorizationStatus {
        case .authorized,
                .limited:
            completion(nil)
        case .notDetermined:
            PHPhotoLibrary.requestAuthorization({ newStatus in
                if newStatus == .authorized {
                    completion(nil)
                } else {
                    completion(DPMediaError.authorizationStatus)
                }
            })
        case .denied:
            completion(DPMediaError.authorizationStatus)
        case .restricted:
            completion(DPMediaError.authorizationStatus)
        @unknown default:
            completion(nil)
        }
    }
    
    open func showPicker() {
        let vc = self.picker.produce()
        vc.subscibeToImagePickerDelegate(self)
        
        if #available(iOS 14.0, *) {
            vc.subscibeToPHPickerDelegate(self)
        }
        
        self.viewController?.present(vc, animated: true)
    }
    
}

// MARK: - UIImagePickerControllerDelegate, UINavigationControllerDelegate
extension DPMediaAdapter: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    public func imagePickerController(
        _ picker: UIImagePickerController,
        didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey: Any]
    ) {
        guard
            let mediaTypeRawValue = info[.mediaType] as? String,
            let mediaType = UIImagePickerController.MediaType(rawValue: mediaTypeRawValue)
        else { return }

        switch mediaType {
        case .image:
            guard let image = (info[.editedImage] ?? info[.originalImage]) as? UIImage else { return }
            
            self.imageProcessor.process(image) { [weak self] result in
                switch result {
                case let .failure(error):
                    self?.didFinish?(.failure(error))
                case let .success(processedImage):
                    let media = DPMedia.image(processedImage)
                    self?.didFinish?(.success([media]))
                }
            }
        case .video:
            guard let url = info[.mediaURL] as? URL else { return }
            
            self.videoProcessor.process(url) { [weak self] result in
                switch result {
                case let .failure(error):
                    self?.didFinish?(.failure(error))
                case let .success(processedVideo):
                    let media = DPMedia.video(processedVideo)
                    self?.didFinish?(.success([media]))
                }
            }
        }
        
        picker.dismiss(animated: true)
    }
    
    public func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true)
    }
    
}

@available(iOS 14.0, *)
extension DPMediaAdapter: PHPickerViewControllerDelegate {
    
    public func picker(_ picker: PHPickerViewController, didFinishPicking results: [PHPickerResult]) {
        picker.dismiss(animated: true)
        
        var medias: [DPMedia] = []
        var errorMain: Error?
        
        let manager = PHImageManager.default()
        let identifiers = results.compactMap(\.assetIdentifier)
        let fetchResult = PHAsset.fetchAssets(withLocalIdentifiers: identifiers, options: nil)
        var countMain = fetchResult.count
        
        func tryFinish() {
            countMain -= 1
            
            if countMain == 0 {
                DispatchQueue.main.async { [weak self] in
                    guard let self = self else { return }
                    
                    if let error = errorMain {
                        self.didFinish?(.failure(error))
                    } else {
                        self.didFinish?(.success(medias))
                    }
                }
            }
        }
        
        fetchResult.enumerateObjects { asset, _, _ in
            switch asset.mediaType {
            case .image:
                let options = PHImageRequestOptions()
                options.deliveryMode = .highQualityFormat
                
                manager.requestImage(
                    for: asset,
                    targetSize: PHImageManagerMaximumSize,
                    contentMode: .aspectFill,
                    options: options
                ) { [weak self] image, info in
                    guard let isDegraded = info?[PHImageResultIsDegradedKey] as? Bool, !isDegraded else { return }
                    
                    guard let self = self, let image = image else {
                        errorMain = DPMediaError.failureImage
                        tryFinish()
                        return
                    }
                    
                    self.imageProcessor.process(image) { result in
                        switch result {
                        case let .failure(error):
                            errorMain = error
                        case let .success(processedImage):
                            medias += [ .image(processedImage) ]
                        }
                        tryFinish()
                    }
                }
            case .video:
                manager.requestAVAsset(
                    forVideo: asset,
                    options: nil
                ) { [weak self] avAsset, _, _ in
                    guard let self = self, let url = (avAsset as? AVURLAsset)?.url else {
                        errorMain = DPMediaError.failureVideo
                        tryFinish()
                        return
                    }
                    
                    self.videoProcessor.process(url) { result in
                        switch result {
                        case let .failure(error):
                            errorMain = error
                        case let .success(processedVideo):
                            medias += [ .video(processedVideo) ]
                        }
                        tryFinish()
                    }
                }
            default:
                tryFinish()
            }
        }
    }
    
}
