import UIKit

struct Tracker {
    let id: UUID
    let name: String
    let color: UIColor
    let emoji: String
    let schedule: [Weekday]
}

enum Weekday: String, Codable, CaseIterable {
    case sunday
    case monday
    case tuesday
    case wednesday
    case thursday
    case friday
    case saturday
    
    var calendarDayNumber: Int {
        switch self {
        case .monday:
            return 2
        case .tuesday:
            return 3
        case .wednesday:
            return 4
        case .thursday:
            return 5
        case .friday:
            return 6
        case .saturday:
            return 7
        case .sunday:
            return 1
        }
    }
    
    var shortDayName: String {
        switch self {
        case .monday:
            return NSLocalizedString("Mon", comment: "")
        case .tuesday:
            return NSLocalizedString("Tue", comment: "")
        case .wednesday:
            return NSLocalizedString("Wed", comment: "")
        case .thursday:
            return NSLocalizedString("Thu", comment: "")
        case . friday:
            return NSLocalizedString("Fri", comment: "")
        case .saturday:
            return NSLocalizedString("Sat", comment: "")
        case .sunday:
            return NSLocalizedString("Sun", comment: "")
        }
    }
}

