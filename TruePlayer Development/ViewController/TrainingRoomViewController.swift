//
//  TrainingRoomViewController.swift
//  TruePlayer Development
//
//  Created by Vijay Rathore on 25/05/23.
//

import UIKit
import RevenueCat

class TrainingRoomViewController : UIViewController {
    
    @IBOutlet weak var topImage: UIImageView!
    
    @IBOutlet weak var logoView: UIView!
    
    @IBOutlet weak var basicSkillsView: UIView!
    
    @IBOutlet weak var ballMasteryView: UIView!
    
    @IBOutlet weak var eliteDrillView: UIView!
    
    @IBOutlet weak var footSpeedView: UIView!
    
    @IBOutlet weak var attackingMovesView: UIView!
    
    @IBOutlet weak var basicSkillsCount: UILabel!
    
    @IBOutlet weak var ballMasteryCount: UILabel!
    
    @IBOutlet weak var eliteDrillCount: UILabel!
    
    @IBOutlet weak var footSpeedCount: UILabel!
    
    @IBOutlet weak var attackingMovesCount: UILabel!
    
    override func viewDidLoad() {
        topImage.layer.cornerRadius = 8
        logoView.layer.cornerRadius = 8
        
        basicSkillsView.addBorderColourAndRadius()
        basicSkillsView.isUserInteractionEnabled = true
        basicSkillsView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(basicSkillsClicked)))
        
        ballMasteryView.addBorderColourAndRadius()
        ballMasteryView.isUserInteractionEnabled = true
        ballMasteryView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(ballMasteryClicked)))
        
        eliteDrillView.addBorderColourAndRadius()
        eliteDrillView.isUserInteractionEnabled = true
        eliteDrillView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(eliteDrillClicked)))
        
        footSpeedView.addBorderColourAndRadius()
        footSpeedView.isUserInteractionEnabled = true
        footSpeedView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(footSpeedClicked)))
        
        attackingMovesView.addBorderColourAndRadius()
        attackingMovesView.isUserInteractionEnabled = true
        attackingMovesView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(attackingMovesClicked)))
        
        
        getCategoriesCount(categoryName: Constants.Category.attacking_moves) { count in
            self.attackingMovesCount.text = "\(count) Videos"
        }
        getCategoriesCount(categoryName: Constants.Category.ball_mastery) { count in
            self.ballMasteryCount.text = "\(count) Videos"
        }
        getCategoriesCount(categoryName: Constants.Category.basic_skills) { count in
            self.basicSkillsCount.text = "\(count) Videos"
        }
        getCategoriesCount(categoryName: Constants.Category.foot_speed) { count in
            self.footSpeedCount.text = "\(count) Videos"
        }
        getCategoriesCount(categoryName: Constants.Category.elite_drill) { count in
            self.eliteDrillCount.text = "\(count) Videos"
        }
    }
    
    
    
    func gotoTrainingVideoPage(catId : String){
        
               Purchases.shared.getCustomerInfo { (customerInfo, error) in
                   if customerInfo?.entitlements.all["Premium"]?.isActive == true {
                       self.performSegue(withIdentifier: "trainingRoomSeg", sender: catId)
                   }
                   else {
                       self.performSegue(withIdentifier: "trainingRoomMembershipSeg", sender: nil)
                   }
               }
        
    }
    
    @objc func attackingMovesClicked(){
        gotoTrainingVideoPage(catId: Constants.Category.attacking_moves)
    }
    
    @objc func footSpeedClicked(){
        gotoTrainingVideoPage(catId: Constants.Category.foot_speed)
    }
    
    @objc func eliteDrillClicked(){
        gotoTrainingVideoPage(catId: Constants.Category.elite_drill)
    }
    
    @objc func ballMasteryClicked(){
        gotoTrainingVideoPage(catId: Constants.Category.ball_mastery)
    }
    
    @objc func basicSkillsClicked(){
        gotoTrainingVideoPage(catId: Constants.Category.basic_skills)
    }
        
        
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "trainingRoomSeg" {
            if let VC = segue.destination as? TrainingRoomVideosViewController {
                if let catId = sender as? String {
                    VC.catId = catId
                }
            }
        }
    }
}
