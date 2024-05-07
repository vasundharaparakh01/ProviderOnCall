//
//  ImageExtension.swift
//  AccessEMR
//
//  Created by Vasundhara Parakh on 2/25/20.
//  Copyright © 2020 smartData Enterprises (I) Ltd. All rights reserved.
//

import UIKit

extension UIImage{
    //MARK:- Navigation buttons
    class func backImage() -> UIImage{
        return UIImage(named: "back_arrow")!
    }
    
    //MARK:- Common
    class func closeImage() -> UIImage{
        return UIImage(named: "close")!
    }

    class func dropdownTextfieldRightImage() -> UIImage{
        return UIImage(named: "down-arrow")!
    }

    class func defaultProfilePicture() -> UIImage{
        return UIImage(named: "defaultProfilePicture")!
    }
    
    class func breakfastImage() -> UIImage{
        return UIImage(named: "breakfast")!
    }
    class func lunchImage() -> UIImage{
        return UIImage(named: "lunch")!
    }

    class func dinnerImage() -> UIImage{
        return UIImage(named: "dinner")!
    }

    class func upArrow() -> UIImage{
        return UIImage(named: "up-arrow")!
    }
    class func downArrow() -> UIImage{
        return UIImage(named: "down-arrow")!
    }

    class func formFilled() -> UIImage{
        return UIImage(named: "filled")!
    }

    class func formIncomplete() -> UIImage{
        return UIImage(named: "pencil")!
    }

    class func docPlaceholder() -> UIImage{
        return UIImage(named: "docPlaceholder")!
    }

    class func unfilledCircle() -> UIImage{
        return UIImage(named:"unfilled-circle")!
    }
    
    class func filledCircle() -> UIImage{
        return UIImage(named:"filled-circle")!
    }
    
    class func buttonBackground() -> UIImage{
        return UIImage(named:"btn_background")!
    }
    
    class func noMedication() -> UIImage{
        return UIImage(named:"noMedication")!
    }
    
    class func doneMedication() -> UIImage{
        return UIImage(named:"doneMedication")!
    }
    
    class func shareScreen() -> UIImage{
        return UIImage(named:"shareScreen")!
    }
    
    class func stopScreen() -> UIImage{
        return UIImage(named:"stopScreen")!
    }


    class func chat() -> UIImage{
        return UIImage(named:"chat")!
    }
    
    class func callRecording_Off() -> UIImage{
        return UIImage(named:"callRecording-Off")!
    }
    class func callRecording_On() -> UIImage{
        return UIImage(named:"callRecording-On")!
    }
    
    class func fileShare() -> UIImage{
        return UIImage(named:"fileShare")!
    }

    class func filterNavigation() -> UIImage{
        return UIImage(named:"filterNavigation")!
    }
    
    class func availability() -> UIImage{
        return UIImage(named:"availability")!
    }

    class func addMeal() -> UIImage{
        return UIImage(named:"addMeal")!
    }
    
    class func addressImage() -> UIImage{
        return UIImage(named:"address")!
    }

}

extension UIImage{
    func convertToBase64String() -> String{
        let image:UIImage = self
        let selectedImageData:NSData = NSData(data: image.jpegData(compressionQuality: 1)!)
        let imageBase64 = selectedImageData.base64EncodedString(options: .lineLength64Characters)
        return imageBase64
    }
    
    func convertSignatureToBase64() -> String{
   let image:UIImage = self
    let selectedImageData:NSData = NSData(data: image.jpegData(compressionQuality: 1)!)
    let imageBase64 = selectedImageData.base64EncodedString(options: .lineLength64Characters)
        
    var correctstr = imageBase64.replacingOccurrences(of: "\\n", with: "")
    
    correctstr = imageBase64.replacingOccurrences(of: "\\r", with: "")
    correctstr = imageBase64.replacingOccurrences(of: "\\", with: "")
    
    correctstr = String(correctstr.filter { !" \n\t\r".contains($0) })
    correctstr = correctstr.components(separatedBy: .whitespacesAndNewlines).joined()
    return correctstr
    }
    
    func convertToBase64StringWithCompletion(completion:@escaping (String) -> Void) {
        let image:UIImage = self
        let selectedImageData:NSData = NSData(data: image.jpegData(compressionQuality: 1)!)
        let imageBase64 = selectedImageData.base64EncodedString(options: .lineLength64Characters)
        completion(imageBase64)
        //return imageBase64
    }
}
