import UIKit
import DropDown

struct ModelData {
    var userId: String
    var userName: String
    var userEmail: String
    var userDOB: String
    var userMobNo: String
    var gender: Int
}

class UserViewController: UIViewController,UITableViewDelegate,UITableViewDataSource, UIScrollViewDelegate {
    
    // API Name
    private let API = "UserAPI.php"
    
    @IBOutlet var tableView: UITableView!
    @IBOutlet var filterBtn: [UIButton]!
    @IBOutlet weak var allBtn: UIButton!
    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var selectSortingBtn: UIButton!
    @IBOutlet var sortingBtn: [UIButton]!
    @IBOutlet var stackview: UIStackView!
    
    private var Flg = 0
    private var dataOffset = 0
    private var searchedUser = [ModelData]()
    private var searching = false
    private var dataJson = [ModelData]()
    private var sortingBtntext = "UserId"
    private var sortingImg = "upArrow-20"
    private var sortOrder = "DESC"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setTitleImage()
        self.tableView.showsVerticalScrollIndicator = false
        self.searchBar.delegate = self
        let nib = UINib(nibName: "UserListTableViewCell", bundle: nil)
        tableView.register(nib, forCellReuseIdentifier: "UserListTableViewCell")
        tableView.delegate = self
        tableView.dataSource = self
        allBtn.setTitleColor(UIColor.gray, for: .normal)
       
