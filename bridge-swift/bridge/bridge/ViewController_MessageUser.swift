//
//  ViewController_MessageUser.swift
//  bridge
//
//  Created by Konstantin Yurchenko on 11/28/16.
//  Copyright © 2016 Konstantin Yurchenko. All rights reserved.
//

import Foundation
import UIKit

class ViewController_MessageUser: BaseViewController, UITextFieldDelegate {
    
    //var checkboxButtons: [CheckboxButton] = []
    
    @IBOutlet weak var view_header: UIView!
    
    var handler: ((_ data: NSDictionary) -> Void) = {data in ()}
    
    // UI ELEMENTS
    var scrollView: UIScrollView!
    
    var receiver_id = 0
    var messages: [Any] = []
    
    override func loadView() {
        super.viewDidLoad()
        
        if self.screenHeight == 480 {
            Bundle.main.loadNibNamed("ViewController_MessageUser", owner: self, options: nil)
        } else if self.screenHeight == 568 {
            Bundle.main.loadNibNamed("ViewController_MessageUser", owner: self, options: nil)
        } else if self.screenHeight == 736 {
            Bundle.main.loadNibNamed("ViewController_MessageUser", owner: self, options: nil)
        } else {
            Bundle.main.loadNibNamed("ViewController_MessageUser", owner: self, options: nil)
        }
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.scrollView = UIScrollView(frame: CGRect(x: 0, y: 0, width: self.screenWidth, height: self.screenHeight))
        self.view.addSubview(scrollView)
        
        self.stackView = UIStackView()
        self.stackView.translatesAutoresizingMaskIntoConstraints = false
        self.stackView.axis = UILayoutConstraintAxis.vertical
        self.stackView.distribution = UIStackViewDistribution.equalSpacing
        self.stackView.alignment = UIStackViewAlignment.center
        self.stackView.spacing = 10
        
        self.assembleInterface()
        
        self.scrollView.addSubview(self.stackView)
        self.scrollView.contentSize = CGSize(width: self.stackView.frame.width, height: self.stackView.frame.height)
        self.scrollView.bounces = false
        
        self.view_header.backgroundColor = PANTONE_greenery
    }
    
    @objc func refresh_message_stream() {
        print("refresh_message_stream")
    }
    
    func keyboardWillShow(notification: NSNotification) {
        if let keyboardSize = (notification.userInfo?[UIKeyboardFrameBeginUserInfoKey] as? NSValue)?.cgRectValue {
            let contentInsets = UIEdgeInsets(top: 0, left: 0, bottom: keyboardSize.height, right: 0)
            print(contentInsets)
        }
    }
    func keyboardWillHide(notification: NSNotification) {

    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(false)
        
        NotificationCenter.default.removeObserver(self)
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(false)
        NotificationCenter.default.addObserver(
            self, selector: #selector(self.refresh_message_stream),
            name:NSNotification.Name(rawValue: "refresh_message_stream_scroll_view"),
            object: nil
        )
        
        NotificationCenter.default.addObserver(self, selector: #selector(self.keyboardWillShow(notification:)), name: NSNotification.Name.UIKeyboardWillShow, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(self.keyboardWillHide(notification:)), name: NSNotification.Name.UIKeyboardWillHide, object: nil)
    }
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        #if DEBUG
            print("viewDidLayoutSubviews")
        #endif
        
        self.scrollView.contentSize = CGSize(width: stackView.frame.width, height: stackView.frame.height)
    }
    
    var text_field_message = UITextField()
    var scroll_view_messages = UIScrollView()
    
    func assembleInterface() {
        self.view_header.heightAnchor.constraint(equalToConstant: 64).isActive = true
        self.view_header.widthAnchor.constraint(equalToConstant: self.screenWidth).isActive = true
        self.stackView.addArrangedSubview(self.view_header)
        
        self.addSpacer()
        
        self.assemble_scroll_view()
        self.scroll_view_messages.backgroundColor = UIColor.green
        self.scroll_view_messages.backgroundColor = PANTONE_silver_blue 
        
        self.stackView.addArrangedSubview(self.scroll_view_messages)
        
//        self.addSpacer()
        
        self.text_field_message = self.createTextField(placeholder: "Your message")
        self.text_field_message.delegate = self
        self.text_field_message.becomeFirstResponder()
        self.text_field_message.keyboardType = .emailAddress
        self.text_field_message.keyboardAppearance = .dark
        self.text_field_message.autocorrectionType = UITextAutocorrectionType.no
        self.stackView.addArrangedSubview(self.text_field_message)
        
        self.continueHandler =  {
            (data: NSDictionary) -> Void in
            print("Continue handler engaged")
        }
    }
    
