//
//  AddReminderViewController.swift
//  TruePlayer Development
//
//  Created by Vijay Rathore on 25/05/23.
//

import UIKit

class AddReminderViewController : UIViewController {
    let categories = ["Basic Skills", "Ball Mastery","Elite Drill","FootSpeed","Attacking Moves"]
    @IBOutlet weak var backView: UIImageView!
    @IBOutlet weak var selectCategory: UITextField!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var noRemindersAvailable: UIView!
    @IBOutlet weak var chooseDate: UITextField!
    @IBOutlet weak var addBtn: UIButton!
    var videoModels = Array<VideoModel>()
    var checkedPosition = -1
    var calendarModel : CalendarWorkoutModel?
    let selectCategoryPicker = UIPickerView()
    let dateAndTimePicker = UIDatePicker()
    override func viewDidLoad() {
     
        selectCategory.setRightIcons(icon: UIImage(named: "down-arrow")!)
        selectCategory.rightView?.isUserInteractionEnabled = false
        selectCategoryPicker.delegate = self
        selectCategoryPicker.dataSource = self
        
        // ToolBar
        let selectCategoryBar = UIToolbar()
        selectCategoryBar.barStyle = .default
        selectCategoryBar.isTranslucent = true
        selectCategoryBar.tintColor = .link
        selectCategoryBar.sizeToFit()
        
        // Adding Button ToolBar
        let doneButton = UIBarButtonItem(title: "Done", style: .plain, target: self, action: #selector(categoryPickerDoneClicked))
        let spaceButton = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        let cancelButton = UIBarButtonItem(title: "Cancel", style: .plain, target: self, action: #selector(categoryPickerCancelClicked))
        selectCategoryBar.setItems([cancelButton, spaceButton, doneButton], animated: false)
        selectCategoryBar.isUserInteractionEnabled = true
        selectCategory.inputAccessoryView = selectCategoryBar
        selectCategory.inputView = selectCategoryPicker
        
        selectCategory.delegate = self
        chooseDate.delegate = self
        
        addBtn.layer.cornerRadius = 8
        
        tableView.delegate = self
        tableView.dataSource = self
        
        backView.isUserInteractionEnabled = true
        backView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(backViewClicked)))
        
        view.isUserInteractionEnabled = true
        view.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(hideKeyboard)))
        
        createDateAndTimePicker()
    }
    func createDateAndTimePicker() {
        if #available(iOS 13.4, *) {
            dateAndTimePicker.preferredDatePickerStyle = .wheels
        }

        let toolbar = UIToolbar()
        toolbar.sizeToFit()
        
        let done = UIBarButtonItem(barButtonSystemItem: .done, target: nil, action: #selector(dateDoneBtnTapped))
        toolbar.setItems([done], animated: true)
        
        chooseDate.inputAccessoryView = toolbar
        
        dateAndTimePicker.datePickerMode = .date
        chooseDate.inputView = dateAndTimePicker
    }
    @objc func dateDoneBtnTapped() {
        view.endEditing(true)
        let selectedDate = dateAndTimePicker.date
        chooseDate.text = convertDateAndTimeFormater(selectedDate)
    }
    @objc func categoryPickerDoneClicked(){
        selectCategory.resignFirstResponder()
        let row = selectCategoryPicker.selectedRow(inComponent: 0)
        selectCategory.text = categories[row]
        var catId = ""
        switch row {
        case 0 : catId = Constants.Category.basic_skills
            self.loadVideo(catId: catId)
            return
        case 1 : catId = Constants.Category.ball_mastery
            self.loadVideo(catId: catId)
            return
        case 2 : catId = Constants.Category.elite_drill
            self.loadVideo(catId: catId)
            return
        case 3 : catId = Constants.Category.foot_speed
            self.loadVideo(catId: catId)
            return
        case 4 : catId = Constants.Category.attacking_moves
            self.loadVideo(catId: catId)
            return
        default:
            catId = ""
        }
        
    }
    
    func loadVideo(catId : String){
        ProgressHUDShow(text: "")
        getVideosForCategory(categoryCode: catId) { videoModels, error in
            self.ProgressHUDHide()
            if let error = error {
                self.showError(error.localizedLowercase)
            }
            else {
                self.videoModels.removeAll()
                self.videoModels.append(contentsOf: videoModels ?? [])
                self.tableView.reloadData()
            }
        }
    }
    
    @objc func categoryPickerCancelClicked(){
        self.view.endEditing(true)
    }
    
    @objc func hideKeyboard(){
        self.view.endEditing(true)
    }
    
    @objc func backViewClicked(){
        self.dismiss(animated: true)
    }
    
    @IBAction func addBtnClicked(_ sender: Any) {
        let sDateAndTime = chooseDate.text
        if calendarModel == nil {
            self.showSnack(messages: "Select Video")
        }
        else if sDateAndTime ==  "" {
            self.showSnack(messages: "Choose Date")
        }
        else {
            ProgressHUDShow(text: "")
            calendarModel?.reminderDate = dateAndTimePicker.date
            try? FirebaseStoreManager.db.collection("Users").document(UserModel.data!.uid ?? "123")
                .collection("Reminders").document(calendarModel!.videoId ?? "123")
                .setData(from: calendarModel, merge : true) { error in
                    self.ProgressHUDHide()
                    if let error = error {
                        self.showError(error.localizedDescription)
                    }
                    else {
                        let seconds = 2.5
                        self.showSnack(messages: "Reminder Added")
                        DispatchQueue.main.asyncAfter(deadline: .now() + seconds) {
                            self.dismiss(animated: true)
                        }
                    }
                }
        }
    }
    
    @objc func checkBoxClicked(gest : MyGesture){
        
        gest.reminderCell.completedCheck.isSelected = !gest.reminderCell.completedCheck.isSelected
        
        if (gest.reminderCell.completedCheck.isSelected) {
            
            checkedPosition = gest.index
            addCalendarModel(videoId: gest.id)
            tableView.reloadData()
        }
        else {
            checkedPosition = -1;
            removeCalendarModel();
        }
    }
    
    func addCalendarModel(videoId : String){
        calendarModel = CalendarWorkoutModel()
        calendarModel!.completed = false
        calendarModel?.videoId = videoId
    }
    
    func removeCalendarModel(){
        calendarModel = nil
    }
}

