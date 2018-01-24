import Foundation

final class BookController {

    // MARK: Book

    let book = BookController.bookAtURL(BookController.bookURL)

    // MARK: Book parser

    private static func bookAtURL(_ URL: Foundation.URL) -> Book {
        guard let bookDict = NSDictionary(contentsOf: URL) as? [String: AnyObject] else {
            preconditionFailure("Unable to load book file")
        }
        guard let bookArray = bookDict[BookController.bookChaptersKey] as? [[String: String]] else {
            preconditionFailure("Unable to load book file")
        }
        return bookWith(array: bookArray)
    }

    private static func bookWith(array: [[String: String]]) -> Book {
        let chapters = array.map(chapterWith)
        return Book(chapters: chapters)
    }

    private static func chapterWith(dictionary: [String: String]) -> Book.Chapter {
        guard let title = dictionary[chapterTitleKey], let fileName = dictionary[chapterFilenameKey] else {
            preconditionFailure("Unable to parse book chapter")
        }
        guard let fileURL = Bundle.main.url(forResource: fileName, withExtension: "html") else {
            preconditionFailure("Unable to find book chapter file")
        }
        let subtitle = dictionary[chapterSubtitleKey]
        let audioURL: URL?
        if let auidioFilename = dictionary[chapterAudioKey], let pathURL = URL(string: audioPath) {
            audioURL = pathURL.appendingPathComponent(auidioFilename).appendingPathExtension(audioFileExtension)
        } else {
            audioURL = nil
        }
        return Book.Chapter(title: title, subtitle: subtitle, fileURL: fileURL, audioURL: audioURL)
    }

    private static let chapterTitleKey = "Title"
    private static let chapterSubtitleKey = "Subtitle"
    private static let chapterFilenameKey = "Filename"
    private static let chapterAudioKey = "Audio"

    // MARK: Book URL

    private static var bookURL: URL {
        guard let bookURL = Bundle.main.url(forResource: bookResource, withExtension: bookResourceExtension) else {
            preconditionFailure("Unable to locate book file")
        }
        return bookURL
    }

    private static let bookResource = "BookChapters"
    private static let bookResourceExtension = "plist"
    private static let bookChaptersKey = "Chapters"
    private static let bookAudioPathKey = "Audio Path"

    // MARK: Audio URL

    //private static let audioPath = "https://media.discoverhealing.com/en/The_Emotion_Code_Audiobook"
    private static var audioPath: String {
        guard let bookDict = NSDictionary(contentsOf: BookController.bookURL) as? [String: AnyObject] else {
            preconditionFailure("Unable to load book file")
        }
        guard let audioPath = bookDict[BookController.bookAudioPathKey] as? String else {
            preconditionFailure("Unable to locate audio path")
        }
        return audioPath
    }
    private static let audioFileExtension = "mp3"

    // MARK: Book chapter query

    func hasChapter(at index: Int) -> Bool {
        return book.chapters.indices.contains(index)
    }

}
