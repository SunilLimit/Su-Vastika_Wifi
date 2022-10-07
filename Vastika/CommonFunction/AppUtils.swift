//
//  AppUtils.swift
//  VMConsumer
//
//  Created by Developer on 17/12/18.
//  Copyright © 2018 Developer. All rights reserved.
//

import Foundation
import Kingfisher
import SwiftyJSON


enum OrderStatus:String{
    case ORDER_UNPAID_VALUE = "7"
    case ORDER_CLOSED_VALUE = "1"
    case ORDER_INITIATED_VALUE = "2"
    case ORDER_CANCELLED_VALUE = "4"
    case ORDER_PENDING_VALUE = "8"
   
}

enum AlertType:String{
    case success = "Success"
    case alert = "alert"
    case error = "error"
    case info = "info"
}


enum TicketLookUpDataType:String{
    case Category = "Category"
    case SubCategory = "alert"
    case Status = "Status"
    case Priority = "Priority"
}


enum ResponseStatus:String{
    case Api_Success = "success"
    case Api_Failure = "fail"
}


class AppUtils{

    //decimal digits to be shown
    static var decimalDigits = 2;
    
    // alert title variables
    static var AlertTypeTitle = "Alert !";
    static var ErrorTypeTitle = "Error !"
    static var SuccessAlertType = "Success"
    static var paymentSuccessAlertType = "Payment Successful !";
    static var paymentFailedAlertType = "Payment Failed !";
    
    static var rechargeSuccessAlertType = "Recharge Successful !";
    static var rechargeFailedAlertType = "Recharge Failed !";
    static var transferSuccessAlertType = "Transfer Successsful !"
    
    //api response
    static let Success = "Success";
    static let alert = "Alert !"
    
    static let FCMToken = "FcmToken"

    
    // keys to save data in preferences
    static let isLoggedIn = "isLogin";
    static let save_UserInfo = "user_info";
    static let walletDetail = "walletDetail";
    static let wallet = "wallet";
    static let token = "token";
    static let userPassword = "password";
    static let userEmailId = "email";
    static let notificationId = "notificationId";
    static let fcmToken = "fcmToken"
    
    // wallet list constant variables
    
    static let availabl_balance = "Balance : "
    static let rupeeSymbol = "₹ ";
    static let percentageSymbol = "%";
    
    //notifications
    static let refreshTransactionList = Notification.Name("refreshTransaction");
    static let swipeOccurs = Notification.Name("swipeViewController");
    static let moveToCart = Notification.Name("showCart");
    static let moveToIndex = Notification.Name("moveToIndex");
    
    
     static let TICKET_STATUS_RESOLVED_TXT   = "Resolved";
     static let TICKET_STATUS_PENDING_TXT   = "Pending";
     static let TICKET_STATUS_INPROGRESS_TXT = "Progress";
     static let TICKET_STATUS_CREATED_TXT   = "Created";
 
  
    
    
  
    
    
   
    
   
    
    static func resetDefaults(isRemoveLoginCredentials:Bool) {
    webServices.token = "";
        let defaults = UserDefaults.standard
        let dictionary = defaults.dictionaryRepresentation()
        dictionary.keys.forEach { key in
            
            if isRemoveLoginCredentials{
                defaults.removeObject(forKey: key)

            }else{
                if key != AppUtils.userPassword && key != AppUtils.userEmailId{
                    defaults.removeObject(forKey: key)
                }
            }
        }
    }
    
    
    //func to convert double to string with decimal formatter
    static func doubleToString(doubleValue:Double)-> String{
        
       return String(format: "%.\(decimalDigits)f", doubleValue)
    }
    
    static func doubleToStringForWeight(doubleValue:Double)-> String{
        return String(format: "%.0f", doubleValue)
    }
    
    
    static func stringWithDecimalFormatter(value:String)->String{
        return String(format: "%.\(decimalDigits)f", value);
    }
    
    
    static func transactionDateFormatter(date:String) -> String{
        let dateFormatter = DateFormatter();
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss" // receiving date format
        
        if let convertToDate = dateFormatter.date(from: date){
            dateFormatter.dateFormat = "dd MMM yyyy | hh:mm a"
            let formattedDate = dateFormatter.string(from: convertToDate);
            //print("formatted date:- \(formattedDate)");

            return formattedDate;

        }
                
        return "";
    }
    
    
    static func offersDateFormatter(date:String) -> String{
        let dateFormatter = DateFormatter();
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss" // receiving date format
        
        if let convertToDate = dateFormatter.date(from: date){
            dateFormatter.dateFormat = "dd MMM, yyyy"
            let formattedDate = dateFormatter.string(from: convertToDate);
            //print("formatted date:- \(formattedDate)");
            
            return formattedDate;
            
        }
        
        return "";
    }
    
    
    static func ticketsDateFormatter(date:String) -> String{
        let dateFormatter = DateFormatter();
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.ssss" // receiving date format
        
        if let convertToDate = dateFormatter.date(from: date){
            dateFormatter.dateFormat = "dd MMM, yyyy"
            let formattedDate = dateFormatter.string(from: convertToDate);
            //print("formatted date:- \(formattedDate)");
            
            return formattedDate;
            
        }
        
        return "";
    }
    
    static func getDateFromNewShowFormate(strDate : String)-> String
    {
        let dateFormatter = DateFormatter();
        dateFormatter.dateFormat = "yyyy-MM-dd"
        if let convertToDate = dateFormatter.date(from: strDate){
            dateFormatter.dateFormat = "dd-MM-yyyy"
            let formattedDate = dateFormatter.string(from: convertToDate);
            return formattedDate;
        }
        return ""
    }
    
