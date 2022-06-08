//
//  LoaderManager.swift
//  VMConsumer
//
//  Created by Developer on 30/10/18.
//  Copyright © 2018 Developer. All rights reserved.
//

import Foundation
import NVActivityIndicatorView
class loaderManager:NVActivityIndicatorViewable{
    
    
    var activityIndicatorView:NVActivityIndicatorView?
    
    var blueView = UIView()
    
    func startLoading(){
        if activityIndicatorView != nil && activityIndicatorView!.isAnimating{
            return
        }
        
        if let applicationDelegate:AppDelegate = UIApplication.shared.delegate as! AppDelegate? {
            if let window:UIWindow = applicationDelegate.window {
                blueView   = UIView(frame: UIScreen.main.bounds)
                blueView.tag = 1008
                blueView.backgroundColor = UIColor.black.withAlphaComponent(0.6)
                window.addSubview(blueView)
            }
        }
        
        let frame = CGRect(x:50, y: 200, width: 75, height: 75)
        activityIndicatorView = NVActivityIndicatorView(frame: frame,
        type: .ballClipRotateMultiple)
        activityIndicatorView?.padding = 20
        
        
        blueView.addSubview(activityIndicatorView!)
        activityIndicatorView?.center = blueView.center
        
        blueView.bringSubviewToFront(activityIndicatorView!)
        activityIndicatorView!.startAnimating()
        print("Show activityIndicator \(activityIndicatorView!)")
        print("Show Background View \(blueView)")
    
    }
    func stopLoading(){
        
        activityIndicatorView?.stopAnimating()
        activityIndicatorView?.removeFromSuperview()
        blueView.removeFromSuperview()
        print("Hide activityIndicator \(activityIndicatorView!)")
        print("Hide Background View \(blueView)")
    }
    
    deinit {
        print("LoderManager Destroyedddd")
    }
    class var sharedInstance:loaderManager{
        struct sharedInstanceStruct{
            static let instance = loaderManager()
            
        }
        return sharedInstanceStruct.instance
    }
    
    
    
    
}



