//
//  DPMediaErrorProtocol.swift
//  Demo
//
//  Created by Дмитрий Поляков on 21.11.2022.
//

import Foundation

public protocol DPMediaErrorProtocol: LocalizedError, Equatable {
    var id: String { get }
    var message: String { get }
}

// MARK: - Default
public extension DPMediaErrorProtocol {
    
    static func == (lhs: Self, rhs: Self) -> Bool {
        lhs.id == rhs.id
    }
    
    var errorDescription: String? {
        self.message
    }
    
    var failureReason: String? {
        self.message
    }
    
}
