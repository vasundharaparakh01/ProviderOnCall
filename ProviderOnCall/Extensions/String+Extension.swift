//
//  String+RUI.swift
//  AccessEMR
//
//  Created by Vasundhara Parakh on 2/25/20.
//  Copyright © 2020 smartData Enterprises (I) Ltd. All rights reserved.
//

import UIKit

extension String {
    
    func sizeOfString (width: CGFloat = CGFloat.greatestFiniteMagnitude, font : UIFont, height: CGFloat = CGFloat.greatestFiniteMagnitude, drawingOption: NSStringDrawingOptions = NSStringDrawingOptions.usesLineFragmentOrigin) -> CGSize {
        return (self as NSString).boundingRect(with: CGSize(width: width, height: height), options: drawingOption, attributes: [NSAttributedString.Key.font : font], context: nil).size
    }
    
    func numberOfLinesForString(size: CGSize, font: UIFont) -> Int {
        let textStorage = NSTextStorage(string: self, attributes: [NSAttributedString.Key.font: font])
        
        let textContainer = NSTextContainer(size: size)
        textContainer.lineBreakMode = .byWordWrapping
        textContainer.maximumNumberOfLines = 0
        textContainer.lineFragmentPadding = 0
        
        let layoutManager = NSLayoutManager()
        layoutManager.textStorage = textStorage
        layoutManager.addTextContainer(textContainer)
        
        var numberOfLines = 0
        var index = 0
        var lineRange : NSRange = NSMakeRange(0, 0)
        
        while index < layoutManager.numberOfGlyphs {
            layoutManager.lineFragmentRect(forGlyphAt: index, effectiveRange: &lineRange)
            index = NSMaxRange(lineRange)
            numberOfLines += 1
        }
        
        return numberOfLines
    }
    
    var lastPathComponent: String {
        get {
            return (self as NSString).lastPathComponent
        }
    }
    
    var pathExtension: String {
        get {
            return (self as NSString).pathExtension
        }
    }
    
    var stringByDeletingLastPathComponent: String {
        get {
            return (self as NSString).deletingLastPathComponent
        }
    }
    
    var stringByDeletingPathExtension: String {
        get {
            return (self as NSString).deletingPathExtension
        }
    }
    
    var pathComponents: [String] {
        get {
            return (self as NSString).pathComponents
        }
    }
    
    func stringByAppendingPathComponent(path: String) -> String {
        let nsSt = self as NSString
        return nsSt.appendingPathComponent(path)
    }
    
    func stringByAppendingPathExtension(ext: String) -> String? {
        let nsSt = self as NSString
        return nsSt.appendingPathExtension(ext)
    }
    
    func trimSpaces() -> String{
       
        return self.trimmingCharacters(in: CharacterSet.whitespaces)
    }
    
    func toBool() -> Bool {
        switch self {
        case "True", "true", "yes", "1":
            return true
        case "False", "false", "no", "0":
            return false
        default:
            return false
        }
    }
    static func className(_ aClass: AnyClass) -> String {
        return NSStringFromClass(aClass).components(separatedBy: ".").last!
    }
    public func isValidPincode() -> Bool {
        let stricterFilterString : String = "[1-9][0-9]{5}"
        let pincodeTest : NSPredicate = NSPredicate(format: "SELF MATCHES %@", stricterFilterString)
        return pincodeTest.evaluate(with: self)
    }
    
    func removeDoctorPrefix() -> String{
        var newStr = self
        newStr = newStr.replacingOccurrences(of: "Dr.", with: "")
        newStr = newStr.replacingOccurrences(of: "Dr", with: "")
        newStr = newStr.replacingOccurrences(of: "DR.", with: "")
        newStr = newStr.replacingOccurrences(of: "DR", with: "")
        return newStr.trimmingCharacters(in: .whitespacesAndNewlines)
    }
}
