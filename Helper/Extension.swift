//
//  Extension.swift
//  Arheb
//
//  Created on 30/05/17.
//  Copyright © 2017. All rights reserved.
//

import Foundation
import UIKit

// MARK:- ScrollView

public extension UIScrollView {
    
    fileprivate func refreshViewWithTag(_ tag:Int) -> PullToRefreshView? {
        let pullToRefreshView = viewWithTag(tag)
        return pullToRefreshView as? PullToRefreshView
    }
    
    public func addPullRefresh(_ options: PullToRefreshOption = PullToRefreshOption(), refreshCompletion :((Void) -> Void)?) {
        let refreshViewFrame = CGRect(x: 0, y: -PullToRefreshConst.height, width: self.frame.size.width, height: PullToRefreshConst.height)
        let refreshView = PullToRefreshView(options: options, frame: refreshViewFrame, refreshCompletion: refreshCompletion)
        refreshView.tag = PullToRefreshConst.pullTag
        addSubview(refreshView)
    }
    
    public func addPushRefresh(_ options: PullToRefreshOption = PullToRefreshOption(), refreshCompletion :((Void) -> Void)?) {
        let refreshViewFrame = CGRect(x: 0, y: contentSize.height, width: self.frame.size.width, height: PullToRefreshConst.height)
        let refreshView = PullToRefreshView(options: options, frame: refreshViewFrame, refreshCompletion: refreshCompletion,down: false)
        refreshView.tag = PullToRefreshConst.pushTag
        addSubview(refreshView)
    }
    
    public func startPullRefresh() {
        let refreshView = self.refreshViewWithTag(PullToRefreshConst.pullTag)
        refreshView?.state = .refreshing
    }
    
    public func stopPullRefreshEver(_ ever:Bool = false) {
        let refreshView = self.refreshViewWithTag(PullToRefreshConst.pullTag)
        if ever {
            refreshView?.state = .finish
        } else {
            refreshView?.state = .stop
        }
    }
    
    public func removePullRefresh() {
        let refreshView = self.refreshViewWithTag(PullToRefreshConst.pullTag)
        refreshView?.removeFromSuperview()
    }
    
    public func startPushRefresh() {
        let refreshView = self.refreshViewWithTag(PullToRefreshConst.pushTag)
        refreshView?.state = .refreshing
    }
    
    public func stopPushRefreshEver(_ ever:Bool = false) {
        let refreshView = self.refreshViewWithTag(PullToRefreshConst.pushTag)
        if ever {
            refreshView?.state = .finish
        } else {
            refreshView?.state = .stop
        }
    }
    
    public func removePushRefresh() {
        let refreshView = self.refreshViewWithTag(PullToRefreshConst.pushTag)
        refreshView?.removeFromSuperview()
    }
    
    // If you want to PullToRefreshView fixed top potision, Please call this function in scrollViewDidScroll
    public func fixedPullToRefreshViewForDidScroll() {
        let pullToRefreshView = self.refreshViewWithTag(PullToRefreshConst.pullTag)
        if !PullToRefreshConst.fixedTop || pullToRefreshView == nil {
            return
        }
        var frame = pullToRefreshView!.frame
        if self.contentOffset.y < -PullToRefreshConst.height {
            frame.origin.y = self.contentOffset.y
            pullToRefreshView!.frame = frame
        }
        else {
            frame.origin.y = -PullToRefreshConst.height
            pullToRefreshView!.frame = frame
        }
    }
}

// MARK:- String

extension String {
    
    /// Returns a new string made by replacing in the `String`
    /// all HTML character entity references with the corresponding
    /// character.
    var stringByDecodingHTMLEntities : String {
        
        // ===== Utility functions =====
        
        // Convert the number in the string to the corresponding
        // Unicode character, e.g.
        //    decodeNumeric("64", 10)   --> "@"
        //    decodeNumeric("20ac", 16) --> "€"
        func decodeNumeric(_ string : String, base : Int) -> Character? {
            guard let code = UInt32(string, radix: base),
                let uniScalar = UnicodeScalar(code) else { return nil }
            return Character(uniScalar)
        }
        
        // Decode the HTML character entity to the corresponding
        // Unicode character, return `nil` for invalid input.
        //     decode("&#64;")    --> "@"
        //     decode("&#x20ac;") --> "€"
        //     decode("&lt;")     --> "<"
        //     decode("&foo;")    --> nil
        func decode(_ entity : String) -> Character? {
            
            if entity.hasPrefix("&#x") || entity.hasPrefix("&#X"){
                return decodeNumeric(entity.substring(with: entity.index(entity.startIndex, offsetBy: 3) ..< entity.index(entity.endIndex, offsetBy: -1)), base: 16)
            } else if entity.hasPrefix("&#") {
                return decodeNumeric(entity.substring(with: entity.index(entity.startIndex, offsetBy: 2) ..< entity.index(entity.endIndex, offsetBy: -1)), base: 10)
            } else {
                return characterEntities[entity]
            }
        }
        
        // ===== Method starts here =====
        
        var result = ""
        var position = startIndex
        
        // Find the next '&' and copy the characters preceding it to `result`:
        while let ampRange = self.range(of: "&", range: position ..< endIndex) {
            result.append(self[position ..< ampRange.lowerBound])
            position = ampRange.lowerBound
            
            // Find the next ';' and copy everything from '&' to ';' into `entity`
            if let semiRange = self.range(of: ";", range: position ..< endIndex) {
                let entity = self[position ..< semiRange.upperBound]
                position = semiRange.upperBound
                
                if let decoded = decode(entity) {
                    // Replace by decoded character:
                    result.append(decoded)
                } else {
                    // Invalid entity, copy verbatim:
                    result.append(entity)
                }
            } else {
                // No matching ';'.
                break
            }
        }
        // Copy remaining characters to `result`:
        result.append(self[position ..< endIndex])
        return result
    }
    
    //MARK:- String empty or not
    func isEmptyString() -> Bool{
        let trimmedString = self.trimmingCharacters(in: NSCharacterSet.whitespacesAndNewlines)
        if trimmedString.characters.count == 0 {
            return true
        }
        return false
    }
    
    //MARK:- remove leading and trailing spacing from string
    func trim() -> String {
        return  self.trimmingCharacters(in: NSCharacterSet.whitespacesAndNewlines)
    }
}


//MARK: Tint Color
extension UIImageView{
    func setTintColor(color: UIColor){
        self.image = self.image?.withRenderingMode(.alwaysTemplate)
        self.tintColor = color
    }
}


