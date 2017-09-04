//
//  ViewController_InstructorList.swift
//  bridge
//
//  Created by Konstantin Yurchenko on 11/22/16.
//  Copyright © 2016 Konstantin Yurchenko. All rights reserved.
//

import Foundation

import UIKit
import SDWebImage

class ViewController_InstructorList: BaseViewController, UICollectionViewDataSource, UICollectionViewDelegate  {
    
    var selection_handler: ((_ campaign_image: NSDictionary) -> Void) = {data in ()}
    let reuseIdentifier = "Cell_InstructorList"
    var instructors: [Any] = []
    var index = 0
    
    var scrollView: UIScrollView!
    
    @IBOutlet weak var collection_view: UICollectionView!
    @IBOutlet weak var view_header: UIView!
    
    override func loadView() {
        super.viewDidLoad()
        
        if self.screenHeight == 480 {
            Bundle.main.loadNibNamed("ViewController_InstructorList", owner: self, options: nil)
        } else if self.screenHeight == 568 {
            Bundle.main.loadNibNamed("ViewController_InstructorList", owner: self, options: nil)
        } else if self.screenHeight == 736 {
            Bundle.main.loadNibNamed("ViewController_InstructorList", owner: self, options: nil)
        } else {
            Bundle.main.loadNibNamed("ViewController_InstructorList", owner: self, options: nil)
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
        return self.instructors.count
    }
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath) as! Cell_InstructorList
        
        print(cell.contentView.subviews)
        
        for object in cell.contentView.subviews {
            print(object)
            object.removeFromSuperview();
        }
        
        let instructor = self.instructors[indexPath.row] as! NSDictionary
        
        let facebook_account = instructor["facebook_account"] as! NSDictionary
        
        let first_name = facebook_account["first_name"] as! String
        let last_name = facebook_account["last_name"] as! String
        
        let main_instrument_friendly = instructor["main_instrument_friendly"] as! String
        let instructor_experience_friendly = instructor["instructor_experience_friendly"] as! String
        
//        cell.title_label.text = "\(first_name) \(last_name.characters.first!). | \(main_instrument_friendly) | \(instructor_experience_friendly) | \(instructor["id"] as! Int)"
        
        let is_open_to_jam = instructor["is_open_to_jam"] as! Bool
        
        if (is_open_to_jam) {
            cell.title_label.text = "\(first_name) \(last_name.characters.first!). | \(main_instrument_friendly) | \(instructor_experience_friendly) | Jam | \(instructor["id"] as! Int)"
        } else {
            cell.title_label.text = "\(first_name) \(last_name.characters.first!). | \(main_instrument_friendly) | \(instructor_experience_friendly) | No Jam | \(instructor["id"] as! Int)"
        }
        
        //cell.title_label.text = "\(student["id"] as! Int)"
        
        cell.handler = { (data: NSDictionary) -> Void in
        }
        
        return cell
    }
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        print("selected: \(indexPath.row)")
        
        let instructor = self.instructors[indexPath.row] as! NSDictionary
        self.get_profile_data(instructor_id: instructor["id"] as! Int)
    }
    
    func get_profile_data(instructor_id: Int) {
        let parameters = NSMutableDictionary()
        
        parameters.setValue(self.app_delegate.me.id, forKey: "user_id") //set all your values..
        parameters.setValue(instructor_id, forKey: "profile_id")
        
        self.app_delegate.show_activity_view_controller(message: "Loading...")
        
        RestAPIClient.sharedInstance.retrieve_instructor_info(parameters: parameters) { response in
            DispatchQueue.main.async(execute: {
                self.app_delegate.remove_activity_view_controller()
                
                let view_controller = ViewController_UserProfile()

                let profile = response["profile"] as! NSDictionary
                view_controller.profile_data = profile
                view_controller.facebook_data = profile["facebook_account"] as! NSDictionary
//                view_controller.lesson_request = self.lesson_request
                
                let lesson_requests = response["lesson_requests"] as! [Any]
                view_controller.lesson_requests = lesson_requests
                
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