    //
    func retrieve_messages() {
        print("retrieve_messages")
        
        let parameters = NSMutableDictionary()
        parameters.setValue(self.app_delegate.me.id, forKey: "id") //set all your values..
        parameters.setValue(0, forKey: "receiver_id")
        
        RestAPIClient.sharedInstance.get_messages(parameters: parameters) { response in
            let error_code = response["error_code"] as! Int
            let messages = response["messages"] as! [Any]
            
            if error_code == 0 {
                DispatchQueue.main.async(execute: {
                    self.messages = messages
                    self.assemble_scroll_view()
                })
                
            } else {
                print ("error")
            }
        }
    }
    
    // MARK: ScrollView
    func assemble_scroll_view() {
        print("assemble_scroll_view")
        
        self.pen_stop = 16
        
        self.scroll_view_messages.subviews.forEach ({
            if $0 is UILabel {
                $0.removeFromSuperview()
            }
        })
        
        for object in self.messages.reversed() {
            let message = object as! [Any]
            
            
            if (message[2] as! String == "in") {
                self.add_incoming_message_label(text: message[1] as! String)
            } else {
                self.add_outgoing_message_label(text: message[1] as! String)
            }
        }
        //        let bottomOffset = CGPoint(x: 0, y: self.messages_scroll_view.contentSize.height - self.messages_scroll_view.bounds.size.height + 8)
        //        self.messages_scroll_view.setContentOffset(bottomOffset, animated: true)
        self.update_scroll_view()
    }
    
    var pen_stop: CGFloat = 16
    
