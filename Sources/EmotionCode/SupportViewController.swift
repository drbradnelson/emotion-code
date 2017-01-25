import UIKit
import HotlineIO

final class SupportViewController: UITableViewController {

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
