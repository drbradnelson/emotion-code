import UIKit
import AudioBar
import AVFoundation
import MediaPlayer

final class AudioBarContainerController: UIViewController {

    private let audioBarController = AudioBarViewController.instantiateFromStoryboard()
    private let nowPlayingInfoCenter = MPNowPlayingInfoCenter.default()

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
        var nowPlayingInfo = nowPlayingInfoCenter.nowPlayingInfo!
        if let subtitle = chapter.subtitle {
            nowPlayingInfo[MPMediaItemPropertyTitle] = chapter.title + " \u{2013} " + subtitle
        } else {
            nowPlayingInfo[MPMediaItemPropertyTitle] = chapter.title
        }
        nowPlayingInfo[MPMediaItemPropertyArtist] = "Dr. Bradley Nelson"
        nowPlayingInfo[MPMediaItemPropertyAlbumTitle] = "The Emotion Code"
        nowPlayingInfo[MPMediaItemPropertyArtwork] = MPMediaItemArtwork(image: UIImage(named: "artwork")!)
        nowPlayingInfoCenter.nowPlayingInfo = nowPlayingInfo
    }

}
