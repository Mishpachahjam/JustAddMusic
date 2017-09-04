//
//  Cell_StudentList.swift
//  hypewizard
//
//  Created by Konstantin Yurchenko on 9/28/16.
//  Copyright © 2016 Disruptive Widgets. All rights reserved.
//

import UIKit

class Cell_LessonList: UICollectionViewCell {
    
    var lesson_id = 0
    var handler: ((_ data: NSDictionary) -> Void) = {data in ()}
    
    @IBOutlet weak var title_label: UILabel!
    
    override func prepareForReuse() {
        super.prepareForReuse()
    }
}
