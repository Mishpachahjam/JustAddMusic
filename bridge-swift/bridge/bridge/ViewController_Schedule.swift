 //
//  ViewController_Schedule.swift
//  bridge
//
//  Created by Konstantin Yurchenko on 1/3/17.
//  Copyright © 2017 Konstantin Yurchenko. All rights reserved.
//

class ViewController_Schedule: BaseViewController, UITextFieldDelegate {
    
    @IBOutlet weak var view_header: UIView!
    @IBOutlet weak var button_back: UIButton!
    
    var handler: ((_ data: NSDictionary) -> Void) = {data in ()}
    var scrollView: UIScrollView!
    
    override func loadView() {
        super.viewDidLoad()
        
        if self.screenHeight == 480 {
            Bundle.main.loadNibNamed("ViewController_Schedule", owner: self, options: nil)
        } else if self.screenHeight == 568 {
            Bundle.main.loadNibNamed("ViewController_Schedule", owner: self, options: nil)
        } else if self.screenHeight == 736 {
            Bundle.main.loadNibNamed("ViewController_Schedule", owner: self, options: nil)
        } else {
            Bundle.main.loadNibNamed("ViewController_Schedule", owner: self, options: nil)
        }
    }
    override func viewDidLoad() {
        super.viewDidLoad()
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
        
        self.view_header.backgroundColor = PANTONE_greenery
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
        self.addSpacer()
        
        // TEXT FIELD
        
        if (self.app_delegate.me.is_student) {
            self.assemble_student_interface()
        } else if (self.app_delegate.me.is_instructor) {
            self.assemble_instructor_interface()
        }
        
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
    
    @objc func assemble_student_interface() {
        print("assemble_student_interface")
        
//        self.stackView.addArrangedSubview(self.createLabel(text: "Student Schedule", size: 16))

        let button_lessons = self.createButton(caption: "Lessons")
        button_lessons.addTarget(self, action: #selector(self.action_show_student_lessons), for: UIControlEvents.touchUpInside)
        self.stackView.addArrangedSubview(button_lessons)
        
//        let button_availability = self.createButton(caption: "Availability")
//        button_availability.addTarget(self, action: #selector(self.action_show_student_availability), for: UIControlEvents.touchUpInside)
//        self.stackView.addArrangedSubview(button_availability)
    }
    @objc func assemble_instructor_interface() {
        print("assemble_instructor_interface")
        
//        self.stackView.addArrangedSubview(self.createLabel(text: "Instructor Schedule", size: 16))

        let button_lessons = self.createButton(caption: "Lessons")
        button_lessons.addTarget(self, action: #selector(self.action_show_instructor_lessons), for: UIControlEvents.touchUpInside)
        self.stackView.addArrangedSubview(button_lessons)
        
//        let button_availability = self.createButton(caption: "Availability")
//        button_availability.addTarget(self, action: #selector(self.action_show_instructor_availability), for: UIControlEvents.touchUpInside)
//        self.stackView.addArrangedSubview(button_availability)
    }
    
    @objc func action_show_student_lessons() {
        print("action_show_student_lessons")
        
        let parameters = NSMutableDictionary()
        
        parameters.setValue(self.app_delegate.me.id, forKey: "user_id") //set all your values..
        
        self.app_delegate.show_activity_view_controller(message: "Loading...")
        
        RestAPIClient.sharedInstance.retrieve_student_lessons(parameters: parameters) { response in
            print(response)
            
            DispatchQueue.main.async(execute: {
                self.app_delegate.remove_activity_view_controller()
                
                let view_controller = ViewController_LessonList()
                
                view_controller.lessons = response["lessons"] as! [Any]
                self.app_delegate.navigation_controller.pushViewController(view_controller, animated: false)
            })
        }
    }
    @objc func action_show_instructor_lessons() {
        print("action_show_instructor_lessons")
        
        let parameters = NSMutableDictionary()
        
        parameters.setValue(self.app_delegate.me.id, forKey: "user_id") //set all your values..
        
        self.app_delegate.show_activity_view_controller(message: "Loading...")
        
        RestAPIClient.sharedInstance.retrieve_instructor_lessons(parameters: parameters) { response in
            print(response)
            
            DispatchQueue.main.async(execute: {
                self.app_delegate.remove_activity_view_controller()
                
                let view_controller = ViewController_LessonList()
                
                view_controller.lessons = response["lessons"] as! [Any]
                self.app_delegate.navigation_controller.pushViewController(view_controller, animated: false)
            })
        }
    }
    @objc func action_show_student_availability() {
        print("action_show_student_availability")
    }
    @objc func action_show_instructor_availability() {
        print("action_show_instructor_availability")
    }
    
    @IBAction func close(sender: AnyObject) {
        self.close()
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
    
    //Error
    internal func flashError(message: String) {
        //        self.labelContainingErrorMessage.text = message
    }
}

