//
//  HomeViewController.swift
//  TruePlayer Development
//
//  Created by Vijay Rathore on 22/05/23.
//

import UIKit
import SDWebImage
import AVFoundation
import AVKit
import RevenueCat

class HomeViewController : UIViewController {
    
    @IBOutlet weak var notificationView: UIView!
    @IBOutlet weak var profilePic: UIImageView!
    @IBOutlet weak var mName: UILabel!
    @IBOutlet weak var mDate: UILabel!
    @IBOutlet weak var timeView: UIStackView!
    @IBOutlet weak var timeLeft: UILabel!
    @IBOutlet weak var appPreviewBtn: UIButton!
    @IBOutlet weak var statusImage: UIImageView!
    @IBOutlet weak var status: UILabel!
    @IBOutlet weak var basicSkillView: UIView!
    @IBOutlet weak var ballMasteryView: UIView!
    @IBOutlet weak var eliteDrillView: UIView!
    @IBOutlet weak var footSpeedView: UIView!
    @IBOutlet weak var attackingMovesView: UIView!
    @IBOutlet weak var basicSkillsCount: UILabel!
    @IBOutlet weak var ballMasteryCount: UILabel!
    @IBOutlet weak var eliteDrillCount: UILabel!
    @IBOutlet weak var footSpeedCount: UILabel!
    @IBOutlet weak var attackingMovesCount: UILabel!
    @IBOutlet weak var highlightsCount: UILabel!
    @IBOutlet weak var noHighLightsAvailable: UIView!
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var collectionViewHeight: NSLayoutConstraint!
    var highlightModels = Array<HighlightModel>()
    
