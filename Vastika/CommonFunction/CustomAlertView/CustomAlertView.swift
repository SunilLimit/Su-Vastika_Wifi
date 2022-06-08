//
//  CustomAlertView.swift
//  VMConsumer
//
//  Created by Developer on 19/01/19.
//  Copyright © 2019 Developer. All rights reserved.
//

import UIKit

class CustomAlertView: UIView {

    var backgroundLayer = UIView()
    var popupView = UIView();
    var imgView = UIImageView();
    var headingLbl = UILabel();
    var msgLbl = UILabel();
    var okBtn = UIButton();
    var cancelBtn = UIButton();
    
   
    
    override init(frame: CGRect) {
        super.init(frame: frame)
//
//        self.backgroundLayer = UIView(frame: (self.bounds));
//        self.backgroundLayer.backgroundColor = UIColor.black.withAlphaComponent(0.6)
//        self.backgroundLayer.tag = 1331
//        self.addSubview(self.backgroundLayer)
     
        
    }
    
    
    
    init(frame:CGRect, title:String,alertType:String,msgToShow:String,buttonsNameDic:[String] = ["OK"]) {
        super.init(frame: frame)
        
        self.backgroundLayer = UIView(frame: (self.bounds));
        self.backgroundLayer.backgroundColor = UIColor.black.withAlphaComponent(0.6)
        self.backgroundLayer.tag = 1331
        self.addSubview(self.backgroundLayer)
    
         let heightOfText = CommonFunctions.sharedInstance.calculateHeight(inString: msgToShow, width:self.frame.width - 80, font: UIFont(name: CustomFont.helveticaRegularFont, size: 15.0)!) + 10
        
        let popUpView = UIView(frame: CGRect(x: 25, y: 100, width: self.frame.width - 50, height: CGFloat(160) + heightOfText))
        popUpView.backgroundColor = color.walletDetail_tabBarBackgroundColor;
        popUpView.layer.cornerRadius = 5.0
        popUpView.clipsToBounds = true;
        popUpView.center = self.backgroundLayer.center
        self.backgroundLayer.addSubview(popUpView);
        
        var imgIconName = "alertIcon"
        
      
        var defaultTitle = "Alert !"
        
        switch alertType {
        case AppUtils.Success: imgIconName = "goalIcon";
        defaultTitle = "Success !"
        break;
        case AppUtils.ErrorTypeTitle :  imgIconName = "alertIcon"
        defaultTitle = "Alert !"
        break;
        case AlertType.error.rawValue : imgIconName = "errorIcon"
                                        defaultTitle = "Error !"
        break;
        case AlertType.info.rawValue : imgIconName = "infoIcon"
                                       defaultTitle = "Info"
        break;
            
        default: print("test")
        break;
            
        }
        
        let imgView = UIImageView(frame: CGRect(x: popUpView.frame.width/2 - 45, y: -5, width: 90, height: 90));
        imgView.image = UIImage(named: imgIconName);
        imgView.contentMode = .center
        popUpView.addSubview(imgView);
        
        
         headingLbl = UILabel(frame: CGRect(x: 20, y: imgView.frame.maxY - 20, width: popUpView.frame.width - 40, height: 40));
        if title == "" {
            headingLbl.text = defaultTitle;

        }else{
            headingLbl.text = title;

        }
        headingLbl.textAlignment = .center;
        headingLbl.textColor = color.themeOrangeColor;
        headingLbl.font = UIFont(name: CustomFont.helveticaRegularFont, size: 17)
        popUpView.addSubview(headingLbl);
        
        
        let lineView = UIView(frame: CGRect(x: 0, y: headingLbl.frame.maxY - 5, width: popUpView.frame.width, height: 0.5))
        lineView.backgroundColor = color.line_backgroundColor;
        popUpView.addSubview(lineView)
        
        
        
        msgLbl = UILabel(frame: CGRect(x: 15, y: lineView.frame.maxY + 10, width: popUpView.frame.width - 30, height: heightOfText))
        msgLbl.textColor = color.wallet_header_title_textColor_light;
        //msgLbl.backgroundColor = color.blueColor
        msgLbl.text = msgToShow;
        msgLbl.textAlignment = .center;
        msgLbl.numberOfLines = 0
        msgLbl.lineBreakMode = .byWordWrapping
        msgLbl.font = UIFont(name: CustomFont.helveticaRegularFont, size: 15.0)
        popUpView.addSubview(msgLbl)
        
        
        
        
        okBtn = UIButton(frame: CGRect(x: popUpView.frame.width - 80, y: popUpView.frame.height - 35, width: 70, height: 30))
        okBtn.setTitle(buttonsNameDic[0], for: .normal)
        okBtn.setTitleColor(color.themeOrangeColor, for: .normal)
       // okBtn.addTarget(self, action: #selector(hideAlert), for: .touchUpInside)
        
        popUpView.addSubview(okBtn)
        
        if buttonsNameDic.count > 1 {
            cancelBtn = UIButton(frame: CGRect(x: popUpView.frame.width - 160, y: popUpView.frame.height - 35, width: 70, height: 30))
            cancelBtn.setTitle(buttonsNameDic[1], for: .normal)
            cancelBtn.setTitleColor(color.themeOrangeColor, for: .normal)
            popUpView.addSubview(cancelBtn)
        }
      
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
  

}

