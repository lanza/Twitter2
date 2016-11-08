import UIKit

extension UIImageView {
    func setupLayer() {
        layer.masksToBounds = true
        layer.cornerRadius = 12
        layer.borderWidth = 1
        layer.borderColor = UIColor.black.cgColor
    }
}
