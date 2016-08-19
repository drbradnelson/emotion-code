import UIKit

// MARK: Main

final class ChapterTitleView: UIView {

    @IBOutlet private var chapterTitleButton: UIButton!

}

// MARK: Chapter index

extension ChapterTitleView {

    func setChapterIndex(index: Int) {
        let title = titleOfChapterWithIndex(index)
        let decoratedTitle = decoratedTitleOfChapter(title)
        chapterTitleButton.setTitle(decoratedTitle, forState: .Normal)
        chapterTitleButton.accessibilityLabel = title
        sizeToFit()
    }

}

// MARK: Decorated chapter title

private extension ChapterTitleView {

    func decoratedTitleOfChapter(title: String) -> String {
        return title + " " + titleDecorator
    }

    var titleDecorator: String {
        return "▼"
    }

}

// MARK: Chapter title

extension ChapterTitleView {

    func titleOfChapterWithIndex(index: Int) -> String {
        return NSString(format: "Chapter %i", index + 1) as String
    }

}
