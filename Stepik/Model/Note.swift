import Foundation
import UIKit

public enum Priority {
    case high
    case base
    case low
}

public struct Note {
    let uid: String
    let title: String
    let content: String
    let color: UIColor
    let priority: Priority
    let expiredDate: Date?
    
    public init(
        title: String,
        content: String,
        priority: Priority,
        uid: String? = nil,
        color: UIColor? = nil,
        expiredDate: Date? = nil
        ) {
        self.uid = uid ?? UUID().uuidString
        self.title = title
        self.content = content
        self.color = color ?? UIColor.white
        self.priority = priority
        self.expiredDate = expiredDate
    }
}
