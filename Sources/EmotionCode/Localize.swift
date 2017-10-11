import Foundation

func setLanguage(lang: Language) {
    UserDefaults.standard.set([lang.code], forKey: "AppleLanguages")
    UserDefaults.standard.synchronize()
    NotificationCenter.default.post(name: languageChangeNotification, object: nil)
}

var currentLanguage: Language {
    if let currentLanguage = UserDefaults.standard.object(forKey: "AppleLanguages") as? [String] {
        return currentLanguage.first?.language ?? Language.english
    }
    return Language.english
}

let languageChangeNotification: NSNotification.Name = NSNotification.Name(rawValue: "LanguageChangeNotification")

let kBundleKey = UnsafeRawPointer(bitPattern: 0)
