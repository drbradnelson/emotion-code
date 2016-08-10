import Foundation

// MARK: Main

struct Book {

    let chapters: [BookChapter]

}

// MARK: Chapter

struct BookChapter {

    let title: String
    let fileURL: NSURL

}
