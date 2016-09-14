import Foundation

// MARK: Book

struct Book {

    let chapters: [BookChapter]

}

// MARK: Chapter

struct BookChapter {

    let title: String
    let fileURL: URL

}
