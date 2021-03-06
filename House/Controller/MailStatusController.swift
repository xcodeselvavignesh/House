//
//  MailStatusController.swift
//  House
//
//  Created by Randy Orton on 15/02/21.
//

import UIKit

class MailStatusController: UIViewController {
    // API Name
    let API = "MailStatusAPI.php"
    
    @IBOutlet weak var username: UILabel!
    @IBOutlet weak var to: UILabel!
    @IBOutlet weak var subject: UILabel!
    @IBOutlet weak var senddatetime: UILabel!
   
    @IBOutlet weak var mailcontent: UITextView!
    
    @IBOutlet weak var msView: UIView!
    var Id : String = ""
    var msUserName : String = ""
    var msMail : String = ""
    var msSubject : String = ""
    var msSendDateTime : String = ""
    var msContent : String = ""
    override func viewDidLoad() {
        let imageView = UIImageView(frame: CGRect(x: 0, y: 0, width: 100, height: 20))
        imageView.contentMode = .scaleToFill
        let image = UIImage(named: "Microbit_logo-40")
        imageView.image  = image
        self.navigationItem.titleView = imageView
        self.mailStatusView()
        let textView = UITextView()
        textView.textContainerInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        msView.layer.masksToBounds = true
        msView.layer.borderColor = UIColor.black.cgColor
        msView.layer.borderWidth = 0.8
        msView.layer.cornerRadius = 3
        // Do any additional setup after loading the view.
    }

    func mailStatusView() {
        let jsonParam: [String: Any] = ["ProcessName": "mailStatusView", "Id": self.Id]
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
                    let username = dict["lastName"] as? String
                    self.msUserName.append(username!)
                    let to = dict["toMail"] as? String
                    self.msMail.append(to!)
                    let subject = dict["subject"] as? String
                    self.msSubject.append(subject!)
                    let senddatetime = dict["createdDateTime"] as? String
                    self.msSendDateTime.append(senddatetime!)
                    let mailcontent = dict["content"] as? String
                    self.msContent.append(mailcontent!)
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
        username.text = self.msUserName
        to.text = self.msMail
        subject.text = msSubject
        senddatetime.text = self.msSendDateTime
        
        mailcontent.attributedText = self.msContent.htmlToAttributedString
        mailcontent.font = UIFont.systemFont(ofSize: 14.0)
    
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
extension String {
    var htmlToAttributedString: NSAttributedString? {

        guard let data = data(using: .utf8) else { return nil }
        do {
            return try NSAttributedString(data: data, options: [.documentType: NSAttributedString.DocumentType.html, .characterEncoding:String.Encoding.utf8.rawValue], documentAttributes: nil)
        } catch {
            return nil
        }
    }
    var htmlToString: String {
        return htmlToAttributedString?.string ?? ""
    }
}
