import UIKit

final class SupportViewController: UITableViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        setUpNotifications()
        updateUsername()
        updateCurrentLanguageLabel()
    }

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let cell = tableView.cellForRow(at: indexPath)!

        switch cell.reuseIdentifier! {
        case "faqCell":
            Hotline.sharedInstance().showFAQs(self)
        case "chatCell":
            Hotline.sharedInstance().showConversations(self)
        case "setLangCell":
            setLanguage()
        default:
            break
        }
    }

    private func setUpNotifications() {
        let notificationSettings = UIUserNotificationSettings(types: [.alert, .badge, .sound], categories: nil)
        let application = UIApplication.shared
        application.registerUserNotificationSettings(notificationSettings)
        application.registerForRemoteNotifications()
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(updateCurrentLanguageLabel),
                                               name: languageChangeNotification,
                                               object: nil)
    }

    private func updateUsername() {
        let defaultName = "Anonymous Mobile User"
        guard let user = HotlineUser.sharedInstance(), user.name != defaultName else { return }
        user.name = defaultName
        Hotline.sharedInstance().update(user)
    }

    private func setLanguage() {
        performSegue(withIdentifier: "setLanguage", sender: nil)
    }

    @IBOutlet weak var currentLangLabel: UILabel!

    func updateCurrentLanguageLabel() {
        currentLangLabel.text = currentLanguage.rawValue
    }
}