    override func viewDidLoad() {
        
        guard let userData = UserModel.data else {
            DispatchQueue.main.async {
                self.logout()
            }
            return
        }
        
        
        collectionView.delegate = self
        collectionView.dataSource = self
        let flowLayout = UICollectionViewFlowLayout()
        let width = self.collectionView.bounds.width
        flowLayout.itemSize = CGSize(width: (width / 2) - 5 , height: (width / 2) - 5)
        flowLayout.scrollDirection = UICollectionView.ScrollDirection.vertical
        flowLayout.minimumInteritemSpacing = 0
        self.collectionView.collectionViewLayout = flowLayout
        
        
        statusImage.layer.cornerRadius = 8
        updateStatus()
        
        notificationView.layer.cornerRadius = 8
        notificationView.dropShadow()
        notificationView.isUserInteractionEnabled = true
        notificationView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(notificationViewClicked)))
        
        profilePic.layer.cornerRadius = 8
        if let picPath = userData.profilePic, !picPath.isEmpty {
            profilePic.sd_setImage(with: URL(string: picPath), placeholderImage: UIImage(named: "profile-placeholder"))
        }
        
        mName.text = "Hi \(userData.fullName ?? "")"
        mDate.text = self.convertDatetoString(Date())
        
        self.timeView.isHidden = true
        FirebaseStoreManager.db.collection("UpcomingVideo")
            .document("eGm5CxGCNj6arfgE2laW").getDocument { snapshot, error in
                
                
                if let snapshot = snapshot, snapshot.exists {
                    if let upcomingVideoModel = try? snapshot.data(as: UpcomingVideoCountModel.self) {
                        if let isEnabled = upcomingVideoModel.isEnabled, isEnabled, (upcomingVideoModel.time ?? Date()) > Date() {
                            self.timeView.isHidden = false
                            self.timeLeft.text = self.getDateDifference(startDate: Date(), endDate: upcomingVideoModel.time ?? Date())
                        }
                        
                    }
                }
                
            }
        
        appPreviewBtn.addBorderColourAndRadius()
        
        status.layer.cornerRadius = 8
        
        basicSkillView.addBorderColourAndRadius()
        basicSkillView.isUserInteractionEnabled = true
        basicSkillView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(basicSkillsClicked)))
        
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
        
        ProgressHUDShow(text: "")
        getAllHighLightsVideos { highlightModels, error in
            self.ProgressHUDHide()
            if let error = error {
                print(error)
            }
            else {
             
                self.highlightModels.removeAll()
                self.highlightModels.append(contentsOf: highlightModels ?? [])
                self.highlightsCount.text = "\(self.highlightModels.count) Videos"
                self.collectionView.reloadData()
            }
        }
    }
    func gotoTrainingVideoPage(catId : String){
        
               Purchases.shared.getCustomerInfo { (customerInfo, error) in
                   if customerInfo?.entitlements.all["Premium"]?.isActive == true {
                       self.performSegue(withIdentifier: "homeTrainingRoomSeg", sender: catId)
                   }
                   else {
                       self.performSegue(withIdentifier: "homemembershipseg", sender: nil)
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
        if segue.identifier == "homeTrainingRoomSeg" {
            if let VC = segue.destination as? TrainingRoomVideosViewController {
                if let catId = sender as? String {
                    VC.catId = catId
                }
            }
        }
    }
    
    
    func updateStatus(){
        status.text = Constants.quotes[self.convertDatetoDay(Date())]
    }
    
    @objc func notificationViewClicked(){
        performSegue(withIdentifier: "notificationSeg", sender: nil)
    }
    
    @IBAction func appPreviewClicked(_ sender: Any) {
        
        let player = AVPlayer(url: URL(string: "https://firebasestorage.googleapis.com/v0/b/trueplayer-development.appspot.com/o/Preview%20(movie).mp4?alt=media&token=2f210a3c-ff70-43bd-bb75-a95d50133f68")!)
        let vc = AVPlayerViewController()
        vc.player = player

        present(vc, animated: true) {
            vc.player?.play()
        }
    }
    
    func refreshCollectionViewHeight(){
       

        let width = self.collectionView.bounds.width
        self.collectionViewHeight.constant = CGFloat((width / CGFloat(2)) + 5) * CGFloat((highlightModels.count) / 2)
        
    }
    
    @objc func highlightCellClicked(value : MyGesture){
        let player = AVPlayer(url: URL(string: self.highlightModels[value.index].videoUrl!)!)
        let vc = AVPlayerViewController()
        vc.player = player

        present(vc, animated: true) {
            vc.player?.play()
        }
    }
}


extension HomeViewController : UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        let width = self.collectionView.bounds.width
        return CGSize(width: (width / 2) - 5, height: (width / 2) - 5)
        

    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
 
        self.noHighLightsAvailable.isHidden = highlightModels.count > 0 ? true : false
        
        
        return highlightModels.count

    }
    
    
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        if let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "highlightCell", for: indexPath) as? HIghLightCollectionViewCell {
            
         
            cell.mImage.layer.cornerRadius = 8
            cell.shadowView.clipsToBounds = true
            cell.shadowView.layer.cornerRadius = 8
            cell.shadowView.layer.maskedCorners = [.layerMaxXMaxYCorner, .layerMinXMaxYCorner]
            
            let highlightModel = self.highlightModels[indexPath.row]
            
            if let thumbnail = highlightModel.thumbnail, !thumbnail.isEmpty {
                cell.mImage.sd_setImage(with: URL(string: thumbnail), placeholderImage: UIImage(named: "placeholder"))
            }
            cell.highLightBy.text = "By \(highlightModel.userName ?? "")"
            
            cell.mView.isUserInteractionEnabled = true
            let gest = MyGesture(target: self, action: #selector(highlightCellClicked(value: )))
            gest.index = indexPath.row
            cell.mView.addGestureRecognizer(gest)
            
            refreshCollectionViewHeight()
            cell.layoutIfNeeded()
        
            return cell
            
            
        }
        
        
        
        return HIghLightCollectionViewCell()
        
        
        
    }
    
}





