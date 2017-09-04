//
//  ViewController_MessageList.swift
//  bridge
//
//  Created by Konstantin Yurchenko on 11/29/16.
//  Copyright © 2016 Konstantin Yurchenko. All rights reserved.
//

import Foundation

import UIKit
import SDWebImage

class ViewController_MessageList: BaseViewController, UICollectionViewDataSource, UICollectionViewDelegate  {
    
    var selection_handler: ((_ campaign_image: NSDictionary) -> Void) = {data in ()}
    let reuseIdentifier = "Cell_MessageList"
    var users: [Any] = []
    var index = 0
    
    var scrollView: UIScrollView!
    
    @IBOutlet weak var collection_view: UICollectionView!
    @IBOutlet weak var view_header: UIView!
    
    override func loadView() {
        super.viewDidLoad()
        
        if self.screenHeight == 480 {
            Bundle.main.loadNibNamed("ViewController_MessageList", owner: self, options: nil)
        } else if self.screenHeight == 568 {
            Bundle.main.loadNibNamed("ViewController_MessageList", owner: self, options: nil)
        } else if self.screenHeight == 736 {
            Bundle.main.loadNibNamed("ViewController_MessageList", owner: self, options: nil)
        } else {
            Bundle.main.loadNibNamed("ViewController_MessageList", owner: self, options: nil)
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
        return self.users.count
    }
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath) as! Cell_MessageList
        
        print(cell.contentView.subviews)
        
        for object in cell.contentView.subviews {
            print(object)
            object.removeFromSuperview();
        }
        
        let user = self.users[indexPath.row] as! NSDictionary
        
//        cell.title_label.text = "\(user["id"] as! Int)"
        cell.title_label.text = "\(user["first_name"] as! String) \(user["last_name"] as! String)"
        
        cell.handler = { (data: NSDictionary) -> Void in
        }
        
        return cell
    }
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        print("selected: \(indexPath.row)")
        
        let user = self.users[indexPath.row] as! NSDictionary
        self.message_user(user: user)
    }
    
    func get_message_stream(recipient_id: Int) {
        let parameters = NSMutableDictionary()
        
        parameters.setValue(self.app_delegate.me.id, forKey: "user_id") //set all your values..
        parameters.setValue(recipient_id, forKey: "recipient_id")
        
        self.app_delegate.show_activity_view_controller(message: "Loading...")
        
        RestAPIClient.sharedInstance.get_student_profile(parameters: parameters) { response in
            DispatchQueue.main.async(execute: {
                self.app_delegate.remove_activity_view_controller()
                
                let view_controller = ViewController_UserProfile()
                view_controller.profile_data = response
                
                if let topViewController = UIApplication.topViewController() {
                    topViewController.navigationController?.pushViewController(
                        view_controller,
                        animated: false
                    )
                }
            })
        }
    }
    
    func message_user(user: NSDictionary) {
        let parameters = NSMutableDictionary()
        
        parameters.setValue(self.app_delegate.me.id, forKey: "user_id") //set all your values..
        parameters.setValue(user["id"] as! Int, forKey: "sender_id")
        
        self.app_delegate.show_activity_view_controller(message: "Loading...")
        
        RestAPIClient.sharedInstance.get_messages(parameters: parameters) { response in
            print(response)
            
            DispatchQueue.main.async(execute: {
                self.app_delegate.remove_activity_view_controller()
                
                let view_controller = ViewController_MessageUser()
                view_controller.messages = response["messages"] as! [Any]
                
                view_controller.receiver_id = user["id"] as! Int
                
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
