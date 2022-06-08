//
//  NoActionAlertView.swift
//  pigiBankApp
//
//  Created by Codifier on 2/16/17.
//  Copyright © 2017 Codifier. All rights reserved.
//

import UIKit


class alertViewManager{
    
    var backgroundLayer:UIView!
    
    init(title:String,msg:String,onVC:UIViewController,className:String = "",buttonAttributeDic:[String:String] = ["OK":""],addOnWindow:Bool = false){
       
        let  alert =  UIAlertController(title: title, message: msg, preferredStyle: UIAlertController.Style.alert)
        
        
        for (title,selector) in buttonAttributeDic{
            alert.addAction(UIAlertAction(title: title, style: UIAlertAction.Style.default, handler: {UIAlertAction in
                print("loop called");
                self.leftButtonAction(className, selector: selector,withVC:onVC)
            
                            }))
        }
        
        self.showCustomAlert(vc: onVC, msgToShow: msg,alertType: title,addOnWindow: addOnWindow);
        //onVC.present(alert, animated: true, completion: nil)
        
    }
    deinit {
        LogUtils.showLog(msg:"GenericAlertViewDestroyed")
    }
    func leftButtonAction(_ className:String,selector:String,withVC:UIViewController){
       
        print("left btn called");
     
        if(selector != ""){
            if let cls = NSObject.fromClassName(className: className) as? UIViewController{
                print("class found methodToFind:- \(selector)");
                if let sel = NSSelectorFromString(selector) as? Selector  {
                    
                    print("found selector:- \(sel)")
                  cls.perform(sel, with: cls)

                }else{
                    print("no selected found");
                }
                
            }
        }
       
        
        
    }
    
