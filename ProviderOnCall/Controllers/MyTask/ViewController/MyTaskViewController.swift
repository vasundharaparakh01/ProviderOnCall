//
//  MyTaskViewController.swift
//  AccessEMR
//
//  Created by Vasundhara Parakh on 2/25/20.
//  Copyright © 2020 smartData Enterprises (I) Ltd. All rights reserved.
//

import UIKit
enum MyTaskItems {
    static let Bathing = "Bathing"
    static let Nailcare = "Nailcare"
    static let Walking = "Walking"
    static let TeethBrushing = "Teeth Brushing"
    static let Cleaning = "Cleaning"
    static let Toileting = "Toileting"
    static let MouthCare = "Mouth Care"
    static let EquipmentMaintenance = "Equipment Maintenance"
}
class MyTaskViewController: BaseViewController {

    lazy var viewModel: MyTaskViewModel = {
        let obj = MyTaskViewModel(with: TaskService())
        self.baseViewModel = obj
        return obj
    }()
    

    @IBOutlet weak var tblView: UITableView!
    
    
    var items = [MyTaskItems.Bathing,MyTaskItems.Nailcare,MyTaskItems.Walking,MyTaskItems.TeethBrushing,MyTaskItems.Cleaning,MyTaskItems.Toileting,MyTaskItems.MouthCare,MyTaskItems.EquipmentMaintenance]

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        self.navigationItem.title = NavigationTitle.TaskList
        self.viewModel.getTaskMasterData()
        self.setupClosures()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.initialSetup()
    }
    func initialSetup(){
        self.addBackButton()

        self.tblView.register(UINib(nibName: ReuseIdentifier.ListTableViewCell, bundle: nil), forCellReuseIdentifier: ReuseIdentifier.ListTableViewCell)

    }

    func setupClosures() {
        self.viewModel.reloadListViewClosure = { [weak self] () in
            DispatchQueue.main.async {
                self?.tblView.reloadData()
            }
        }
    }

}

extension MyTaskViewController:UITableViewDataSource, UITableViewDelegate {
   
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.viewModel.numberOfRows(section: section)
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: ReuseIdentifier.ListTableViewCell, for: indexPath as IndexPath) as! ListTableViewCell
        let task = self.viewModel.roomForIndexPath(indexPath)
        cell.titleLbl.text = task?.taskType ?? ""
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath){

    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return Device.IS_IPAD ? 60 : 50
    }
}
