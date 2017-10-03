import UIKit

class LanguageTableViewController: UITableViewController {
    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return supportedLanguages.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "languageCell", for: indexPath)
        cell.textLabel?.text = supportedLanguages[indexPath.row].rawValue
        cell.accessoryType = currentLanguage == supportedLanguages[indexPath.row] ? .checkmark : .none
        return cell
    }

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let lang = supportedLanguages[indexPath.row]
        setLanguage(lang: lang)
        confirmLanguageChange()
    }

    private func reloadRootVC() {
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let storyboard = UIStoryboard(name: "TabBar", bundle: nil)
        appDelegate.window?.rootViewController = storyboard.instantiateInitialViewController()
    }

    private func confirmLanguageChange() {
        let alert = UIAlertController(title: NSLocalizedString("Need to Close App Title", comment: ""),
                                      message: NSLocalizedString("Need to Close App Message", comment: ""),
                                      preferredStyle: UIAlertControllerStyle.alert)
        alert.addAction(UIAlertAction(title: NSLocalizedString("Close App", comment: ""),
                                      style: UIAlertActionStyle.default) { _ in
            exit(0)
        })
        alert.addAction(UIAlertAction(title: NSLocalizedString("Cancel", comment: ""), style: UIAlertActionStyle.cancel, handler: nil))
        present(alert, animated: true, completion: nil)
    }

}
