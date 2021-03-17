import UIKit

class RegisterViewController: UIViewController {
    
    //API
    let API = "UserAPI.php"
    
    //IBOutlets
    @IBOutlet weak var TxtSurName: UITextField!
    @IBOutlet weak var TxtGivenName: UITextField!
    @IBOutlet weak var BtnRadioMale: UIButton!
    @IBOutlet weak var BtnRadioFemale: UIButton!
    @IBOutlet weak var datePicker: UIDatePicker!
    @IBOutlet weak var TxtEmailId: UITextField!
    @IBOutlet weak var TxtPassword: UITextField!
    @IBOutlet weak var TxtConfirmPassword: UITextField!
    @IBOutlet weak var TxtMobileNo: UITextField!
    @IBOutlet weak var Btn_Regiter: UIButton!
    @IBOutlet weak var Btn_Cancel: UIButton!
    @IBOutlet weak var LblPassword: UILabel!
    @IBOutlet weak var LblConfirmPassword: UILabel!
    @IBOutlet weak var LblPWDMantadorySymbol: UILabel!
    @IBOutlet weak var LblConfirmPwdMantadorySymbol: UILabel!
    @IBOutlet weak var LblPageTitle: UILabel!
    @IBOutlet weak var LblMobileNoMandatory: UILabel!
    @IBOutlet weak var LblMobileNo: UILabel!
    @IBOutlet weak var LblUsrId: UILabel!
    @IBOutlet weak var LblUserId: UILabel!
    @IBOutlet weak var LblUsrIdMantadorySymbol: UILabel!
    @IBOutlet weak var LblSurName: UILabel!
    @IBOutlet weak var EditView: UIView!
    //Variables
    private  var gender = 1
    var id : String = ""
    var userId : String = ""
    var fName : String = ""
    var lName : String = ""
    var email : String = ""
    var mobileNo : String = ""
    var genderFlg = 1
    var dob : String = ""
    private var Lbl_UserId = NSLocalizedString("Lbl_UserId", comment: "")
   
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if id != "" {
            self.getUserData()
            
            LblPassword.isHidden = true
            
            LblPWDMantadorySymbol.isHidden = true
            
            TxtPassword.isHidden = true
            
            LblConfirmPassword.isHidden = true
            
            TxtConfirmPassword.isHidden = true
            
            LblConfirmPwdMantadorySymbol.isHidden = true
            
            LblMobileNo.topAnchor.constraint(equalTo: LblPassword.topAnchor).isActive = true
            
            EditView.heightAnchor.constraint(equalToConstant: CGFloat(320)).isActive = true
            
            LblPageTitle?.text = "Profile . Edit"
        } else {
            
            LblUsrId.isHidden = true
            
            LblUserId.isHidden = true
            
            LblUsrIdMantadorySymbol.isHidden = true
            
            LblSurName.topAnchor.constraint(equalTo: EditView.topAnchor).isActive = true
        }
        LblUsrId?.text = Lbl_UserId
        self.setInitialProperties()
        self.datePicker.date = Calendar.current.date(byAdding: .year, value: -18, to: Date()) ?? Date()
        self.datePicker.maximumDate = Calendar.current.date(byAdding: .year, value: -18, to: Date()) ?? Date()
        self.datePicker.minimumDate = Calendar.current.date(byAdding: .year, value: -50, to: Date()) ?? Date()
    }
    
    func getUserData() {
        let jsonParam: [String: Any] = ["ProcessName": "userSingleView","id": id]
        Common.sharedInstance.RequestFromApi( api: self.API, jsonParams: jsonParam, completionHandler: {(result) -> Void in
            let msg = result["message"] as? Int
            var key: String!
            var dict = [String: Any]()
            var sortedIndex = [String]()
            if(msg == 0)
            {
                for obj in result {
                    key = obj.key as? String
                    if(key != "error" && key != "message") {
                        sortedIndex.append(key)
                    }
                }
                for index in sortedIndex.sorted() {
                    dict = result[index] as! [String: Any]
                    let usrid = dict["userId"] as? String
                    self.userId.append(usrid!)
                    let firstName = dict["firstName"] as? String
                    self.fName.append(firstName!)
                    let lastName = dict["lastName"] as? String
                    self.lName.append(lastName!)
                    let gender = Int((dict["gender"] as? String)!)
                    self.genderFlg = (gender)!
                    let date =  dict["dob"] as? String
                    self.dob.append(date!)
                    let email = dict["email"] as? String
                    self.email.append(email!)
                    
                    let mobileNo = dict["mobileNo"] as? String
                    self.mobileNo.append(mobileNo!)
                }
                DispatchQueue.main.async {
                    self.setElement()
                }
           }
           else {
               DispatchQueue.main.async {
               }
           }
       })
   }
    
    func setElement() {
        LblUserId.text = self.userId
        TxtSurName.text = self.fName
        TxtGivenName.text = self.lName
        TxtEmailId.text = self.email
        TxtMobileNo.text = self.mobileNo
        
        let dateFormatter = DateFormatter()
        dateFormatter.locale = Locale(identifier: "en_US_POSIX") // set locale to reliable US_POSIX
        dateFormatter.dateFormat = "yyyy-MM-dd'"
        datePicker.date = dateFormatter.date(from:self.dob)!
        if genderFlg == 1 {
            BtnRadioMale.isSelected = true
            BtnRadioFemale.isSelected = false
            self.gender = 1
        }
        else if genderFlg == 2 {
            BtnRadioMale.isSelected = false
            BtnRadioFemale.isSelected = true
            self.gender = 2
        }
       }
    
    private func setInitialProperties() {
        if id != "" {
            self.Btn_Regiter.setAttributedTitle(NSAttributedString(string: "Update"), for: .normal)
            self.Btn_Regiter.layer.cornerRadius = 3
            let ultraLightConfiguration = UIImage.SymbolConfiguration(scale: .medium)
            let ultraLightSymbolImage = UIImage(systemName: "square.and.pencil", withConfiguration: ultraLightConfiguration)
            let imagecolor = ultraLightSymbolImage?.withTintColor(.white,renderingMode: .alwaysOriginal)
            self.Btn_Regiter.setImage(imagecolor, for: .normal)
            self.Btn_Regiter.imageEdgeInsets = UIEdgeInsets(top: 0, left: -5, bottom: 0, right: 5)
        } else {
            self.Btn_Regiter.layer.cornerRadius = 3
            let ultraLightConfiguration = UIImage.SymbolConfiguration(scale: .medium)
            let ultraLightSymbolImage = UIImage(systemName: "plus", withConfiguration: ultraLightConfiguration)
            let imagecolor = ultraLightSymbolImage?.withTintColor(.white,renderingMode: .alwaysOriginal)
            self.Btn_Regiter.setImage(imagecolor, for: .normal)
            self.Btn_Regiter.imageEdgeInsets = UIEdgeInsets(top: 0, left: -5, bottom: 0, right: 5)
            self.Btn_Regiter.backgroundColor = UIColor(red: 22/255, green: 160/255, blue: 134/255, alpha: 1)
            self.BtnRadioMale.isSelected = true
           
        }
        
        self.Btn_Cancel.backgroundColor = UIColor(red: 201/255, green: 48/255, blue: 44/255, alpha: 1)
        self.Btn_Cancel.layer.cornerRadius = 3
        let ultraLightConfigurations = UIImage.SymbolConfiguration(scale: .medium)
        let ultraLightSymbolImages = UIImage(systemName: "xmark", withConfiguration: ultraLightConfigurations)
        let imagecolors = ultraLightSymbolImages?.withTintColor(.white,renderingMode: .alwaysOriginal)
        self.Btn_Cancel.setImage(imagecolors, for: .normal)
        self.Btn_Cancel.imageEdgeInsets = UIEdgeInsets(top: 0, left: -5, bottom: 0, right: 5)
       
    }
    
    @IBAction func BtnRadio(_ sender: UIButton) {
        if sender.tag == 1 {
            BtnRadioMale.isSelected = true
            BtnRadioFemale.isSelected = false
            self.gender = sender.tag
        }
        else if sender.tag == 2 {
            BtnRadioMale.isSelected = false
            BtnRadioFemale.isSelected = true
            self.gender = sender.tag
        }
        
    }
    
    @IBAction func BtnRegProcess(_ sender: UIButton) {
        if(!self.regValidation()) {
            return
        }
        if id != "" {
            let confirmationDialog = Common.DialogResult(title: "Confirmation", message: "Are you sure, you want to Update?")
            let okClick = UIAlertAction(title: "Yes", style: .default, handler: { (alert) -> Void in
                self.updateProcess()
            })
            let cancelClick = UIAlertAction(title: "No", style: .cancel, handler: { (alert) -> Void in
                self.updateProcess()
            })
            confirmationDialog.addAction(okClick)
            confirmationDialog.addAction(cancelClick)
            DispatchQueue.main.async {
                self.present(confirmationDialog, animated: true, completion: nil)
            }
        } else {
            let confirmationDialog = Common.DialogResult(title: "Confirmation", message: "Are you sure, you want to Register?")
            let okClick = UIAlertAction(title: "Yes", style: .default, handler: { (alert) -> Void in
                self.regProcess()
            })
            let cancelClick = UIAlertAction(title: "No", style: .cancel, handler: nil)
            confirmationDialog.addAction(okClick)
            confirmationDialog.addAction(cancelClick)
            DispatchQueue.main.async {
                self.present(confirmationDialog, animated: true, completion: nil)
            }
        }
       
    }
    
    
    private func regValidation() -> Bool {
        var valid = true
        if(self.TxtSurName.text!.isEmpty) {
            Common.addImageValidation(txtField: self.TxtSurName,flg: 1)
            valid = false
        } else {
            Common.RemoveImageValidation(txtField: self.TxtSurName)
        }
        if(self.TxtGivenName.text!.isEmpty) {
            Common.addImageValidation(txtField: self.TxtGivenName,flg: 1)
            valid = false
        } else {
            Common.RemoveImageValidation(txtField: self.TxtGivenName)
        }
        if(self.TxtEmailId.text!.isEmpty) {
            Common.addImageValidation(txtField: self.TxtEmailId,flg: 1)
            valid = false
        } else {
            if(!Common.IsValidEmail(email: self.TxtEmailId.text!)) {
                Common.addImageValidation(txtField: self.TxtEmailId,flg: 3)
                valid = false
            } else {
                Common.RemoveImageValidation(txtField: self.TxtEmailId)
            }
        }
        if id == "" {
            if(self.TxtPassword.text!.isEmpty) {
                Common.addImageValidation(txtField: self.TxtPassword,flg: 1)
                valid = false
            } else {
                Common.RemoveImageValidation(txtField: self.TxtPassword)
            }
            if(self.TxtConfirmPassword.text!.isEmpty) {
                Common.addImageValidation(txtField: self.TxtConfirmPassword,flg: 1)
                valid = false
            } else {
                if(self.TxtPassword.text! != self.TxtConfirmPassword.text!) {
                    Common.addImageValidation(txtField: self.TxtConfirmPassword,flg: 2)
                    valid = false
                } else {
                    Common.RemoveImageValidation(txtField: self.TxtConfirmPassword)
                }
            }
            
        }
        if(self.TxtMobileNo.text!.isEmpty) {
            Common.addImageValidation(txtField: self.TxtMobileNo,flg: 1)
            valid = false
        } else {
            if(self.TxtMobileNo.text!.count > 12) {
                Common.addImageValidation(txtField: self.TxtMobileNo,flg: 4)
                valid = false
            } else if(self.TxtMobileNo.text!.count < 9) {
                Common.addImageValidation(txtField: self.TxtMobileNo,flg: 5)
                valid = false
            } else {
                Common.RemoveImageValidation(txtField: self.TxtMobileNo)
            }
        }
        return valid
    }

    private func regProcess() {
        let DOB = Common.sharedInstance.DateWitthFormat(dateFormat: Common.sharedInstance.DateFormat, date: self.datePicker.date)
        let jsonParam: [String: Any] = ["ProcessName": "Register" , "SurName": self.TxtSurName.text!, "GivenName": self.TxtGivenName.text!, "DOB": DOB, "gender": self.gender, "EmailId": self.TxtEmailId.text!, "Password": self.TxtPassword.text!, "ConfirmPassword": self.TxtConfirmPassword.text!, "MobileNo": self.TxtMobileNo.text!]
        Common.sharedInstance.RequestFromApi(api: self.API, jsonParams: jsonParam, completionHandler: {(result) -> Void in
            let msg = result["message"] as? Int
            var alertMessage: String!
            var okClick = UIAlertAction()
            
            if(msg == 0) {
                alertMessage = "Registered succesfully"
                okClick = UIAlertAction(title: "Ok", style: .default) { (alert: UIAlertAction!) -> Void in
                    Common.sharedInstance.RedirectStoryboard(viewController: self, segueName: "RegproSegue") }
            }
            else if(msg == 2) {
                alertMessage = "Email Id Already Exists"
                okClick = (UIAlertAction(title: "Ok", style: UIAlertAction.Style.default, handler: nil))
            }
            else {
                alertMessage = "User failed to add"
                okClick = (UIAlertAction(title: "Try Again", style: UIAlertAction.Style.default, handler: nil))
            }
            DispatchQueue.main.async {
                let confirmationAlert = UIAlertController(title: "Alert", message: alertMessage, preferredStyle: .alert)
                confirmationAlert.addAction(okClick)
                self.present(confirmationAlert, animated: true, completion: nil)
            }
        })
    }
    
    func updateProcess() {
        let DOB = Common.sharedInstance.DateWitthFormat(dateFormat: Common.sharedInstance.DateFormat, date: self.datePicker.date)
        let jsonParam: [String: Any] = ["ProcessName": "Update" , "userId": id,"SurName": self.TxtSurName.text!, "GivenName": self.TxtGivenName.text!, "DOB": DOB, "gender": self.gender, "EmailId": self.TxtEmailId.text!, "MobileNo": self.TxtMobileNo.text!]
        Common.sharedInstance.RequestFromApi(api: self.API, jsonParams: jsonParam, completionHandler: {(result) -> Void in
            let msg = result["message"] as? Int
            var alertMessage: String!
            var okClick = UIAlertAction()
            if(msg == 0) {
                alertMessage = "Update succesfully"
                okClick = UIAlertAction(title: "Ok", style: .default) { (alert: UIAlertAction!) -> Void in
                    self.navigationController?.popViewController(animated: true)
                }
            }
            else {
                alertMessage = "User failed to Update"
                okClick = (UIAlertAction(title: "Try Again", style: UIAlertAction.Style.default, handler: nil))
            }
            DispatchQueue.main.async {
                let confirmationAlert = UIAlertController(title: "Alert", message: alertMessage, preferredStyle: .alert)
                confirmationAlert.addAction(okClick)
                self.present(confirmationAlert, animated: true, completion: nil)
                
            }
        })
    }
    
    @IBAction func cancelProcess(_ sender: Any) {
        if(id != "") {
            self.navigationController?.popViewController(animated: true)
        } else {
            performSegue(withIdentifier: "GoLoginPage", sender: self)
        }
        
    }
}
