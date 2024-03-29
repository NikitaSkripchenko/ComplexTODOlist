import Foundation
import UIKit

public extension Note{
    
    static func parse(json: [String: Any]) -> Note?{
        let uid = json["uid"] as? String
        let title = json["title"] as? String
        let content = json["content"] as? String
        let priority = Priority.base
        let expirationDate = Date()
        
        var color = UIColor.white
        if let hexString = (json["color"] as? String) {
            color = self.convertToColor(hexString: hexString)
        }
        let note = Note(title: title!, content: content!, priority: priority, uid: uid!, color: color, expiredDate: expirationDate)
        return note
    }
    
    var json: [String: Any]{
        var dic = [String: Any]()
        
        dic["uid"] = self.uid
        dic["title"] = self.title
        dic["content"] = self.content
        
        if self.color != .white{
            dic["color"] = self.hexColor
        }
        if let date = self.expiredDate{
            dic["expirationDate"] = date.timeIntervalSince1970
        }
        if self.priority != .base{
            dic["priority"] = self.priority.rawValue
        }
        return dic
    }
    
    private static func convertToColor(hexString : String) -> UIColor {
        guard hexString.hasPrefix("#") && hexString.count == 9 else {
            return UIColor.white
        }
        let scanner = Scanner(string : hexString)
        scanner.scanLocation = 1
        var hexColor:  UInt32 = 0
        guard scanner.scanHexInt32(&hexColor) else {
            return UIColor.white
        }
        let mask = CGFloat(255)
        let r = CGFloat((hexColor & 0xFF000000) >> 24) / mask
        let g = CGFloat((hexColor & 0x00FF0000) >> 16) / mask
        let b = CGFloat((hexColor & 0x0000FF00) >> 8) / mask
        let a = CGFloat(hexColor & 0x000000FF) / mask
        return UIColor(red: r, green: g, blue: b, alpha: a)
    }

    private var hexColor : String {
        var r:CGFloat = 0
        var g:CGFloat = 0
        var b:CGFloat = 0
        var a:CGFloat = 0
        self.color.getRed(&r, green: &g, blue: &b, alpha: &a)
        return String(format: "#%02X%02X%02X%02X",
                      Int(round(r * 255)), Int(round(g * 255)),
                      Int(round(b * 255)), Int(round(a * 255)))
    }
    
}

extension Date{
    static func stringToDate(_ date: String) -> Date {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        dateFormatter.locale = Locale(identifier: "en_US_POSIX")
        return dateFormatter.date(from: date)!
    }
    static func dateToString(_ date: Date) -> String{
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        return dateFormatter.string(from: date)
    }
}
