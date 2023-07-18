//
//  CalendarTableViewCell.swift
//  TruePlayer Development
//
//  Created by Vijay Rathore on 25/05/23.
//

import UIKit

class CalendarTableViewCell : UITableViewCell {
    
    @IBOutlet weak var mView: UIView!
    
    @IBOutlet weak var mProfile: UIImageView!

    @IBOutlet weak var mTitle: UILabel!
    
    @IBOutlet weak var mCategory: UILabel!
  
    @IBOutlet weak var reminderAtBtn: UIButton!
    
    @IBOutlet weak var completedCheck: UIButton!
    
    @IBOutlet weak var mDelete: UIImageView!
    
    
    override class func awakeFromNib() {
        
    }
    
}
