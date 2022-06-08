//
//  FloatingTextFieldCustomization.swift
//  VMConsumer
//
//  Created by Developer on 25/10/18.
//  Copyright © 2018 Developer. All rights reserved.
//

import Foundation
import UIKit
import SkyFloatingLabelTextField

class FloatingTextFieldCustomization{


     let lineColor = UIColor(red: 0, green: 0, blue: 0, alpha: 1.0)
     let selectedLineColor = UIColor(red: 0, green: 0, blue: 0, alpha: 1.0)
     let errorColor = UIColor.red
     let selectedTitleColor = UIColor(red: 30/255.0, green: 64/255.0, blue: 120/255.0, alpha: 1.0)
     let titleColor = UIColor(red: 30/255.0, green: 64/255.0, blue: 120/255.0, alpha: 1.0)
    
    
    
     func CustomizeTextField(txttfield:[SkyFloatingLabelTextField]){
        
        for textfield in txttfield{
            textfield.lineHeight = CommonFunctions.lineHeightForTF;
            textfield.lineColor = color.textFiledTitleColor;
            textfield.textColor = color.textFiledTextColor;
            textfield.selectedTitleColor = color.textFiledTitleColor;
            textfield.selectedLineColor = color.textFiledTitleColor;
             textfield.titleColor = color.textFiledTitleColor;
            
             if(Device.IS_IPHONE_X){
                
                textfield.font = UIFont.systemFont(ofSize: 15)
                textfield.titleFont = UIFont.systemFont(ofSize: 15.0)
                
            }
//            textfield.font = UIFont(name: CustomFont.helveticaLightFont, size: 15.0);
//            textfield.titleFont = UIFont(name: CustomFont.helveticaRegularFont, size: 14.0)!
            
        }
        
       
        
    }
    


}
