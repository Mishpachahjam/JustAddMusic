//
//  ActivityViewController.swift
//  switcharoo
//
//  Created by Konstantin Yurchenko on 12/10/15.
//  Copyright © 2015 Play Entertainment LLC. All rights reserved.
//

import Foundation
import UIKit

import FacebookLogin
import FacebookCore

import FBSDKCoreKit

class ViewController_Console: BaseViewController {
    
    //var checkboxButtons: [CheckboxButton] = []
    
    @IBOutlet weak var view_header: UIView!
    
    var handler: ((_ data: NSDictionary) -> Void) = {data in ()}
    
    // UI ELEMENTS
    var scrollView: UIScrollView!
    var first_name = ""
    
    override func loadView() {
        super.viewDidLoad()
        
        if self.screenHeight == 480 {
            Bundle.main.loadNibNamed("ViewController_Console", owner: self, options: nil)
        } else if self.screenHeight == 568 {
            Bundle.main.loadNibNamed("ViewController_Console", owner: self, options: nil)
        } else if self.screenHeight == 736 {
            Bundle.main.loadNibNamed("ViewController_Console", owner: self, options: nil)
        } else {
            Bundle.main.loadNibNamed("ViewController_Console", owner: self, options: nil)
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
    
    func assembleInterface() {
        self.view_header.heightAnchor.constraint(equalToConstant: 64).isActive = true
        self.view_header.widthAnchor.constraint(equalToConstant: self.screenWidth).isActive = true
        self.stackView.addArrangedSubview(self.view_header)
        
        self.addSpacer()
        
        self.stackView.addArrangedSubview(self.createLabel(text: "Hey, \(self.first_name)!", size: 16))
        
        self.stackView.addArrangedSubview(self.createLabel(text: "Are you?", size: 14))
        
        self.addSpacer()
        
        let button = self.createButton(caption: "Ping")
        button.addTarget(self, action: #selector(self.action_ping), for: UIControlEvents.touchUpInside)
        self.stackView.addArrangedSubview(button)
        
        self.addSpacer()
        
        self.addExpandInfoLabel1Fold(button_text: "Instructions", label_text: "")
        //        self.addExpandInfoLabel2Fold()
        self.addWhyInfoLabel1Fold()
        self.addSpacer()
        
    }
    @IBAction func action_ping(sender: AnyObject) {
        print("action_ping")
        
    }

    @IBAction func close(sender: AnyObject) {
        self.close()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true;
    }
    
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
