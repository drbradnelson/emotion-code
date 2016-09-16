import Foundation

// MARK: Book

struct Book {

    struct Chapter {
        let title: String
        let fileURL: URL
    }

    let chapters: [Chapter]

}
