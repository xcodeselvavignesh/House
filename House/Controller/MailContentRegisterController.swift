//
//  MailContentRegisterController.swift
//  House
//
//  Created by Randy Orton on 26/02/21.
//

import UIKit
import SideMenu
protocol MailContentRegister {
    func passDataBack(mcName: String,mcSubject: String,mcHeader: String,mcContent: String)
}
protocol MailContentReg {
    func passDataReg()
}
class MailContentRegisterController: UIViewController,UITextFieldDelegate, UITextViewDelegate {
    
    //API
    let API = "MailContentAPI.php"
    @IBOutlet weak var mailName: UITextField!
    @IBOutlet weak var mailSubject: UITextField!
    @IBOutlet weak var mailHeader: UITextField!
    @IBOutlet weak var mailContent: UITextView!
    @IBOutlet weak var mailcontentView: UIView!
    @IBOutlet weak var mailregButton: UIButton!
    @IBOutlet weak var mailcanButton: UIButton!
    
    @IBOutlet weak var LblPageTitle: UILabel!
    var id : String = ""
    var mcName : String = ""
    var mcSubject : String = ""
    var mcHeader : String = ""
    var mcContent : String = ""
    var delegate: MailContentRegister?
    var delegates: MailContentReg?
    override func viewDidLoad() {
        mailName.delegate = self
        mailSubject.delegate = self
        mailHeader.delegate = self
        mailContent.delegate = self
        let imageView = UIImageView(frame: CGRect(x: 0, y: 0, width: 100, height: 20))
        imageView.contentMode = .scaleToFill
        let image = UIImage(named: "Microbit_logo-40")
        imageView.image  = image
        self.navigationItem.titleView = imageView
        if id != "" {
            self.getMailContentEditDetails()
            LblPageTitle?.text = NSLocalizedString("Lbl_MailContentEdit", comment: "")
            self.mailregButton.setAttributedTitle(NSAttributedString(string: NSLocalizedString("Lbl_Update", comment: "")), for: .normal)
            mailregButton.backgroundColor = UIColor.systemOrange
        }
        mailcontentView.layer.masksToBounds = true
        mailcontentView.layer.borderColor = UIColor.black.cgColor
        mailcontentView.layer.borderWidth = 0.8
        mailcontentView.layer.cornerRadius = 3
        mailName.layer.borderWidth = 0.6
        mailName.layer.cornerRadius = 3
        mailSubject.layer.borderWidth = 0.6
        mailSubject.layer.cornerRadius = 3
        mailHeader.layer.borderWidth = 0.6
        mailHeader.layer.cornerRadius = 3
        mailContent.layer.borderWidth = 0.8
        mailContent.layer.cornerRadius = 3
        self.registerdesign()
        self.canceldesign()
        // Do any additional setup after loading the view.
    }
    func getMailContentEditDetails() {
        let jsonParam: [String: Any] = ["ProcessName": "mailcontentSingleView","id": id]
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
                    let mailname = dict["mailName"] as? String
                    self.mcName.append(mailname!)
                    let mailsubject = dict["subject"] as? String
                    self.mcSubject.append(mailsubject!)
                    let mailheader = dict["header"] as? String
                    self.mcHeader.append(mailheader!)
                    let mailcontent = dict["content"] as? String
                    self.mcContent.append(mailcontent!)
    
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
        mailName.text = self.mcName
        mailSubject.text = self.mcSubject
        mailHeader.text = self.mcHeader
        mailContent.text = self.mcContent
    }
    func registerdesign()
    {
        if id != "" {
            mailregButton.layer.cornerRadius = 3
            let ultraLightConfiguration = UIImage.SymbolConfiguration(scale: .medium)
            let ultraLightSymbolImage = UIImage(systemName: "square.and.pencil", withConfiguration: ultraLightConfiguration)
            let imagecolor = ultraLightSymbolImage?.withTintColor(.white,renderingMode: .alwaysOriginal)
            mailregButton.setImage(imagecolor, for: .normal)
            mailregButton.imageEdgeInsets = UIEdgeInsets(top: 0, left: -5, bottom: 0, right: 5)
        } else {
            mailregButton.layer.cornerRadius = 3
            let ultraLightConfiguration = UIImage.SymbolConfiguration(scale: .medium)
            let ultraLightSymbolImage = UIImage(systemName: "plus", withConfiguration: ultraLightConfiguration)
            let imagecolor = ultraLightSymbolImage?.withTintColor(.white,renderingMode: .alwaysOriginal)
            mailregButton.setImage(imagecolor, for: .normal)
            mailregButton.imageEdgeInsets = UIEdgeInsets(top: 0, left: -5, bottom: 0, right: 5)
            
        }
    }
    func canceldesign() {
        mailcanButton.layer.cornerRadius = 3
        let ultraLightConfigurations = UIImage.SymbolConfiguration(scale: .medium)
        let ultraLightSymbolImages = UIImage(systemName: "xmark", withConfiguration: ultraLightConfigurations)
        let imagecolors = ultraLightSymbolImages?.withTintColor(.white,renderingMode: .alwaysOriginal)
        mailcanButton.setImage(imagecolors, for: .normal)
        mailcanButton.imageEdgeInsets = UIEdgeInsets(top: 0, left: -5, bottom: 0, right: 5)
    }

