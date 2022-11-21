//
//  DPMediaVideoProcessorFactory.swift
//  Demo
//
//  Created by Дмитрий Поляков on 20.11.2022.
//

import Foundation

public protocol DPMediaVideoProcessorFactory {
    func process(_ url: URL, completion: @escaping (Result<DPMediaVideo, Error>) -> Void)
}
