//
//  NotificationListViewModel.swift

//
//  Created by Vasundhara Parakh on 5/12/20.
//  Copyright © 2020 smartData Enterprises (I) Ltd. All rights reserved.
//

import UIKit

class NotificationListViewModel: BaseViewModel {
    // MARK: - Parameters
    private(set) var service:UserService
    var arrNotification = [NotificationList]()
    
    // MARK: - Constructor
    init(with service:UserService) {
        self.service = service
    }
    
    //MARK: -Table view methods
    func numberOfRows()-> Int{
        return arrNotification.count
    }
    func roomForIndexPath(_ indexPath: IndexPath) -> NotificationList {
        return arrNotification[indexPath.row]
    }
    
    // MARK: - Network calls
    func getNotificationList() {
        self.isLoading = true
        self.service.getNotifications  { (result) in
            self.isLoading = false
            self.arrNotification.removeAll()
            if let list = result as? [NotificationList]{
                self.arrNotification = list
            }else{
                self.arrNotification.removeAll()
            }
            self.isListLoaded = true
        }
    }
    
    func deleteNotification(notificationIds:[Int]) {
        self.isLoading = true
        service.deleteNotifications(ids: notificationIds) { (result) in
            self.isLoading = false
            if let res = result{
                if ((res as! NSDictionary).object(forKey: "statusCode") as! Int) == 200{
                    self.getNotificationList()
                }
                self.errorMessage = ((res as! NSDictionary).object(forKey: Key.Response.message) as! String)
            }
        }
    }
}
