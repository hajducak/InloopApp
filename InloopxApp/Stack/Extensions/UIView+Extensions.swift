import UIKit

extension UIView {
    
    // MARK: Activity Indicator on view
    func startActivityIndicator(style: UIActivityIndicatorView.Style = .whiteLarge, color: UIColor = UIColor.black, backgroundColor: UIColor = UIColor.clear) {
        endEditing(true)
        stopActivityIndicator()
        let activityIndicatorView = ActivityIndicatorView()
        activityIndicatorView.indicator.style = style
        activityIndicatorView.indicator.color = color
        activityIndicatorView.backgroundView.backgroundColor = backgroundColor
        activityIndicatorView.translatesAutoresizingMaskIntoConstraints = false
        ConstraintsHelper.setConstraintToCoverView(containerView: self, view: activityIndicatorView)
    }
    
    func stopActivityIndicator() {
        for view in subviews {
            if view.isKind(of: ActivityIndicatorView.self) {
                view.removeFromSuperview()
            }
        }
    }
    
}
