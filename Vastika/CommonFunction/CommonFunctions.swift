//
//  CommonFunctions.swift
//  VMConsumer
//
//  Created by Developer on 25/10/18.
//  Copyright © 2018 Developer. All rights reserved.
//

import Foundation
import UIKit
import SkyFloatingLabelTextField
class CommonFunctions{
    
    static var itemsCount = 1;
    static let lineHeightForTF:CGFloat = 1.5;
    #if DEVELOPMENT
        static var OperatorId:Int =  1  // for dev
    #elseif STAGING
        static var OperatorId:Int =  1  // for staging, Operator Id can be 1 or 3
    #else
        static var OperatorId:Int =  1  // for live 1
    #endif

    static let shadowColor:UIColor = color.color_shadow;
    static let opacity:Float = 0.25;
    static let opacity2:Float = 0.75;
    static let shadowRadius:CGFloat = 1;
    
    static var cornerRadius: CGFloat = 2
    static  var shadowOffsetWidth: Int = 0
    static var shadowOffsetHeight: Int = 3
    static var shadowColorr: UIColor? = UIColor.black
    static var shadowOpacityy: Float = 0.5
    
    static let ACCEPTABLE_CHARACTERS = "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789_ "
    
    //    http:\/\/45.116.117.110:9006\/mediastorage\/\/Data\/WalletImage\/\/Paytm_logo.jpg
    func assignbackground(vc:UIViewController){
        let background = UIImage(named: "bg")
        var imageView : UIImageView!
        imageView = UIImageView(frame: vc.view.bounds)
        imageView.contentMode =  UIView.ContentMode.scaleAspectFill
        imageView.clipsToBounds = true
        imageView.image = background
        imageView.center = vc.view.center
        vc.view.addSubview(imageView)
        vc.view.sendSubviewToBack(imageView)
        vc.navigationController?.navigationBar.barStyle = .black
        
    }
    
    
    
    func calculateHeight(inString:String,width:CGFloat,font:UIFont) -> CGFloat {
        let messageString = inString
        let attributes:[NSAttributedString.Key : Any]  = [NSAttributedString.Key(rawValue: NSAttributedString.Key.font.rawValue) :font]
        
        let attributedString : NSAttributedString = NSAttributedString(string: messageString, attributes: attributes)
        
        let rect : CGRect = attributedString.boundingRect(with: CGSize(width: width, height: CGFloat.greatestFiniteMagnitude), options: .usesLineFragmentOrigin, context: nil)
        
        let requredSize:CGRect = rect
        return requredSize.height
    }
    
    
    func customizeNavigationBar(vc:UIViewController,title: String,isImageShown:Bool,isBackBtnReq:Bool){
        
        // display label on nav bar item 
        if let navigationBar = vc.navigationController?.navigationBar {
            vc.navigationController?.navigationBar.barStyle = .black
            for v in vc.navigationController!.navigationBar.subviews{
                v.removeFromSuperview()
            }
            
            navigationBar.backgroundColor = color.navigationBarBackgroundColor;
            navigationBar.barTintColor = color.navigationBarBackgroundColor;
            
            if isImageShown{
                let logoImg = UIImageView(frame: CGRect(x:30,y:0,width:140,height:navigationBar.frame.size.height))
                logoImg.image = UIImage(named: "logo")
                logoImg.contentMode = UIView.ContentMode.scaleAspectFit
                navigationBar.addSubview(logoImg)
                
            }else{
                if let tabbarController = vc.tabBarController{
                    tabbarController.title = title
                }else{
                   vc.title = title
                    
                }
            }
                        
        }
    }
    
    
    
    
    func rightBorderInText(textfield:UITextField,color:CGColor){
        
        let rightBorder = CALayer()
        rightBorder.frame = CGRect(x: textfield.frame.size.width - 1, y: 0, width: 1, height: textfield.frame.size.height)
        rightBorder.backgroundColor = color//UIColor(red:223/255,green:223/255,blue:223/255,alpha:1).cgColor
        textfield.layer.addSublayer(rightBorder)
    }
    
    
    func leftBorderInText(textfield:UITextField,color:CGColor){
        
        let rightBorder = CALayer()
        rightBorder.frame = CGRect(x: 0, y: 0, width: 1, height: textfield.frame.size.height)
        rightBorder.backgroundColor = color //UIColor(red:223/255,green:223/255,blue:223/255,alpha:1).cgColor
        textfield.layer.addSublayer(rightBorder)
    }
    
    func topBorderInText(textfield:UITextField,color:CGColor){
        
        let rightBorder = CALayer()
        rightBorder.frame = CGRect(x: 0, y: 0, width: textfield.frame.size.width, height: 1)
        rightBorder.backgroundColor = color//UIColor(red:223/255,green:223/255,blue:223/255,alpha:1).cgColor
        textfield.layer.addSublayer(rightBorder)
    }
    
