
import UIKit

@IBDesignable class BaseButtonView: UIView {
    
    @IBInspectable var cornerRadius: CGFloat = 5.0 {
        didSet {
            layer.cornerRadius = cornerRadius
            layer.masksToBounds = cornerRadius > 0
        }
    }
    
    @IBInspectable var borderWidth: CGFloat = 1.0 {
        didSet {
            layer.borderWidth = borderWidth
        }
    }
    
    @IBInspectable var borderColor: UIColor = UIColor.lightGray {
        didSet {
            layer.borderColor = borderColor.cgColor
        }
    }
    
    override func awakeFromNib() {
        layer.cornerRadius = cornerRadius
        layer.masksToBounds = cornerRadius > 0
        layer.borderWidth = borderWidth
        layer.borderColor = borderColor.cgColor
    }
}
