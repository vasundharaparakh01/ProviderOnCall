//
//  ImageViewExtensions.swift
//  neobook
//
//  Created by SDN MacMini 17 on 27/01/17.
//  Copyright © 2017 Mohit Choudhary. All rights reserved.
//

import UIKit


extension UIImageView{
    func roundedCorner()->Void{
        self.layer.masksToBounds = true
        self.layer.cornerRadius = self.frame.size.width/2
    }
 
    func addFullScreenView(){
        let pictureTap = UITapGestureRecognizer(target: self, action: #selector(self.imageTapped(sender:)))
        self.addGestureRecognizer(pictureTap)
        self.isUserInteractionEnabled = true
    }
     @IBAction func imageTapped(sender: UITapGestureRecognizer) {
            let imageView = sender.view as! UIImageView
            let newImageView = UIImageView(image: imageView.image)
            newImageView.frame = UIScreen.main.bounds
            newImageView.backgroundColor = UIColor("#000000", alpha: 0.85)
            newImageView.contentMode = .scaleAspectFit
            newImageView.isUserInteractionEnabled = true
            let tap = UITapGestureRecognizer(target: self, action: #selector(dismissFullscreenImage(sender:)))
            newImageView.addGestureRecognizer(tap)
            if let window = UIApplication.shared.windows.first as? UIWindow {
                window.addSubview(newImageView)
            }
            
    //        let btnClose = UIButton(type: .custom)
    //        btnClose.frame = CGRect(x: imageView.frame.size.width - 50, y: 20, width:  30 , height: 30)
    //        btnClose.backgroundColor = .clear
    //        btnClose.setImage(UIImage.closeImage(), for: .normal)
    //        btnClose.addTarget(self, action: #selector(dismissFullscreenImage(sender:)), for: .touchUpInside)
    //        newImageView.addSubview(btnClose)
    //        newImageView.bringSubviewToFront(btnClose)

            //self.navigationController?.isNavigationBarHidden = true
            //self.tabBarController?.tabBar.isHidden = true
        }

        @objc func dismissFullscreenImage(sender: UITapGestureRecognizer) {
            //self.navigationController?.isNavigationBarHidden = false
            //self.tabBarController?.tabBar.isHidden = false
            sender.view?.removeFromSuperview()
        }
}
