import EventKit

final class CalendarManager {
    // MARK: - Properties
    private let eventStore = EKEventStore()

    // MARK: - Calendar Access
    func requestAccess(completion: @escaping (Bool) -> Void) {
        eventStore.requestAccess(to: .event) { granted, error in
            if let error = error {
                print("Ошибка при запросе доступа к календарю: \(error)")
                completion(false)
            } else {
                completion(granted)
            }
        }
    }

    func checkCalendarAuthorizationStatus(completion: @escaping (EKAuthorizationStatus) -> Void) {
        let status = EKEventStore.authorizationStatus(for: .event)
        completion(status)
    }

    // MARK: - Event Management
    func saveEvent(title: String, description: String, startDate: Date, endDate: Date, completion: @escaping (Bool) -> Void) {
        let event = EKEvent(eventStore: eventStore)
        event.title = title
        event.notes = description
        event.startDate = startDate
        event.endDate = endDate
        event.calendar = eventStore.defaultCalendarForNewEvents

        do {
            try eventStore.save(event, span: .thisEvent)
            completion(true)
        } catch {
            print("Ошибка при сохранении события: \(error)")
            completion(false)
        }
    }
}
