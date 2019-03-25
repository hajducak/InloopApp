
import Foundation

extension NSObject {
    
    /// class name literal
    public class var nameOfClass: String {
        get {
            guard let className = NSStringFromClass(self).components(separatedBy: ".").last else {
                return "N/A"
            }
            return className
        }
    }
}

