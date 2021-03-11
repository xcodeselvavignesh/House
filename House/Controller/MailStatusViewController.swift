import UIKit

class MailStatusViewController: UIViewController,UITableViewDelegate,UITableViewDataSource {
    
    // API Name
   let API = "MailStatusAPI.php"
   
   @IBOutlet weak var MailStatusList: UITableView!
    var id = [String]()
   var mailstsuserName = [String]()
   var mailstsEmail = [String]()
   var mailstsSubject = [String]()
   var mailstsSendby = [String]()
   var mailstsSenddatetime = [String]()
   private var dataOffset = 0
   var selectedIndexPath: Int!
   override func viewDidLoad() {
        super.viewDidLoad()
        self.setTitleImage()
        self.MailStatusList.showsVerticalScrollIndicator = false
        let nib = UINib(nibName: "MailStatusTableViewCell", bundle: nil)
        MailStatusList.register(nib, forCellReuseIdentifier: "MailStatusTableViewCell")
        MailStatusList.delegate = self
        MailStatusList.dataSource = self
        getMailStatusList()
   }
   
    func getMailStatusList() {
        let jsonParam: [String: Any] = ["ProcessName": "mailStatusIndex", "Offset": self.dataOffset]
        Common.sharedInstance.RequestFromApi(pagination: true, api: self.API, jsonParams: jsonParam, completionHandler: {(result) -> Void in
            DispatchQueue.main.async {
                self.MailStatusList.tableFooterView = nil
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
                    let id = dict["id"] as? String
                    self.id.append(id!)
                    
                    let username = dict["createdBy"] as? String
                    self.mailstsuserName.append(username!)
                    
                    let email = dict["toMail"] as? String
                    self.mailstsEmail.append(email!)
                    
                    let sub = dict["subject"] as? String
                    self.mailstsSubject.append(sub!)
                    
                    let mailsendby = dict["createdBy"] as? String
                    self.mailstsSendby.append(mailsendby!)
                    
                    let mailsenddatetime = dict["createdDateTime"] as? String
                    self.mailstsSenddatetime.append(mailsenddatetime!)
                }
                DispatchQueue.main.async {
                    self.MailStatusList.reloadData()
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
            if self.mailstsuserName.count > 0
             {
                self.MailStatusList.backgroundView = nil
            } else {
                let noDataLabel: UILabel = UILabel(frame: CGRect(x: 0, y: 0, width: self.MailStatusList.bounds.size.width, height: self.MailStatusList.bounds.size.height))
                noDataLabel.text = NSLocalizedString("Lbl_NoDataFound", comment: "")
                noDataLabel.textColor = UIColor(red: 22.0/255.0, green: 106.0/255.0, blue: 176.0/255.0, alpha: 1.0)
                noDataLabel.textAlignment = NSTextAlignment.center
                self.MailStatusList.backgroundView = noDataLabel

              }
       return self.mailstsuserName.count
   }
   
   func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
       
       let cell = MailStatusList.dequeueReusableCell(withIdentifier: "MailStatusTableViewCell",for: indexPath) as! MailStatusTableViewCell
       
       cell.layer.masksToBounds = true
       cell.layer.borderColor = UIColor.black.cgColor
       cell.layer.borderWidth = 0.3
       cell.mailStatusUserName.tag = indexPath.row
       cell.mailStatusUserName.setTitle(self.mailstsuserName[indexPath.row], for: .normal)
       cell.mailStatusUserName.addTarget(self, action: #selector(btnaction), for: .touchUpInside)
       cell.mailEmail.text = self.mailstsEmail[indexPath.row]
       cell.mailSubject.text = self.mailstsSubject[indexPath.row]
       cell.mailSendBy.text = self.mailstsSendby[indexPath.row]
       cell.mailSendDateTime.text = self.mailstsSenddatetime[indexPath.row]
       cell.mailStatusCount.text = "\(indexPath.row + 1) | \(self.mailstsuserName.count)"
    return cell
   }
    
   func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
       return 150
   }
  @objc func btnaction(_ sender:UIButton){
        self.selectedIndexPath = sender.tag
        self.performSegue(withIdentifier: "MailStatusViewSegue", sender: self)
        
   }
   override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "MailStatusViewSegue" {
            let vc = segue.destination as! MailStatusController
            vc.Id = self.id[self.selectedIndexPath]
            
        }
        
   }
   func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let position = scrollView.contentOffset.y
        if(position > (self.MailStatusList.contentSize.height-100-scrollView.frame.size.height)) {
            guard !Common.sharedInstance.isPaginated! else {
                return
            }
            self.MailStatusList.tableFooterView = self.createSpinnerFooter()
            self.dataOffset = self.dataOffset+5
            self.getMailStatusList()
            DispatchQueue.main.async {
                self.MailStatusList.reloadData()
            }
        }
    }
}