    @IBAction func mailcontentRegisterProcess(_ sender: UIButton) {
        if(!self.regValidation()) {
            return
        }
        var alertMessage: String!
        var okclick = UIAlertAction()
        if(self.mailContent.text!.isEmpty) {
            alertMessage = "MailContent Field is required"
            okclick = (UIAlertAction(title: "Ok", style: UIAlertAction.Style.default, handler: nil))
            let confirmationAlert = UIAlertController(title: "Alert", message: alertMessage, preferredStyle: .alert)
            confirmationAlert.addAction(okclick)
            self.present(confirmationAlert, animated: true, completion: nil)
        }
        if id != "" {
            let confirmationDialog = Common.DialogResult(title: "Confirmation", message: NSLocalizedString("Lbl_Updateconfirmmessage", comment: ""))
            let cancelClick = UIAlertAction(title: NSLocalizedString("Lbl_Nomessage", comment: ""), style: .cancel, handler: nil)
            let okClick = UIAlertAction(title: NSLocalizedString("Lbl_Yesmessage", comment: ""), style: .default, handler: { (alert) -> Void in
                self.mailcontenteditProcess()
            })
            confirmationDialog.addAction(okClick)
            confirmationDialog.addAction(cancelClick)
            DispatchQueue.main.async {
                self.present(confirmationDialog, animated: true, completion: nil)
            }
        } else {
            let confirmationDialog = Common.DialogResult(title: "Confirmation", message: NSLocalizedString("Lbl_Registerconfirmmessage", comment: ""))
            let okClick = UIAlertAction(title: NSLocalizedString("Lbl_Yesmessage", comment: ""), style: .default, handler: { (alert) -> Void in
                self.mailcontentregProcess()
            })
            let cancelClick = UIAlertAction(title: NSLocalizedString("Lbl_Nomessage", comment: ""), style: .cancel, handler: nil)
            confirmationDialog.addAction(okClick)
            confirmationDialog.addAction(cancelClick)
            DispatchQueue.main.async {
                self.present(confirmationDialog, animated: true, completion: nil)
            }
        }
    }
    private func regValidation() -> Bool {
        var valid = true
        if(self.mailName.text!.isEmpty) {
            Common.addImageValidation(txtField: self.mailName,flg: 1)
            valid = false
        } else {
            Common.RemoveImageValidation(txtField: self.mailName)
        }
        if(self.mailSubject.text!.isEmpty) {
            Common.addImageValidation(txtField: self.mailSubject,flg: 1)
            valid = false
        } else {
            Common.RemoveImageValidation(txtField: self.mailSubject)
        }
        if(self.mailHeader.text!.isEmpty) {
            Common.addImageValidation(txtField: self.mailHeader,flg: 1)
            valid = false
        } else {
            Common.RemoveImageValidation(txtField: self.mailHeader)
        }
        return valid
    }
    private func mailcontentregProcess() {
        let jsonParam: [String: Any] = ["ProcessName": "mailcontentRegister" , "MailName": self.mailName.text!, "MailSubject": self.mailSubject.text!, "MailHeader": self.mailHeader.text!,"MailContent": self.mailContent.text!,"LastName": UserDefaults.standard.string(forKey: "lastName")!]
        Common.sharedInstance.RequestFromApi(api: self.API, jsonParams: jsonParam, completionHandler: {(result) -> Void in
            let msg = result["message"] as? Int
            var alertMessage: String!
            var okClick = UIAlertAction()
            if(msg == 0) {
                alertMessage = "Registered Successfully"
                okClick = UIAlertAction(title: "Ok", style: .default) { (alert: UIAlertAction!) -> Void in
                    self.navigationController?.popViewController(animated: true)
                    self.delegates?.passDataReg()
                    self.navigationController?.popViewController(animated: true)
                   
                }
            }
            else {
                alertMessage = "MailContent failed to add"
                okClick = (UIAlertAction(title: "Try Again", style: UIAlertAction.Style.default, handler: nil))
            }
            DispatchQueue.main.async {
                let confirmationAlert = UIAlertController(title: "Alert", message: alertMessage, preferredStyle: .alert)
                confirmationAlert.addAction(okClick)
                self.present(confirmationAlert, animated: true, completion: nil)
            }
        })
    }
    private func mailcontenteditProcess() {
        let jsonParam: [String: Any] = ["ProcessName": "mailcontentEdit" ,"MailId":id, "MailName": self.mailName.text!, "MailSubject": self.mailSubject.text!, "MailHeader": self.mailHeader.text!,"MailContent": self.mailContent.text!,"LastName": UserDefaults.standard.string(forKey: "lastName")!]
        Common.sharedInstance.RequestFromApi(api: self.API, jsonParams: jsonParam, completionHandler: {(result) -> Void in
            let msg = result["message"] as? Int
            var alertMessage: String!
            var okClick = UIAlertAction()
            if(msg == 0) {
                alertMessage = "Updated Successfully"
                okClick = UIAlertAction(title: "Ok", style: .default) { (alert: UIAlertAction!) -> Void in
                    self.delegate?.passDataBack(mcName: self.mailName.text!, mcSubject: self.mailSubject.text!, mcHeader: self.mailHeader.text!, mcContent: self.mailContent.text!)
                    self.navigationController?.popViewController(animated: true)
                }
            }
            else {
                alertMessage = "MailContent failed to update"
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
       self.navigationController?.popViewController(animated: true)
    }
    //Max length set in all Text fields
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        if (textField == mailName || textField == mailSubject || textField == mailHeader) {
            guard let text = textField.text else { return true }
            let newLength = text.count + string.count - range.length
            return newLength <= 50
        }
        return true
    }
    //Max length set in all Text View
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        if (textView == mailContent) {
            let newText = (textView.text as NSString).replacingCharacters(in: range, with: text)
            let numberofChars = newText.count
            return numberofChars <= 300
        }
        return true
    }
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
