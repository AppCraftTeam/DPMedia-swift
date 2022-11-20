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
        imageProcessor: DPMediaImageProcessorFactory = DPMediaPNGImageProcessor()
    ) {
        self.viewController = viewController
        self.picker = picker
        self.imageProcessor = imageProcessor
        self.videoProcessor = videoProcessor
    }
    
    // MARK: - Props
    open weak var viewController: UIViewController?
    open var picker: DPMediaPickerFactory
    open var imageProcessor: DPMediaImageProcessorFactory
    open var videoProcessor: DPMediaVideoProcessorFactory
    open var didError: ((Error) -> Void)?
    open var didFinsh: (([DPMedia]) -> Void)?
    
    // MARK: - Methods
    open func start() {
        self.requestAuthorization { [weak self] error in
            DispatchQueue.main.async { [weak self] in
                if let error = error {
                    self?.didError?(error)
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
            let imagePickerMediaType = info[.mediaType] as? String,
            let mediaType = DPMediaType(rawValue: imagePickerMediaType)
        else { return }

        switch mediaType {
        case .image:
            guard let image = (info[.editedImage] ?? info[.originalImage]) as? UIImage else { return }
            
            do {
                let processedImage = try self.imageProcessor.process(image)
                self.didFinsh?([ .image(processedImage) ])
            } catch {
                self.didError?(error)
            }
        case .video:
            guard let url = info[.mediaURL] as? URL else { return }
            
            do {
                let processedVideo = try self.videoProcessor.process(url)
                self.didFinsh?([ .video(processedVideo) ])
            } catch {
                self.didError?(error)
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
        let loadingGroup = DispatchGroup()
        var medias: [DPMedia] = []
        var errorMain: Error?
        
        for result in results {
            if result.itemProvider.hasItemConformingToTypeIdentifier(UTType.movie.identifier) {
                loadingGroup.enter()
                result.itemProvider.loadFileRepresentation(forTypeIdentifier: UTType.movie.identifier) { url, error in
                    guard let url = url, error == nil else {
                        errorMain = error
                        loadingGroup.leave()
                        return
                    }
                    
                    do {
                        let processedVideo = try self.videoProcessor.process(url)
                        medias += [ .video(processedVideo) ]
                        loadingGroup.leave()
                    } catch {
                        errorMain = error
                        loadingGroup.leave()
                    }
                }
            }
            
            else if result.itemProvider.hasItemConformingToTypeIdentifier(UTType.image.identifier) {
                loadingGroup.enter()
                result.itemProvider.loadFileRepresentation(forTypeIdentifier: UTType.image.identifier) { url, error in
                    guard let url = url, error == nil else {
                        errorMain = error
                        loadingGroup.leave()
                        return
                    }
                    
                    do {
                        let data = try Data(contentsOf: url)
                        
                        guard let image = UIImage(data: data) else {
                            loadingGroup.leave()
                            return
                        }
                        
                        let processedImage = try self.imageProcessor.process(image)
                        medias += [ .image(processedImage) ]
                        loadingGroup.leave()
                    } catch {
                        errorMain = error
                        loadingGroup.leave()
                    }
                }
            }
        }
        
        loadingGroup.notify(queue: .main) { [weak self] in
            if let error = errorMain {
                self?.didError?(error)
            } else {
                self?.didFinsh?(medias)
            }
        }
        
        picker.dismiss(animated: true)
    }
    
}
