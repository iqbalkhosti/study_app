import Foundation
import UserNotifications

class NotificationManager {
    static let shared = NotificationManager()
    
    private init() {}
    
    func requestAuthorization() {
        UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .sound, .badge]) { granted, _ in
            if granted {
                self.scheduleWeeklyReviewNotification()
            }
        }
    }
    
    func scheduleWeeklyReviewNotification() {
        let center = UNUserNotificationCenter.current()
        center.removeAllPendingNotificationRequests()
        
        let content = UNMutableNotificationContent()
        content.title = "Time for Your Weekly Review"
        content.body = "Reflect on this week's sessions and set intentions for next week"
        content.sound = .default
        
        var dateComponents = DateComponents()
        dateComponents.weekday = 1 // Sunday
        dateComponents.hour = 20 // 8 PM
        
        let trigger = UNCalendarNotificationTrigger(dateMatching: dateComponents, repeats: true)
        let request = UNNotificationRequest(
            identifier: "weeklyReview",
            content: content,
            trigger: trigger
        )
        
        center.add(request)
    }
    
    func cancelWeeklyReviewNotification() {
        UNUserNotificationCenter.current().removePendingNotificationRequests(withIdentifiers: ["weeklyReview"])
    }
}
