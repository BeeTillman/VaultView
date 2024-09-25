import Foundation
import UserNotifications

class NotificationManager: NSObject, UNUserNotificationCenterDelegate {
    static let shared = NotificationManager()

    private override init() {
        super.init()
        UNUserNotificationCenter.current().delegate = self
    }

    func requestAuthorization() {
        let center = UNUserNotificationCenter.current()
        center.requestAuthorization(options: [.alert, .sound, .badge]) { granted, error in
            if let error = error {
                print("Notification authorization error: \(error.localizedDescription)")
            } else if granted {
                print("Notification permission granted.")
            } else {
                print("Notification permission denied.")
            }
        }
    }

    func scheduleNotification(frequency: TimeInterval) {
        // Remove existing notifications
        UNUserNotificationCenter.current().removeAllPendingNotificationRequests()

        // Create notification content
        let content = UNMutableNotificationContent()
        content.title = "Update Your Balances"
        content.body = "It's time to update your account balances in VaultView."
        content.sound = .default

        // Create trigger based on frequency
        let trigger = UNTimeIntervalNotificationTrigger(timeInterval: frequency, repeats: true)

        // Create notification request
        let request = UNNotificationRequest(identifier: "balanceUpdateReminder", content: content, trigger: trigger)

        // Schedule the notification
        UNUserNotificationCenter.current().add(request) { error in
            if let error = error {
                print("Error scheduling notification: \(error.localizedDescription)")
            } else {
                print("Notification scheduled with frequency: \(frequency) seconds.")
            }
        }
    }

    // Handle notifications while the app is in the foreground
    func userNotificationCenter(_ center: UNUserNotificationCenter,
                                willPresent notification: UNNotification,
                                withCompletionHandler completionHandler:
                                @escaping (UNNotificationPresentationOptions) -> Void) {
        completionHandler([.banner, .sound])
    }
}
