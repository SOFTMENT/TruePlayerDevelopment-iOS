//
//  TrainingPlanViewController.swift
//  TruePlayer Development
//
//  Created by Vijay Rathore on 26/05/23.
//

import UIKit

class TrainingPlanViewController : UIViewController {
    @IBOutlet weak var createPlan: UIButton!
    
    @IBOutlet weak var topImage: UIImageView!
    
    @IBOutlet weak var startFromTime: UILabel!
    @IBOutlet weak var weeklyHours: UILabel!
    @IBOutlet weak var noWeeklyPlanAvailable: UIView!
    
    @IBOutlet weak var basicSkillsView: UIView!
    @IBOutlet weak var basicSkillsVideoCount: UILabel!
    @IBOutlet weak var basicSkillsHoursCount: UILabel!
    
    @IBOutlet weak var ballMasteryView: UIView!
    @IBOutlet weak var ballMasteryVideoCount: UILabel!
    @IBOutlet weak var ballMasteryHoursCount: UILabel!
    
    @IBOutlet weak var eliteDrillView: UIView!
    @IBOutlet weak var eliteDrillVideoCount: UILabel!
    @IBOutlet weak var eliteDrillHoursCount: UILabel!
    
    @IBOutlet weak var footSpeedView: UIView!
    @IBOutlet weak var footSpeedVideosCount: UILabel!
    @IBOutlet weak var footSppedHoursCount: UILabel!
    
    @IBOutlet weak var attackingMovesView: UIView!
    @IBOutlet weak var attackingMovesVideosCount: UILabel!
    @IBOutlet weak var attackingMovesHoursCount: UILabel!
    @IBOutlet weak var mView: UIView!
    
    
    
    override func viewDidLoad() {
        topImage.addBorderColourAndRadius()
        createPlan.addBorderColourAndRadius()
        
        basicSkillsView.addBorderColourAndRadius()
        ballMasteryView.addBorderColourAndRadius()
        eliteDrillView.addBorderColourAndRadius()
        footSpeedView.addBorderColourAndRadius()
        attackingMovesView.addBorderColourAndRadius()
        
        
        getCategoriesCount(categoryName: Constants.Category.basic_skills) { count in
            self.basicSkillsVideoCount.text = "\(count) Videos"
        }
        
        getCategoriesCount(categoryName: Constants.Category.ball_mastery) { count in
            self.ballMasteryVideoCount.text = "\(count) Videos"
        }
        
        getCategoriesCount(categoryName: Constants.Category.elite_drill) { count in
            self.eliteDrillVideoCount.text = "\(count) Videos"
        }
        
        getCategoriesCount(categoryName: Constants.Category.foot_speed) { count in
            self.footSpeedVideosCount.text = "\(count) Videos"
        }
        
        getCategoriesCount(categoryName: Constants.Category.attacking_moves) { count in
            self.attackingMovesVideosCount.text = "\(count) Videos"
        }
        
        self.ProgressHUDShow(text: "")
        FirebaseStoreManager.db.collection("Users").document(UserModel.data!.uid ?? "123").collection("WeeklyPlan").document(UserModel.data!.uid ?? "123").addSnapshotListener { snapshot, error in
            self.ProgressHUDHide()
            if let error = error {
                self.showError(error.localizedDescription)
                self.mView.isHidden = true
                self.noWeeklyPlanAvailable.isHidden = false
            }
            else {
                if let snapshot = snapshot, snapshot.exists {
                    if let weeklyPlanModel = try? snapshot.data(as: WeeklyPlanModel.self) {
                        
                        self.mView.isHidden = false
                        self.noWeeklyPlanAvailable.isHidden = true
                        
                        self.startFromTime.text = self.convertDatetoString(weeklyPlanModel.addedDate ?? Date())
                        self.weeklyHours.text = "\(weeklyPlanModel.weeklyHours ?? 0) Hours"
                     
                        self.basicSkillsHoursCount.text =  "\(weeklyPlanModel.basicHours ?? 0) Hours"
                        self.ballMasteryHoursCount.text =  "\(weeklyPlanModel.ballMasteryHours ?? 0) Hours"
                        self.footSppedHoursCount.text =  "\(weeklyPlanModel.footSpeed ?? 0) Hours"
                        self.eliteDrillHoursCount.text =  "\(weeklyPlanModel.eliteDrillHours ?? 0) Hours"
                        self.attackingMovesHoursCount.text =  "\(weeklyPlanModel.attackingHours ?? 0) Hours"
                    }
                }
            }
        }
        
    }
    
    @IBAction func createPlanClicked(_ sender: Any) {
        performSegue(withIdentifier: "createPlanSeg", sender: nil)
    }
}
