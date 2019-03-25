import UIKit

class ActivityIndicatorView: XIBView {
    
    @IBOutlet weak var backgroundView: UIView!
    
    @IBOutlet weak var indicator: UIActivityIndicatorView!
    
    override var nibName: String {
        return ActivityIndicatorView.nameOfClass
    }
    
}
