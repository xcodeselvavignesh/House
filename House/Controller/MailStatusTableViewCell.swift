//
//  MailStatusTableViewCell.swift
//  House
//
//  Created by randyorton on 17/01/21.
//

import UIKit

class MailStatusTableViewCell: UITableViewCell {

    
    
    @IBOutlet weak var mailStatusUserName: UIButton!
    
    @IBOutlet weak var mailEmail: UILabel!
    
    
    @IBOutlet weak var mailSubject: UILabel!
    
    
    @IBOutlet weak var mailSendBy: UILabel!
    
    
    
    @IBOutlet weak var mailSendDateTime: UILabel!
    
    
    
    @IBOutlet weak var mailStatusCount: UILabel!
    
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
