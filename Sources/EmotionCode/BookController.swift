import Foundation
import Down

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

    // MARK: HTML string for chapter

    func htmlStringForChapter(at index: Int) throws -> String {
        let chapterMarkdownURL = book.chapters[index].fileURL
        let markdownString = try String(contentsOf: chapterMarkdownURL)
        let markdown = Down(markdownString: markdownString)
        let htmlString = try markdown.toHTML()
        return htmlString
    }

    private func embedHTMLStringIntoTemplate(_ htmlString: String) throws -> String {
        let templateHTML = try String(contentsOf: BookController.templateHTMLURL)
        guard let bodyTagRange = templateHTML.range(of: "<body>") else {
            preconditionFailure("Unable to locate body tag")
        }
        let bodyStart = templateHTML.substring(to: bodyTagRange.upperBound)
        let bodyEnd = templateHTML.substring(from: bodyTagRange.upperBound)
        let embeddedString = bodyStart + htmlString + bodyEnd
        return embeddedString
    }

    // MARK: Template HTML URL

    private static var templateHTMLURL: URL {
        guard let templateURL = Bundle.main.url(forResource: "main", withExtension: "html") else {
            preconditionFailure("Unable to locate template file")
        }
        return templateURL
    }

}
