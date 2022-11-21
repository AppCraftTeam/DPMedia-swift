//
//  DPMediaFileTypeChecker.swift
//  
//
//  Created by Дмитрий Поляков on 22.11.2022.
//

import Foundation

public struct DPMediaFileTypeChecker {
    
    // MARK: - Init
    public init() {}
    
    // MARK: - Methods
    func check(_ data: Data, allowsFileTypes: Set<DPMediaFileType> = []) throws {
        guard !allowsFileTypes.isEmpty else { return }
        guard let fileType = DPMediaMimeType(data: data)?.fileType else { return }
        guard !allowsFileTypes.contains(fileType) else { return }
        throw DPMediaError.fileTypeNotSupported
    }
    
}
