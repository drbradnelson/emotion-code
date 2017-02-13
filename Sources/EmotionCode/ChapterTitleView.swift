import UIKit

final class ChapterTitleView: UIView {

    // MARK: Chapter title button

    @IBOutlet private var chapterTitleButton: UIButton!

    // MARK: Chapter index

    func setChapterTitle(_ chapterTitle: String) {
        let decoratedTitle = decoratedChapterTitle(chapterTitle)
        chapterTitleButton.setTitle(decoratedTitle, for: UIControlState())
        chapterTitleButton.accessibilityLabel = chapterTitle
        sizeToFit()
    }

    // MARK: Decorated chapter title

    private func decoratedChapterTitle(_ title: String) -> String {
        return title + " " + titleDecorator
    }

    private var titleDecorator: String {
        return "▼"
    }

}
