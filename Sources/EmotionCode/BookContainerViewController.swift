import UIKit
import AudioBar

final class BookContainerViewController: UIViewController, AudioBarDelegate {

    private var bookPageViewController: BookPageViewController!
    private var audioBarContainerController: AudioBarContainerController!

    @IBOutlet weak var audioBarContainerView: UIView!

    override func viewDidLoad() {
        super.viewDidLoad()
        audioBarContainerController.delegate = self
        navigationItem.leftBarButtonItem = bookPageViewController.previousChapterButtonItem
        navigationItem.titleView = bookPageViewController.chapterTitleView
        navigationItem.rightBarButtonItem = bookPageViewController.nextChapterButtonItem
        bookPageViewController.didShowChapter = { [weak audioBarContainerController] chapter in
            audioBarContainerController?.loadChapter(chapter)
        }
        audioBarContainerController.loadChapter(bookPageViewController.bookController.book.chapters[bookPageViewController.currentChapterIndex])
    }

    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        bookPageViewController.preferredTopLayoutGuide = topLayoutGuide.length
        bookPageViewController.preferredBottomLayoutGuide = bottomLayoutGuide.length + audioBarContainerView.bounds.height
    }

    // MARK: State preservation/restoration

    private let bookPageViewControllerKey = "BookPageViewController"

    override func encodeRestorableState(with coder: NSCoder) {
        super.encodeRestorableState(with: coder)
        coder.encode(bookPageViewController, forKey: bookPageViewControllerKey)
    }

    override func decodeRestorableState(with coder: NSCoder) {
        super.decodeRestorableState(with: coder)
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        super.prepare(for: segue, sender: sender)
        switch segue.destination {
        case let bookPageViewController as BookPageViewController:
            self.bookPageViewController = bookPageViewController
        case let audioBarContainerController as AudioBarContainerController:
            self.audioBarContainerController = audioBarContainerController
        default:
            fatalError()
        }
    }

    // MARK: Audio bar delegate

    func audioBarDidPlayToEnd() {
        let bookController = bookPageViewController.bookController
        let nextChapterIndex = bookPageViewController.currentChapterIndex + 1
        guard bookController.hasChapter(at: nextChapterIndex), bookController.book.chapters[nextChapterIndex].audioURL != nil else { return }
        bookPageViewController.showChapter(at: nextChapterIndex, direction: .forward, animated: true)
        audioBarContainerController.play()
    }

}
