
//
//  ViewController_LessonRequestDatePicker.swift
//  bridge
//
//  Created by Konstantin Yurchenko on 1/28/17.
//  Copyright © 2017 Konstantin Yurchenko. All rights reserved.
//

import Foundation

import UIKit

class ViewController_LessonRequestDatePicker: BaseViewController {
    
    @IBOutlet weak var view_header: UIView!
    
    var handler: ((_ data: NSDictionary) -> Void) = {data in ()}
    
    // UI ELEMENTS
    var scrollView: UIScrollView!
    
    var options: NSDictionary = [:]
    var setting_key = ""
    var caption = ""
    
    var setting_index = 0
    
    override func loadView() {
        super.viewDidLoad()
        
        if self.screenHeight == 480 {
            Bundle.main.loadNibNamed("ViewController_LessonRequestDatePicker", owner: self, options: nil)
        } else if self.screenHeight == 568 {
            Bundle.main.loadNibNamed("ViewController_LessonRequestDatePicker", owner: self, options: nil)
        } else if self.screenHeight == 736 {
            Bundle.main.loadNibNamed("ViewController_LessonRequestDatePicker", owner: self, options: nil)
        } else {
            Bundle.main.loadNibNamed("ViewController_LessonRequestDatePicker", owner: self, options: nil)
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

//        self.selected_value = self.options.allValues[0] as! String
//        self.selected_key = self.options.allKeys[0] as! String
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
    
    var date_picker = UIDatePicker()
    
    func assembleInterface() {
        self.view_header.heightAnchor.constraint(equalToConstant: 64).isActive = true
        self.view_header.widthAnchor.constraint(equalToConstant: self.screenWidth).isActive = true
        self.stackView.addArrangedSubview(self.view_header)
        
        self.addSpacer()
        self.stackView.addArrangedSubview(self.createLabel(text: self.caption, size: 16))
        
        self.addSpacer()
        self.date_picker = self.createDatePickerView()
        self.stackView.addArrangedSubview(self.date_picker)
        
        date_picker.addTarget(self, action: #selector(self.date_changed), for: .valueChanged)
        
        let button_set_date = self.createButton(caption: "Set Date")
        button_set_date.addTarget(self, action: #selector(self.action_set_date), for: UIControlEvents.touchUpInside)
        self.stackView.addArrangedSubview(button_set_date)
        
        self.addSpacer()
        self.addExpandInfoLabel1Fold(button_text: "Instructions", label_text: "")
        //        self.addExpandInfoLabel2Fold()
        self.addWhyInfoLabel1Fold()
    }
    
    @objc func date_changed(sender: UIDatePicker) {
        print("date_changed")
        self.selected_date = sender.date
//        let formatter = DateFormatter()
//        formatter.timeStyle = .ShortStyle
//        startTimeDiveTextField.text = formatter.stringFromDate(sender.date)
    }
    
    var selected_date = Date()
    
    @objc func action_set_date(sender: AnyObject) {
        let data: NSDictionary = [
            "date": self.selected_date
        ]
        
        self.handler(data)
        self.close()
    }
    
    @IBAction func close(sender: AnyObject) {
        self.close()
    }
//    
//    func numberOfComponents(in pickerView: UIPickerView) -> Int {
//        return 1
//    }
//    
//    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
//        return self.options.allValues.count
//    }
//    
//    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
//        return self.options.allValues[row] as? String
//    }
//    
//    var selected_value = ""
//    var selected_key = ""
//    
//    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
////        self.answer_picker.isHidden = false
//        
////        self.selected_value = self.options.allValues[row] as! String
////        self.selected_key = self.options.allKeys[row] as! String
//    }
//    
//    func pickerView(_ pickerView: UIPickerView, viewForRow row: Int, forComponent component: Int, reusing view: UIView?) -> UIView {
//        
//        var label = view as! UILabel!
//        if label == nil {
//            label = UILabel()
//        }
//        
//        let data = self.options.allValues[row] as! String
//        let title = NSAttributedString(string: data, attributes: [NSFontAttributeName:UIFont(name: "Copperplate",size: 18.0)!])
//        label?.attributedText = title
//        label?.textAlignment = .center
//        return label!
//    }
}