        selectSortingBtn.setAttributedTitle(NSAttributedString(string: sortingBtntext), for: .normal)
        let img = UIImage(named: (sortingImg))
        selectSortingBtn.setImage(img, for: .normal)
        selectSortingBtn.contentEdgeInsets = UIEdgeInsets(top: 5, left: 0, bottom: 5, right: 0)
        selectSortingBtn.imageEdgeInsets = UIEdgeInsets(top: 0, left: 102, bottom: 0, right: 0)
        selectSortingBtn.titleEdgeInsets = UIEdgeInsets(top: 0, left: -13, bottom: 0, right: 0)
        selectSortingBtn.layer.cornerRadius = 5.0
        selectSortingBtn.layer.borderWidth = 1.0
        selectSortingBtn.layer.borderColor = UIColor.lightGray.cgColor
        selectSortingBtn.contentHorizontalAlignment = .left
        self.stackview.arrangedSubviews[1].backgroundColor = .systemBlue
        sortingBtn[0].setTitleColor(UIColor.white, for: .normal)
        sortingBtn.forEach { (btn) in
            btn.isHidden = true
            btn.alpha = 0
            btn.contentHorizontalAlignment = .left
        }
        self.searchDesign()
        self.getUserList()
    }
    
    @IBAction func selectSortingPressed(_ sender: UIButton) {
        sortingBtn.forEach { (btn) in
            UIView.animate(withDuration: 0.7) {
                btn.isHidden = !btn.isHidden
                btn.alpha = btn.alpha == 0 ? 1 : 0
                btn.layoutIfNeeded()
                btn.contentHorizontalAlignment = .left
              }
          }
    }
     
    @IBAction func sortingPressed(_ sender: UIButton) {
        dataJson.removeAll()
        tableView.reloadData()
        searching = false
        searchBar.text = ""
        self.dataOffset = 0
        self.stackview.arrangedSubviews[1].backgroundColor = .systemBackground
        sortingBtn.forEach { (btn) in
            btn.isHidden = true
            btn.alpha = 0
            btn.contentHorizontalAlignment = .left
        }
        if sortOrder == "DESC" {
            sortOrder = "ASC"
            sortingImg = "downArrow-20"
        } else {
            sortOrder = "DESC"
            sortingImg = "upArrow-20"
        }
        sender.titleLabel?.text = ""
        stackview.removeArrangedSubview(sender)
        sender.removeFromSuperview()
        stackview.insertArrangedSubview(sender, at: 1)
        self.stackview.arrangedSubviews[1].backgroundColor = .systemBlue
        let img = UIImage(named: (sortingImg))
        let btnlabel = sender.titleLabel?.text
        sortingBtntext = btnlabel!
        selectSortingBtn.setAttributedTitle(NSAttributedString(string: sortingBtntext), for: .normal)
        selectSortingBtn.setImage(img, for: .normal)
        selectSortingBtn.contentEdgeInsets = UIEdgeInsets(top: 5, left: 0, bottom: 5, right: 0)
        selectSortingBtn.imageEdgeInsets = UIEdgeInsets(top: 0, left: 102, bottom: 0, right: 0)
        selectSortingBtn.titleEdgeInsets = UIEdgeInsets(top: 0, left: -13, bottom: 0, right: 0)
                if sortingBtntext == "User Id" {
            sortingBtntext = "userId"
        } else if sortingBtntext == "Given Name" {
            sortingBtntext = "firstName"
        } else if sortingBtntext == "Date of Birth" {
            sortingBtntext = "dob"
        }
        for button in sortingBtn {
            if sender.tag == button.tag {
                button.setTitleColor(UIColor.white, for: .normal)
            } else {
                button.setTitleColor(UIColor.black, for: .normal)
            }
        }
        self.getUserList()
      }
    
    @IBAction func filterProcess(_ sender: UIButton) {
        dataJson.removeAll()
        tableView.reloadData()
        searching = false
        searchBar.text = ""
        self.dataOffset = 0
        for button in filterBtn {
            if sender.tag == button.tag {
                button.setTitleColor(UIColor.gray, for: .normal)
            } else {
                button.setTitleColor(UIColor.systemBlue, for: .normal)
            }
        }
        switch sender.tag {
        case 0:
            Flg = 0
        case 1:
            Flg = 1
        case 2:
            Flg = 2
        default:
            break
        }
        getUserList()
    }
    
    
    private func searchDesign() {
        let searchTextField = self.searchBar.searchTextField
                searchTextField.textColor = UIColor.black
        self.searchBar.layer.borderWidth = 1
        self.searchBar.layer.borderColor = UIColor.white.cgColor
        searchTextField.clearButtonMode = .always
        searchTextField.clearButtonMode = .whileEditing
        searchTextField.borderStyle = .none
        searchTextField.layer.borderWidth = 3
        searchTextField.layer.borderColor = UIColor.lightGray.cgColor
        searchTextField.layer.cornerRadius = 5
        searchTextField.background = nil;
        searchTextField.backgroundColor = UIColor.white
        let glassIconView = searchTextField.leftView as! UIImageView
        glassIconView.image = glassIconView.image?.withRenderingMode(.alwaysTemplate)
        glassIconView.tintColor = UIColor.red
    }
    
    func getUserList() {
        let jsonParam: [String: Any] = ["ProcessName": "userIndex", "Flg": Flg, "Offset": self.dataOffset, "sortingBtntext": sortingBtntext,"sortOrder": sortOrder]
        Common.sharedInstance.RequestFromApi(pagination: true, api: self.API, jsonParams: jsonParam, completionHandler: {(result) -> Void in
            DispatchQueue.main.async {
                self.tableView.tableFooterView = nil
            }
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
                    let firstName = dict["firstName"] as? String
                    let gender = dict["gender"] as? Int
                    let email = dict["email"] as? String
                    let mobileNo = dict["mobileNo"] as? String
                    let dob = dict["dob"] as? String
                    let data = ModelData(userId: userId!, userName: firstName!, userEmail: email!, userDOB: dob!, userMobNo: mobileNo!, gender: gender!)
                    self.dataJson.append(data)
                }
                DispatchQueue.main.async {
                    self.tableView.reloadData()
                }
            }
            else {
                DispatchQueue.main.async {
                }
            }
        })
    }
    
    private func createSpinnerFooter() -> UIView {
        let footerView = UIView(frame: CGRect(x: 0, y: 0, width: view.frame.size.width, height: 100))
        let spinner = UIActivityIndicatorView()
        spinner.center = footerView.center
        footerView.addSubview(spinner)
        spinner.startAnimating()
        return footerView
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if self.dataJson.count == 0 {
            getNodataFound()
        }
        else if searching {
            self.tableView.backgroundView = nil
            if self.searchedUser.count == 0 {
                getNodataFound()
            }
            return self.searchedUser.count
        }
        else {
            self.tableView.backgroundView = nil
        }
        return self.dataJson.count
    }
    
    func getNodataFound() {
        let noDataLabel: UILabel = UILabel(frame: CGRect(x: 0, y: 0, width: self.tableView.bounds.size.width, height: self.tableView.bounds.size.height))
        noDataLabel.text = NSLocalizedString("Lbl_NoDataFound", comment: "")
        noDataLabel.textColor = UIColor(red: 22.0/255.0, green: 106.0/255.0, blue: 176.0/255.0, alpha: 1.0)
        noDataLabel.textAlignment = NSTextAlignment.center
        self.tableView.backgroundView = noDataLabel
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var UserData = dataJson[indexPath.row]
        let cell = tableView.dequeueReusableCell(withIdentifier: "UserListTableViewCell",for: indexPath) as! UserListTableViewCell
        cell.layer.masksToBounds = true
        cell.layer.borderColor = UIColor.black.cgColor
        cell.layer.borderWidth = 0.8
        cell.layer.cornerRadius = 3
        if searching {
            UserData = searchedUser[indexPath.row]
        } else {
            UserData = dataJson[indexPath.row]
        }
        if UserData.gender == 1 {
            let imageName = "male-40.jpeg"
            cell.usrImage.image = UIImage(named: (imageName))
        } else {
            let imageName = "female-40.jpg"
            cell.usrImage.image = UIImage(named: (imageName))
        }
        cell.usrID.text = UserData.userId
        cell.usrName.text = UserData.userName
        cell.usrDOB.text = "\u{f073}" + " " + UserData.userDOB
        cell.usrEmail.text = "\u{f003}" + " " + UserData.userEmail
        cell.usrMobNo.text = "\u{f095}" + " " + UserData.userMobNo
        return cell
    }
   
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 220
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath){
        if (indexPath.row % 2 == 0) {
            cell.backgroundColor = UIColor.white
        } else {
            cell.backgroundColor =  UIColor(red: 1.00, green: 0.94, blue: 0.91, alpha: 1.00)
        }
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let position = scrollView.contentOffset.y
        if(position > (self.tableView.contentSize.height-100-scrollView.frame.size.height)) {
            guard !Common.sharedInstance.isPaginated! else {
                return
            }
            self.tableView.tableFooterView = self.createSpinnerFooter()
            self.dataOffset = self.dataOffset+3
            self.getUserList()
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
        }
    }
}

extension UserViewController:UISearchBarDelegate {
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        searchedUser = dataJson.filter({$0.userId.uppercased().prefix(searchText.count) == searchText.uppercased() || $0.userName.uppercased().prefix(searchText.count) == searchText.uppercased()})
        searching = true
        self.tableView.reloadData()
    }
}
