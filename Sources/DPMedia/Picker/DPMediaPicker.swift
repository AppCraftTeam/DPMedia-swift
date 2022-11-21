//
//  DPMediaPicker.swift
//  Demo
//
//  Created by Дмитрий Поляков on 20.11.2022.
//

import Foundation
import UIKit
import Photos
import PhotosUI

public struct DPMediaPicker: DPMediaPickerFactory {
    
    // MARK: - Init
    public init(
        sourceType: UIImagePickerController.SourceType = .photoLibrary,
        allowsEditing: Bool = false,
        mediaTypes: Set<UIImagePickerController.MediaType> = [],
        selectionLimit: Int = 1
    ) {
        self.sourceType = sourceType
        self.allowsEditing = allowsEditing
        self.mediaTypes = mediaTypes
        self.selectionLimit = selectionLimit
    }
    
    // MARK: - Props
    public var sourceType: UIImagePickerController.SourceType
    public var allowsEditing: Bool
    public var mediaTypes: Set<UIImagePickerController.MediaType>
    public var selectionLimit: Int
    
    // MARK: - Methods
    public func produce() -> DPMediaPickerInterface {
        switch self.sourceType {
        case .camera:
            return self.produceImagePicker()
        default:
            if #available(iOS 14, *) {
                return self.producePHPickerViewController()
            } else {
                return self.produceImagePicker()
            }
        }
    }
    
    public func produceImagePicker() -> UIImagePickerController {
        let vc = UIImagePickerController()
        vc.sourceType = self.sourceType
        vc.allowsEditing = self.allowsEditing
        
        if
            !self.mediaTypes.isEmpty,
            let availableMediaTypes = UIImagePickerController.availableMediaTypes(for: self.sourceType)
        {
            vc.mediaTypes = availableMediaTypes.filter({ imagePickerMediaType in
                if
                    let mediaType = UIImagePickerController.MediaType(rawValue: imagePickerMediaType),
                    self.mediaTypes.contains(mediaType)
                {
                    return true
                } else {
                    return false
                }
            })
        }
        
        return vc
    }
    
    @available(iOS 14, *)
    public func producePHPickerViewController() -> PHPickerViewController {
        var configuration = PHPickerConfiguration(photoLibrary: .shared())
        configuration.selectionLimit = self.selectionLimit
        configuration.preferredAssetRepresentationMode = .current
        
        if !self.mediaTypes.isEmpty {
            let filters: [PHPickerFilter] = self.mediaTypes.map { type in
                switch type {
                case .image:
                    return .images
                case .video:
                    return .videos
                }
            }
            
            configuration.filter = .any(of: filters)
        }
        
        return PHPickerViewController(configuration: configuration)
    }
    
}
