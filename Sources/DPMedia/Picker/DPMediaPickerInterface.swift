//
//  DPMediaPickerInterface.swift
//  Demo
//
//  Created by Дмитрий Поляков on 20.11.2022.
//

import Foundation
import PhotosUI

public protocol DPMediaPickerInterface: UIViewController {
    func subscibeToImagePickerDelegate(_ delegate: UIImagePickerControllerDelegate & UINavigationControllerDelegate)
    
    @available(iOS 14.0, *)
    func subscibeToPHPickerDelegate(_ delegate: PHPickerViewControllerDelegate)
}

// MARK: - UIImagePickerController + DPMediaPickerInterface
extension UIImagePickerController: DPMediaPickerInterface {
    
    public func subscibeToImagePickerDelegate(_ delegate: UIImagePickerControllerDelegate & UINavigationControllerDelegate) {
        self.delegate = delegate
    }
    
    @available(iOS 14.0, *)
    public func subscibeToPHPickerDelegate(_ delegate: PHPickerViewControllerDelegate) {}
    
}
 
// MARK: - PHPickerViewController + DPMediaPickerInterface
@available(iOS 14, *)
extension PHPickerViewController: DPMediaPickerInterface {
    
    public func subscibeToImagePickerDelegate(_ delegate: UIImagePickerControllerDelegate & UINavigationControllerDelegate) {}
    
    public func subscibeToPHPickerDelegate(_ delegate: PHPickerViewControllerDelegate) {
        self.delegate = delegate
    }
    
}
