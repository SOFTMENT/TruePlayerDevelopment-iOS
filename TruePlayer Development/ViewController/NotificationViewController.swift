//
//  NotificationViewController.swift
//  TruePlayer Development
//
//  Created by Vijay Rathore on 24/05/23.
//

import UIKit
import Firebase
import FirebaseFirestoreSwift

class NotificationViewController : UIViewController {

    @IBOutlet weak var backView: UIImageView!
    @IBOutlet weak var noNotificationsAvailable: UILabel!
    @IBOutlet weak var tableView: UITableView!
    
    var notifications : [NotificationModel] = []
    override func viewDidLoad() {
        
        tableView.estimatedRowHeight = 44
        tableView.rowHeight = UITableView.automaticDimension
        
        tableView.delegate = self
        tableView.dataSource = self
        
        backView.isUserInteractionEnabled = true
        backView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(backViewClicked)))
        
        getAllNotifications()
    }
    
 
    @objc func backViewClicked() {
        self.dismiss(animated: true, completion: nil)
    }
    
    public func getAllNotifications(){
        ProgressHUDShow(text: "")
        Firestore.firestore().collection("Notifications").order(by: "notificationTime",descending: true).getDocuments { snapshot, error in
            self.ProgressHUDHide()
            if error == nil {
                self.notifications.removeAll()
                if let snap = snapshot, !snap.isEmpty {
                    for qdr in  snap.documents{
                        if let notification = try? qdr.data(as: NotificationModel.self) {
                            self.notifications.append(notification)
                        }
                    }
                   
                }
                self.tableView.reloadData()
            }
            else {
                self.showError(error!.localizedDescription)
            }
        }
    }
}


extension NotificationViewController : UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if notifications.count > 0 {
            noNotificationsAvailable.isHidden = true
        }
        else {
            noNotificationsAvailable.isHidden = false
        }
    
        return notifications.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let cell = tableView.dequeueReusableCell(withIdentifier: "notificationscell", for: indexPath) as? NotificationTableViewCell {
            
         
            cell.mView.addBorderColourAndRadius()
            
            let notification = notifications[indexPath.row]
            cell.mTitle.text = notification.title ?? ""
            cell.mMessage.text = notification.message ?? ""
            cell.mHour.text = (notification.notificationTime ?? Date()).timeAgoSinceDate()
            
            return cell
        }
        return NotificationTableViewCell()
    }
    
    
}
