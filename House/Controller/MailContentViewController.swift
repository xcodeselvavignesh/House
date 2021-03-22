import UIKit
import DropDown

struct MailData {
    var mailcontentId: String
    var mailcontentName: String
    var mailcontentSubject: String
    var mailcontentFlg: Int
}


class MailContentViewController: UIViewController,UITableViewDelegate,UITableViewDataSource, UIScrollViewDelegate {
    // API Name
    let API = "MailContentAPI.php"
    @IBOutlet weak var MailContentList: UITableView!
    
    @IBOutlet weak var searchBar: UISearchBar!
    
    @IBOutlet weak var mailButton: UIButton!
    
    @IBOutlet var filterButton: [UIButton]!
    
    @IBOutlet weak var allBtn: UIButton!
    
    @IBOutlet var sortingBtn: [UIButton]!
    
   
    @IBOutlet weak var stackview: UIStackView!
    
    @IBOutlet weak var selectSortingBtn: UIButton!
    private var Flg = 0
    private var dataOffset = 0
    private var searchedMailContent = [MailData]()
    private var searching = false
    private var dataJson = [MailData]()
    private var sortingBtntext = NSLocalizedString("Lbl_MailId", comment: "")
    private var sortingImg = "downArrow-20"
    private var sortOrder = "DESC"
    private var id = "MAIL0001"
    var selectedIndexPath: Int!
    var mailcontentMailid = [String]()
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setTitleImage()
        self.MailContentList.showsVerticalScrollIndicator = false
        allBtn.setTitleColor(UIColor.gray, for: .normal)
        allBtn.isEnabled = false
        mailButton.layer.cornerRadius = 3
        let ultraLightConfiguration = UIImage.SymbolConfiguration(scale: .medium)
        let ultraLightSymbolImage = UIImage(systemName: "plus", withConfiguration: ultraLightConfiguration)
        let imagecolor = ultraLightSymbolImage?.withTintColor(.white,renderingMode: .alwaysOriginal)
        mailButton.setImage(imagecolor, for: .normal)
        mailButton.imageView?.contentMode = .scaleAspectFit
        mailButton.imageEdgeInsets = UIEdgeInsets(top: 0, left: -5, bottom: 0, right: 0)
        let nib = UINib(nibName: "MailContentTableViewCell", bundle: nil)
        MailContentList.register(nib, forCellReuseIdentifier: "MailContentTableViewCell")
        MailContentList.delegate = self
        MailContentList.dataSource = self
        self.searchBar.delegate = self
        self.searchDesign()
        self.sortingDesign()
        self.getMailList()
    }
    func searchDesign() {
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
        searchTextField.font = UIFont.systemFont(ofSize: 14)
    }
    func sortingDesign() {
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
        MailContentList.reloadData()
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
            sortingImg = "upArrow-20"
        } else {
            sortOrder = "DESC"
            sortingImg = "downArrow-20"
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
        if sortingBtntext == "Mail Id" || sortingBtntext == "メールId" {
            sortingBtntext = "mailId"
        } else if sortingBtntext == "Mail Name" || sortingBtntext == "メール種類"{
            sortingBtntext = "mailName"
        }
        for button in sortingBtn {
            if sender.tag == button.tag {
                button.setTitleColor(UIColor.white, for: .normal)
            } else {
                button.setTitleColor(UIColor.black, for: .normal)
            }
        }
        self.getMailList()
      }
    @IBAction func FilterProcess(_ sender: UIButton) {
        dataJson.removeAll()
        MailContentList.reloadData()
        searching = false
        searchBar.text = ""
        self.dataOffset = 0
        for button in filterButton {
            if sender.tag == button.tag {
                button.isEnabled = false
                button.setTitleColor(UIColor.gray, for: .normal)
            } else {
                button.isEnabled = true
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
        getMailList()
    }
    func getMailList() {
        let jsonParam: [String: Any] = ["ProcessName": "mailContentIndex", "Flg": Flg, "Offset": self.dataOffset,"sortingBtntext": sortingBtntext,"sortOrder": sortOrder]
        Common.sharedInstance.RequestFromApi(pagination: true, api: self.API, jsonParams: jsonParam, completionHandler: {(result) -> Void in
            DispatchQueue.main.async {
                self.MailContentList.tableFooterView = nil
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
                    let mailId = dict["mailId"] as? String
                    let mailName = dict["mailName"] as? String
                    let subject = dict["subject"] as? String
                    let mailFlg = Int((dict["delFlg"] as? String)!)
                    let data = MailData(mailcontentId: mailId!, mailcontentName: mailName!, mailcontentSubject: subject!, mailcontentFlg: mailFlg!)
                    self.dataJson.append(data)

                }
                DispatchQueue.main.async {
                    self.MailContentList.reloadData()
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
            self.MailContentList.backgroundView = nil
            if self.searchedMailContent.count == 0 {
                getNodataFound()
            }
            return self.searchedMailContent.count
        }
        else {
            self.MailContentList.backgroundView = nil
        }
        return self.dataJson.count
    }
    func getNodataFound() {
        let noDataLabel: UILabel = UILabel(frame: CGRect(x: 0, y: 0, width: self.MailContentList.bounds.size.width, height: self.MailContentList.bounds.size.height))
        noDataLabel.text = NSLocalizedString("Lbl_NoDataFound", comment: "")
        noDataLabel.textColor = UIColor(red: 22.0/255.0, green: 106.0/255.0, blue: 176.0/255.0, alpha: 1.0)
        noDataLabel.textAlignment = NSTextAlignment.center
        self.MailContentList.backgroundView = noDataLabel
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var MailContentData = dataJson[indexPath.row]
        let cell = tableView.dequeueReusableCell(withIdentifier: "MailContentTableViewCell",for: indexPath) as! MailContentTableViewCell
        cell.layer.masksToBounds = true
        cell.layer.borderColor = UIColor.black.cgColor
        cell.layer.borderWidth = 0.8
        cell.layer.cornerRadius = 3
        if searching {
            MailContentData = searchedMailContent[indexPath.row]
        } else {
            MailContentData = dataJson[indexPath.row]
        }
        cell.mailcontentId.setAttributedTitle(NSAttributedString(string: MailContentData.mailcontentId), for: .normal)
        cell.mailcontentId.addTarget(self, action: #selector(self.mailContentSingleView(sender:)), for: .touchUpInside)
        cell.mailcontentName.text = MailContentData.mailcontentName
        cell.mailcontentSubject.text = MailContentData.mailcontentSubject
        cell.mailcontentFlg.tag = indexPath.row
        cell.mailcontentFlgs.tag = indexPath.row
        if MailContentData.mailcontentFlg == 0 {
            cell.mailcontentFlg.isHidden = true
            cell.mailcontentFlgs.isHidden = false
            let useFlg = NSLocalizedString("Lbl_Use", comment: "")
            cell.mailcontentFlgs.setAttributedTitle(NSAttributedString(string: useFlg,attributes: [NSAttributedString.Key.foregroundColor : UIColor.blue]), for: .normal)
            cell.mailcontentFlgs.addTarget(self, action: #selector(mailContentuseChangeFlg), for: .touchUpInside)
           
        } else {
            cell.mailcontentFlgs.isHidden = true
            cell.mailcontentFlg.isHidden = false
            let notuseFlg = NSLocalizedString("Lbl_NotUse", comment: "")
            cell.mailcontentFlg.setAttributedTitle(NSAttributedString(string: notuseFlg,attributes: [NSAttributedString.Key.foregroundColor : UIColor.red]), for: .normal)
            cell.mailcontentFlg.addTarget(self, action: #selector(mailContentnotuseChangeFlg), for: .touchUpInside)
        }
        return cell
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 125
    }
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath){
        if (indexPath.row % 2 == 0) {
            cell.backgroundColor = UIColor.white
        } else {
            cell.backgroundColor =  UIColor(red: 1.00, green: 0.94, blue: 0.91, alpha: 1.00)
        }
    }
    @objc func mailContentuseChangeFlg (sender: UIButton) {
        self.selectedIndexPath = sender.tag
        let indexPath = IndexPath(row: selectedIndexPath, section: 0)
        var MailContentData = dataJson[indexPath.row]
        if searching {
            MailContentData = searchedMailContent[indexPath.row]
        } else {
            MailContentData = dataJson[indexPath.row]
        }
        let mailcontentMailid = MailContentData.mailcontentId
        let confirmationDialog = Common.DialogResult(title: "Confirmation", message: NSLocalizedString("Lbl_UseNotuseconfirmmessage", comment: ""))
        let okClick = UIAlertAction(title: "Yes", style: .default, handler: { (alert) -> Void in
            self.dataJson.removeAll()
            self.MailContentList.reloadData()
            self.searching = false
            self.searchBar.text = ""
            let jsonParam: [String: Any] = ["ProcessName": "mailcontentFlg" , "MailId": mailcontentMailid, "MailDelFlg": 1]
            Common.sharedInstance.RequestFromApi(api: self.API, jsonParams: jsonParam, completionHandler: {(result) -> Void in
                self.dataOffset = 0
                self.getMailList()
                DispatchQueue.main.async {
                    self.MailContentList.reloadData()
                }
            })
        })
        let cancelClick = UIAlertAction(title: "No", style: .cancel, handler: nil)
        confirmationDialog.addAction(okClick)
        confirmationDialog.addAction(cancelClick)
        DispatchQueue.main.async {
            self.present(confirmationDialog, animated: true, completion: nil)
        }
    }
    @objc func mailContentnotuseChangeFlg (sender: UIButton) {
        self.selectedIndexPath = sender.tag
        let indexPath = IndexPath(row: selectedIndexPath, section: 0)
        var MailContentData = dataJson[indexPath.row]
        if searching {
            MailContentData = searchedMailContent[indexPath.row]
        } else {
            MailContentData = dataJson[indexPath.row]
        }
        let mailcontentMailid = MailContentData.mailcontentId
        let confirmationDialog = Common.DialogResult(title: "Confirmation", message: NSLocalizedString("Lbl_UseNotuseconfirmmessage", comment: ""))
        let okClick = UIAlertAction(title: "Yes", style: .default, handler: { (alert) -> Void in
            self.dataJson.removeAll()
            self.MailContentList.reloadData()
            self.searching = false
            self.searchBar.text = ""
            let jsonParam: [String: Any] = ["ProcessName": "mailcontentFlg" , "MailId": mailcontentMailid, "MailDelFlg": 0]
            Common.sharedInstance.RequestFromApi(api: self.API, jsonParams: jsonParam, completionHandler: {(result) -> Void in
                self.dataOffset = 0
                self.getMailList()
                DispatchQueue.main.async {
                    self.MailContentList.reloadData()
                }
            })
        })
        let cancelClick = UIAlertAction(title: "No", style: .cancel, handler: nil)
        confirmationDialog.addAction(okClick)
        confirmationDialog.addAction(cancelClick)
        DispatchQueue.main.async {
            self.present(confirmationDialog, animated: true, completion: nil)
        }
    }
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let position = scrollView.contentOffset.y
        if(position > (self.MailContentList.contentSize.height-100-scrollView.frame.size.height)) {
            guard !Common.sharedInstance.isPaginated! else {
                return
            }
            self.MailContentList.tableFooterView = self.createSpinnerFooter()
            self.dataOffset = self.dataOffset+5
            self.getMailList()
            DispatchQueue.main.async {
                self.MailContentList.reloadData()
            }
        }
    }
    
    @objc func mailContentSingleView (sender: UIButton) {
        self.id = (sender.titleLabel?.text)!
        performSegue(withIdentifier: "mailcontentSingleView", sender: self)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let id = self.id
        if segue.identifier == "mailcontentSingleView" {
            let vc = segue.destination as! MailContentSingleViewController
            vc.id = id
        }
    }
}
extension MailContentViewController:UISearchBarDelegate {
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if searchText == "" {
            searching = false
            view.endEditing(true)
            MailContentList.reloadData()
        } else {
            searching = true
            searchedMailContent = dataJson.filter({$0.mailcontentId.uppercased().contains(searchText.uppercased()) || $0.mailcontentName.uppercased().contains(searchText.uppercased()) })
            MailContentList.reloadData()
        }
    }
}
