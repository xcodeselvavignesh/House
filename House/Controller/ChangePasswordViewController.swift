import UIKit

class ChangePasswordViewController: UIViewController, UITextFieldDelegate {
    
    private let API = "HomeAPI.php"

    @IBOutlet weak var Txt_CurrentPassword: UITextField!
    @IBOutlet weak var Txt_NewPassword: UITextField!
    @IBOutlet weak var Txt_ConfirmPassword: UITextField!
    @IBOutlet weak var Lbl_Error: UILabel!
    override func viewDidLoad() {
        super.viewDidLoad()
        Txt_CurrentPassword.delegate = self
        Txt_NewPassword.delegate = self
        Txt_ConfirmPassword.delegate = self
        self.setTitleImage()
    }
    
    @IBAction func showHidePassword(_ sender: UIButton) {
        if(sender.isSelected) {
            self.toggleButton(sender: sender, toggleValue: false)
        }
        else {
            self.toggleButton(sender: sender, toggleValue: true)
        }
    }
    
    @IBAction func Btn_ChangePasswordAction(_ sender: UIButton) {
        if(!self.checkValidation()) {
            return
        }
        let confirmationDialog = Common.DialogResult(title: "Confirmation", message: "Are you sure, you want to change the password?")
        let okClick = UIAlertAction(title: "Yes", style: .default, handler: { (alert) -> Void in
            self.changePasswordProcess()
        })
        let cancelClick = UIAlertAction(title: "No", style: .cancel, handler: nil)
        confirmationDialog.addAction(okClick)
        confirmationDialog.addAction(cancelClick)
        DispatchQueue.main.async {
            self.present(confirmationDialog, animated: true, completion: nil)
        }
    }
    
    private func checkValidation() -> Bool {
        var isValid = true
        if(self.Txt_CurrentPassword.text!.isEmpty) {
            Common.addImageValidation(txtField: self.Txt_CurrentPassword,flg: 1)
            isValid = false
        }
        else {
            Common.RemoveImageValidation(txtField: self.Txt_CurrentPassword)
        }
        if(self.Txt_NewPassword.text!.isEmpty) {
            Common.addImageValidation(txtField: self.Txt_NewPassword,flg: 1)
            isValid = false
        }
        else {
            Common.RemoveImageValidation(txtField: self.Txt_NewPassword)
        }
        if(self.Txt_ConfirmPassword.text!.isEmpty) {
            Common.addImageValidation(txtField: self.Txt_ConfirmPassword,flg: 1)
            isValid = false
        }
        else {
            Common.RemoveImageValidation(txtField: self.Txt_ConfirmPassword)
        }
        if(!self.Txt_NewPassword.text!.isEmpty && !self.Txt_ConfirmPassword.text!.isEmpty) {
            if(self.Txt_NewPassword.text != self.Txt_ConfirmPassword.text) {
                isValid = false
                self.Lbl_Error.isHidden = false
                self.Lbl_Error.text = "Confirm Password does not match"
            }
            else {
                self.Lbl_Error.text = "Current Password does not match"
                self.Lbl_Error.isHidden = true
            }
        }
        return isValid
    }
    
    private func changePasswordProcess() {
        let jsonParam: [String: Any] = ["UserID": UserDefaults.standard.string(forKey: "UserID")!,"ProcessName": "ChangePassword","CurrentPassword": self.Txt_CurrentPassword.text!, "NewPassword": self.Txt_NewPassword.text!]
        Common.sharedInstance.RequestFromApi(api: self.API, jsonParams: jsonParam, completionHandler: {(result) -> Void in
            let msg = result["message"] as? Int
            DispatchQueue.main.async {
                if(msg == 0) {
                    UserDefaults.standard.removeObject(forKey: "UserID")
                    self.performSegue(withIdentifier: "ChangePasswordSegue", sender: nil)
                }
                else {
                    self.Lbl_Error.isHidden = false
                }
            }
        })
    }
    
    private func toggleButton(sender: UIButton, toggleValue: Bool) {
        if(toggleValue) {
            sender.isSelected = true
            self.toggleContent(sender: sender, toggleValue: true)
        }
        else {
            sender.isSelected = false
            self.toggleContent(sender: sender, toggleValue: false)
        }
    }
    
    private func toggleContent(sender: UIButton, toggleValue: Bool) {
        let buttonTag = sender.tag
        if(toggleValue) {
            switch buttonTag {
            case 1:
                self.Txt_CurrentPassword.isSecureTextEntry = false
            case 2:
                self.Txt_NewPassword.isSecureTextEntry = false
            default:
                self.Txt_ConfirmPassword.isSecureTextEntry = false
            }
        }
        else {
            switch buttonTag {
            case 1:
                self.Txt_CurrentPassword.isSecureTextEntry = true
            case 2:
                self.Txt_NewPassword.isSecureTextEntry = true
            default:
                self.Txt_ConfirmPassword.isSecureTextEntry = true
            }
        }
    }
    //Max length set in all fields
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        if (textField == Txt_NewPassword || textField == Txt_CurrentPassword || textField == Txt_ConfirmPassword) {
            guard let text = textField.text else { return true }
            let newLength = text.count + string.count - range.length
            return newLength <= 30
        }
        return true
    }
}