    func bottomBorderIntext(textfield:UITextField){
        
        let rightBorder = CALayer()
        rightBorder.frame = CGRect(x: 0, y: textfield.frame.size.height-1, width: textfield.frame.size.width, height:1 )
        //        rightBorder.backgroundColor = color//UIColor(red:223/255,green:223/255,blue:223/255,alpha:1).cgColor
        textfield.layer.addSublayer(rightBorder)
    }
    
    
    func giveBottomPaddingToTextField(withTextField:UITextField){
        withTextField.leftViewMode = UITextField.ViewMode.always
        let paddingView = UIView(frame: CGRect(x:0, y:0, width:withTextField.frame.width, height:1))
        // paddingView.backgroundColor = UIColor.red
        withTextField.leftView = paddingView
        withTextField.leftViewMode = UITextField.ViewMode.always
        // globalFunctions().text_border("grayCode", textField:withTextField)
    }
    
    
    
    func saveDataToUserDefault(data:Any,key:String){
        UserDefaults.standard.set(data, forKey: key);
    }
    
    
    func getDataFromUserDefaults(key:String)->Any{
        return UserDefaults.standard.value(forKey: key) as Any;
    }
    
    func saveNotificationIdToUserDefault(data:Any,key:String){
        UserDefaults.standard.set(data, forKey: key);
    }
    
    func getNotificationIdFromUserDefault(key:String)->Any?{
        return UserDefaults.standard.value(forKey: key);
    }
    
    
    func saveFCMToken(data:Any,key:String){
        UserDefaults.standard.set(data, forKey: key);
    }
    
    func getFCMToken(key:String) -> Any? {
        return UserDefaults.standard.value(forKey: key);
    }
    
    func alertForSettings(title:String,msg:String,vc:UIViewController){
        let alertView = UIAlertController(title: title, message: msg, preferredStyle: .alert)
        let cancelAction = UIAlertAction(title: "Cancel", style: .default) { (action) in
            
        }
        
        let settingsAction = UIAlertAction(title: "Settings", style: .default) { (_) -> Void in
            
            guard let settingsUrl = URL(string: UIApplication.openSettingsURLString) else {
                return
            }
            
            if UIApplication.shared.canOpenURL(settingsUrl) {
                UIApplication.shared.open(settingsUrl, completionHandler: { (success) in
                    //                    print("Settings opened: \(success)") // Prints true
                })
            }
        }
        
        alertView.addAction(cancelAction);
        alertView.addAction(settingsAction);
        
        vc.present(alertView, animated: false, completion: nil);
    }
    
    
    
    func addShadowToView(view:UIView,shadowColor:UIColor,opacity:Float,radius:CGFloat){
        view.layer.shadowColor = shadowColor.cgColor
        view.layer.shadowOpacity = opacity
        view.layer.shadowOffset = CGSize(width: 0, height: 1)
        view.layer.shadowRadius = radius
        view.layer.masksToBounds = false
    }
    
    
    func addShadowToViewAllSidesWithCornerRadius(layer:CALayer,shadowColor:UIColor,opacity:Float,radius:CGFloat,cornerRadius:CGFloat){
        layer.cornerRadius = cornerRadius
        layer.shadowColor = shadowColor.cgColor
        layer.shadowOpacity = opacity
        layer.shadowOffset = CGSize.zero
        layer.shadowRadius = radius
        layer.masksToBounds = false
    }
    
    
    func addShadowToViewAllSides(layer:CALayer,shadowColor:UIColor,opacity:Float,radius:CGFloat){
        layer.shadowColor = shadowColor.cgColor
        layer.shadowOpacity = opacity
        layer.shadowOffset = CGSize.zero
        layer.shadowRadius = radius
        layer.masksToBounds = false
    }
    
    
    static func cardViewLayout(cardView:UIView){
        let shadowPath = UIBezierPath(roundedRect: cardView.bounds, cornerRadius: cornerRadius)
        cardView.layer.masksToBounds = false
        cardView.layer.shadowColor = shadowColorr?.cgColor
        cardView.layer.shadowOffset = CGSize(width: shadowOffsetWidth, height: shadowOffsetHeight);
        cardView.layer.shadowOpacity = opacity
        cardView.layer.shadowPath = shadowPath.cgPath
        cardView.layer.cornerRadius = cornerRadius
        
    }
    
