//
//  CreatePlanViewController.swift
//  TruePlayer Development
//
//  Created by Vijay Rathore on 26/05/23.
//

import UIKit

class CreatePlanViewController : UIViewController {
    
    
    @IBOutlet weak var backView: UIImageView!
    @IBOutlet weak var howManyHours: UITextField!
    
    @IBOutlet weak var availableHoursView: UIView!
    @IBOutlet weak var basicSkillsView: UIView!
    @IBOutlet weak var ballMasteryView: UIView!
    @IBOutlet weak var eliteDrillView: UIView!
    @IBOutlet weak var footSpeedView: UIView!
    @IBOutlet weak var attackingMovesView: UIView!
    
    
    @IBOutlet weak var availableHoursCount: UILabel!
    
    @IBOutlet weak var basicSkillsCount: UILabel!
    @IBOutlet weak var basicSkillsTF: UITextField!
    
    @IBOutlet weak var ballMasteryCount: UILabel!
    @IBOutlet weak var ballMasteryTF: UITextField!
    
    @IBOutlet weak var eliteDrillCount: UILabel!
    @IBOutlet weak var eliteDrillTF: UITextField!
    
    @IBOutlet weak var footSpeedCount: UILabel!
    @IBOutlet weak var footSpeedTF: UITextField!
    
    @IBOutlet weak var attackingMovesCount: UILabel!
    @IBOutlet weak var attackingMovesTF: UITextField!
    
