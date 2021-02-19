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
    
    //Variables
    private  var gender = 1
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setInitialProperties()
        self.datePicker.date = Calendar.current.date(byAdding: .year, value: -18, to: Date()) ?? Date()
        self.datePicker.maximumDate = Calendar.current.date(byAdding: .year, value: -18, to: Date()) ?? Date()
        self.datePicker.minimumDate = Calendar.current.date(byAdding: .year, value: -50, to: Date()) ?? Date()
    }
    
    private func setInitialProperties() {
        self.Btn_Regiter.backgroundColor = UIColor(red: 22/255, green: 160/255, blue: 134/255, alpha: 1)
        self.Btn_Cancel.backgroundColor = UIColor(red: 201/255, green: 48/255, blue: 44/255, alpha: 1)
        self.BtnRadioMale.isSelected = true
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

}
