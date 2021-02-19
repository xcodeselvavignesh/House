//
//  UserListTableViewCell.swift
//  HouseUserList
//
//  Created by kasthuri1994 on 7/1/21.
//

import UIKit

class UserListTableViewCell: UITableViewCell {
    
    @IBOutlet var usrImage: UIImageView!
    @IBOutlet var usrID: UILabel!
    @IBOutlet var usrName: UILabel!
    @IBOutlet var usrDOB: UILabel!
    @IBOutlet var usrEmail: UILabel!
    @IBOutlet var usrMobNo: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()
        
        // Initialization code
        usrDOB.font = UIFont(name: "FontAwesome", size: 20)
        usrEmail.font = UIFont(name: "FontAwesome", size: 20)
        usrMobNo.font = UIFont(name: "FontAwesome", size: 20)
       
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
