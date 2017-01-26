import UIKit
import HotlineIO

final class SupportViewController: UITableViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        let notificationSettings = UIUserNotificationSettings(types: [.alert, .badge, .sound], categories: nil)
        UIApplication.shared.registerUserNotificationSettings(notificationSettings)
        UIApplication.shared.registerForRemoteNotifications()
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

}
