//
//  TrainingRoomVideosViewController.swift
//  TruePlayer Development
//
//  Created by Vijay Rathore on 24/05/23.
//

import UIKit
import AVFoundation
import AVKit

class TrainingRoomVideosViewController : UIViewController {
    
    @IBOutlet weak var backView: UIImageView!
    @IBOutlet weak var categoryName: UILabel!
    @IBOutlet weak var noVideosAvailable: UIView!
    @IBOutlet weak var tableView: UITableView!
    var videoModels = Array<VideoModel>()
  
    var catId : String?
    override func viewDidLoad() {
        
        guard  let catId = catId else {
            DispatchQueue.main.async {
                self.dismiss(animated: true)
            }
            return
        }
        
        backView.isUserInteractionEnabled = true
        backView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(backBtnClicked)))
        
        tableView.delegate = self
        tableView.dataSource = self
        
        categoryName.text = Constants.Category.getCategoryName(by: catId)
        
        ProgressHUDShow(text: "")
        getVideosForCategory(categoryCode: catId) { videoModels, error in
            self.ProgressHUDHide()
            if let error = error {
                self.showError(error)
            }
            else {
                self.videoModels.removeAll()
                self.videoModels.append(contentsOf: videoModels ?? [])
                self.tableView.reloadData()
                
            }
        }
    }
    
    @objc func backBtnClicked(){
        self.dismiss(animated: true)
    }
    
    @objc func cellClicked(value : MyGesture){
        
        let player = AVPlayer(url: URL(string: videoModels[value.index].videoUrl ?? "" )!)
        let vc = AVPlayerViewController()
        vc.player = player

        present(vc, animated: true) {
            vc.player?.play()
        }
    }
}

extension TrainingRoomVideosViewController : UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        noVideosAvailable.isHidden = videoModels.count > 0 ? true : false
        return videoModels.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let cell = tableView.dequeueReusableCell(withIdentifier: "videoCell", for: indexPath) as? WorkoutVideoTableViewCell {
            
            cell.mView.layer.cornerRadius = 8
            cell.mImage.clipsToBounds = true
            cell.mImage.layer.cornerRadius = 8
            cell.mImage.layer.maskedCorners = [.layerMinXMinYCorner, .layerMinXMaxYCorner]
            
            cell.mView.isUserInteractionEnabled = true
            let myGest = MyGesture(target: self, action: #selector(cellClicked(value: )))
            myGest.index = indexPath.row
            cell.mView.addGestureRecognizer(myGest)
            
            let videoModel = videoModels[indexPath.row]
            if let imagePath = videoModel.thumbnail, !imagePath.isEmpty {
                cell.mImage.sd_setImage(with: URL(string: imagePath), placeholderImage: UIImage(named: "placeholder"))
            }
            cell.mTitle.text = videoModel.title ?? ""
            cell.mTime.text = self.convertSecondsToMinAndSec(totalSec: videoModel.videoLength ?? 0)
            
            return cell
        }
        return WorkoutVideoTableViewCell()
    }
    
    
}
