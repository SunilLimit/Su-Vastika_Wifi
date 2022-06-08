//
//  textFieldValidator.swift
//  VMConsumer
//
//  Created by Developer on 25/10/18.
//  Copyright © 2018 Developer. All rights reserved.
//

import Foundation
class textFieldValidator{
    
    func isValidEmailId(emailId email:String) -> Bool{
        
        let emailFormat =  "[A-Za-z0-9._%+-]{1,}+(\\.[_A-Za-z0-9-]+)*@"
            + "[A-Za-z0-9-]+(\\.[A-Za-z0-9]+)*(\\.[A-Za-z]{2,})$"
        let emailPredicate = NSPredicate(format:"SELF MATCHES %@", emailFormat)
        return emailPredicate.evaluate(with: email)
    }
    
    func isValidName(userName name:String) -> Bool{
        let nameFormat =  "^[A-Za-z\\s]{1,}[\\.]{0,1}[A-Za-z\\s]{0,}$";
        let namePredicate = NSPredicate(format:"SELF MATCHES %@", nameFormat)
        return namePredicate.evaluate(with: name)
    }
    
    func isValidPhoneNumber(PhoneNumber phno:String) ->Bool{
        
        let badcharacters = CharacterSet.decimalDigits.inverted
        
        let ph = phno.split(separator: "-");
        
        if(ph.count > 1){
            guard ph[1].rangeOfCharacter(from: badcharacters) == nil else { return false}
            if  ph[1].count == 10 {
                return true
            }
            else{return false}
        }else{
            return true;
        }
    }

    func isValidMobileNumber(PhoneNumber phno:String) ->Bool{
        
        let badcharacters = CharacterSet.decimalDigits.inverted
        
        
            guard phno.rangeOfCharacter(from: badcharacters) == nil else { return false}
            if  phno.count == 10 {
                return true
            }
            else{
                return false
                
        }
       
    }
    
    
    
    
    
    
    
    func isValidPassword(Password passText:String)->Bool
    {
        let emailFormat = "[A-Za-z0-9@#$&%*!]{1,}"
        let emailPredicate = NSPredicate(format:"SELF MATCHES %@", emailFormat)
        return emailPredicate.evaluate(with: passText) && passText.count > 5
        
    }
    
    
    
    class var sharedInstance:textFieldValidator{
        struct sharedInstanceStruct{
            static let instance = textFieldValidator()
        }
        return sharedInstanceStruct.instance
    }
}
