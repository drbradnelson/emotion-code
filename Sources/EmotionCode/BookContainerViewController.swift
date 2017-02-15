import UIKit

final class BookContainerViewController: UIViewController {

    private var bookPageViewController: BookPageViewController!
    private var audioBarContainerController: AudioBarContainerController!

    @IBOutlet weak var audioBarContainerView: UIView!

    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.leftBarButtonItem = bookPageViewController.previousChapterButtonItem
        navigationItem.titleView = bookPageViewController.chapterTitleView
        navigationItem.rightBarButtonItem = bookPageViewController.nextChapterButtonItem
        bookPageViewController.didShowChapter = { [weak audioBarContainerController] chapter in
            audioBarContainerController?.loadChapter(chapter)
        }
        audioBarContainerController.loadChapter(bookPageViewController.currentBookChapterViewController.chapterIndex)
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

}
