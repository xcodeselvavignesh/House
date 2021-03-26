//
//  MailContentSingleViewController.swift
//  House
//
//  Created by Sarath kumar on 08/03/21.
//

import UIKit
protocol MailContentSingleView {
    func passDataBacks()
}
class MailContentSingleViewController: UIViewController,MailContentRegister {
    func passDataBack(mcName: String, mcSubject: String, mcHeader: String, mcContent: String) {
        MailName.text = mcName
        MailSubject.text = mcSubject
        MailHeader.text = mcHeader
        MailContent.text = mcContent
    }
    
    private let API = "MailContentAPI.php"
    
    @IBOutlet weak var mcView: UIView!
    @IBOutlet weak var MailId: UILabel!
    @IBOutlet weak var MailName: UILabel!
    @IBOutlet weak var MailSubject: UILabel!
    @IBOutlet weak var MailHeader: UILabel!
    @IBOutlet weak var MailContent: UITextView!
    @IBOutlet weak var editButton: UIButton!
    var id : String = ""
    var mailid : String = ""
    var mailname : String = ""
    var mailsubject : String = ""
    var mailheader : String = ""
    var mailcontent : String = ""
    var delegate: MailContentSingleView?
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.setHidesBackButton(true, animated: true)
        let backButton = UIBarButtonItem(title: "< Back", style: .plain, target: self, action: #selector (backButtonClick(sender:)))
        navigationItem.setLeftBarButton(backButton, animated: false)
        let imageView = UIImageView(frame: CGRect(x: 0, y: 0, width: 100, height: 20))
        imageView.contentMode = .scaleToFill
        let image = UIImage(named: "Microbit_logo-40")
        imageView.image  = image
        self.navigationItem.titleView = imageView
        let textView = UITextView()
        textView.textContainerInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        mcView.layer.masksToBounds = true
        mcView.layer.borderColor = UIColor.black.cgColor
        mcView.layer.borderWidth = 0.8
        mcView.layer.cornerRadius = 3
        editButton.layer.cornerRadius = 3
        self.getMailContentSingleViewData()
        let ultraLightConfiguration = UIImage.SymbolConfiguration(scale: .medium)
        let ultraLightSymbolImage = UIImage(systemName: "square.and.pencil", withConfiguration: ultraLightConfiguration)
        let imagecolor = ultraLightSymbolImage?.withTintColor(.white,renderingMode: .alwaysOriginal)
        editButton.setImage(imagecolor, for: .normal)
        editButton.imageView?.contentMode = .scaleAspectFit
        editButton.imageEdgeInsets = UIEdgeInsets(top: 0, left: -5, bottom: 0, right: 0)
        
    }
    @objc func backButtonClick(sender : UIButton) {
        self.delegate?.passDataBacks()
        self.navigationController?.popViewController(animated: true)
        
    }
    func getMailContentSingleViewData() {
        let jsonParam: [String: Any] = ["ProcessName": "mailcontentSingleView","id": id]
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
                    let MailId = dict["mailId"] as? String
                    self.mailid.append(MailId!)
                    let MailName = dict["mailName"] as? String
                    self.mailname.append(MailName!)
                    let MailSubject = dict["subject"] as? String
                    self.mailsubject.append(MailSubject!)
                    let MailHeader = dict["header"] as? String
                    self.mailheader.append(MailHeader!)
                    let MailContent = dict["content"] as? String
                    self.mailcontent.append(MailContent!)
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
        MailId.text = self.mailid
        MailName.text = self.mailname
        MailSubject.text = self.mailsubject
        MailHeader.text = self.mailheader
        MailContent.attributedText = self.mailcontent.htmlAttributedString
        MailContent.font = UIFont.systemFont(ofSize: 14.0)
    }
    
    @IBAction func mailcontentEdit(_ sender: Any) {
        performSegue(withIdentifier: "MailContentRegisterSegue", sender: self)
    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let id = self.mailid
        if segue.identifier == "MailContentRegisterSegue" {
            let vc = segue.destination as! MailContentRegisterController
            vc.id = id
            vc.delegate = self
        }
    }
}
extension String {
    var htmlAttributedString: NSAttributedString? {

        guard let data = data(using: .utf8) else { return nil }
        do {
            return try NSAttributedString(data: data, options: [.documentType: NSAttributedString.DocumentType.html, .characterEncoding:String.Encoding.utf8.rawValue], documentAttributes: nil)
        } catch {
            return nil
        }
    }
    var htmlString: String {
        return htmlAttributedString?.string ?? ""
    }
}


