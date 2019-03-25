
import UIKit

class CustomNavBar: XIBView {

    override var nibName: String {
        return CustomNavBar.nameOfClass
    }
    
    
    @IBOutlet weak var backButton: UIButton!
    @IBOutlet weak var containerView: UIView!
    


}
