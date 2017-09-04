//
//  ViewController_ProfileBio.swift
//  bridge
//
//  Created by Konstantin Yurchenko on 11/17/16.
//  Copyright © 2016 Konstantin Yurchenko. All rights reserved.
//

import Foundation
import UIKit

enum ProfileType: Int {
    case STUDENT = 1, INSTRUCTOR
}

enum ViewController_ProfileBio_Mode: Int {
    case CREATE = 1, UPDATE
}

class ViewController_ProfileBio: BaseViewController, UITextViewDelegate, UITextFieldDelegate {
    
    @IBOutlet weak var button_submit: UIButton!
    
    @IBOutlet weak var view_header: UIView!
    
    var handler: ((_ data: NSDictionary) -> Void) = {data in ()}
    
    // UI ELEMENTS
    var scrollView: UIScrollView!
    var profile_type = ProfileType.STUDENT
    
    var settings: [String : NSDictionary] = [:]
    
    var is_open_to_jam = true
    var bio = ""
    
    var mode = ViewController_ProfileBio_Mode.CREATE
    
    override func loadView() {
        super.viewDidLoad()
        
        if self.screenHeight == 480 {
            Bundle.main.loadNibNamed("ViewController_ProfileBio", owner: self, options: nil)
        } else if self.screenHeight == 568 {
            Bundle.main.loadNibNamed("ViewController_ProfileBio", owner: self, options: nil)
        } else if self.screenHeight == 736 {
            Bundle.main.loadNibNamed("ViewController_ProfileBio", owner: self, options: nil)
        } else {
            Bundle.main.loadNibNamed("ViewController_ProfileBio", owner: self, options: nil)
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
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(false)
        
    }
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        #if DEBUG
            print("viewDidLayoutSubviews")
        #endif
        
        self.scrollView.contentSize = CGSize(width: stackView.frame.width, height: stackView.frame.height)
    }
    
    var bio_text_view = UITextView()
    var character_count_label = UILabel()
  