    func add_incoming_message_label(text: String) {
        print("add_incoming_message_label")
        
        let label = UILabel()
        label.textColor = UIColor.black
        label.text = text
        label.lineBreakMode = NSLineBreakMode.byWordWrapping
        let font = UIFont.init(name: "Copperplate", size: 16)
        label.font = font
        label.numberOfLines = 0;
        let text = label.text! as NSString
        let size = text.size(attributes: [NSFontAttributeName:font!])
        label.frame = CGRect(x: 16, y: self.pen_stop, width: size.width, height: size.height)
        
        self.pen_stop += label.frame.height
        self.pen_stop += 8
        
        self.scroll_view_messages.addSubview(label)
    }
    func add_outgoing_message_label(text: String) {
        print("add_outgoing_message_label")
        
        let label = UILabel()
        label.textColor = UIColor.gray
        label.text = text
        label.lineBreakMode = NSLineBreakMode.byWordWrapping
        let font = UIFont.init(name: "Copperplate", size: 16)
        label.font = font
        label.numberOfLines = 0;
        let text = label.text! as NSString
        let size = text.size(attributes: [NSFontAttributeName:font!])
        label.frame = CGRect(x: self.view.frame.width/2, y: self.pen_stop, width: size.width, height: size.height)
        
        self.pen_stop += label.frame.height
        self.pen_stop += 8
        
        self.scroll_view_messages.addSubview(label)
    }
    func update_scroll_view() {
        self.scroll_view_messages.updateContentViewSize()
        let bottomOffset = CGPoint(x: 0, y: self.scroll_view_messages.contentSize.height - self.scroll_view_messages.bounds.size.height)
        self.scroll_view_messages.setContentOffset(bottomOffset, animated: true)
        
        self.scroll_view_messages.widthAnchor.constraint(equalToConstant: self.screenWidth - 16).isActive = true
        
//        self.scroll_view_messages.heightAnchor.constraint(equalToConstant: self.scroll_view_messages.contentSize.height - self.scroll_view_messages.bounds.size.height).isActive = true
        
        var scroll_view_height_contraint = self.screenHeight
        print(scroll_view_height_contraint)
        scroll_view_height_contraint -= self.view_header.frame.height
        print(scroll_view_height_contraint)
        scroll_view_height_contraint -= 48 // spacer
        print(scroll_view_height_contraint)
        scroll_view_height_contraint -= 258 // keyboard
        print(scroll_view_height_contraint)
        scroll_view_height_contraint -= self.text_field_message.frame.height // input bar
        print(scroll_view_height_contraint)
        
        self.scroll_view_messages.heightAnchor.constraint(equalToConstant: scroll_view_height_contraint).isActive = true
    }
    // MARK: ScrollView
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        //        textField.resignFirstResponder()
        if (!self.text_field_message.text!.isEmpty) {
            self.send_message()
            self.add_outgoing_message_label(text: self.text_field_message.text!)
            
            self.update_scroll_view()
            //            let bottomOffset = CGPoint(x: 0, y: self.messages_scroll_view.contentSize.height - self.messages_scroll_view.bounds.size.height + 16)
            //            self.messages_scroll_view.setContentOffset(bottomOffset, animated: true)
            
            self.text_field_message.text = ""
        }
        return true
    }
    func send_message() {
        print("send_message")
//        let parameters = [
//            "sender_id": "\(self.app_delegate.me.id)",
//            "receiver_id": "\(self.recipient_id)",
//            "subject": "",
//            "body": "\(self.text_field_containing_new_message.text!)",
//            "api_token": self.app_delegate.me.api_token
//            ] as [String: AnyObject]
        
        let parameters = NSMutableDictionary()
        parameters.setValue(self.app_delegate.me.id, forKey: "id") //set all your values..
        parameters.setValue(self.receiver_id, forKey: "receiver_id")
//        parameters.setValue(self.app_delegate.me.id, forKey: "receiver_id")
        
        let message = NSMutableDictionary()
        message.setValue(self.text_field_message.text!, forKey: "message")
        message.setValue(self.receiver_id, forKey: "receiver_id")
        message.setValue(true, forKey: "is_new")
        message.setValue(self.app_delegate.me.id, forKey: "sender_id")
        
        parameters.setValue(message, forKey: "message")
        
        //        let activity_view_controller = self.app_delegate.show_activity_view_controller("Loading...", parent_view_controller: self)
        
        RestAPIClient.sharedInstance.create_message(parameters: parameters) { response in
            
            DispatchQueue.main.async(execute: {
//                self.app_delegate.remove_activity_view_controller()
//                
//                let view_controller = ViewController_UserProfile()
//                view_controller.profile_data = response
//                
//                if let topViewController = UIApplication.topViewController() {
//                    topViewController.navigationController?.pushViewController(
//                        view_controller,
//                        animated: false
//                    )
//                }
                print ("message sent")

            })
            
//            print (json)
//            
//            let error_code = json["error_code"]
//            
//            if error_code == 0 {
//                let user = json["user"]
//                print (user)
//                print (user["api_token"])
//                print ("message sent")
//            } else {
//                dispatch_async(dispatch_get_main_queue(),{
//                    let alertController = UIAlertController(title: "Message Alert", message: "Error sending message", preferredStyle: UIAlertControllerStyle.Alert)
//                    let OKAction = UIAlertAction(title: "OK", style: .Default) { (action:UIAlertAction!) in
//                        //                        self.text_field_containing_new_message.enabled = true
//                        //                        self.text_field_containing_new_message.becomeFirstResponder()
//                    }
//                    alertController.addAction(OKAction)
//                    self.navigationController?.presentViewController(alertController, animated: true, completion: nil)
//                })
//            }
        }
    }
    //
    
    @IBAction func close(sender: AnyObject) {
        self.close()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
//    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
//        textField.resignFirstResponder()
//        return true;
//    }
    
    override var prefersStatusBarHidden: Bool {
        get {
            return true
        }
    }
    func doneClicked(sender: AnyObject) {
        self.view.endEditing(true)
    }
    
    //Error
    internal func flashError(message: String) {
        //        self.labelContainingErrorMessage.text = message
    }
}
extension UIScrollView {
    func updateContentViewSize() {
        var newHeight: CGFloat = 0
        for view in subviews {
            let ref = view.frame.origin.y + view.frame.height
            if ref > newHeight {
                newHeight = ref
            }
        }
        let oldSize = contentSize
        let newSize = CGSize(width: oldSize.width, height: newHeight + 20)
        contentSize = newSize
    }
}