    static func getDateFromString(dateString:String,format:String) -> Date{
        
        let dateformatter = DateFormatter();
        dateformatter.dateFormat = format
//        dateformatter.locale = Locale(identifier: "en_US_POSIX")
//        dateformatter.timeZone = TimeZone(abbreviation: "GMT+5:30")
        let date = dateformatter.date(from: dateString)
        print("date:- \(date)")
        return date!
    }
    
    
    static func isValidDateFormat(date:String)-> Bool{
        let dateFormatter = DateFormatter();
        dateFormatter.dateFormat = "dd MMM, yyyy" // receiving date format
        
        if let convertToDate = dateFormatter.date(from: date){
//            dateFormatter.dateFormat = "yyyy-MM-dd"
//            let formattedDate = dateFormatter.string(from: convertToDate);
//            //print("formatted date:- \(formattedDate)");
            if convertToDate != nil{
                return true;

            }else{
                return false;

            }
            
        }
        return false;
    }
    
    static func formatFilterDate(date:String,isReverse:Bool) -> String{
        let dateFormatter = DateFormatter();
        
        if isReverse{
            dateFormatter.dateFormat = "dd MMM, yyyy" // receiving date format
            
            if let convertToDate = dateFormatter.date(from: date){
                dateFormatter.dateFormat = "yyyy-MM-dd"
                let formattedDate = dateFormatter.string(from: convertToDate);
                //print("formatted date:- \(formattedDate)");
                
                return formattedDate;
                
            }
        }else{
            dateFormatter.dateFormat = "yyyy-MM-dd" // receiving date format
            
            if let convertToDate = dateFormatter.date(from: date){
                dateFormatter.dateFormat = "dd MMM, yyyy"
                let formattedDate = dateFormatter.string(from: convertToDate);
                //print("formatted date:- \(formattedDate)");
                
                return formattedDate;
                
            }
        }
       
        
        return "";
    }
    
    
    static func getDayFromDate(date:String,isRequiredDayOnly:Bool) -> String{
        
        let formatter  = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss"
        guard let todayDate = formatter.date(from: date) else { return "" }
        
        if(isRequiredDayOnly){
            let myCalendar = Calendar(identifier: .gregorian)
            let weekDay = myCalendar.component(.day, from: todayDate)
            return "\(weekDay)"
        }else{
            
            formatter.dateFormat = "MMM yyyy  HH:mm";
            let requiredDate = formatter.string(from: todayDate);
            return requiredDate;
            
        }
      
        
    }
    
    
    static func getCurrenTimeStamp() -> String{
    
        let date = Date();
        let dateFormatter = DateFormatter();
        dateFormatter.dateFormat = "yyyyMMddHHmmss";
        return dateFormatter.string(from: date)
    }
    
    
    static func getDateFromMonthBefore()-> String{
        
        let date = Date();
        let dateFormatter = DateFormatter();
        dateFormatter.dateFormat = "yyyy-MM-dd";
        
        let dateOneMonthAgo = Calendar(identifier: .gregorian).date(byAdding: .day, value: -30, to: date)
        
        if dateOneMonthAgo != nil{
            
            return dateFormatter.string(from: dateOneMonthAgo!);
        }
        
        return "";
    }
    
    static func getDateFromMonthBeforeForTransactionHistory()-> String{
        
        let date = Date();
        let dateFormatter = DateFormatter();
        dateFormatter.dateFormat = "dd MMM, yyyy";
        
        let dateOneMonthAgo = Calendar(identifier: .gregorian).date(byAdding: .day, value: -30, to: date)
        
        if dateOneMonthAgo != nil{
            
            return dateFormatter.string(from: dateOneMonthAgo!);
        }
        
        return "";
    }
    
    static func getCurrentDate() -> String{
        let date = Date();
        let dateFormatter = DateFormatter();
        dateFormatter.dateFormat = "yyyy-MM-dd";
   
        return dateFormatter.string(from: date)
    }
    
    
    static func getCurrentDateForTransactionHistory() -> String{
        let date = Date();
        let dateFormatter = DateFormatter();
        dateFormatter.dateFormat = "dd MMM, yyyy";
        
        return dateFormatter.string(from: date)
    }
    
    static func getDateForPaymentInfo(paymentDate:String) -> String{
        
        let dateFormatter = DateFormatter();
        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss" // receiving date format
        
        if let convertToDate = dateFormatter.date(from: paymentDate){
            dateFormatter.dateFormat = "dd MMM, yyyy | hh:mm a"
            let formattedDate = dateFormatter.string(from: convertToDate);
            //print("formatted date:- \(formattedDate)");
            
            return formattedDate;
            
        }
        
        return "";
    }
    
    static func getOrderStatus(status:String) -> String{
        
        if status == OrderStatus.ORDER_UNPAID_VALUE.rawValue{
            return "Unpaid";
        }else if status == OrderStatus.ORDER_PENDING_VALUE.rawValue{
            return "View Pending";
        }
        else if status == OrderStatus.ORDER_INITIATED_VALUE.rawValue{
            return "Open";
        }
        else if status == OrderStatus.ORDER_CLOSED_VALUE.rawValue{
            return "Closed";
        }
        
        return "Cancel";
    }

    
    static func calculateApiVersion(apiUrl:String)->String{
       // let specificUrl = apiUrl.components(separatedBy: webServices.baseUrl)
        //add switch here to return api_version according to url
        return "1.0"
    }
    
    
    
    
}