extension AddReminderViewController : UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        noRemindersAvailable.isHidden = videoModels.count > 0 ? true : false
        return videoModels.count
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if let cell = tableView.dequeueReusableCell(withIdentifier: "reminderCell", for: indexPath) as? ReminderTableViewCell {
            
            cell.mView.layer.cornerRadius = 8
            cell.mImage.clipsToBounds = true
            cell.mImage.layer.cornerRadius = 8
            cell.mImage.layer.maskedCorners = [.layerMinXMinYCorner, .layerMinXMaxYCorner]
            let videoModel = videoModels[indexPath.row]
            if let imagePath = videoModel.thumbnail, !imagePath.isEmpty {
                cell.mImage.sd_setImage(with: URL(string: imagePath), placeholderImage: UIImage(named: "placeholder"))
            }
            cell.mTitle.text = videoModel.title ?? ""
            
            cell.mCategory.text = Constants.Category.getCategoryName(by: videoModel.categoryId ?? "")
            cell.mTimeView.addBorderColourAndRadius()
            cell.mTimeView.setTitle(self.convertSecondsToMinAndSec(totalSec: videoModel.videoLength ?? 0), for: .normal)
            
            cell.completedCheck.isSelected = (self.checkedPosition == indexPath.row)
            
          
            cell.completedCheck.isUserInteractionEnabled = true
            let myGest = MyGesture(target: self, action: #selector(checkBoxClicked))
            myGest.reminderCell = cell
            myGest.index = indexPath.row
            myGest.id = videoModel.id ?? "123"
            cell.completedCheck.addGestureRecognizer(myGest)
            return cell
        }
        return ReminderTableViewCell()
    }

}

extension AddReminderViewController  : UITextFieldDelegate {
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        self.hideKeyboard()
        return true
    }
    
}
extension AddReminderViewController : UIPickerViewDelegate, UIPickerViewDataSource {

    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }

    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return categories.count

    }

    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {

        
        return categories[row]
        

    }

}
