import UIKit

class Forgot_PasswordViewController: UIViewController {
    
    private let API = "HomeAPI.php"
    
    //IBOutlets
    @IBOutlet weak var Btn_ResetPassword: UIButton!
    @IBOutlet weak var Btn_Cancel: UIButton!
    @IBOutlet weak var Txt_Email: UITextField!
    @IBOutlet weak var Lbl_Email: UILabel!
    @IBOutlet weak var Lbl_EmailErrorLabel: UILabel!
    @IBOutlet weak var Lbl_EmailNotExists: UILabel!

    override func viewDidLoad() {
        super.viewDidLoad()
        self.setInitialProperties()
    }
    
    @IBAction func Btn_ResetPasswordAction(_ sender: UIButton) {
        if(!self.checkValidation()) {
            return
        }
        self.Lbl_EmailErrorLabel.isHidden = true
        self.Lbl_EmailNotExists.isHidden = true
        self.resetPassword()
    }
    
    private func setInitialProperties() {
        self.Btn_ResetPassword.backgroundColor = UIColor(red: 46/255, green: 109/255, blue: 164, alpha: 1)
        self.Btn_Cancel.backgroundColor = UIColor(red: 212/255, green: 63/255, blue: 58/255, alpha: 1)
        self.Lbl_Email.backgroundColor = UIColor(patternImage: UIImage(named: "dots-40.png")!)
    }
    
    private func checkValidation() -> Bool {
        var valid = false
        if(!self.Txt_Email.text!.isEmpty) {
            if(!Common.IsValidEmail(email: self.Txt_Email.text!)) {
                self.Lbl_EmailErrorLabel.isHidden = false
                self.Lbl_EmailErrorLabel.text = "Not a Valid Email"
            }
            else {
                self.Lbl_EmailErrorLabel.isHidden = true
                valid = true
            }
        }
        else {
            self.Lbl_EmailErrorLabel.isHidden = false
            self.Lbl_EmailErrorLabel.text = "Required"
        }
        return valid
    }
    
    private func resetPassword() {
        let requestURL = URL(string: self.API)
        let request = NSMutableURLRequest(url: requestURL!)
        request.httpMethod = "POST"
        let jsonParams: [String: Any] = ["ProcessName": "ResetPassword", "Email": self.Txt_Email.text!]
        Common.sharedInstance.RequestFromApi(api: self.API, jsonParams: jsonParams, completionHandler: {(result) -> Void in
            let msg = result["message"] as? Int
            var alertMessage: String!
            
            var okClick = UIAlertAction()
            if(msg == 0) {
                alertMessage = "Password reseted succesfully"
                okClick = UIAlertAction(title: "Ok", style: .default) { (alert: UIAlertAction!) -> Void in
                    Common.sharedInstance.RedirectStoryboard(viewController: self, segueName: "ForgotPasswordSegue") }
            }
            else if(msg == 2) {
                DispatchQueue.main.async {
                    self.Lbl_EmailNotExists.isHidden = false
                }
            }
            else {
                alertMessage = "Something went wrong"
            }
            if(msg == 1 || msg == nil) {
                okClick = (UIAlertAction(title: "Try Again", style: UIAlertAction.Style.default, handler: nil))
            }
            if(msg != 2) {
                DispatchQueue.main.async {
                    let confirmationAlert = UIAlertController(title: "Alert", message: alertMessage, preferredStyle: .alert)
                    confirmationAlert.addAction(okClick)
                    self.present(confirmationAlert, animated: true, completion: nil)
                }
            }
        })
    }
    
}
