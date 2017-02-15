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
        audioBarContainerController.loadChapter(bookPageViewController.bookController.book.chapters[bookPageViewController.currentChapterIndex])
    }

    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        bookPageViewController.preferredTopLayoutGuide = topLayoutGuide.length
        bookPageViewController.preferredBottomLayoutGuide = bottomLayoutGuide.length + audioBarContainerView.bounds.height
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
