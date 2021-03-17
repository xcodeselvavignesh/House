import UIKit

class SingleUserViewController: UIViewController {
    
    private let API = "UserAPI.php"
    @IBOutlet weak var userId: UILabel!
    @IBOutlet weak var lastName: UILabel!
    @IBOutlet weak var firstName: UILabel!
    @IBOutlet weak var gender: UILabel!
    @IBOutlet weak var dob: UILabel!
    @IBOutlet weak var email: UILabel!
    @IBOutlet weak var mobileNo: UILabel!
    @IBOutlet weak var userDataView: UIView!
    @IBOutlet weak var pageTitle: UILabel!
    @IBOutlet weak var userEditBtn: UIButton!
    @IBOutlet weak var pageTitleImg: UIImageView!
    
    var id : String = ""
    var headingTitle : String = ""
    var usrId : String = ""
    var fName : String = ""
    var lName : String = ""
    var date : String = ""
    var mail : String = ""
    var mobNo : String = ""
    var genderFlg = 1
    private var Lbl_Profile = NSLocalizedString("Lbl_Profile", comment: "")
    private var Lbl_Edit = NSLocalizedString("Lbl_Edit", comment: "")
    
    override func viewDidLoad() {
        userDataView.layer.borderWidth = 3
        userDataView.layer.borderColor = UIColor.gray.cgColor
        self.getUserData()
        if headingTitle != "" && id != "" {
            userEditBtn.setAttributedTitle(NSAttributedString(string: Lbl_Edit), for: .normal)
            pageTitle?.text = self.Lbl_Profile
            let imageName = "profile-40.png"
            pageTitleImg.image = UIImage(named: (imageName))
            userEditBtn.layer.cornerRadius = 3
            userEditBtn.backgroundColor = UIColor.orange
            let ultraLightConfiguration = UIImage.SymbolConfiguration(scale: .medium)
            let ultraLightSymbolImage = UIImage(systemName: "square.and.pencil", withConfiguration: ultraLightConfiguration)
            let imagecolor = ultraLightSymbolImage?.withTintColor(.white,renderingMode: .alwaysOriginal)
            userEditBtn.setImage(imagecolor, for: .normal)
            userEditBtn.imageView?.contentMode = .scaleAspectFit
            userEditBtn.imageEdgeInsets = UIEdgeInsets(top: 0, left: -5, bottom: 0, right: 0)
        } else {
            userEditBtn.isHidden = true
            userEditBtn.heightAnchor.constraint(equalToConstant: 0).isActive = true
        }
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
                    let userId = dict["userId"] as? String
                    self.usrId.append(userId!)
                    let firstName = dict["firstName"] as? String
                    self.fName.append(firstName!)
                    let lastName = dict["lastName"] as? String
                    self.lName.append(lastName!)
                    let gender = Int((dict["gender"] as? String)!)
                    self.genderFlg = (gender)!
                    let dob = dict["dob"] as? String
                    self.date.append(dob!)
                    let email = dict["email"] as? String
                    self.mail.append(email!)
                    let mobileNo = dict["mobileNo"] as? String
                    self.mobNo.append(mobileNo!)
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
        userId.text = self.usrId
        firstName.text = self.fName
        lastName.text = self.lName
        if genderFlg == 1 {
            gender.text = "Male"
        } else {
            gender.text = "Female"
        }
        dob.text = self.date
        email.text = self.mail
        mobileNo.text = self.mobNo
    }
   
    @IBAction func userEdit(_ sender: Any) {
        self.performSegue(withIdentifier: "GoEditPage", sender: self)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "GoEditPage" {
            let vc = segue.destination as! RegisterViewController
            vc.id = UserDefaults.standard.string(forKey: "UserID")!
        }
    }
   
}
