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
        do {
            let url = URL(string: "http://www.healerslibrary.com/audiobook/english/The_Emotion_Code_Ch_1.mp3")!
            audioBarController.loadURL(url: url)
        }
    }

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        audioBarController.view.frame = view.bounds
    }

}
