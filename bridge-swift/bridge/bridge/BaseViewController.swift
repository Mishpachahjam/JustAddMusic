//
//  RestAPIClient.swift
//  hypewizard
//
//  Created by Konstantin Yurchenko on 11/07/16.
//  Copyright © 2016 Disruptive Widgets. All rights reserved.
//  http://www.disruptivewidgets.com
//


import Foundation
import UIKit
import SDWebImage

let PANTONE_kalamata = UIColor(hexString: "#5F5B4C") // 95, 91, 75 https://www.pantone.com/color-finder/19-0510-TCX
let PANTONE_silt_green = UIColor(hexString: "#A9BDB1") // 169, 189, 177 https://www.pantone.com/color-finder/14-5706-TCX
let PANTONE_silver_blue = UIColor(hexString: "#8A9A9A") // 138, 154, 154 https://www.pantone.com/color-finder/16-4706-TCX
let PANTONE_willow_bough = UIColor(hexString: "#59754D") // 89, 117, 77 https://www.pantone.com/color-finder/18-0119-TCX
let PANTONE_greenery = UIColor(hexString: "#88B04B") // 136, 176, 75 https://www.pantone.com/color-finder/15-0343-TCX
let PANTONE_goblin_blue = UIColor(hexString: "#5F7278") // 95, 114, 120 https://www.pantone.com/color-finder/18-4011-TCX

public class BaseViewController: UIViewController {
    var challengeData: NSDictionary = [:]
    var continueHandler: ((_ data: NSDictionary) -> Void) = {data in ()}
    var cancellationHandler: ((_ data: NSDictionary) -> Void) = {data in ()}
    let app_delegate = UIApplication.shared.delegate as! AppDelegate
    
    func close() {
        let data: NSDictionary = [:]
        self.cancellationHandler(data)
        
        self.app_delegate.navigation_controller.popViewController(animated: false)
    }
    
    let screenHeight = UIScreen.main.bounds.size.height
    let screenWidth = UIScreen.main.bounds.size.width
    
    func createInfoHeaderLabel(text: String) -> UILabel {
        
        let label = UILabel()
        label.heightAnchor.constraint(equalToConstant: 32).isActive = true
        label.widthAnchor.constraint(equalToConstant: self.screenWidth).isActive = true
        label.textAlignment = NSTextAlignment.center
        label.numberOfLines = 0
        label.text = text
        
        // LABEL CUSTOMIZATION
        label.textColor = UIColor(hexString: "#000000")
        label.font = UIFont(
            name: "Copperplate",
            size: 18
        )
        return label
    }
    func createInfoTextLabel(text: String) -> UILabel {
        // INFO TEXT LABEL
        let label: UILabel = UILabel(frame: CGRect(x: 0, y: 0, width: self.screenWidth - 16, height: CGFloat.greatestFiniteMagnitude))
        label.textAlignment = NSTextAlignment.center
        label.numberOfLines = 0
        label.lineBreakMode = NSLineBreakMode.byWordWrapping
        label.text = text
        
        // LABEL CUSTOMIZATION
        label.textColor = UIColor(hexString: "#000000")
        label.font = UIFont(
            name: "Copperplate",
            size: 18
        )
        
        label.sizeToFit()
        
        label.widthAnchor.constraint(equalToConstant: self.screenWidth - 16).isActive = true
        label.heightAnchor.constraint(equalToConstant: label.frame.height).isActive = true
        
        return label
    }
    func createAddInfoLabel(text: String) -> UILabel {
        // INFO TEXT LABEL
        let label: UILabel = UILabel(frame: CGRect(x: 0, y: 0, width: self.screenWidth - 16, height: CGFloat.greatestFiniteMagnitude))
        label.textAlignment = NSTextAlignment.center
        label.numberOfLines = 0
        label.lineBreakMode = NSLineBreakMode.byWordWrapping
        label.text = text
        
        // LABEL CUSTOMIZATION
        label.textColor = UIColor(hexString: "#000000")
        label.font = UIFont(
            name: "Copperplate",
            size: 18
        )
        
        label.sizeToFit()
        
        label.widthAnchor.constraint(equalToConstant: self.screenWidth - 16).isActive = true
        label.heightAnchor.constraint(equalToConstant: label.frame.height).isActive = true
        
        return label
    }
    func createChallengeInfoLabel(text: String) -> UILabel {
        let label: UILabel = UILabel(frame: CGRect(x: 0, y: 0, width: self.screenWidth - 16, height: CGFloat.greatestFiniteMagnitude))
        
        label.textAlignment = NSTextAlignment.center
        label.numberOfLines = 0
        label.lineBreakMode = NSLineBreakMode.byWordWrapping
        label.text = text
        
        // LABEL CUSTOMIZATION
        label.textColor = UIColor(hexString: "#000000")
        label.font = UIFont(
            name: "Copperplate",
            size: 18
        )
        
        label.sizeToFit()
        
        label.widthAnchor.constraint(equalToConstant: self.screenWidth - 16).isActive = true
        label.heightAnchor.constraint(equalToConstant: label.frame.height).isActive = true
        
        return label
    }
    
