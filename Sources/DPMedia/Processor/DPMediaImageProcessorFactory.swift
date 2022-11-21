//
//  DPMediaImageProcessorFactory.swift
//  Demo
//
//  Created by Дмитрий Поляков on 20.11.2022.
//

import Foundation
import UIKit

public protocol DPMediaImageProcessorFactory {
    func process(_ image: UIImage, completion: @escaping (Result<DPMediaImage, Error>) -> Void)
}