    func assembleInterface() {
        // HEADER
        self.view_header.heightAnchor.constraint(equalToConstant: 64).isActive = true
        self.view_header.widthAnchor.constraint(equalToConstant: self.screenWidth).isActive = true
        self.stackView.addArrangedSubview(self.view_header)
        
        self.stackView.addArrangedSubview(self.createLabel(text: "Short Bio", size: 24))
        
        let keyboardDoneButtonView = UIToolbar.init()
        keyboardDoneButtonView.sizeToFit()
        let doneButton = UIBarButtonItem.init(barButtonSystemItem: UIBarButtonSystemItem.done,
                                               target: self,
                                              action: #selector(self.doneClicked(sender:)))
        
        keyboardDoneButtonView.items = [doneButton]
        
        self.character_count_label = self.createLabel(text: "Character Count: \(self.bio.characters.count)", size: 16)
        self.stackView.addArrangedSubview(self.character_count_label)
        
        self.bio_text_view = self.createTextView()
        self.bio_text_view.delegate = self
        self.bio_text_view.becomeFirstResponder()
        self.bio_text_view.keyboardAppearance = .dark
        self.bio_text_view.inputAccessoryView = keyboardDoneButtonView
        
        self.bio_text_view.text = self.bio
        
        self.stackView.addArrangedSubview(self.bio_text_view)
        
        self.addSpacer()
        
        self.addExpandInfoLabel1Fold(button_text: "Instruction", label_text: "Tell us about yourself")
        //        self.addExpandInfoLabel2Fold()
        self.addWhyInfoLabel1Fold()
        self.addSpacer()
    }
    
    @IBAction func next(sender: AnyObject) {
        print("next")

        var error = false
        var message = ""
        
        if self.bio_text_view.text!.isEmpty {
            error = true
            message = "Message can't be empty"
        }
        
        if error {
            self.show_failure_alert(message: message)
        } else {
            
            if (self.mode == ViewController_ProfileBio_Mode.CREATE) {
                self.create_new_profile()
            } else if (self.mode == ViewController_ProfileBio_Mode.UPDATE) {
                self.update_profile()
            }
        }
    }
    @IBAction func close(sender: AnyObject) {
        self.close()
    }
    
    func create_new_profile() {
        let parameters = NSMutableDictionary()

        parameters.setValue(self.app_delegate.me.id, forKey: "id") //set all your values..
        parameters.setValue(self.settings, forKey: "settings")
        parameters.setValue(self.bio_text_view.text, forKey: "bio")
        parameters.setValue(self.is_open_to_jam, forKey: "is_open_to_jam")

        self.app_delegate.show_activity_view_controller(message: "Loading...")

        switch self.profile_type {
            case ProfileType.STUDENT:
                RestAPIClient.sharedInstance.create_student_profile(parameters: parameters) { response in
                    DispatchQueue.main.async(execute: {
                        self.app_delegate.remove_activity_view_controller()
        
                        let view_controller = ViewController_UserProfile()
                        view_controller.profile_data = response
        
                        self.app_delegate.me.is_student = true
                        self.app_delegate.me.is_instructor = false
                        
                        if let topViewController = UIApplication.topViewController() {
                            topViewController.navigationController?.pushViewController(
                                view_controller,
                                animated: false
                            )
                        }
                    })
                }
                break
            case ProfileType.INSTRUCTOR:
                RestAPIClient.sharedInstance.create_instructor_profile(parameters: parameters) { response in
                    DispatchQueue.main.async(execute: {
                        self.app_delegate.remove_activity_view_controller()
                        
                        let view_controller = ViewController_UserProfile()
                        view_controller.profile_data = response
                        
                        self.app_delegate.me.is_student = false
                        self.app_delegate.me.is_instructor = true
                        
                        if let topViewController = UIApplication.topViewController() {
                            topViewController.navigationController?.pushViewController(
                                view_controller,
                                animated: false
                            )
                        }
                    })
                }
                break
        }
    }
    func update_profile() {
        print("update_profile")
        
        let parameters = NSMutableDictionary()

        print(self.settings)
        
        parameters.setValue(self.app_delegate.me.profile_id, forKey: "profile_id") //set all your values..
        parameters.setValue(self.bio_text_view.text, forKey: "bio")
        parameters.setValue(self.settings, forKey: "settings")
        parameters.setValue(self.is_open_to_jam, forKey: "is_open_to_jam")
        
        self.app_delegate.show_activity_view_controller(message: "Loading...")
        
        switch self.profile_type {
        case ProfileType.STUDENT:
            RestAPIClient.sharedInstance.update_student_profile(parameters: parameters) { response in
                DispatchQueue.main.async(execute: {
                    self.app_delegate.remove_activity_view_controller()
                    
                    let view_controller = ViewController_UserProfile()
                    view_controller.profile_data = response
                    
                    self.app_delegate.me.is_student = true
                    self.app_delegate.me.is_instructor = false
                    
                    if let topViewController = UIApplication.topViewController() {
                        topViewController.navigationController?.pushViewController(
                            view_controller,
                            animated: false
                        )
                    }
                })
            }
            break
        case ProfileType.INSTRUCTOR:
            RestAPIClient.sharedInstance.update_instructor_profile(parameters: parameters) { response in
                DispatchQueue.main.async(execute: {
                    self.app_delegate.remove_activity_view_controller()
                    
                    let view_controller = ViewController_UserProfile()
                    view_controller.profile_data = response
                    
                    self.app_delegate.me.is_student = false
                    self.app_delegate.me.is_instructor = true
                    
                    if let topViewController = UIApplication.topViewController() {
                        topViewController.navigationController?.pushViewController(
                            view_controller,
                            animated: false
                        )
                    }
                })
            }
            break
        }
        
    }
    var options: [String] = []
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true;
    }
    func textViewDidChange(_ textView: UITextView) { //Handle the text changes here
        self.character_count_label.text = "Character Count: \(textView.text.characters.count)"
    }
    
    override var prefersStatusBarHidden: Bool {
        get {
            return true
        }
    }
    func textViewDidBeginEditing(_ textView: UITextView) {
        self.button_submit.isHidden = true
    }
    func doneClicked(sender: AnyObject) {
        self.button_submit.isHidden = false
        
        self.view.endEditing(true)
    }
    //Error
    internal func flashError(message: String) {
        //        self.labelContainingErrorMessage.text = message
    }
}

