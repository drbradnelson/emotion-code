import UIKit
import AudioBar
import AVFoundation

final class AudioBarContainerController: UIViewController {

    private let audioBarController = AudioBarViewController.instantiateFromStoryboard()

    override func viewDidLoad() {
        super.viewDidLoad()
        do {
            let audioSession = AVAudioSession.sharedInstance()
            try! audioSession.setCategory(AVAudioSessionCategoryPlayback)
            try! audioSession.setMode(AVAudioSessionModeSpokenAudio)
            try! audioSession.setActive(true)
        }
        do {
            addChildViewController(audioBarController)
            view.addSubview(audioBarController.view)
            audioBarController.didMove(toParentViewController: self)
        }
    }

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        audioBarController.view.frame = view.bounds
    }

    func loadChapter(_ chapter: Book.Chapter) {
        audioBarController.loadURL(url: chapter.audioURL)
    }

}
