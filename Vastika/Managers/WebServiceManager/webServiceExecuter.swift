


import Foundation
import Alamofire
import SwiftyJSON


class webServiceExecuter{
    var webServiceRequestObject:Alamofire.DataRequest?
    var webServiceAuthenticateObject:AnyObject?
    var jsonResponse:Any?
    
    
    func executeRequest(_ url:String,param:[String:AnyObject],serviceType:String,header:[String:String]?,withVC:UIViewController?,completionHandler:@escaping (_ jsonResponse:Any)->Void){
        LogUtils.showLog(msg:"param..\(param)")
        
        var headerr = header
        if header != [:]{
            headerr?.updateValue("\(webServices.preToken) \(webServices.token)", forKey: "authorization")
        }
        webServiceRequestObjectCreator(url, param: param, serviceType: serviceType,header: headerr){
            (requestObject:Alamofire.DataRequest?) in
            //   requestObject!.authenticate(user: webServices.user, password: webServices.password)
            
            print("request obj:- \(requestObject)")
            requestObject?.responseJSON{ res in
                
                let statusCode = res.response?.statusCode
                print("res: \(String(describing: statusCode))")
                LogUtils.showLog(msg:"StatusCode...\(String(describing: statusCode))")
                
                
                let json = JSON( res.result.value as AnyObject)
                
                switch res.result{
                case .success( _):
                    
                    if(statusCode! != 401){
                        webServiceExecuter.sharedInstance.jsonResponse = res.result.value as AnyObject
                        completionHandler(webServiceExecuter.sharedInstance.jsonResponse!)
                    }else{
                        
                        if statusCode != nil && statusCode! == 401{
                            webServiceExecuter.sharedInstance.jsonResponse = ["errorMessage":Message.token_Expire] as AnyObject
                            completionHandler(webServiceExecuter.sharedInstance.jsonResponse!)
                        }
                        //here handle 401
                    }
                    break
                    
                case .failure(let err):
                    
                    if statusCode != nil &&  statusCode! == 401{
                        webServiceExecuter.sharedInstance.jsonResponse = ["errorMessage":Message.server_unavailable] as AnyObject
                        //  self.sendUserToLoginAgain(vc: withVC)
                    }else{
                        print("failure")
                        print("error:- \(err.localizedDescription)");
                        LogUtils.showLog(msg:"failure")
                        if err.localizedDescription == "The Internet connection appears to be offline."{
                            webServiceExecuter.sharedInstance.jsonResponse = ["errorMessage":err.localizedDescription] as AnyObject
                        }else if statusCode == nil{
                            webServiceExecuter.sharedInstance.jsonResponse = ["errorMessage":Message.server_unavailable] as AnyObject
                        }else{
                            webServiceExecuter.sharedInstance.jsonResponse = ["errorMessage":Message.server_unavailable] as AnyObject
                        }
                        
                        completionHandler(webServiceExecuter.sharedInstance.jsonResponse!)
                    }
                    break
                }
            }
        }
    }
    
    
   
    func webServiceRequestObjectCreator(_ url:String,param:[String:AnyObject] = [:],serviceType:String,header:[String:String]?,completionHandler:(_ requestObject:Alamofire.DataRequest?)->Void){
        
        
        
        switch serviceType {
        case "post":
            
            webServiceExecuter.sharedInstance.webServiceRequestObject = Alamofire.request(url,method:.post,parameters: param,encoding:JSONEncoding.default,headers:header)
            completionHandler(webServiceRequestObject)
            break
        case "getQuery":
            webServiceExecuter.sharedInstance.webServiceRequestObject =        Alamofire.request(url,method:.get,parameters: param,encoding:URLEncoding.queryString,headers:header)
            
            completionHandler(webServiceRequestObject)
            break
            
        case "get":
            webServiceExecuter.sharedInstance.webServiceRequestObject =        Alamofire.request(url,method:.get,headers:header)
            
            completionHandler(webServiceRequestObject)
            break
            
        case "put":
            webServiceExecuter.sharedInstance.webServiceRequestObject =          Alamofire.request(url,method:.put,parameters: param,encoding:JSONEncoding.default,headers:header)
            
            completionHandler(webServiceRequestObject)
            break
            
        case "delete":
            webServiceExecuter.sharedInstance.webServiceRequestObject =          Alamofire.request(url,method:.delete,parameters: param,encoding:JSONEncoding.default,headers:header)
            
            completionHandler(webServiceRequestObject)
            break
            
        default:
            LogUtils.showLog(msg:"Invalid type of service webservice should be .get/.post/.put/ .delete")
            
            break
        }
        
    }
    
    class var sharedInstance:webServiceExecuter{
        struct sharedInstanceStruct{
            static let instance = webServiceExecuter()
        }
        return sharedInstanceStruct.instance
    }
    
}
    
   
    
   
    
    
    
    
    
    
    
    

