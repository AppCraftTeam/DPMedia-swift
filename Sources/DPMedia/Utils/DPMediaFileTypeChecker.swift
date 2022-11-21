//
//  DPMediaFileTypeChecker.swift
//  
//
//  Created by Дмитрий Поляков on 22.11.2022.
//

import Foundation

public struct DPMediaFileTypeChecker {
    
    // MARK: - Init
    public init(allowsFileTypes: Set<DPMediaFileType> = []) {
        self.allowsFileTypes = allowsFileTypes
    }
    
    // MARK: - Props
    public var allowsFileTypes: Set<DPMediaFileType>
    
    // MARK: - Methods
    public func checkData(_ data: Data) throws {
        guard !self.allowsFileTypes.isEmpty else { return }
        guard let fileType = DPMediaMimeType(data: data)?.fileType else { return }
        guard !self.allowsFileTypes.contains(fileType) else { return }
        throw DPMediaError.fileTypeNotSupported
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
