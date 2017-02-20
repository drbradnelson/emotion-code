import UIKit
import HotlineIO

@UIApplicationMain final class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey : Any]? = nil) -> Bool {

        let app = (
            id: "aa56e77b-ba9b-43d0-9e20-2b4e872b1532",
            key: "f30e542a-e6c8-4562-83e6-50eda74da991"
        )
        let hotlineConfig = HotlineConfig.init(appID: app.id, andAppKey: app.key)
        Hotline.sharedInstance().initWith(hotlineConfig)

        if Hotline.sharedInstance().isHotlineNotification(launchOptions) {
            Hotline.sharedInstance().handleRemoteNotification(launchOptions, andAppstate: application.applicationState)
        }

        return true

    }

    func applicationDidBecomeActive(_ application: UIApplication) {
        let unreadCount = Hotline.sharedInstance().unreadCount()
        UIApplication.shared.applicationIconBadgeNumber = unreadCount
    }

    func application(_ application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {
        Hotline.sharedInstance().updateDeviceToken(deviceToken)
    }

    func application(_ application: UIApplication, didReceiveRemoteNotification userInfo: [AnyHashable : Any]) {
        if Hotline.sharedInstance().isHotlineNotification(userInfo) {
            Hotline.sharedInstance().handleRemoteNotification(userInfo, andAppstate: application.applicationState)
        }
    }

    func application(_ application: UIApplication, shouldSaveApplicationState coder: NSCoder) -> Bool {
        return true
    }

    func application(_ application: UIApplication, shouldRestoreApplicationState coder: NSCoder) -> Bool {
        return true
    }

}
