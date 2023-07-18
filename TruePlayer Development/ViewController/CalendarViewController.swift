//
//  CalendarViewController.swift
//  TruePlayer Development
//
//  Created by Vijay Rathore on 25/05/23.
//

import UIKit

class CalendarViewController : UIViewController {
    
    @IBOutlet weak var addReminderBtn: UIButton!
    @IBOutlet weak var calendarBack: UIView!
    @IBOutlet weak var calendar: UIDatePicker!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var tableViewHeight: NSLayoutConstraint!
    @IBOutlet weak var noRemindersAvailable: UIView!
    var calendarWorkoutModels = Array<CalendarWorkoutModel>()
    override func viewDidLoad() {
        addReminderBtn.addBorderColourAndRadius()
        calendarBack.layer.cornerRadius = 8
        tableView.dataSource = self
        tableView.delegate = self
    
        calendar.date = Date()
        calendar.locale = .current
        calendar.addTarget(self, action: #selector(calendarDateSelected), for: .valueChanged)
        calendarDateSelected()
    }
    
    @objc func calendarDateSelected(){
        let startDate = Calendar.current.date(bySettingHour: 0, minute: 0, second: 0, of: calendar.date)!
        let endDate = Calendar.current.date(bySettingHour: 23, minute: 59, second: 59, of: calendar.date)!
        

        ProgressHUDShow(text: "")
        FirebaseStoreManager.db.collection("Users").document(UserModel.data!.uid ?? "123").collection("Reminders").order(by: "reminderDate").whereField("reminderDate", isGreaterThan: startDate).whereField("reminderDate", isLessThan : endDate).addSnapshotListener { snapshot, error in
            if error == nil {
        
                self.ProgressHUDHide()
                self.calendarWorkoutModels.removeAll()
                if let snapshot = snapshot,!snapshot.isEmpty {
                    for qdr in snapshot.documents {
                      
                        if let calendarModel = try? qdr.data(as: CalendarWorkoutModel.self) {
                           
                            self.calendarWorkoutModels.append(calendarModel)
                        }
                    }
                }
                
                self.tableView.reloadData()
            }
            
            
        }
    }
    
    @IBAction func addReminderClicked(_ sender: Any) {
        performSegue(withIdentifier: "addReminderSeg", sender: nil)
    }
    
    @objc func checkBoxClicked(gest : MyGesture) {
        gest.calendarCell.completedCheck.isSelected = !gest.calendarCell.completedCheck.isSelected
        let calendarModel = calendarWorkoutModels[gest.index]
        if gest.calendarCell.completedCheck.isSelected {
          
            calendarModel.completed = true
            try? FirebaseStoreManager.db.collection("Users").document(UserModel.data!.uid ?? "123").collection("Reminders").document(gest.id).setData(from: calendarModel, merge : true)
        }
        else {
        
            calendarModel.completed = false
            try? FirebaseStoreManager.db.collection("Users").document(UserModel.data!.uid ?? "123").collection("Reminders").document(gest.id).setData(from: calendarModel, merge : true)
        }
    }
    
    @objc func trashBtnClicked(gest : MyGesture){
        self.ProgressHUDShow(text: "Deleting...")
        FirebaseStoreManager.db.collection("Users").document(UserModel.data!.uid ?? "123").collection("Reminders").document(gest.id).delete { error in
            self.ProgressHUDHide()
            if let error = error {
                self.showError(error.localizedDescription)
            }
            else {
                self.showSnack(messages: "Deleted")
            }
        };
    }
}

extension CalendarViewController : UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        noRemindersAvailable.isHidden = calendarWorkoutModels.count > 0 ? true : false
        return calendarWorkoutModels.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let cell = tableView.dequeueReusableCell(withIdentifier: "calendarCell", for: indexPath) as? CalendarTableViewCell {
            
            let calendarModel = calendarWorkoutModels[indexPath.row]
            cell.mView.layer.cornerRadius = 8
            cell.mProfile.clipsToBounds = true
            cell.mProfile.layer.cornerRadius = 8
            cell.mProfile.layer.maskedCorners = [.layerMinXMinYCorner, .layerMinXMaxYCorner]
        
            if let isCompleted = calendarModel.completed, isCompleted {
                cell.completedCheck.isSelected = true
            }
            else {
                cell.completedCheck.isSelected = false
            }
            
            let deleteGest = MyGesture(target: self, action: #selector(trashBtnClicked(gest:)))
            deleteGest.id = calendarModel.videoId ?? "123"
            cell.mDelete.isUserInteractionEnabled = true
            cell.mDelete.addGestureRecognizer(deleteGest)
       
            let checkGest = MyGesture(target: self, action: #selector(checkBoxClicked(gest:)))
            checkGest.id = calendarModel.videoId ?? "123"
            checkGest.calendarCell = cell
            checkGest.index = indexPath.row
            cell.completedCheck.isUserInteractionEnabled = true
            cell.completedCheck.addGestureRecognizer(checkGest)
            
            cell.reminderAtBtn.setTitle("Reminder at \(self.convertDateIntoTime(calendarModel.reminderDate ?? Date()))", for: .normal)
            self.getVideo(By: calendarModel.videoId ?? "123") { videoModel, error in
                if error != nil {
                    FirebaseStoreManager.db.collection("Users").document(UserModel.data!.uid ?? "123").collection("Reminders").document(calendarModel.videoId ?? "123").delete();
                }
                else {
                    if let videoModel = videoModel {
                        cell.mTitle.text = videoModel.title ?? ""
                        cell.mCategory.text = Constants.Category.getCategoryName(by: videoModel.categoryId ?? "")
                        if let imagePath = videoModel.thumbnail, !imagePath.isEmpty {
                            cell.mProfile.sd_setImage(with: URL(string: imagePath), placeholderImage: UIImage(named: "placeholder"))
                        }
                    }
                }
            }
          
            
            return cell
        }
        return CalendarTableViewCell()
    }
    
    
    
    
}
