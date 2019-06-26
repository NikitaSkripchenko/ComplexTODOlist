import Foundation
import UIKit

public extension Note{
    static func priorityToString(_ priority: Priority)->String{
        switch priority {
        case .base:
            return "base priority"
        case .high:
            return "hight priority"
        case .low:
            return "low priority"
        }
    }
    
    static func stringToPriority(_ priority: String) -> Priority {
        switch priority {
        case "base priority":
            return .base
        case "hight priority":
            return .high
        case "low priority":
            return .low
        default:
            return .base
        }
    }
    
    static func parse(json: [String: Any]) -> Note?{
        let uid = json["uid"] as? String
        let title = json["title"] as? String
        let content = json["content"] as? String
        let priority = Note.stringToPriority((json["priority"] as? String)!)
        let color = UIColor.hexToColor(json["color"] as? String)
        let expirationDate = Date.stringToDate((json["expirationDate"] as? String)!)
        let note = Note(title: title!, content: content!, priority: priority, uid: uid!, color: color!, expiredDate: expirationDate)
        return note
    }
    
    var json: [String: Any]{
        var dic = [String: Any]()
        
        dic["uid"] = self.uid
        dic["title"] = self.title
        dic["content"] = self.content
        
        if self.color != .white{
            dic["color"] = self.color.rgbColor
        }
        if self.expiredDate != nil{
            dic["expirationDate"] = Date.dateToString(self.expiredDate!) //date
        }
        if self.priority != .base{
            dic["priority"] = Note.priorityToString(self.priority)
        }
        return dic
    }
}

extension UIColor {
    var rgbComponents: (red: CGFloat, green: CGFloat, blue: CGFloat, alpha: CGFloat) {
        var r: CGFloat = 0
        var g: CGFloat = 0
        var b: CGFloat = 0
        var a: CGFloat = 0
        
        if getRed(&r, green: &g, blue: &b, alpha: &a) {
            return (r,g,b,a)
        }
        
        return (0,0,0,0)
    }
    
    var hsbComponents: (hue: CGFloat, saturation: CGFloat, brightness: CGFloat, alpha: CGFloat) {
        var hue:CGFloat = 0
        var saturation:CGFloat = 0
        var brightness:CGFloat = 0
        var alpha:CGFloat = 0
        if getHue(&hue, saturation: &saturation, brightness: &brightness, alpha: &alpha){
            return (hue,saturation,brightness,alpha)
        }
        return (0,0,0,0)
    }
    
    var rgbColor: String {
        return String(format: "#%02x%02x%02x", Int(rgbComponents.red * 255), Int(rgbComponents.green * 255),Int(rgbComponents.blue * 255))
    }
    
    var rgbaColor: String {
        return String(format: "#%02x%02x%02x%02x", Int(rgbComponents.red * 255), Int(rgbComponents.green * 255),Int(rgbComponents.blue * 255),Int(rgbComponents.alpha * 255) )
    }
    
    static func hexToColor(_ hex: String?) -> UIColor? {
        guard (hex != nil) else {
            return nil
        }
        
        var cString = hex!.trimmingCharacters(in: CharacterSet.whitespaces).uppercased()
        
        if (cString.hasPrefix("#")) {
            cString = (cString as NSString).substring(from: 1)
        }
        
        if (cString.count != 6) {
            return UIColor.gray
        }
        
        let rString = (cString as NSString).substring(to: 2)
        let gString = ((cString as NSString).substring(from: 2) as NSString).substring(to: 2)
        let bString = ((cString as NSString).substring(from: 4) as NSString).substring(to: 2)
        
        var r: CUnsignedInt = 0
        var g: CUnsignedInt = 0
        var b: CUnsignedInt = 0
        
        Scanner(string: rString).scanHexInt32(&r)
        Scanner(string: gString).scanHexInt32(&g)
        Scanner(string: bString).scanHexInt32(&b)
        
        return UIColor(
            red: CGFloat(Float(r) / 255.0),
            green: CGFloat(Float(g) / 255.0),
            blue: CGFloat(b) / 255.0,
            alpha: CGFloat(1)
        )
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
