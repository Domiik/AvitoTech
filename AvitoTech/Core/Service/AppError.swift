//
//  AppError.swift
//  AvitoTech
//
//  Created by Владимир Иванов on 11.09.2024.
//

import Foundation

enum AppError: Error {
    case networkError
    case decodingError
    case noInternetConnection
    case unknownError
    
    var localizedDescription: String {
        switch self {
        case .networkError:
            return "Ошибка сети. Пожалуйста, проверьте ваше соединение."
        case .decodingError:
            return "Не удалось обработать данные. Попробуйте еще раз."
        case .noInternetConnection:
            return "Нет подключения к интернету."
        case .unknownError:
            return "Произошла неизвестная ошибка. Попробуйте еще раз позже."
        }
    }
}

