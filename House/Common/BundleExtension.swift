import Foundation
import UIKit

var bundleKey: UInt8 = 0

class AnyLanguageBundle: Bundle {

    override func localizedString(forKey key: String, value: String?, table tableName: String?) -> String {
        guard let path = objc_getAssociatedObject(self, &bundleKey) as? String,
            let bundle = Bundle(path: path) else {
                return super.localizedString(forKey: key, value: value, table: tableName)
        }
        return bundle.localizedString(forKey: key, value: value, table: tableName)
      }
}

extension Bundle {    
class func setLanguage(_ language: String) {
    
    defer {
        object_setClass(Bundle.main, AnyLanguageBundle.self)
    }
    objc_setAssociatedObject(Bundle.main, &bundleKey,    Bundle.main.path(forResource: language, ofType: "lproj"), .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
  }
}

extension UIViewController {
    func setTitleImage() {
        let imageView = UIImageView(frame: CGRect(x: 0, y: 0, width: 100, height: 20))
        imageView.contentMode = .scaleToFill
        let image = UIImage(named: "Microbit_logo-40")
        imageView.image  = image
        self.navigationItem.titleView = imageView
    }
}
