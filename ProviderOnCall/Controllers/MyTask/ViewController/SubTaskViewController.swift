//
//  SubTaskViewController.swift
//  AccessEMR
//
//  Created by Vasundhara Parakh on 4/7/20.
//  Copyright © 2020 smartData Enterprises (I) Ltd. All rights reserved.
//

import UIKit
enum SubTask : Int {
    case myTask = 0
    case followingTask
}
class SubTaskViewController: BaseViewController {
    
    @IBOutlet weak var collectionView: UICollectionView!
    var items = ["My Task", "I'm Following"]
    var images = ["mytask-large", "mytask-large"]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.initialSetup()
        self.navigationItem.title = NavigationTitle.Tasks
    }
    

    func initialSetup(){
       
    }
    
    @IBAction func addTask_Clicked(_ sender: Any) {
        let vc = AddTaskViewController.instantiate(appStoryboard: Storyboard.Forms) as! AddTaskViewController
        vc.hidesBottomBarWhenPushed = true
        self.navigationController?.pushViewController(vc,animated:true)
    }

}

extension SubTaskViewController:UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    // tell the collection view how many cells to make
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.items.count
    }

    // make a cell for each cell index path
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {

        // get a reference to our storyboard cell
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ReuseIdentifier.HomeCollectionViewCell, for: indexPath as IndexPath) as! HomeCollectionViewCell

        // Use the outlet in our custom class to get a reference to the UILabel in the cell
        cell.titleLabel.text = self.items[indexPath.item]
        cell.imageView.image = UIImage(named: self.images[indexPath.item])
//        cell.backgroundColor = UIColor.cyan // make cell more visible in our example project

        return cell
    }

    // MARK: - UICollectionViewDelegate protocol
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        // handle tap events
        print("You selected cell #\(indexPath.item)!")
        switch indexPath.item {
        case SubTask.myTask.rawValue:
            let vc = TaskListViewController.instantiate(appStoryboard: Storyboard.Dashboard) as! TaskListViewController
            self.navigationController?.pushViewController(vc,animated:true)
        case SubTask.followingTask.rawValue:
            let vc = FollowingTaskListViewController.instantiate(appStoryboard: Storyboard.Dashboard) as! FollowingTaskListViewController
            self.navigationController?.pushViewController(vc,animated:true)
        default:
            break
        }
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        sizeForItemAt indexPath: IndexPath) -> CGSize {
        let itemPerRow : CGFloat = Device.IS_IPAD ? 3.0 : 2.0
        let width = ((Screen.width - (30 * itemPerRow)))/itemPerRow
        let ratio = CGFloat(150.0/160.0)
        let height = width*ratio
        return CGSize(width: Screen.width - 30, height: height)
    }
    

    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 20.0
    }

    func collectionView(_ collectionView: UICollectionView, layout
        collectionViewLayout: UICollectionViewLayout,
                        minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 20.0
    }
}

