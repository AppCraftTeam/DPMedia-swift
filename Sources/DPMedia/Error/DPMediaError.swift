//
//  DPMediaError.swift
//  Demo
//
//  Created by Дмитрий Поляков on 20.11.2022.
//

import Foundation

public struct DPMediaError: DPMediaErrorProtocol {
    
    // MARK: - Methods
    public init(id: String, message: String) {
        self.id = id
        self.message = message
    }
    
    // MARK: - Props
    public let id: String
    public let message: String
}

// MARK: - Store
public extension DPMediaError {
    
    static let someError = DPMediaError(
        id: "someError",
        message: "Произошла ошибка."
    )
    
    static let cancel = DPMediaError(
        id: "cancel",
        message: "Отменено."
    )
    
    static let imageTypeNotSupported = DPMediaError(
        id: "imageTypeNotSupported",
        message: "Формат изображения не поддерживается."
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
    
    static let fileTypeNotSupported = DPMediaError(
        id: "videoTypeNotSupported",
        message: "Формат файла не поддерживается."
    )
    
    static func maxSizeMB(_ value: Double) -> DPMediaError {
        DPMediaError(id: "failureFile", message: "Максимальный размер файла - \(Int(value)) Мб")
    }
    
}
