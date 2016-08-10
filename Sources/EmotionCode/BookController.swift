import Foundation

// MARK: Main

final class BookController {

    let book = BookController.bookAtURL(BookController.bookURL)

}

// MARK: Parser

private extension BookController {

    static func bookAtURL(URL: NSURL) -> Book {
        guard let bookChapterArray = NSArray(contentsOfURL: URL) as? [[String: String]] else {
            preconditionFailure("Unable to load book file")
        }
        return bookWithChapterArray(bookChapterArray)
    }

    static func bookWithChapterArray(array: [[String: String]]) -> Book {
        let chapters = array.map(chapterWithDictionary)
        return Book(chapters: chapters)
    }

    static func chapterWithDictionary(dictionary: [String: String]) -> BookChapter {
        guard let title = dictionary[chapterTitleKey], fileName = dictionary[chapterFileNameKey], fileURL = NSURL(string: fileName) else {
            preconditionFailure("Unable to parse book chapter")
        }
        return BookChapter(title: title, fileURL: fileURL)
    }

}

private extension BookController {

    static let chapterTitleKey = "Title"
    static let chapterFileNameKey = "Filename"

}

// MARK: Book URL

private extension BookController {

    static var bookURL: NSURL {
        let bundle = NSBundle.mainBundle()
        guard let bookURL = bundle.URLForResource(bookResource, withExtension: bookResourceExtension) else {
            preconditionFailure("Unable to locate book file")
        }
        return bookURL
    }

}

private extension BookController {

    static let bookResource = "BookChapters"
    static let bookResourceExtension = "plist"

}
