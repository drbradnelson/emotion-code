import UIKit

final class ChapterTitleView: UIView {

    // MARK: Chapter title button

    @IBOutlet private var chapterTitleButton: UIButton!

    // MARK: Chapter index

    func setChapterIndex(_ index: Int) {
        let title = titleOfChapter(at: index)
        let decoratedTitle = decoratedChapterTitle(title)
        chapterTitleButton.setTitle(decoratedTitle, for: UIControlState())
        chapterTitleButton.accessibilityLabel = title
        sizeToFit()
    }

    // MARK: Decorated chapter title

    private func decoratedChapterTitle(_ title: String) -> String {
        return title + " " + titleDecorator
    }

    private var titleDecorator: String {
        return "▼"
    }

    // MARK: Chapter title

    func titleOfChapter(at index: Int) -> String {
        let format = NSLocalizedString("Chapter %i", comment: "")
        return String.localizedStringWithFormat(format, index + 1)
    }

}
