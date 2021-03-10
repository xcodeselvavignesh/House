//
//  MailContentRegisterController.swift
//  House
//
//  Created by Randy Orton on 26/02/21.
//

import UIKit
import SideMenu
class MailContentRegisterController: UIViewController {
    
    //API
    let API = "MailContentAPI.php"
    @IBOutlet weak var mailName: UITextField!
    @IBOutlet weak var mailSubject: UITextField!
    @IBOutlet weak var mailHeader: UITextField!
    @IBOutlet weak var mailContent: UITextView!
    @IBOutlet weak var mailcontentView: UIView!
    @IBOutlet weak var mailregButton: UIButton!
    @IBOutlet weak var mailcanButton: UIButton!
    override func viewDidLoad() {
        super.viewDidLoad()
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
    func registerdesign()
    {
        mailregButton.layer.cornerRadius = 3
        let ultraLightConfiguration = UIImage.SymbolConfiguration(scale: .medium)
        let ultraLightSymbolImage = UIImage(systemName: "plus", withConfiguration: ultraLightConfiguration)
        let imagecolor = ultraLightSymbolImage?.withTintColor(.white,renderingMode: .alwaysOriginal)
        mailregButton.setImage(imagecolor, for: .normal)
        mailregButton.imageEdgeInsets = UIEdgeInsets(top: 0, left: -5, bottom: 0, right: 5)
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
        let confirmationDialog = Common.DialogResult(title: "Confirmation", message: "Are you sure, you want to Register?")
        let okClick = UIAlertAction(title: "Yes", style: .default, handler: { (alert) -> Void in
            self.mailcontentregProcess()
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
                alertMessage = "Registered successfully"
                okClick = UIAlertAction(title: "Ok", style: .default) { (alert: UIAlertAction!) -> Void in
                    self.navigationController?.popViewController(animated: true)
                                       self.navigationController?.viewControllers.forEach{ ($0 as? MailContentViewController)?.MailContentList.reloadData() }
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

    @IBAction func cancelProcess(_ sender: Any) {
       self.navigationController?.popViewController(animated: true)
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
