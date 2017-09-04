//
//  ActivityViewController.swift
//  switcharoo
//
//  Created by Konstantin Yurchenko on 12/10/15.
//  Copyright © 2015 Play Entertainment LLC. All rights reserved.
//

import UIKit

class ViewController_Activity: BaseViewController {
    
    @IBOutlet weak var spinner: UIActivityIndicatorView!
    
    @IBOutlet weak var message_label: UILabel!
    
    var parent_view_controller: UIViewController!
    
    override func loadView() {
        super.viewDidLoad()
        
        if self.screenHeight == 480 {
            Bundle.main.loadNibNamed("ViewController_Activity", owner: self, options: nil)
        } else if self.screenHeight == 568 {
            Bundle.main.loadNibNamed("ViewController_Activity", owner: self, options: nil)
        } else if self.screenHeight == 736 {
            Bundle.main.loadNibNamed("ViewController_Activity", owner: self, options: nil)
        } else {
            Bundle.main.loadNibNamed("ViewController_Activity", owner: self, options: nil)
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.backgroundColor = PANTONE_greenery
        // Do any additional setup after loading the view, typically from a nib.
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}
