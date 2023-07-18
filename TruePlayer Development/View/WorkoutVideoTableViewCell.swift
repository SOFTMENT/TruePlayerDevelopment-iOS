//
//  WorkoutVideoTableViewCell.swift
//  TruePlayer Development
//
//  Created by Vijay Rathore on 24/05/23.
//

import UIKit

class WorkoutVideoTableViewCell : UITableViewCell {
    
    @IBOutlet weak var mView: UIView!
    
    @IBOutlet weak var mImage: UIImageView!
    @IBOutlet weak var mTitle: UILabel!
 
    @IBOutlet weak var mTime: UILabel!
    
    override class func awakeFromNib() {
        
    }
    
}
