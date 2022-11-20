//
//  DPMediaError.swift
//  Demo
//
//  Created by Дмитрий Поляков on 20.11.2022.
//

import Foundation

public struct DPMediaError {
    
    // MARK: - Methods
    public init(id: String, message: String) {
        self.id = id
        self.message = message
    }
    
    // MARK: - Props
    public let id: String
    public let message: String
}

// MARK: - Equatable
extension DPMediaError: Equatable {
    
    public static func == (lhs: Self, rhs: Self) -> Bool {
        lhs.id == rhs.id
    }
    
}

// MARK: - LocalizedError
extension DPMediaError: LocalizedError {
    
    public var errorDescription: String? {
        self.message
    }
    
    public var failureReason: String? {
        self.message
    }
    
}

// MARK: - Store
public extension DPMediaError {
    
    static let imageTypeNotSupported = DPMediaError(
        id: "imageTypeNotSupported",
        message: "Формат загруженного изображения не поддерживается."
    )
    
    static let authorizationStatus = DPMediaError(
        id: "authorizationStatus",
        message: "У приложения нет доступка к вашим фото. Чтобы предоставить доступ, перейдите в Настройки и включите Фото."
    )
    
    static let failureImage = DPMediaError(
        id: "failureImage",
        message: "Не удалось обработать изображение."
    )
    
    static let failureVideo = DPMediaError(
        id: "failureImage",
        message: "Не удалось обработать видео."
    )
    
}
