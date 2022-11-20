//
//  DPMediaPickerFactory.swift
//  Demo
//
//  Created by Дмитрий Поляков on 20.11.2022.
//

import Foundation
import UIKit

public protocol DPMediaPickerFactory {
    func produce() -> DPMediaPickerInterface
}


