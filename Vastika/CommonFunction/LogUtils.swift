//
//  LogUtils.swift
//  VMConsumer
//
//  Created by Developer on 25/10/18.
//  Copyright © 2018 Developer. All rights reserved.
//

import Foundation
import UIKit
class LogUtils{
 
   static let keyboardMinY:CGFloat = 400.0
    static let isShowLog = false;
    
    //userdefaults key
    
 

    static func showLog(msg:String){
        
        if isShowLog{
            print(msg)
        }
    }
    
    
}
