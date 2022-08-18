//
//  DemoVC.swift
//  Vastika
//
//  Created by Mac on 24/09/21.
//

import UIKit
import WebKit



class DemoVC: UIViewController {
    
    var viewModel = DeviceDetailsViewModel()
    var deviceDetails = [DeviceDetailsModel]()
    var deviceid = String()
    @IBOutlet weak var webkit: WKWebView!
    @IBOutlet weak var lblTitle: UILabel!
    @IBOutlet weak var btnAlert: UIButton!
    @IBOutlet weak var btnSetting: UIButton!
    @IBOutlet weak var btnDiagones: UIButton!
    @IBOutlet weak var btnSaving: UIButton!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let dict = UserDefaults.standard.object(forKey: "user") as? NSDictionary
        let token = dict?.object(forKey: "token") as? String
        webServices.token = token!
        let url = "http://52.66.155.48/device/" + self.deviceid + "/ios?token=" + webServices.token
        print(url)
        let link = URL(string:url)!
        let request = URLRequest(url: link)
        self.webkit.load(request)
        self.getDeviceDeetails()

        self.btnAlert.layer.cornerRadius = self.btnAlert.frame.size.height/2
        self.btnAlert.clipsToBounds = true
        
        self.btnSaving.layer.cornerRadius = self.btnSaving.frame.size.height/2
        self.btnSaving.clipsToBounds = true
        
        self.btnSetting.layer.cornerRadius = self.btnSetting.frame.size.height/2
        self.btnSetting.clipsToBounds = true
        
        self.btnDiagones.layer.cornerRadius = self.btnDiagones.frame.size.height/2
        self.btnDiagones.clipsToBounds = true
        // Do any additional setup after loading the view.
    }
    

    func getDeviceDeetails()
    {
      
        if !Reachability.isConnectedToNetwork()
        {
            let alert = UIAlertController(title: webServices.AppName, message: "Internet connection is not available. Please check your internet.", preferredStyle: UIAlertController.Style.alert)
            alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { (action) in
               
            }))
            self.present(alert, animated: true, completion: nil)
            return
        }
        
        self.viewModel.deviceDetails(deviceId: self.deviceid, viewController: self, isLoaderRequired: true) { [self] status, obj in
            if status == "Success"
            {
                self.deviceDetails.removeAll()
                self.deviceDetails.append(obj)
               
                DispatchQueue.main.async {
                    self.setupDetails(obj: obj)
                }

            }
            else
            {
            }
        }
    }
    
    func setupDetails(obj : DeviceDetailsModel)
    {
       
        
        if obj.status_ups == 1 && obj.status_mains == 0
        {
        
            self.lblTitle.text = "UPS Mode (Mains Fail)"
        }
        else if obj.status_ups == 0 && obj.status_mains == 1
        {
            
            
            if obj.pvw > 0 && obj.bw == 0
            {
                self.lblTitle.text = "Solar Mode"
            }
            else
            {
                self.lblTitle.text = "Main Mode (Mains Present)"
            }
        }
        else if obj.status_ups == 0 && obj.status_mains == 0
        {
            self.lblTitle.text = "Device Offline"
        }
        
    }
    
    
    
    @IBAction func tapBack(_ sender: Any) {
        //self.gameTimer?.invalidate()
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func tapAlert(_ sender: Any) {
        if let vcToPresent = self.storyboard!.instantiateViewController(withIdentifier: "AlertVC") as? AlertVC{
            vcToPresent.deviceeId = self.deviceid
            self.navigationController?.pushViewController(vcToPresent, animated: true)
        }
    }
    
    @IBAction func tapDiagnose(_ sender: Any) {
        if let vcToPresent = self.storyboard!.instantiateViewController(withIdentifier: "DeviceDiagonsisVC") as? DeviceDiagonsisVC{
            self.navigationController?.pushViewController(vcToPresent, animated: true)
        }
    }
    
    @IBAction func tapSetting(_ sender: Any) {
        if let vcToPresent = self.storyboard!.instantiateViewController(withIdentifier: "SettingVC") as? SettingVC{
            vcToPresent.deviceId = self.deviceid
            self.navigationController?.pushViewController(vcToPresent, animated: true)
        }
    }
    
    @IBAction func tapTotalSaving(_ sender: Any) {
        if let vcToPresent = self.storyboard!.instantiateViewController(withIdentifier: "PriceVC") as? PriceVC{
            vcToPresent.deviceId = self.deviceid
            self.navigationController?.pushViewController(vcToPresent, animated: true)
        }
    }
}