    static func cardViewLayoutForNotifications(cardView:UIView){
        let opacityL:Float = 0.2;
        let cornerRadius: CGFloat = 10
        let shadowOffsetWidthh: Int = 0
        let shadowOffsetHeightt: Int = -1
        let shadowColr: UIColor? = UIColor.black.withAlphaComponent(0.5)
        
        let shadowPath = UIBezierPath(roundedRect: cardView.bounds, cornerRadius: cornerRadius)
        cardView.layer.masksToBounds = false
        cardView.layer.shadowColor = shadowColr?.cgColor
        cardView.layer.shadowOffset = CGSize(width: shadowOffsetWidthh, height: shadowOffsetHeightt);
        cardView.layer.shadowOpacity = opacityL
        cardView.layer.shadowPath = shadowPath.cgPath
        cardView.layer.cornerRadius = cornerRadius
        
    }
    
    
    func getAttributedPriceForPlanogramItem(str:String,str_color:String) -> NSAttributedString{
        
        let main_string = str
        let string_to_color = str_color
        
        let range = (main_string as NSString).range(of: string_to_color)
        
        let attributedString = NSMutableAttributedString.init(string: main_string)
        attributedString.addAttribute(NSAttributedString.Key.foregroundColor, value: color.price_plus_green_color , range: range)
        attributedString.addAttribute(NSAttributedString.Key.font, value: UIFont(name: CustomFont.helveticaBoldFont, size: 13.0)!, range: range)
        return attributedString
        
    }
    
    
    func getAttributedStringForTicketList(str:String,str_color:String,colorTobeUsed:UIColor = color.wallet_header_title_textColor_light) -> NSAttributedString{
        
        let main_string = str
        let string_to_color = str_color
        let range = (main_string as NSString).range(of: string_to_color)
        
        let attributedString = NSMutableAttributedString.init(string: main_string)
        attributedString.addAttribute(NSAttributedString.Key.foregroundColor, value: colorTobeUsed , range: range)
        
        if Device.IS_IPHONE_X{
            
            attributedString.addAttribute(NSAttributedString.Key.font, value: UIFont(name: CustomFont.helveticaRegularFont, size: 14.0)!, range: range)
            
        }else{
            
            attributedString.addAttribute(NSAttributedString.Key.font, value: UIFont(name: CustomFont.helveticaRegularFont, size: 12.0)!, range: range)
            
        }
        
        return attributedString
    }
    
    func getAttributedStringForCommentList(str:String,str_color:String,colorTobeUsed:UIColor = color.wallet_header_title_textColor_light) -> NSAttributedString{
        
        let main_string = str
        let string_to_color = str_color
        
        let range = (main_string as NSString).range(of: string_to_color)
        
        let attributedString = NSMutableAttributedString.init(string: main_string)
        attributedString.addAttribute(NSAttributedString.Key.foregroundColor, value: colorTobeUsed , range: range)
        attributedString.addAttribute(NSAttributedString.Key.font, value: UIFont(name: CustomFont.helveticaRegularFont, size: 11.0)!, range: range)
        return attributedString
        
    }
    
    func createGradientLayer(button:UIButton) {

    }
    
    
    func showPopup(alertType:String,vc:UIViewController,msg:String, isBackRequired:Bool = true){
        let view = CustomAlertView(frame: vc.view.frame, title: "", alertType: alertType, msgToShow:msg)
        view.okBtn.actionHandle(controlEvents: .touchUpInside) {
            view.removeFromSuperview();
            if isBackRequired{
                vc.navigationController?.popViewController(animated: true)
            }
        }
        vc.view.addSubview(view);
    }
    
    static func askUserForLocationPermissionONWindow(){
        let window = UIApplication.shared.keyWindow
        let view = CustomAlertView(frame: (window?.frame)!, title: "Location Permission Required", alertType: AlertType.alert.rawValue, msgToShow:"Please enable location access in settings.",buttonsNameDic: ["Settings","Cancel"])
        
        view.okBtn.addAction(for: .touchUpInside) {
            view.removeFromSuperview();
            UIApplication.shared.open(URL(string:UIApplication.openSettingsURLString)!)
        }
        
        view.cancelBtn.addAction(for: .touchUpInside) {
            view.removeFromSuperview();

        }
        window!.addSubview(view)
    }
    
    static func askUserForLocationPermission(vc:UIViewController){
        let alertController = UIAlertController(title: "Location Permission Required", message: "Please enable location permissions in settings.", preferredStyle: UIAlertController.Style.alert)
        
        let okAction = UIAlertAction(title: "Settings", style: .default, handler: {(cAlertAction) in
            //Redirect to Settings app
            UIApplication.shared.open(URL(string:UIApplication.openSettingsURLString)!)
        })
        
        let cancelAction = UIAlertAction(title: "Cancel", style: UIAlertAction.Style.cancel)
        alertController.addAction(cancelAction)
        alertController.addAction(okAction)
        vc.present(alertController, animated: true, completion: nil)
    }
    
    
    class var sharedInstance:CommonFunctions{
        struct sharedInstanceStruct{
            static let instance = CommonFunctions()
        }
        return sharedInstanceStruct.instance
    }
}
