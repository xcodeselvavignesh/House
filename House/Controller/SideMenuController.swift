import Foundation
import UIKit
import SideMenu

class SideMenuController {
    
    private var sideMenu: SideMenuNavigationController?
    private var userController: UIViewController?
    private var mailStatusController: UIViewController?
    private var mailcontentController: UIViewController?
    private var changePasswordController: UIViewController?
    
    init() {
        let common = Common()
        self.userController = common.userController
        self.mailStatusController = common.mailStatusController
        self.mailcontentController = common.mailcontentController
        self.changePasswordController = common.changePasswordController
    }
    
    public func AddChildControllers(viewController: UIViewController) {
        //Adding Child
        viewController.addChild(self.userController!)
        viewController.addChild(self.mailStatusController!)
        viewController.addChild(self.mailcontentController!)
        viewController.addChild(self.changePasswordController!)
        //Adding views to parent
        viewController.view.addSubview(self.userController!.view)
        viewController.view.addSubview(self.mailStatusController!.view)
        viewController.view.addSubview(self.mailcontentController!.view)
        viewController.view.addSubview(self.changePasswordController!.view)
        //set frame
        self.userController!.view.frame = viewController.view.bounds
        self.mailStatusController!.view.frame = viewController.view.bounds
        self.mailcontentController!.view.frame = viewController.view.bounds
        self.changePasswordController!.view.frame = viewController.view.bounds
        //ViewDidLoad
        self.userController!.didMove(toParent: viewController)
        self.mailStatusController!.didMove(toParent: viewController)
        self.mailcontentController!.didMove(toParent: viewController)
        self.changePasswordController!.didMove(toParent: viewController)
        //Hidden
        self.userController!.view.isHidden = true
        self.mailStatusController!.view.isHidden = true
        self.mailcontentController!.view.isHidden = true
        self.changePasswordController!.view.isHidden = true
    }
    