    private func showCustomAlert(vc:UIViewController,msgToShow:String,alertType:String,addOnWindow:Bool = false){
        
        
        self.backgroundLayer = UIView(frame: (vc.view.bounds));
        self.backgroundLayer.backgroundColor = UIColor.black.withAlphaComponent(0.8)
        self.backgroundLayer.tag = 1331
        
        if addOnWindow{
            self.backgroundLayer.frame = UIScreen.main.bounds;
            let window = UIApplication.shared.keyWindow;
            window?.insertSubview(self.backgroundLayer, aboveSubview: vc.view);
            window?.bringSubviewToFront(self.backgroundLayer);
        }else{
            vc.view.addSubview(self.backgroundLayer)
            vc.view.bringSubviewToFront(self.backgroundLayer)
        }
      

        
         let heightOfText = CommonFunctions.sharedInstance.calculateHeight(inString: msgToShow, width:vc.view.frame.width - 80, font: UIFont(name: CustomFont.helveticaRegularFont, size: 15.0)!)
      
        
        let popUpView = UIView(frame: CGRect(x: 25, y: 100, width: vc.view.frame.width - 50, height: CGFloat(160) + heightOfText))
        popUpView.backgroundColor = color.walletDetail_tabBarBackgroundColor;
        popUpView.layer.cornerRadius = 2.0
        popUpView.clipsToBounds = true;
        popUpView.center = self.backgroundLayer.center
        self.backgroundLayer.addSubview(popUpView);
        self.backgroundLayer.bringSubviewToFront(self.backgroundLayer)

        
        var imgIconName = "alertIcon"
        var title = "Alert !"
        
        switch alertType {
        case AppUtils.Success: imgIconName = "goalIcon";
                title = "Success !"
        break;
        case AppUtils.ErrorTypeTitle :  imgIconName = "alertIcon"
                title = "Alert !"
        break;
            
        default: print("test")
            break;
            
        }
        
        let imgView = UIImageView(frame: CGRect(x: popUpView.frame.width/2 - 45, y: -10, width: 90, height: 90));
        imgView.image = UIImage(named: imgIconName);
        imgView.contentMode = .center
        popUpView.addSubview(imgView);
        
        
        let headingLbl = UILabel(frame: CGRect(x: 20, y: imgView.frame.maxY - 25, width: popUpView.frame.width - 40, height: 40));
        headingLbl.text = title;
        headingLbl.textAlignment = .center;
        headingLbl.textColor = color.themeOrangeColor;
        headingLbl.font = UIFont(name: CustomFont.helveticaRegularFont, size: 17)
        popUpView.addSubview(headingLbl);
        
        
        let lineView = UIView(frame: CGRect(x: 0, y: headingLbl.frame.maxY - 5, width: popUpView.frame.width, height: 0.5))
        lineView.backgroundColor = color.line_backgroundColor;
        popUpView.addSubview(lineView)
        
       
        
        let msgLbl = UILabel(frame: CGRect(x: 15, y: lineView.frame.maxY + 10 , width: popUpView.frame.width - 30, height: heightOfText))
        msgLbl.textColor = color.wallet_header_title_textColor_light;
//        msgLbl.backgroundColor = color.blueColor
        msgLbl.text = msgToShow;
        msgLbl.textAlignment = .center;
        msgLbl.numberOfLines = 0
        msgLbl.lineBreakMode = .byWordWrapping
        
        msgLbl.font = UIFont(name: CustomFont.helveticaRegularFont, size: 15.0)
        popUpView.addSubview(msgLbl)
        
        
      
        
        let okBtn = UIButton(frame: CGRect(x: popUpView.frame.width - 60, y: popUpView.frame.height - 35, width: 50, height: 30))
        okBtn.setTitle("OK", for: .normal)
        okBtn.tag = 1011;
        okBtn.setTitleColor(color.themeOrangeColor, for: .normal)
        okBtn.addTarget(self, action: #selector(hideAlert), for: .touchUpInside)
        popUpView.addSubview(okBtn)
        
        
        
        // if no balance amount
        
        
    }
    
    
    
    @objc func demo(sender:UIButton){
        print("demo called")
    }
    
    
    
    func showCustomAlertWithActionOptions(vc:UIViewController,msgToShow:String,alertType:String,tag:Int,buttonsNameDic:[String] = ["OK"]){
        
        
        self.backgroundLayer = UIView(frame: (vc.view.bounds));
        self.backgroundLayer.backgroundColor = UIColor.black.withAlphaComponent(0.8)
        self.backgroundLayer.tag = 1331
        vc.view.addSubview(self.backgroundLayer)
        
        
        
        
        let popUpView = UIView(frame: CGRect(x: 25, y: 100, width: vc.view.frame.width - 50, height: 200))
        popUpView.backgroundColor = color.walletDetail_tabBarBackgroundColor;
        popUpView.layer.cornerRadius = 2.0
        popUpView.clipsToBounds = true;
        popUpView.center = self.backgroundLayer.center
        self.backgroundLayer.addSubview(popUpView);
        
        var imgIconName = "alertIcon"
        var title = "Alert !"
        
        switch alertType {
        case AppUtils.Success: imgIconName = "goalIcon";
        title = "Success !"
        break;
        case AppUtils.ErrorTypeTitle :  imgIconName = "alertIcon"
        title = "Alert !"
        break;
            
        default: print("test")
        break;
            
        }
        
        let imgView = UIImageView(frame: CGRect(x: popUpView.frame.width/2 - 45, y: -10, width: 90, height: 90));
        imgView.image = UIImage(named: imgIconName);
        imgView.contentMode = .center
        popUpView.addSubview(imgView);
        
        
        let headingLbl = UILabel(frame: CGRect(x: 20, y: imgView.frame.maxY - 25, width: popUpView.frame.width - 40, height: 40));
        headingLbl.text = title;
        headingLbl.textAlignment = .center;
        headingLbl.textColor = color.themeOrangeColor;
        headingLbl.font = UIFont(name: CustomFont.helveticaRegularFont, size: 17)
        popUpView.addSubview(headingLbl);
        
        
        let lineView = UIView(frame: CGRect(x: 0, y: headingLbl.frame.maxY - 5, width: popUpView.frame.width, height: 1))
        lineView.backgroundColor = color.line_backgroundColor;
        popUpView.addSubview(lineView)
        
        
        
        let msgLbl = UILabel(frame: CGRect(x: 15, y: lineView.frame.maxY , width: popUpView.frame.width - 30, height: 60))
        msgLbl.textColor = color.wallet_header_title_textColor_light;
        //        msgLbl.backgroundColor = color.blueColor
        msgLbl.text = msgToShow;
        msgLbl.textAlignment = .center;
        msgLbl.numberOfLines = 0
        msgLbl.lineBreakMode = .byWordWrapping
        msgLbl.font = UIFont(name: CustomFont.helveticaRegularFont, size: 15.0)
        popUpView.addSubview(msgLbl)
        
        
        
        
        let okBtn = UIButton(frame: CGRect(x: popUpView.frame.width - 60, y: popUpView.frame.height - 35, width: 50, height: 30))
        okBtn.setTitle(buttonsNameDic[0], for: .normal)
        okBtn.setTitleColor(color.themeOrangeColor, for: .normal)
        okBtn.addTarget(self, action: #selector(hideAlert), for: .touchUpInside)
        popUpView.addSubview(okBtn)
        
        let cancelBtn = UIButton(frame: CGRect(x: popUpView.frame.width - 140, y: popUpView.frame.height - 35, width: 70, height: 30))
        cancelBtn.setTitle(buttonsNameDic[0], for: .normal)
        cancelBtn.setTitleColor(color.themeOrangeColor, for: .normal)
        cancelBtn.addTarget(self, action: #selector(hideAlert), for: .touchUpInside)
        popUpView.addSubview(cancelBtn)
    }
    
    @objc func hideAlert(){
//        print("demo called")
        self.backgroundLayer.removeFromSuperview();
    }
    
    

    }

    

extension NSObject {
    class func fromClassName(className : String) -> NSObject {
        let className = Bundle.main.infoDictionary!["CFBundleName"] as! String + "." + className
        let aClass = NSClassFromString(className) as! UIViewController.Type
        return aClass.init()
    }
}
