//
//  ViewController_StudentSettings
//
//  Created by Konstantin Yurchenko on 7/18/16.
//  Copyright © 2016 Play Entertainment. All rights reserved.
//

import Foundation
import UIKit

class ViewController_StudentSettings: BaseViewController, UITextFieldDelegate {
    @IBOutlet weak var view_header: UIView!
    
    var handler: ((_ data: NSDictionary) -> Void) = {data in ()}
    var scrollView: UIScrollView!
    
    var default_settings: NSDictionary = [:]
    var actual_settings: NSDictionary = [:]
    
    override func loadView() {
        super.viewDidLoad()
        
        if self.screenHeight == 480 {
            Bundle.main.loadNibNamed("ViewController_InstructorSettings", owner: self, options: nil)
        } else if self.screenHeight == 568 {
            Bundle.main.loadNibNamed("ViewController_InstructorSettings", owner: self, options: nil)
        } else if self.screenHeight == 736 {
            Bundle.main.loadNibNamed("ViewController_InstructorSettings", owner: self, options: nil)
        } else {
            Bundle.main.loadNibNamed("ViewController_InstructorSettings", owner: self, options: nil)
        }
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view_header.backgroundColor = PANTONE_greenery
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(false)
        
        if (self.scrollView != nil) {
            self.scrollView.removeFromSuperview()
        }
        
        self.scrollView = UIScrollView(frame: CGRect(x: 0, y: 0, width: self.screenWidth, height: self.screenHeight))
        self.view.addSubview(self.scrollView)
        
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
    }
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        #if DEBUG
            print("viewDidLayoutSubviews")
        #endif
        
        self.scrollView.contentSize = CGSize(width: stackView.frame.width, height: stackView.frame.height)
    }
    func assembleInterface() {
        self.view_header.heightAnchor.constraint(equalToConstant: 64).isActive = true
        self.view_header.widthAnchor.constraint(equalToConstant: self.screenWidth).isActive = true
        self.stackView.addArrangedSubview(self.view_header)
        
        self.addSpacer()
        
        self.stackView.addArrangedSubview(self.createLabel(text: "Student Settings", size: 16))
        
        self.addSpacer()
        self.add_setting_interface()
        
        self.addSpacer()
        self.stackView.addArrangedSubview(self.createLabel(text: "Are you interested in jamming?", size: 16))
        
        let jam_switch = self.createSwitch(isOn: self.is_open_to_jam)
        jam_switch.addTarget(self, action: #selector(self.set_jam_setting(sender:)), for: .valueChanged)
        self.stackView.addArrangedSubview(jam_switch)
        
        self.addSpacer()
        self.addExpandInfoLabel1Fold(button_text: "Instructions", label_text: "")
        //        self.addExpandInfoLabel2Fold()
        self.addWhyInfoLabel1Fold()
        self.addSpacer()
        
        self.continueHandler =  {
            (data: NSDictionary) -> Void in
            
            print("Continue handler engaged")
        }
    }
    
//    func add_setting_interface() {
//        for (index, key) in self.default_settings.allKeys.enumerated() {
//            if let setting = self.default_settings[key] as? NSDictionary {
//                let setting_key = key as! String
//                let caption = setting["caption"] as! String
//                
//                let button = self.createButton(caption: caption)
//                
//                button.addTarget(self, action: #selector(self.action_select_answer), for: UIControlEvents.touchUpInside)
//                button.tag = index
//                
//                self.stackView.addArrangedSubview(button)
//                
//                if (self.custom_settings.keys.contains(setting_key)) {
//                    let answer = self.custom_settings[setting_key]! as NSDictionary
//                    
//                    //                    let key = answer["key"] as! String
//                    let value = answer["value"] as! String
//                    
//                    self.stackView.addArrangedSubview(self.createLabel(text: value, size: 16))
//                }
//            }
//        }
//    }
    
    func add_setting_interface() {
        
        print("custom_settings: \(self.custom_settings)")
        
        if (self.actual_settings != [:] && self.custom_settings == [:]) {
            for key in self.default_settings.allKeys {
                if let setting = self.default_settings[key] as? NSDictionary {
                    let setting_key = key as! String
                    
                    let options = setting["options"] as! NSDictionary
                    
                    let value: NSDictionary = [
                        "key": self.actual_settings[setting_key] as! String,
                        "value": options[self.actual_settings[setting_key] as! String] as! String
                    ]
                    
                    self.custom_settings[setting_key] = value
                }
            }
            self.is_open_to_jam = self.actual_settings["is_open_to_jam"] as! Bool
        }
        
        print("custom_settings: \(self.custom_settings)")
        
        for (index, key) in self.default_settings.allKeys.enumerated() {
            if let setting = self.default_settings[key] as? NSDictionary {
                let setting_key = key as! String
                let caption = setting["caption"] as! String
                
                let button = self.createButton(caption: caption)
                
                button.addTarget(self, action: #selector(self.action_select_answer), for: UIControlEvents.touchUpInside)
                button.tag = index
                
                self.stackView.addArrangedSubview(button)
                
                if (self.actual_settings != [:]) {
                    print("###################")
                    print("actual: \(self.actual_settings)")
                    print("default_settings: \(self.default_settings)")
                    print("custom_settings: \(self.custom_settings)")
                    print("###################")
                }
                
                if (self.custom_settings.keys.contains(setting_key)) {
                    let answer = self.custom_settings[setting_key]! as NSDictionary
                    
                    //                    let key = answer["key"] as! String
                    let value = answer["value"] as! String
                    
                    self.stackView.addArrangedSubview(self.createLabel(text: value, size: 16))
                }
            }
        }
    }
    
    var custom_settings: [String : NSDictionary] = [:]

    var is_open_to_jam = true

    func set_jam_setting(sender: UISwitch) {
        self.is_open_to_jam = sender.isOn
    }
    
    @objc func action_select_answer(sender: AnyObject) {
        print(sender.tag)
        
        let view_controller = ViewController_ProfileSettingPicker()
        
        let keys = self.default_settings.allKeys
        
        let key = keys[sender.tag] as! String
        
        let setting = self.default_settings[key] as! NSDictionary
        view_controller.caption = setting["caption"] as! String
        
        let options = setting["options"] as! NSDictionary
        
        view_controller.options = options
        view_controller.setting_key = key
        
        view_controller.handler = {
            (data: NSDictionary) -> Void in
            print(data)
            
            let key = data["key"] as! String
            let value = data["value"] as! String
            
            print(key, value)
            
            self.custom_settings[view_controller.setting_key] = data
        }
        
        if let topViewController = UIApplication.topViewController() {
            topViewController.navigationController?.pushViewController(
                view_controller,
                animated: false
            )
        }
    }
    
    @IBAction func close(sender: AnyObject) {
        self.close()
    }
    @IBAction func next(sender: AnyObject) {
        
        let view_controller = ViewController_ProfileBio()
        view_controller.profile_type = ProfileType.STUDENT
        
        view_controller.settings = self.custom_settings
        
        view_controller.is_open_to_jam = self.is_open_to_jam
        
        if (self.actual_settings != [:]) {
            view_controller.bio = self.actual_settings["bio"] as! String
            view_controller.mode = ViewController_ProfileBio_Mode.UPDATE
        } else {
            view_controller.mode = ViewController_ProfileBio_Mode.CREATE
        }
        
        print(self.custom_settings)
        
        self.app_delegate.navigation_controller.pushViewController(view_controller, animated: false)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override var prefersStatusBarHidden: Bool {
        get {
            return true
        }
    }
}
