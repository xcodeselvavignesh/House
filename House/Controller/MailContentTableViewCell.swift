//
//  MailContentTableViewCell.swift
//  House
//
//  Created by Randy Orton on 24/02/21.
//

import UIKit

class MailContentTableViewCell: UITableViewCell {
    @IBOutlet weak var mailcontentId: UIButton!
    
    @IBOutlet weak var mailcontentName: UILabel!
    
    @IBOutlet weak var mailcontentSubject: UILabel!
    
    @IBOutlet weak var mailcontentFlgs: UIButton!
    
    @IBOutlet weak var mailcontentFlg: UIButton!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
