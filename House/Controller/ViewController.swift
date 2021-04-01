import UIKit

class ViewController: UIViewController, UITextFieldDelegate {
    
    // API Name
    let API = "HomeAPI.php"
    
    // @IBOutlets
    @IBOutlet weak var TxtUserId: UITextField!
    @IBOutlet weak var TxtPassword: UITextField!
    @IBOutlet weak var Out_btnLogin: UIButton!
    @IBOutlet weak var Img_BannerIcon: UIImageView!
    @IBOutlet weak var Img_BannerBG: UIImageView!
    @IBOutlet weak var Lbl_BannerLabel: UILabel!
    @IBOutlet weak var Lbl_EmailMessage: UILabel!
    @IBOutlet weak var Lbl_PasswordMessage: UILabel!
    @IBOutlet weak var Lbl_LoginErrorLabel: UILabel!
    
    
    private var imageTimer: Timer!
    private let images = [ UIImage(named: "dots-40.png"), UIImage(named: "gears-40.png")]
    private let bannerLabels = ["About us", "Contact"]
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        TxtUserId.delegate = self
        TxtPassword.delegate = self
        self.startImageTimer()
        self.setInitialProperties()
        self.TxtUserId.addTarget(self, action: #selector(textFieldDidChange(_:)), for: .editingChanged)
        self.TxtPassword.addTarget(self, action: #selector(textFieldDidChange(_:)), for: .editingChanged)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        navigationController?.setNavigationBarHidden(true, animated: animated)
    }
    
    @IBAction func BtnLogin(_ sender: Any) {
        self.checkValidation(textField: self.TxtUserId)
        self.checkValidation(textField: self.TxtPassword)
        let userId = TxtUserId.text
        let password = TxtPassword.text
        if (userId!.isEmpty || password!.isEmpty) {
            return
        }
        self.loginProcess(userId!,password!)
     
    }
    
    private func addBottomBorder(textField: UITextField) {
        let bottomLine = CALayer()
        bottomLine.frame = CGRect(x: 0, y: textField.frame.height - 2, width: textField.frame.width, height: 2)
        bottomLine.backgroundColor = UIColor.init(red: 90/255, green: 99/255, blue: 116/255, alpha: 1).cgColor
        textField.layer.addSublayer(bottomLine)
    }
    
    private func setInitialProperties() {
        self.addBottomBorder(textField: TxtUserId)
        self.addBottomBorder(textField: TxtPassword)
        self.Img_BannerIcon.backgroundColor = UIColor(red: 79/255, green: 193/255, blue: 183/255, alpha: 1)
        self.Img_BannerBG.backgroundColor = UIColor(red: 245/255, green: 129/255, blue: 66/255, alpha: 1)
        self.Out_btnLogin.backgroundColor = UIColor(red: 245/255, green: 129/255, blue: 66/255, alpha: 1)
    }
    
    private func startImageTimer() {
        self.imageTimer = Timer(fire: Date(), interval: 5, repeats: true) { (timer) in
            self.Img_BannerBG.image = self.images.randomElement() as? UIImage
            self.Lbl_BannerLabel.text = self.bannerLabels.randomElement()
        }
        RunLoop.main.add(self.imageTimer, forMode: .common)
    }
    
    private func checkValidation(textField: UITextField) {
        if (textField.text!.isEmpty) {
            if(textField.accessibilityIdentifier == "Email") {
                self.Lbl_EmailMessage.isHidden = false
                self.Lbl_EmailMessage.text = "Required"
            }
            if(textField.accessibilityIdentifier == "Password") {
                self.Lbl_PasswordMessage.isHidden = false
                self.Lbl_PasswordMessage.text = "Required"
            }
        }
    }
    
    @objc func textFieldDidChange(_ textField: UITextField) {
        if(textField.accessibilityIdentifier == "Email") {
            if(textField.text!.isEmpty) {
                self.Lbl_EmailMessage.isHidden = false
                self.Lbl_EmailMessage.text = "Required"
            }
            else {
                self.Lbl_EmailMessage.isHidden = true
            }
        }
        else if(textField.accessibilityIdentifier == "Password") {
            if(textField.text!.isEmpty) {
                self.Lbl_PasswordMessage.isHidden = false
                self.Lbl_PasswordMessage.text = "Required"
            }
            else {
                self.Lbl_PasswordMessage.isHidden = true
            }
        }
    }
    //Max length set in all fields
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        if (textField == TxtUserId || textField == TxtPassword) {
            guard let text = textField.text else { return true }
            let newLength = text.count + string.count - range.length
            return newLength <= 30
        }
        return true
    }
    func loginProcess(_ userId: String, _ password: String) {
        let jsonParam: [String: Any] = ["ProcessName": "Login", "userId": self.TxtUserId.text!, "password": self.TxtPassword.text!]
        Common.sharedInstance.RequestFromApi(api: self.API, jsonParams: jsonParam, completionHandler: {(result) -> Void in
            let msg = result["message"] as? Int
            var alertMessage: String!
            var okClick = UIAlertAction()
            DispatchQueue.main.async {
                if(msg == 0)
                {
                    let sessionVar = result["0"] as! [String : Any]
                    let userId = sessionVar["userId"] as? String
                    let emailId = sessionVar["email"] as? String
                    let userType = Int((sessionVar["userType"] as? String)!)
                    let lastName = sessionVar["lastName"] as? String
                    let langFlg = Int((sessionVar["langFlg"] as? String)!)
                    let verifyFlg = Int((sessionVar["verifyFlg"] as? String)!)
                    UserDefaults.standard.setValue(userId!, forKey: "UserID")
                    UserDefaults.standard.setValue(emailId!, forKey: "emailID")
                    UserDefaults.standard.setValue(userType, forKey: "userType")
                    UserDefaults.standard.setValue(lastName!, forKey: "lastName")
                    UserDefaults.standard.setValue(langFlg, forKey: "langFlg")
                    UserDefaults.standard.setValue(verifyFlg, forKey: "verifyFlg")
                    self.Lbl_LoginErrorLabel.isHidden = true
                    if((UserDefaults.standard.integer(forKey: "verifyFlg")) == 1 || (UserDefaults.standard.integer(forKey: "userType")) == 1){
                        var locale: String
                        if((UserDefaults.standard.integer(forKey: "langFlg")) == 1){
                                locale = "ja"
                        } else {
                                locale = "en"
                        }
                        Common.sharedInstance.languageChangeAction(locale: locale)
                    } else {
                        alertMessage = "Please Verify Email"
                        okClick = (UIAlertAction(title: "Ok", style: UIAlertAction.Style.default, handler: nil))
                    }
                    DispatchQueue.main.async {
                        let confirmationAlert = UIAlertController(title: "Alert", message: alertMessage, preferredStyle: .alert)
                        confirmationAlert.addAction(okClick)
                        self.present(confirmationAlert, animated: true, completion: nil)
                    }
                }
                else
                {
                    self.Lbl_LoginErrorLabel.isHidden = false
                }
            }
        })
    }
}
