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
        guard let audioURL = chapter.audioURL else {
            disableAudioBar()
            return
        }
        enableAudioBar()
        audioBarController.loadURL(url: audioURL)
    }

    private func enableAudioBar() {
        audioBarController.view.isUserInteractionEnabled = true
        audioBarController.view.tintColor = view.tintColor
    }

    private func disableAudioBar() {
        audioBarController.view.isUserInteractionEnabled = false
        audioBarController.view.tintColor = .lightGray
    }

}
