//
//  D2AServiceCategory.swift
//  D2A
//
//  Created by Shibo Tong on 29/4/2025.
//

enum D2AServiceCategory: String {
    case opendotaConstant = "📕"
    case coredata = "💾"
    case stratz = "🏉"
    case video = "🎥"
}

enum LoggingLevel: Int {
     case debug, warn, error

     var icon: String {
         switch self {
         case .debug:
             "📝"
         case .warn:
             "⚠️"
         case .error:
             "❌"
         }
     }
 }
