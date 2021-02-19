import UIKit
import Foundation

protocol MenuControllerDelegate {
    func didSelectMenu(named: String)
}

class MenuController: UITableViewController {
   
    private let menuItems = ["Welcome \(UserDefaults.standard.string(forKey: "lastName")!)",
                             NSLocalizedString("Lbl_Menu_House", comment: ""),
                            NSLocalizedString("Lbl_Menu_User", comment: ""),
            
                            NSLocalizedString("Lbl_Menu_MailStatus", comment: ""),
                             NSLocalizedString("Lbl_Menu_MailContent", comment: ""),
                             NSLocalizedString("Lbl_Menu_Change", comment: ""),
                             Common.sharedInstance.getAppLocale(),
                             NSLocalizedString("Lbl_Menu_Logout", comment: "")
                             
    ]
    private let menuItemsUser = ["Welcome \(UserDefaults.standard.string(forKey: "lastName")!)",            NSLocalizedString("Lbl_Menu_House", comment: ""),

                             NSLocalizedString("Lbl_Menu_Change", comment: ""),
                             Common.sharedInstance.getAppLocale(),
                             NSLocalizedString("Lbl_Menu_Logout", comment: "")
    ]
    public var delegate: MenuControllerDelegate?
    private let color = UIColor(red: 211/255, green: 211/255, blue: 211/255, alpha: 1)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.backgroundColor = color
        view.backgroundColor = color
        tableView.tableFooterView = UIView()
    }
    init() {
        super.init(nibName: nil, bundle: nil)
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "MenuCell")
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if((UserDefaults.standard.integer(forKey: "userType")) == 1){
            return self.menuItems.count
        } else {
            return self.menuItemsUser.count
        }
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "MenuCell", for: indexPath)
        if((UserDefaults.standard.integer(forKey: "userType")) == 1){
            let menuLabel = menuItems[indexPath.row]
            cell.textLabel?.text = menuLabel
            cell.textLabel?.textColor = .black
            cell.backgroundColor = color
            if(menuLabel == NSLocalizedString("Lbl_Menu_House", comment: "")) {
                cell.contentView.backgroundColor = UIColor(red: 245/255, green: 129/255, blue: 66/255, alpha: 1)
            }
            else {
                cell.contentView.backgroundColor = color
            }
        } else {
            let menuLabel = menuItemsUser[indexPath.row]
            cell.textLabel?.text = menuLabel
            cell.textLabel?.textColor = .black
            cell.backgroundColor = color
            if(menuLabel == NSLocalizedString("Lbl_Menu_House", comment: "")) {
                cell.contentView.backgroundColor = UIColor(red: 245/255, green: 129/255, blue: 66/255, alpha: 1)
            }
            else {
                cell.contentView.backgroundColor = color
            }
        }
       return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let cell = tableView.cellForRow(at: indexPath)
        let menuLabel = cell?.textLabel?.text
        if(menuLabel != Common.sharedInstance.getAppLocale() && menuLabel != NSLocalizedString("Lbl_Menu_Logout", comment: "") && menuLabel != "Welcome \(UserDefaults.standard.string(forKey: "lastName")!)") {
            setSelectedColor(tableView: tableView, indexPath: indexPath)
            tableView.cellForRow(at: IndexPath(row: 1, section: 0))?.contentView.backgroundColor = color
        }
        if((UserDefaults.standard.integer(forKey: "userType")) == 1){
            let selectedItem = menuItems[indexPath.row]
            delegate?.didSelectMenu(named: selectedItem)
        } else {
            let selectedItem = menuItemsUser[indexPath.row]
            delegate?.didSelectMenu(named: selectedItem)
        }
    }
    
    private func setSelectedColor(tableView: UITableView, indexPath: IndexPath) {
        tableView.reloadData()
        let cell = tableView.cellForRow(at: indexPath)
        cell?.contentView.backgroundColor = UIColor(red: 245/255, green: 129/255, blue: 66/255, alpha: 1)
    }
}
