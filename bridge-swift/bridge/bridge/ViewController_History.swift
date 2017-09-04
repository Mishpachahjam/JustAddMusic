//
//  ViewController_History.swift
//  bridge
//
//  Created by Konstantin Yurchenko on 1/3/17.
//  Copyright © 2017 Konstantin Yurchenko. All rights reserved.
//

import Foundation
import UIKit

class ViewController_History: BaseViewController, UITextFieldDelegate, UICollectionViewDataSource, UICollectionViewDelegate {
    @IBOutlet weak var view_header: UIView!
    
    var handler: ((_ data: NSDictionary) -> Void) = {data in ()}
    var scrollView: UIScrollView!
    var default_settings: NSDictionary = [:]
    
    var lesson_requests: [Any] = []
    
    let reuseIdentifier = "Cell_History"
    @IBOutlet weak var CollectionView_History: UICollectionView!
    
    override func loadView() {
        super.viewDidLoad()
        
        if self.screenHeight == 480 {
            Bundle.main.loadNibNamed("ViewController_History", owner: self, options: nil)
        } else if self.screenHeight == 568 {
            Bundle.main.loadNibNamed("ViewController_History", owner: self, options: nil)
        } else if self.screenHeight == 736 {
            Bundle.main.loadNibNamed("ViewController_History", owner: self, options: nil)
        } else {
            Bundle.main.loadNibNamed("ViewController_History", owner: self, options: nil)
        }
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let nib = UINib(nibName: self.reuseIdentifier, bundle:nil)
        self.CollectionView_History.register(nib, forCellWithReuseIdentifier: self.reuseIdentifier)
        self.CollectionView_History.delegate = self
        self.CollectionView_History.dataSource = self
        
        self.view_header.backgroundColor = PANTONE_greenery
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(false)
        
//        if (self.scrollView != nil) {
//            self.scrollView.removeFromSuperview()
//        }
//        
//        self.scrollView = UIScrollView(frame: CGRect(x: 0, y: 0, width: self.screenWidth, height: self.screenHeight))
//        self.view.addSubview(self.scrollView)
//        
//        self.stackView = UIStackView()
//        self.stackView.translatesAutoresizingMaskIntoConstraints = false
//        self.stackView.axis = UILayoutConstraintAxis.vertical
//        self.stackView.distribution = UIStackViewDistribution.equalSpacing
//        self.stackView.alignment = UIStackViewAlignment.center
//        self.stackView.spacing = 10
//        
//        self.assembleInterface()
//        
//        self.scrollView.addSubview(self.stackView)
//        self.scrollView.contentSize = CGSize(width: self.stackView.frame.width, height: self.stackView.frame.height)
//        self.scrollView.bounces = false
    }
    // MARK: Collection View
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.lesson_requests.count
    }
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath) as! Cell_History
        
        for object in cell.contentView.subviews {
            print(object)
            object.removeFromSuperview()
        }
        
        cell.backgroundColor = UIColor.white
        
        cell.tag = indexPath.row
        
        if (self.app_delegate.me.is_student) {
            let lesson_request = self.lesson_requests[indexPath.row] as! NSDictionary
            
            let instructor = lesson_request["instructor"] as! NSDictionary
            let facebook_account = instructor["facebook_account"] as! NSDictionary
            
            let first_name = facebook_account["first_name"] as! String
            let last_name = facebook_account["last_name"] as! String
            
            let is_open = lesson_request["is_open"] as! Bool
            
            if is_open {
                cell.title_label.text = "Your lesson with \(first_name) \(last_name.characters.first!). is pending. (Id: \(lesson_request["id"] as! Int))"
            } else {
                cell.title_label.text = "\(first_name) \(last_name.characters.first!). has closed your pending lesson request.  (Id: \(lesson_request["id"] as! Int))"
            }
        }
        else if (self.app_delegate.me.is_instructor) {
            let lesson_request = self.lesson_requests[indexPath.row] as! NSDictionary
            
            let student = lesson_request["student"] as! NSDictionary
            let facebook_account = student["facebook_account"] as! NSDictionary
            
            let first_name = facebook_account["first_name"] as! String
            let last_name = facebook_account["last_name"] as! String
            
            let is_open = lesson_request["is_open"] as! Bool
            
            if is_open {
                cell.title_label.text = "\(first_name) \(last_name.characters.first!). is requesting a lesson with you. (Id: \(lesson_request["id"] as! Int))"
            } else {
                cell.title_label.text = "Your have closed a pending lesson request with \(first_name) \(last_name.characters.first!). (Id: \(lesson_request["id"] as! Int))"
            }
            
            //cell.title_label.text = "\(lesson_request["id"] as! Int)"
        }
        
        return cell
    }
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        print("test")
        
        let lesson_request = self.lesson_requests[indexPath.row] as! NSDictionary
        self.show_ViewController_LessonRequestPreview(lesson_request: lesson_request)
    }
    
    func show_ViewController_LessonRequestPreview(lesson_request: NSDictionary) {
        print("show_ViewController_LessonRequestPreview")
        
        let id = lesson_request["id"] as! Int
        
        let parameters = NSMutableDictionary()
        
        parameters.setValue(self.app_delegate.me.id, forKey: "user_id") //set all your values..
        parameters.setValue(id, forKey: "lesson_request_id")
        
        self.app_delegate.show_activity_view_controller(message: "Loading...")
        
        RestAPIClient.sharedInstance.get_lesson_request(parameters: parameters) { response in
            DispatchQueue.main.async(execute: {
                self.app_delegate.remove_activity_view_controller()
          
                let view_controller = ViewController_LessonRequestPreview()
                view_controller.lesson_request = response["lesson_request"] as! NSDictionary
    
                self.app_delegate.navigation_controller.pushViewController(view_controller, animated: false)
            })
        }
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
}
