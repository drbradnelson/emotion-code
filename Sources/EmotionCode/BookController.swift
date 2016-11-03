import Foundation

final class BookController {

    // MARK: Book

    let book = BookController.bookAtURL(BookController.bookURL)

    // MARK: Book parser

    private static func bookAtURL(_ URL: Foundation.URL) -> Book {
        guard let bookArray = NSArray(contentsOf: URL) as? [[String: String]] else {
            preconditionFailure("Unable to load book file")
        }
        return bookWith(array: bookArray)
    }

    private static func bookWith(array: [[String: String]]) -> Book {
        let chapters = array.map(chapterWith)
        return Book(chapters: chapters)
    }

    private static func chapterWith(dictionary: [String: String]) -> Book.Chapter {
        guard let title = dictionary[chapterTitleKey], let fileName = dictionary[chapterFileNameKey] else {
            preconditionFailure("Unable to parse book chapter")
        }
        guard let fileURL = Bundle.main.url(forResource: fileName, withExtension: "html") else {
            preconditionFailure("Unable to find book chapter file")
        }
        return Book.Chapter(title: title, fileURL: fileURL)
    }

    private static let chapterTitleKey = "Title"
    private static let chapterFileNameKey = "Filename"

    // MARK: Book URL

    private static var bookURL: URL {
        guard let bookURL = Bundle.main.url(forResource: bookResource, withExtension: bookResourceExtension) else {
            preconditionFailure("Unable to locate book file")
        }
        return bookURL
    }

    private static let bookResource = "BookChapters"
    private static let bookResourceExtension = "plist"

    // MARK: Book chapter query

    func hasChapter(at index: Int) -> Bool {
        return book.chapters.indices.contains(index)
    }

}
