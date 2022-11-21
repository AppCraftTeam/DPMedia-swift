//
//  DPMediaMaxSizeChecker.swift
//  
//
//  Created by Дмитрий Поляков on 22.11.2022.
//

import Foundation

public struct DPMediaMaxSizeChecker {
    
    // MARK: - Init
    public init(maxSizeMB: Double? = nil) {
        self.maxSizeMB = maxSizeMB
    }
    
    // MARK: - Props
    public var maxSizeMB: Double?
    
    // MARK: - Methods
    public func checkData(_ data: Data) throws {
        guard  let maxSizeMB = self.maxSizeMB else { return }
        guard (Double(data.count) / 1000 / 1024) > maxSizeMB else { return }
        throw DPMediaError.maxSizeMB(maxSizeMB)
    }
    
    public func checkURL(_ url: URL) throws {
        do {
            let data = try Data(contentsOf: url)
            try self.checkData(data)
        } catch {
            throw error
        }
    }
    
}