    func DidSelectMenu(menuItem: String, viewController: UIViewController) {
        if((UserDefaults.standard.integer(forKey: "userType")) == 1){
            switch menuItem {
                case NSLocalizedString("Lbl_Menu_House", comment: ""):
                    self.userController!.view.isHidden = true
                    self.mailStatusController!.view.isHidden = true
                    self.mailcontentController!.view.isHidden = true
                    self.changePasswordController!.view.isHidden = true
                case NSLocalizedString("Lbl_Menu_User", comment: ""):
                    self.userController!.view.isHidden = false
                    self.mailStatusController!.view.isHidden = true
                    self.mailcontentController!.view.isHidden = true
                    self.changePasswordController!.view.isHidden = true
                case NSLocalizedString("Lbl_Menu_MailStatus", comment: ""):
                    self.userController!.view.isHidden = true
                    self.mailStatusController!.view.isHidden = false
                    self.mailcontentController!.view.isHidden = true
                    self.changePasswordController!.view.isHidden = true
                case NSLocalizedString("Lbl_Menu_MailContent", comment: ""):
                    self.userController!.view.isHidden = true
                    self.mailStatusController!.view.isHidden = true
                    self.mailcontentController!.view.isHidden = false
                    self.changePasswordController!.view.isHidden = true
                case NSLocalizedString("Lbl_Menu_Change", comment: ""):
                    self.userController!.view.isHidden = true
                    self.mailStatusController!.view.isHidden = true
                    self.mailcontentController!.view.isHidden = true
                    self.changePasswordController!.view.isHidden = false
                case NSLocalizedString("Lbl_Menu_Logout", comment: ""):
                    let confirmationAlert = Common.DialogResult(title: "Alert", message: "Are you sure, you want to logout?")
                    let okClick = UIAlertAction(title: "OK", style: .default, handler: {alert -> Void in
                        //API
                        let API = "HomeAPI.php"
                        let jsonParam: [String: Any] = ["ProcessName": "Logout" , "userId": UserDefaults.standard.string(forKey: "UserID")!]
                        Common.sharedInstance.RequestFromApi(api: API, jsonParams: jsonParam, completionHandler: {(result) -> Void in
                        })
                        Common.sessionClear(viewController: viewController)
                    })
                    let cancelClick = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
                    confirmationAlert.addAction(okClick)
                    confirmationAlert.addAction(cancelClick)
                    DispatchQueue.main.async {
                        viewController.present(confirmationAlert, animated: true, completion: nil)
                    }
                case NSLocalizedString("Lbl_Menu_EN", comment: ""), NSLocalizedString("Lbl_Menu_JA", comment: ""):
                    var locale: String
                    switch menuItem {
                        case NSLocalizedString("Lbl_Menu_EN", comment: ""):
                            locale = "en"
                        default:
                            locale = "ja"
                    }
                    let confirmationAlert = Common.DialogResult(title: NSLocalizedString("Lbl_Alert", comment: ""), message: NSLocalizedString("Lbl_Alert_Message", comment: ""))
                    let okClick = UIAlertAction(title: NSLocalizedString("Lbl_OK", comment: ""), style: .default, handler: {alert -> Void in
                        Common.sharedInstance.languageChangeAction(locale: locale)
                    })
                    let cancelClick = UIAlertAction(title: NSLocalizedString("Lbl_Cancel", comment: ""), style: .cancel, handler: nil)
                    confirmationAlert.addAction(okClick)
                    confirmationAlert.addAction(cancelClick)
                    DispatchQueue.main.async {
                        viewController.present(confirmationAlert, animated: true, completion: nil)
                    }
                default:
                    print("failed")
            }
        } else {
            switch menuItem {
                case NSLocalizedString("Lbl_Menu_House", comment: ""):
                    self.userController!.view.isHidden = true
                    self.mailStatusController!.view.isHidden = true
                    self.mailcontentController!.view.isHidden = true
                    self.changePasswordController!.view.isHidden = true
                case NSLocalizedString("Lbl_Menu_Change", comment: ""):
                    self.userController!.view.isHidden = true
                    self.mailStatusController!.view.isHidden = true
                    self.mailcontentController!.view.isHidden = true
                    self.changePasswordController!.view.isHidden = false
                case NSLocalizedString("Lbl_Menu_Logout", comment: ""):
                    let confirmationAlert = Common.DialogResult(title: "Alert", message: "Are you sure, you want to logout?")
                    let okClick = UIAlertAction(title: "OK", style: .default, handler: {alert -> Void in
                        //API
                        let API = "HomeAPI.php"
                        let jsonParam: [String: Any] = ["ProcessName": "Logout" , "userId": UserDefaults.standard.string(forKey: "UserID")!]
                        Common.sharedInstance.RequestFromApi(api: API, jsonParams: jsonParam, completionHandler: {(result) -> Void in
                        })
                        Common.sessionClear(viewController: viewController)
                    })
                    let cancelClick = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
                    confirmationAlert.addAction(okClick)
                    confirmationAlert.addAction(cancelClick)
                    DispatchQueue.main.async {
                        viewController.present(confirmationAlert, animated: true, completion: nil)
                    }
                case NSLocalizedString("Lbl_Menu_EN", comment: ""), NSLocalizedString("Lbl_Menu_JA", comment: ""):
                    var locale: String
                    switch menuItem {
                        case NSLocalizedString("Lbl_Menu_EN", comment: ""):
                            locale = "en"
                        default:
                            locale = "ja"
                    }
                    let confirmationAlert = Common.DialogResult(title: NSLocalizedString("Lbl_Alert", comment: ""), message: NSLocalizedString("Lbl_Alert_Message", comment: ""))
                    let okClick = UIAlertAction(title: NSLocalizedString("Lbl_OK", comment: ""), style: .default, handler: {alert -> Void in
                        Common.sharedInstance.languageChangeAction(locale: locale)
                    })
                    let cancelClick = UIAlertAction(title: NSLocalizedString("Lbl_Cancel", comment: ""), style: .cancel, handler: nil)
                    confirmationAlert.addAction(okClick)
                    confirmationAlert.addAction(cancelClick)
                    DispatchQueue.main.async {
                        viewController.present(confirmationAlert, animated: true, completion: nil)
                    }
                default:
                    print("failed")
            }
            
        }
    }
}
