//
//  ViewController_LessonList.swift
//  bridge
//
//  Created by Konstantin Yurchenko on 1/6/17.
//  Copyright © 2017 Konstantin Yurchenko. All rights reserved.
//


import Foundation

import UIKit
import SDWebImage

class ViewController_LessonList: BaseViewController, UICollectionViewDataSource, UICollectionViewDelegate  {
    
    var selection_handler: ((_ campaign_image: NSDictionary) -> Void) = {data in ()}
    let reuseIdentifier = "Cell_LessonList"
    var lessons: [Any] = []
    var index = 0
    
    var scrollView: UIScrollView!
    
    @IBOutlet weak var collection_view: UICollectionView!
    @IBOutlet weak var view_header: UIView!
    
    override func loadView() {
        super.viewDidLoad()
        
        if self.screenHeight == 480 {
            Bundle.main.loadNibNamed("ViewController_LessonList", owner: self, options: nil)
        } else if self.screenHeight == 568 {
            Bundle.main.loadNibNamed("ViewController_LessonList", owner: self, options: nil)
        } else if self.screenHeight == 736 {
            Bundle.main.loadNibNamed("ViewController_LessonList", owner: self, options: nil)
        } else {
            Bundle.main.loadNibNamed("ViewController_LessonList", owner: self, options: nil)
        }
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let nib = UINib(nibName: reuseIdentifier, bundle:nil)
        self.collection_view.register(nib, forCellWithReuseIdentifier: reuseIdentifier)
        
        self.view_header.backgroundColor = PANTONE_greenery

    }
    override func viewWillAppear(_ animated: Bool) {
        self.collection_view.reloadData()
        
        let subviews = self.view.subviews
        print("Number of Subviews: \(subviews.count)")
        for item in subviews {
            print(item)
        }
        self.view.sendSubview(toBack: self.collection_view)
    }
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.lessons.count
    }
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath) as! Cell_LessonList
        
        print(cell.contentView.subviews)
        
        for object in cell.contentView.subviews {
            print(object)
            object.removeFromSuperview();
        }
        
        let lesson = self.lessons[indexPath.row] as! NSDictionary
        
//        cell.title_label.text = "\(lesson["id"] as! Int)"
        
        if (self.app_delegate.me.is_student) {
            let instructor = lesson["instructor"] as! NSDictionary
            let facebook_account = instructor["facebook_account"] as! NSDictionary
            
            let first_name = facebook_account["first_name"] as! String
            let last_name = facebook_account["last_name"] as! String
            
            let seconds_until = lesson["time_until"] as! Int
            
            if seconds_until > 0 {
                cell.title_label.text = "You have a lesson with \(first_name) \(last_name.characters.first!). (Id: \(lesson["id"] as! Int))"
            } else {
                cell.title_label.text = "You had a lesson with \(first_name) \(last_name.characters.first!). (Id: \(lesson["id"] as! Int))"
            }
        }
        else if (self.app_delegate.me.is_instructor) {
            let student = lesson["student"] as! NSDictionary
            let facebook_account = student["facebook_account"] as! NSDictionary
            
            let first_name = facebook_account["first_name"] as! String
            let last_name = facebook_account["last_name"] as! String
            
            let seconds_until = lesson["time_until"] as! Int
            
            if seconds_until > 0 {
                cell.title_label.text = "You have a lesson with \(first_name) \(last_name.characters.first!). (Id: \(lesson["id"] as! Int))"
            } else {
                cell.title_label.text = "You had a lesson with \(first_name) \(last_name.characters.first!). (Id: \(lesson["id"] as! Int))"
            }
        }
        
        cell.handler = {
            (data: NSDictionary) -> Void in
        }
        
        return cell
    }
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        print("selected: \(indexPath.row)")
        
        let lesson = self.lessons[indexPath.row] as! NSDictionary
        self.get_lesson_data(lesson_id: lesson["id"] as! Int)    }
    
    func get_lesson_data(lesson_id: Int) {
        let parameters = NSMutableDictionary()
        
        parameters.setValue(self.app_delegate.me.id, forKey: "user_id") //set all your values..
        parameters.setValue(lesson_id, forKey: "lesson_id")
        
        self.app_delegate.show_activity_view_controller(message: "Loading...")
        
        RestAPIClient.sharedInstance.get_lesson(parameters: parameters) { response in
            DispatchQueue.main.async(execute: {
                self.app_delegate.remove_activity_view_controller()
                
                let view_controller = ViewController_Lesson()
                view_controller.lesson = response
                self.app_delegate.navigation_controller.pushViewController(view_controller, animated: false)
            })
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    @IBAction func back(sender: AnyObject) {
        print("back")
        self.close()
    }
}

