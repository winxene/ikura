//
//  ReminderNotification.swift
//  MainActor
//
//  Created by Winxen Ryandiharvin on 14/08/23.
//

import UserNotifications
import Combine
//use singleton instance to make it easier to declare globally
class ReminderNotificationManager: NSObject, UNUserNotificationCenterDelegate{
    
    static let shared = ReminderNotificationManager()
    
    // Don't forget to declare here
    override init() {
        super.init()
    }
    
    //combine part is only adding the ->AnyPublisher<Void, Error> & the wrapper
//    func scheduledNotification() -> AnyPublisher<Void, Error> {
    func scheduledNotification(){
        //the wrapper, comment the return future to disable combine
//        return Future<Void, Error> { promise in
        let notificationCenter = UNUserNotificationCenter.current()

        let content = UNMutableNotificationContent()
        let identifier = "expenseReminder"
        content.title = "Track your expense"
        content.subtitle = "A friendly reminder to track your expense in Main Actor"
        content.sound = UNNotificationSound.default
            
        var dateComponents = DateComponents()
        dateComponents.hour = 23
        dateComponents.minute = 33
        
        let trigger = UNCalendarNotificationTrigger(dateMatching: dateComponents, repeats: true)
        
        let request = UNNotificationRequest(identifier: identifier, content: content, trigger: trigger)
        
        //removing the pending notification so that the notification refreshes
        notificationCenter.removePendingNotificationRequests(withIdentifiers: [identifier])

        //closure here
        notificationCenter.add(request) { error in
            if let error = error {
                print("Error scheduling notification: \(error.localizedDescription)")
            } else {
                print("Notification scheduled successfully")
            }
        }
//        }.eraseToAnyPublisher()
    }
    
    // Copy and paste this line so that the notification can be allowed
    func askNotificationPermission(){
        let notificationCenter = UNUserNotificationCenter.current()

        notificationCenter.requestAuthorization(options: [.alert, .sound, .badge]) { granted, error in
            if granted {
                print("Notification authorization granted")
                //call the scheduled notification
                self.scheduledNotification()
            } else {
                print("Notification authorization denied")
            }
        }
    }
    
    //implement this method to the delegate so that you can notify the user well
    func userNotificationCenter(
        _ center: UNUserNotificationCenter,
        willPresent notification: UNNotification,
        withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void
    ) {
        // This method is called when a notification is about to be presented in the foreground.
        // You can customize how the notification should be presented using the completionHandler.

        // For example, you can choose to present the notification with sound and alert.
        completionHandler([.sound, .alert])
    }
}



