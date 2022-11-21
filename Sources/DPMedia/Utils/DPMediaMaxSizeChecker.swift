//
//  DPMediaMaxSizeChecker.swift
//  
//
//  Created by Дмитрий Поляков on 22.11.2022.
//

import Foundation

public struct DPMediaMaxSizeChecker {
    
    // MARK: - Init
    public init() {}
    
    // MARK: - Methods
    func check(_ data: Data, maxSizeMB: Double? = nil) throws {
        guard  let maxSizeMB = maxSizeMB else { return }
        guard (Double(data.count) / 1000 / 1024) > maxSizeMB else { return }
        throw DPMediaError.maxSizeMB(maxSizeMB)
    }
    
}