    func create_image_view_with_url(url: String, width: CGFloat, height: CGFloat) -> UIImageView {
        let image_view = UIImageView(frame: CGRect(x: (self.screenWidth - width) / 2, y: (self.screenHeight - width) / 2, width: width, height: height))
        
        image_view.contentMode = UIViewContentMode.scaleAspectFit
        image_view.sd_setImage(with: NSURL(string: url) as URL!)
        
        image_view.heightAnchor.constraint(equalToConstant: height).isActive = true
        image_view.widthAnchor.constraint(equalToConstant: width).isActive = true
        
        return image_view
    }
    
    func createErrorMessageLabel(text: String) -> UILabel {
        let label = UILabel()
        label.heightAnchor.constraint(equalToConstant: 16).isActive = true
        label.widthAnchor.constraint(equalToConstant: self.screenWidth).isActive = true
        label.textAlignment = NSTextAlignment.center
        label.numberOfLines = 0
        label.text = text
        
        // LABEL CUSTOMIZATION
        label.textColor = UIColor.red
        label.font = UIFont(
            name: "Copperplate",
            size: 18
        )
        
        return label
    }
    
    // Choose Another Payment Method Button and customization
    func createContinueButton() -> UIButton{
        
        let button = UIButton()
        button.heightAnchor.constraint(equalToConstant: 54).isActive = true
        button.widthAnchor.constraint(equalToConstant: self.screenWidth - 80).isActive = true
        button.setTitle("Launch", for: UIControlState.normal)
        button.backgroundColor = UIColor.green //UIColor(red: 0.8, green: 0.4, blue: 1, alpha: 1)
        
        button.titleLabel?.font = UIFont(
            name: "Copperplate",
            size: 18
        )
        button.setTitleColor(
            UIColor.white,
            for: .normal
        )
        button.layer.cornerRadius = CGFloat(4)
        
        button.addTarget(self, action: #selector(self.continue_action), for: UIControlEvents.touchUpInside)
        return button
    }
    
    // GENERICS
    func createButton(caption: String) -> UIButton {
        let button = UIButton()
        button.heightAnchor.constraint(equalToConstant: 54).isActive = true
        button.widthAnchor.constraint(equalToConstant: self.screenWidth - 80).isActive = true
        button.setTitle(caption, for: UIControlState.normal)
        button.backgroundColor = UIColor(red: 0.8, green: 0.4, blue: 1, alpha: 1)
        
        button.backgroundColor = PANTONE_silt_green
        
        button.titleLabel?.font = UIFont(
            name: "Copperplate",
            size: 18
        )
        button.setTitleColor(
            UIColor.white,
            for: .normal
        )
        button.layer.cornerRadius = CGFloat(4)
        
        return button
    }
    func createTextButton(caption: String, captionHeight: CGFloat, buttonHeight: CGFloat) -> UIButton {
        let button = UIButton()
        button.heightAnchor.constraint(equalToConstant: buttonHeight).isActive = true
        button.widthAnchor.constraint(equalToConstant: self.screenWidth - 80).isActive = true
        button.setTitle(caption, for: UIControlState.normal)
        button.backgroundColor = UIColor.white
        
        button.titleLabel?.font = UIFont(
            name: "Copperplate",
            size: captionHeight
        )
        button.setTitleColor(
//            UIColor(red: 0.8, green: 0.4, blue: 1, alpha: 1),
            PANTONE_goblin_blue,
            for: .normal
        )
        button.layer.cornerRadius = CGFloat(4)
        
        return button
    }
    func createLabel(text: String, size: CGFloat) -> UILabel {
        let label: UILabel = UILabel(frame: CGRect(x: 0, y: 0, width: self.screenWidth - 16, height: CGFloat.greatestFiniteMagnitude))
        
        label.textAlignment = NSTextAlignment.center
        label.numberOfLines = 0
        label.lineBreakMode = NSLineBreakMode.byWordWrapping
        label.text = text
        
        // LABEL CUSTOMIZATION
        label.textColor = UIColor(hexString: "#000000")
        label.font = UIFont(name: "Copperplate", size: size)
        
        label.sizeToFit()
        
        label.widthAnchor.constraint(equalToConstant: self.screenWidth - 16).isActive = true
        label.heightAnchor.constraint(equalToConstant: label.frame.height).isActive = true
        
        return label
    }
    func createSwitch(isOn: Bool) -> UISwitch {
        let toggle = UISwitch(frame: CGRect(x: 0, y: 0, width: self.screenWidth - 16, height: CGFloat.greatestFiniteMagnitude))
        toggle.isOn = isOn
        toggle.setOn(isOn, animated: false);
        toggle.heightAnchor.constraint(equalToConstant: toggle.frame.height).isActive = true
        
        return toggle
    }
    func createTextField(placeholder: String) -> UITextField {
        
        let text_field = UITextField()
        text_field.widthAnchor.constraint(equalToConstant: self.screenWidth - 16).isActive = true
        text_field.heightAnchor.constraint(equalToConstant: 32).isActive = true
        
        text_field.textColor = UIColor.black
        text_field.font = UIFont(
            name: "Copperplate",
            size: 14
        )
        text_field.placeholder = placeholder
        text_field.layer.cornerRadius = 4
        text_field.layer.borderColor = UIColor.gray.withAlphaComponent(0.5).cgColor
        text_field.layer.borderWidth = 0.5
        text_field.clipsToBounds = true
        
        text_field.textAlignment = .center
        
        return text_field
    }
    func createTextView() -> UITextView {
        
        let text_view = UITextView()
        text_view.widthAnchor.constraint(equalToConstant: self.screenWidth - 16).isActive = true
        text_view.heightAnchor.constraint(equalToConstant: 128).isActive = true
//        text_view.backgroundColor = UIColor(red: 0.501961, green: 0, blue: 1, alpha: 1)
        
        text_view.backgroundColor = PANTONE_silver_blue
        
        text_view.font = UIFont(
            name: "Copperplate",
            size: 14
        )
        
        text_view.textColor = UIColor.white
        
        return text_view
    }
    func createPickerView() -> UIPickerView {
     
        let picker_view = UIPickerView()
        
        return picker_view
    }
    func createDatePickerView() -> UIDatePicker {
        
        let picker_view = UIDatePicker()
        picker_view.datePickerMode = UIDatePickerMode.dateAndTime
        return picker_view
    }
    
    // GENERICS
    @IBAction func continue_action(sender: AnyObject) {
        self.continueHandler([:])
        self.navigationController?.popViewController(animated: false)
    }
    
    var stackView: UIStackView!
    
    // Fold Labels
    var whyInfoLabel1 = UILabel()
    func whyInfoLabel1ButtonAction(sender: UIButton) {
        DispatchQueue.main.async(execute: {
            self.whyInfoLabel1.isHidden = !self.whyInfoLabel1.isHidden
            
            self.stackView.setNeedsUpdateConstraints()
            self.stackView.setNeedsLayout()
            self.stackView.layoutIfNeeded()
            self.stackView.layoutSubviews()
        })
    }
    func addWhyInfoLabel1Fold() {
        // HELP NEEDED
        if let text = self.challengeData["whyInfoLabel1"] as? String {
            let button = UIButton()
            button.heightAnchor.constraint(equalToConstant: 32).isActive = true
            button.widthAnchor.constraint(equalToConstant: self.screenWidth).isActive = true
            button.setTitle(text, for: UIControlState.normal)
            
            // BUTTON CUSTOMIZATION
            button.backgroundColor = UIColor.lightGray
            button.setTitleColor(UIColor.black, for: UIControlState.normal)
            button.titleLabel?.font = UIFont(
                name: "Copperplate",
                size: 14
            )
            
            button.addTarget(
                self,
                action: #selector(self.whyInfoLabel1ButtonAction),
                for: UIControlEvents.touchUpInside
            )
            
            self.stackView.addArrangedSubview(button)
        }
        
        if let text = self.challengeData["whyInfoText1"] as? String {
            self.whyInfoLabel1 = UILabel()
            self.whyInfoLabel1.heightAnchor.constraint(equalToConstant: 105).isActive = true
            self.whyInfoLabel1.widthAnchor.constraint(equalToConstant: self.screenWidth - 16).isActive = true
            self.whyInfoLabel1.textAlignment = NSTextAlignment.left
            self.whyInfoLabel1.numberOfLines = 0
            self.whyInfoLabel1.isHidden = true
            self.whyInfoLabel1.text = text
            
            // LABEL CUSTOMIZATION
            self.whyInfoLabel1.textColor = UIColor.gray
            self.whyInfoLabel1.font = UIFont(
                name: "Copperplate",
                size: 12
            )
            
            self.stackView.addArrangedSubview(self.whyInfoLabel1)
        }
    }
    
    var expandInfoLabel1 = UILabel()
    func expandInfoLabel1ButtonAction(sender: UIButton) {
        DispatchQueue.main.async(execute: {
            self.expandInfoLabel1.isHidden = !self.expandInfoLabel1.isHidden
            
            self.stackView.setNeedsUpdateConstraints()
            self.stackView.setNeedsLayout()
            self.stackView.layoutIfNeeded()
            self.stackView.layoutSubviews()
        })
    }
    func addExpandInfoLabel1Fold(button_text: String, label_text: String) {
        // HELP NEEDED
        let button = UIButton()
        button.heightAnchor.constraint(equalToConstant: 32).isActive = true
        button.widthAnchor.constraint(equalToConstant: self.screenWidth).isActive = true
        button.setTitle(button_text, for: UIControlState.normal)
        
        // BUTTON CUSTOMIZATION
        button.backgroundColor = UIColor.lightGray
        button.setTitleColor(UIColor.black, for: UIControlState.normal)
        button.titleLabel?.font = UIFont(
            name: "Copperplate",
            size: 12
        )
        
        button.addTarget(
            self,
            action: #selector(expandInfoLabel1ButtonAction),
            for: UIControlEvents.touchUpInside
        )
        
        self.stackView.addArrangedSubview(button)
        
        self.expandInfoLabel1 = UILabel()
        self.expandInfoLabel1.heightAnchor.constraint(equalToConstant: 105).isActive = true
        self.expandInfoLabel1.widthAnchor.constraint(
            equalToConstant: self.screenWidth - 16).isActive = true
        self.expandInfoLabel1.textAlignment = NSTextAlignment.center
        self.expandInfoLabel1.numberOfLines = 0
        self.expandInfoLabel1.isHidden = true
        self.expandInfoLabel1.text = label_text
        self.expandInfoLabel1.backgroundColor = UIColor.lightText
        
        // LABEL CUSTOMIZATION
        self.expandInfoLabel1.textColor = UIColor.gray
        self.expandInfoLabel1.font = UIFont(
            name: "Copperplate",
            size: 12
        )
        
        self.stackView.addArrangedSubview(self.expandInfoLabel1)
    }
    
    var expandInfoLabel2 = UILabel()
    func expandInfoLabel2ButtonAction(sender: UIButton) {
        DispatchQueue.main.async(execute: {
            self.expandInfoLabel2.isHidden = !self.expandInfoLabel2.isHidden
            
            self.stackView.setNeedsUpdateConstraints()
            self.stackView.setNeedsLayout()
            self.stackView.layoutIfNeeded()
            self.stackView.layoutSubviews()
        })
    }
    func addExpandInfoLabel2Fold() {
        // HELP NEEDED
        if let text = "SelfOneRolling" as? String {
            let button = UIButton()
            button.heightAnchor.constraint(equalToConstant: 32).isActive = true
            button.widthAnchor.constraint(equalToConstant: self.screenWidth).isActive = true
            button.setTitle(text, for: UIControlState.normal)
            
            // BUTTON CUSTOMIZATION
            button.backgroundColor = UIColor.lightGray
            button.setTitleColor(UIColor.black, for: UIControlState.normal)
            button.titleLabel?.font = UIFont(
                name: "Copperplate",
                size: 12
            )
            
            button.addTarget(
                self,
                action: #selector(expandInfoLabel2ButtonAction),
                for: UIControlEvents.touchUpInside
            )
            
            self.stackView.addArrangedSubview(button)
        }
        
        if let text = "Rolling post, will remove previous post if message is the same. Will post on connected account." as? String {
            self.expandInfoLabel2 = UILabel()
            self.expandInfoLabel2.heightAnchor.constraint(equalToConstant: 105).isActive = true
            self.expandInfoLabel2.widthAnchor.constraint(equalToConstant: self.screenWidth - 16).isActive = true
            self.expandInfoLabel2.textAlignment = NSTextAlignment.left
            self.expandInfoLabel2.numberOfLines = 0
            self.expandInfoLabel2.isHidden = true
            self.expandInfoLabel2.text = text
            self.expandInfoLabel2.backgroundColor = UIColor.lightText
            
            // LABEL CUSTOMIZATION
            self.expandInfoLabel2.textColor = UIColor.gray
            self.expandInfoLabel2.font = UIFont(
                name: "Copperplate",
                size: 12
            )
            
            self.stackView.addArrangedSubview(self.expandInfoLabel2)
        }
    }
    
    func addSpacer() {
        let view = UIView()
        view.heightAnchor.constraint(equalToConstant: 16).isActive = true
        view.widthAnchor.constraint(equalToConstant: self.screenWidth).isActive = true
        
        self.stackView.addArrangedSubview(view)
        
        DispatchQueue.main.async(execute: {
            self.stackView.setNeedsUpdateConstraints()
            self.stackView.setNeedsLayout()
            self.stackView.layoutIfNeeded()
            self.stackView.layoutSubviews()
        })
    }
    func show_success_alert() {
        let alert = UIAlertController(title: "Hype Wizard Alert", message: "Success!", preferredStyle: UIAlertControllerStyle.alert)
        alert.addAction(UIAlertAction(title: "Okay", style: UIAlertActionStyle.default, handler: nil))
        self.navigationController?.present(alert, animated: true, completion: nil)
        
        if let topViewController = UIApplication.topViewController() {
            topViewController.navigationController?.present(alert, animated: true, completion: nil)
        }
    }
    func show_failure_alert(message: String) {
        let alert = UIAlertController(title: "Hype Wizard Failure", message: message, preferredStyle: UIAlertControllerStyle.alert)
        alert.addAction(UIAlertAction(title: "Okay", style: UIAlertActionStyle.default, handler: nil))
        self.navigationController?.present(alert, animated: true, completion: nil)
        
        if let topViewController = UIApplication.topViewController() {
            topViewController.navigationController?.present(alert, animated: true, completion: nil)
        }
    }
    override public var prefersStatusBarHidden: Bool {
        get {
            return true
        }
    }
}
