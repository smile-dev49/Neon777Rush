import Foundation
import UserNotifications

final class NotificationService {
    static let shared = NotificationService()

    private init() {}

    func requestAuthorization() {
        UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .badge, .sound]) { granted, _ in
            guard granted else { return }
            self.scheduleOfflineReminders()
        }
    }

    func scheduleOfflineReminders() {
        let center = UNUserNotificationCenter.current()
        center.removeAllPendingNotificationRequests()
        schedule(identifier: "daily.reward", title: "Daily reward ready", body: "Claim today's Neon 777 Rush coins and gems.", hour: 18)
        schedule(identifier: "mission.progress", title: "Mission streak waiting", body: "Finish today's spins and collect your bonus.", hour: 20)
        schedule(identifier: "event.countdown", title: "777 Jackpot Event", body: "Your event tickets are ready for another run.", hour: 21)
        schedule(identifier: "vip.reward", title: "VIP vault refreshed", body: "Your offline VIP perks are ready to claim.", hour: 12)
    }

    private func schedule(identifier: String, title: String, body: String, hour: Int) {
        var date = DateComponents()
        date.hour = hour
        date.minute = 7

        let content = UNMutableNotificationContent()
        content.title = title
        content.body = body
        content.sound = .default

        let trigger = UNCalendarNotificationTrigger(dateMatching: date, repeats: true)
        let request = UNNotificationRequest(identifier: identifier, content: content, trigger: trigger)
        UNUserNotificationCenter.current().add(request)
    }
}