    var availableHours = 0
    @IBOutlet weak var createPlanBtn: UIButton!
    
    
    override func viewDidLoad() {
        backView.isUserInteractionEnabled = true
        backView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(backViewClicked)))
        
        howManyHours.delegate = self
        basicSkillsTF.delegate = self
        ballMasteryTF.delegate = self
        eliteDrillTF.delegate = self
        footSpeedTF.delegate = self
        attackingMovesTF.delegate = self
        
        availableHoursView.addBorderColourAndRadius()
        basicSkillsView.addBorderColourAndRadius()
        ballMasteryView.addBorderColourAndRadius()
        eliteDrillView.addBorderColourAndRadius()
        footSpeedView.addBorderColourAndRadius()
        attackingMovesView.addBorderColourAndRadius()
        
        createPlanBtn.layer.cornerRadius = 8
        
        getCategoriesCount(categoryName: Constants.Category.basic_skills) { count in
            self.basicSkillsCount.text = "\(count) Videos"
        }
        
        getCategoriesCount(categoryName: Constants.Category.ball_mastery) { count in
            self.ballMasteryCount.text = "\(count) Videos"
        }
        
        getCategoriesCount(categoryName: Constants.Category.elite_drill) { count in
            self.eliteDrillCount.text = "\(count) Videos"
        }
        
        getCategoriesCount(categoryName: Constants.Category.foot_speed) { count in
            self.footSpeedCount.text = "\(count) Videos"
        }
        
        getCategoriesCount(categoryName: Constants.Category.attacking_moves) { count in
            self.attackingMovesCount.text = "\(count) Videos"
        }
        
        view.isUserInteractionEnabled = true
        view.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(hideKeyboard)))
        
        howManyHours.addTarget(self, action: #selector(howManyHoursFieldDidChange(_:)), for: .editingChanged)
        
        basicSkillsTF.addTarget(self, action: #selector(textFieldDidChange(_:)), for: .editingChanged)
        ballMasteryTF.addTarget(self, action: #selector(textFieldDidChange(_:)), for: .editingChanged)
        eliteDrillTF.addTarget(self, action: #selector(textFieldDidChange(_:)), for: .editingChanged)
        footSpeedTF.addTarget(self, action: #selector(textFieldDidChange(_:)), for: .editingChanged)
        attackingMovesTF.addTarget(self, action: #selector(textFieldDidChange(_:)), for: .editingChanged)
    }
   
    @objc func howManyHoursFieldDidChange(_ textField: UITextField) {
        if howManyHours.text!.count > 0 {
            availableHoursCount.text = "\(Int(howManyHours.text!)!) Hours"
        }
        else {
            availableHoursCount.text = "0 Hour"
        }
    }
    
    @objc func textFieldDidChange(_ textField: UITextField) {
        
        let sWeeklyHours =  howManyHours.text
        let sBasicSkills = basicSkillsTF.text
        let sBallMastery = ballMasteryTF.text
        let sEliteDrill =  eliteDrillTF.text
        let sFootSpeed = footSpeedTF.text
        let sAttackingMoves = attackingMovesTF.text

        var iBasicSkills = 0
        var iBallMastery = 0
        var iEliteDrill = 0
        var iFootSpeed = 0
        var iAttackingMoves = 0
        var iWeeklyHours = 0


        if (sBasicSkills != "") {
            iBasicSkills = Int(sBasicSkills!)!
        }
        if (sBallMastery != "") {
            iBallMastery = Int(sBallMastery!)!
        }
        if (sFootSpeed != "") {
            iFootSpeed = Int(sFootSpeed!)!
        }
        if (sEliteDrill != "") {
            iEliteDrill = Int(sEliteDrill!)!
        }
        if (sAttackingMoves != "") {
            iAttackingMoves = Int(sAttackingMoves!)!
        }
        if (sWeeklyHours != "") {
            iWeeklyHours = Int(sWeeklyHours!)!
        }

        if (iWeeklyHours >= (iBasicSkills + iBallMastery + iEliteDrill + iAttackingMoves + iFootSpeed)) {

            self.availableHours = iWeeklyHours - (iBasicSkills + iBallMastery + iEliteDrill + iAttackingMoves + iFootSpeed)
            availableHoursCount.text = "\(self.availableHours) Hours"
        }
        else {
            if (ballMasteryTF == textField) {
                ballMasteryTF.text = "0"
            }
            else if (basicSkillsTF == textField) {
                basicSkillsTF.text = "0"
            }
            else if (eliteDrillTF == textField) {
                eliteDrillTF.text = "0"
            }
            else if (footSpeedTF == textField) {
                footSpeedTF.text = "0"
            }
            else if (attackingMovesTF == textField) {
                attackingMovesTF.text = "0"
            }
            self.showSnack(messages: "Please increase weekly hours")
        }
    }
    
    
    @objc func backViewClicked(){
        self.dismiss(animated: true)
    }

    @IBAction func createPlanClicked(_ sender: Any) {
        
        let sWeeklyHours = howManyHours.text
        let sBasicSkills = basicSkillsTF.text
        let sBallMastery = ballMasteryTF.text
        let sEliteDrill = eliteDrillTF.text
        let sFootSpeed = footSpeedTF.text
        let sAttackingMoves = attackingMovesTF.text
    
        var iBasicSkills = 0
        var iBallMastery = 0
        var iEliteDrill = 0
        var iFootSpeed = 0
        var iAttackingMoves = 0
        var iWeeklyHours = 0


        if (sBasicSkills != "") {
            iBasicSkills = Int(sBasicSkills!)!
        }
        if (sBallMastery != "") {
            iBallMastery = Int(sBallMastery!)!
        }
        if (sFootSpeed != "") {
            iFootSpeed = Int(sFootSpeed!)!
        }
        if (sEliteDrill != "") {
            iEliteDrill = Int(sEliteDrill!)!
        }
        if (sAttackingMoves != "") {
            iAttackingMoves = Int(sAttackingMoves!)!
        }
        if (sWeeklyHours != "") {
            iWeeklyHours = Int(sWeeklyHours!)!
        }
        
        self.ProgressHUDShow(text: "")
        let weeklyPlanModel = WeeklyPlanModel()
        weeklyPlanModel.addedDate = Date()
        weeklyPlanModel.ballMasteryHours = iBallMastery
        weeklyPlanModel.basicHours = iBasicSkills
        weeklyPlanModel.eliteDrillHours = iEliteDrill
        weeklyPlanModel.footSpeed = iFootSpeed
        weeklyPlanModel.attackingHours = iAttackingMoves
        weeklyPlanModel.weeklyHours = iWeeklyHours
        
        try? FirebaseStoreManager.db.collection("Users").document(UserModel.data!.uid ?? "123")
            .collection("WeeklyPlan").document(UserModel.data!.uid ?? "123").setData(from: weeklyPlanModel) { error in
                self.ProgressHUDHide()
                if let error = error {
                    self.showError(error.localizedDescription)
                }
                else {
                    self.showSnack(messages: "Updated")
                }
            }

    }
    
    @objc func hideKeyboard(){
        self.view.endEditing(true)
    }
    
}

extension CreatePlanViewController : UITextFieldDelegate {
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        self.view.endEditing(true)
        return true
    }
    
}
