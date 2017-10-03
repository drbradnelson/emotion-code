import Foundation

enum Language: String {
    case english = "English"
    case spanish = "Español"
}

let supportedLanguages = [
    Language.english,
    Language.spanish
]

extension Language {
    var code: String {
        switch self {
        case .english:
            return "en"
        case .spanish:
            return "es"
        }
    }
}

extension String {
    var language: Language {
        switch self {
        case "en":
            return Language.english
        case "es":
            return Language.spanish
        default:
            return Language.english
        }
    }
}
