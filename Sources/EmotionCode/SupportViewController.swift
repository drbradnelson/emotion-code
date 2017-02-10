import UIKit
import HotlineIO

final class SupportViewController: UITableViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        setUpNotifications()
        updateUsername()
    }

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let cell = tableView.cellForRow(at: indexPath)!

        switch cell.reuseIdentifier! {
        case "faqCell":
            Hotline.sharedInstance().showFAQs(self)
        case "chatCell":
            Hotline.sharedInstance().showConversations(self)
        default:
            break
        }
    }

    private func setUpNotifications() {
        let notificationSettings = UIUserNotificationSettings(types: [.alert, .badge, .sound], categories: nil)
        let application = UIApplication.shared
        application.registerUserNotificationSettings(notificationSettings)
        application.registerForRemoteNotifications()
    }

    private func updateUsername() {
        let defaultName = "Anonymous Mobile User"
        guard let user = HotlineUser.sharedInstance(), user.name != defaultName else { return }
        user.name = defaultName
        Hotline.sharedInstance().update(user)
    }

}
