import Foundation
import UIKit

class Common {
    
    //Singleton Initialization
    public static let sharedInstance = Common()
    //API
    let API = "HomeAPI.php"
    public let REQUEST_URL =  "http://ssdev.microbit.co.jp/HouseManagement/api/"
    public let Date_Formatter = DateFormatter()
    public typealias CompletionHandler = (_ result: NSDictionary) -> Void
    public let DateFormat = "yyyy-MM-dd"
    public var isPaginated: Bool?
    
    public lazy var userController: UIViewController = {
        let storyboard = UIStoryboard(name: "UserIndex", bundle: nil)
        let vc = storyboard.instantiateViewController(withIdentifier: "UserIndexVC")
        return vc
    }()
    
    public lazy var mailStatusController: UIViewController = {
        let storyboard = UIStoryboard(name: "MailStatusIndex", bundle: nil)
        let vc = storyboard.instantiateViewController(withIdentifier: "MailStatusIndexVC")
        return vc
    }()
    
    public lazy var mailcontentController: UIViewController = {
        let storyboard = UIStoryboard(name: "MailContent", bundle: nil)
        let vc = storyboard.instantiateViewController(withIdentifier: "MailContentVC")
        return vc
    }()

    public lazy var changePasswordController: UIViewController = {
        let storyboard = UIStoryboard(name: "Change_Password", bundle: nil)
        let vc = storyboard.instantiateViewController(withIdentifier: "ChangePasswordVC")
        return vc
    }()
    
    public lazy var singleUserViewController: UIViewController = {
        let storyboard = UIStoryboard(name: "SingleUserView", bundle: nil)
        let vc = storyboard.instantiateViewController(withIdentifier: "SingleUserViewVC") as! SingleUserViewController
        vc.id = UserDefaults.standard.string(forKey: "UserID")!
        return vc
    }()
    public func getAppLocale() -> String {
       if(UserDefaults.standard.integer(forKey: "langFlg") == 1) {
           return NSLocalizedString("Lbl_Menu_EN", comment: "")
       } else {
           return NSLocalizedString("Lbl_Menu_JA", comment: "")
       }
    }
    
    public func Url_String(api: String) -> String {
        return self.REQUEST_URL + api
    }
    
    public func DateWitthFormat(dateFormat: String, date: Date ) -> String {
        self.Date_Formatter.dateFormat = dateFormat
        let date = self.Date_Formatter.string(from: date)
        return date
    }
    
    public func RedirectStoryboard(viewController: UIViewController, segueName: String) {
        viewController.performSegue(withIdentifier: segueName, sender: nil)
    }
    
    public func RequestFromApi(pagination: Bool = false, api: String, jsonParams: Dictionary<String, Any>? = nil, completionHandler: @escaping CompletionHandler) {
        if(pagination) {
            self.isPaginated = true
        }
        var returnJSON = NSDictionary()
        let requestURL = URL(string: self.Url_String(api: api))
        let request = NSMutableURLRequest(url: requestURL!)
        request.httpMethod = "POST"
        if(jsonParams != nil) {
            do {
                request.httpBody = try JSONSerialization.data(withJSONObject: jsonParams!, options: .prettyPrinted)
                request.addValue("application/json", forHTTPHeaderField: "Content-Type")
                request.addValue("application/json", forHTTPHeaderField: "Accept")
            }
            catch {
                print(error.localizedDescription)
            }
        }
        let task = URLSession.shared.dataTask(with: request as URLRequest)
        { data, response, error in
            if error != nil
            {
                print("error is \(String(describing: error))")
                return;
            }
            do
            {
                returnJSON = try JSONSerialization.jsonObject(with: data!, options: .allowFragments) as? NSDictionary ?? NSDictionary()
                completionHandler(returnJSON)
                if(pagination) {
                    self.isPaginated = false
                }
            }
            catch
            {
                print(String(bytes: data!, encoding: .utf8)!)
                print(error)
            }
        }
        task.resume()
    }
    
    public static func IsValidEmail(email: String) -> Bool {
        let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"
        let emailPred = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
        return emailPred.evaluate(with: email)
    }
    
    public static func addImageValidation(txtField: UITextField,flg: Int) {
        let imageView = UIImageView(frame: CGRect(x: 0, y: 0, width: 30, height: 20))
        imageView.image = UIImage(named: "infoImg-20.png")
        imageView.contentMode = .scaleAspectFit
        txtField.rightView = imageView
        txtField.rightViewMode = .always
        txtField.layer.borderColor = UIColor.red.cgColor
        txtField.layer.borderWidth = 1
        txtField.layer.cornerRadius = 5
        if(flg == 2) {
            txtField.text = ""
            txtField.placeholder = "Confirm Password DoesNot Match"
        } else if(flg == 3) {
            txtField.text = ""
            txtField.placeholder = "Invalid Email"
        } else if(flg == 4) {
            txtField.text = ""
            txtField.placeholder = "Mobile Number below 12 Digit"
        } else if(flg == 5) {
            txtField.text = ""
            txtField.placeholder = "Mobile Number should 10 Digit"
        } else {
            txtField.placeholder = "The Field is Required"
        }
    }
    
    public static func RemoveImageValidation(txtField: UITextField) {
        txtField.rightView = .none
        txtField.rightViewMode = .always
        txtField.layer.borderColor = UIColor.black.cgColor
        txtField.layer.borderWidth = 0
        txtField.layer.cornerRadius = 0
    }
    
    public static func DialogResult(title: String, message: String, style: UIAlertController.Style = .alert) -> UIAlertController {
        let confirmationAlert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        return confirmationAlert
    }
    
    public static func sessionClear(viewController: UIViewController) {
        let session = UserDefaults.standard
        let dictionary = session.dictionaryRepresentation()
        dictionary.keys.forEach { key in
            session.removeObject(forKey: key)
        }
        let storyboard = UIStoryboard(name: "Login", bundle: nil)
        let login: ViewController = storyboard.instantiateViewController(withIdentifier: "LoginVC") as! ViewController
        DispatchQueue.main.async {
            viewController.present(login, animated: true, completion: nil)
        }
    }
    
    public func languageChangeAction(locale: String) {
        var langflg: Int
        if (locale == "en"){
            langflg = 0;
        } else {
            langflg = 1;
        }
        UserDefaults.standard.setValue(langflg, forKey: "langFlg")
        Bundle.setLanguage(locale)
        let jsonParam: [String: Any] = ["ProcessName": "LanguageFlgChange" , "userId": UserDefaults.standard.string(forKey: "UserID")!,"langflg":langflg]
        Common.sharedInstance.RequestFromApi(api: self.API, jsonParams: jsonParam, completionHandler: {(result) -> Void in
        })
        let storyboard = UIStoryboard(name: "House", bundle: nil)
        let initialViewController = storyboard.instantiateViewController(identifier: "HouseVC")
        let sceneDelegate = UIApplication.shared.connectedScenes.first!.delegate as! SceneDelegate
        sceneDelegate.window!.rootViewController = initialViewController
        sceneDelegate.window!.makeKeyAndVisible()
    }
}

