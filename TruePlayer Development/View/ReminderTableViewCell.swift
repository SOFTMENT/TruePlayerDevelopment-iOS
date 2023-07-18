//
//  ReminderTableViewCell.swift
//  TruePlayer Development
//
//  Created by Vijay Rathore on 25/05/23.
//

import UIKit

class ReminderTableViewCell : UITableViewCell {
    
    @IBOutlet weak var mView: UIView!
    @IBOutlet weak var mImage: UIImageView!
    
    @IBOutlet weak var mTitle: UILabel!
    @IBOutlet weak var mCategory: UILabel!
    
    @IBOutlet weak var completedCheck: UIButton!
    @IBOutlet weak var mTimeView: UIButton!
    
    override class func awakeFromNib() {
        
    }
    
}
