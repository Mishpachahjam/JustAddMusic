//
//  ViewController.swift
//  bridge
//
//  Created by Konstantin Yurchenko on 11/7/16.
//  Copyright © 2016 Konstantin Yurchenko. All rights reserved.
//

import UIKit


class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        self.authenticate_user()

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
        
    }
    
    func authenticate_user() {
        print("authenticate_user")
        
        let parameters = NSMutableDictionary()
        parameters.setValue("example@mail.com", forKey: "email") //set all your values..
        parameters.setValue("123123123", forKey: "password")
        
        RestAPIClient.sharedInstance.authenticate(parameters: parameters) { response in
            print(response["auth_token"] as! String)
//            if let error_code = response["error_code"] {
//                if error_code as! Int == 0 {
//                    DispatchQueue.main.async(execute: {
////                        self.app_delegate.remove_activity_view_controller()
////                        self.show_success_alert()
////                        self.close()
//                    })
//                } else {
////                    print ("error")
////                    self.show_failure_alert(message: "Can't add campaign")
//                }
//            }
        }
    }
}

