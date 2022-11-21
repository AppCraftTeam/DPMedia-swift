//
//  DPMediaAdapterInterface.swift
//  Demo
//
//  Created by Дмитрий Поляков on 20.11.2022.
//

import Foundation
import UIKit

public protocol DPMediaAdapterInterface {
    var viewController: UIViewController? { get set }
    var picker: DPMediaPickerFactory { get set }
    var imageProcessor: DPMediaImageProcessorFactory { get set }
    var videoProcessor: DPMediaVideoProcessorFactory { get set }
    var didFinish: ((Result<[DPMedia], Error>) -> Void)? { get set }
    
    func start()
}
