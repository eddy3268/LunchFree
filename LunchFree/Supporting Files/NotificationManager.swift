import Foundation
import UserNotifications

class NotificationManager {
    static func scheduleDailyLunchNotification(at timeString: String) {
        let center = UNUserNotificationCenter.current()
        // Remove old notifications if any
        center.removePendingNotificationRequests(withIdentifiers: ["LunchReminder"])
        let components = timeString.split(separator: ":").compactMap { Int($0) }
        guard components.count == 2 else { return }
        var dateComponents = DateComponents()
        dateComponents.hour = components[0]
        dateComponents.minute = components[1]
        let content = UNMutableNotificationContent()
        content.title = "ランチタイムのお知らせ"
        content.body = "注文をお忘れなく！"
        content.sound = .default
        let trigger = UNCalendarNotificationTrigger(dateMatching: dateComponents, repeats: true)
        let request = UNNotificationRequest(identifier: "LunchReminder", content: content, trigger: trigger)
        center.add(request) { error in
            if let error = error {
                print("Failed to schedule lunch reminder: \(error)")
            }
        }
    }
}
