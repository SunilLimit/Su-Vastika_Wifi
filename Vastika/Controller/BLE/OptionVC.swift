//
//  OptionVC.swift
//  Vastika
//
//  Created by Sunil on 23/12/22.
//

import UIKit
import SystemConfiguration.CaptiveNetwork
import AVFoundation

class OptionVC: UIViewController {

    @IBOutlet weak var connectView: UIView!
    @IBOutlet weak var innerView: UIView!
    @IBOutlet weak var txtFieldSSID: UITextField!
    @IBOutlet weak var txtFieldPass: UITextField!
    @IBOutlet weak var btnSUbmit: UIButton!
    var ssidDetails = String()
    @IBOutlet weak var btmView: UIView!
    @IBOutlet weak var lblHeader: UILabel!
    @IBOutlet weak var lblWifi: UILabel!
    @IBOutlet weak var lblBluethooth: UILabel!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.btnSUbmit.layer.cornerRadius = self.btnSUbmit.frame.size.height / 2
        self.btnSUbmit.clipsToBounds = true
        
        self.innerView.layer.cornerRadius = 30
        self.innerView.clipsToBounds = true
        
        self.btmView.layer.cornerRadius = 50
        self.btmView.clipsToBounds = true
        
        self.btmView.roundCorners([.topLeft, .topRight], radius: 50)
        
        
        self.lblHeader.font = UIFont(name: "Montserrat-Medium", size: 16)
        self.lblWifi.font = UIFont(name: "Montserrat-Medium", size: 16)
        self.lblBluethooth.font = UIFont(name: "Montserrat-Medium", size: 16)


        
        self.txtFieldSSID.text = "limitless_unifi"
        self.txtFieldPass.text = "L@mit123"
        
        self.navigationController?.setStatusBar(backgroundColor: Device.common_header_Color)
        self.navigationController?.setToolbarHidden(true, animated: true)
        
        let ssid = self.getAllWiFiNameList()
        
        
        
        
        // Do any additional setup after loading the view.
    }
    
    func getAllWiFiNameList() -> String? {
                var ssid: String?
                if let interfaces = CNCopySupportedInterfaces() as NSArray? {
                for interface in interfaces {
                if let interfaceInfo = CNCopyCurrentNetworkInfo(interface as! CFString) as NSDictionary? {
                            ssid = interfaceInfo[kCNNetworkInfoKeySSID as String] as? String
                            break
                        }
                    }
                }
                return ssid
            }
    
    
    @IBAction func tapClose(_ sender: Any) {
       
        
        self.connectView.isHidden = true
    }
    
    @IBAction func tapBLE(_ sender: Any) {
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        appDelegate.isFrom = "WIFI"
        self.connectView.isHidden = false
    }
    
    @IBAction func tapSubmit(_ sender: Any) {
        self.ssidDetails = "~" + self.txtFieldSSID.text! +  "~"
        self.ssidDetails = self.ssidDetails + self.txtFieldPass.text! + "~"
        if let vcToPresent = self.storyboard!.instantiateViewController(withIdentifier: "AvailableBLEVC") as? AvailableBLEVC{
            vcToPresent.ssid = self.ssidDetails
            self.navigationController?.pushViewController(vcToPresent, animated: true);
        }
        
        
    }
    
    
    @IBAction func tapCLoud(_ sender: Any) {
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        appDelegate.isFrom = "BLE"
        if let vcToPresent = self.storyboard!.instantiateViewController(withIdentifier: "AvailableBLEVC") as? AvailableBLEVC{
            self.navigationController?.pushViewController(vcToPresent, animated: true);
        }
        
    }
    
}


extension UIView {

    func roundCorners(_ corners: UIRectCorner, radius: CGFloat) {
        if #available(iOS 11.0, *) {
            clipsToBounds = true
            layer.cornerRadius = radius
            layer.maskedCorners = CACornerMask(rawValue: corners.rawValue)
        } else {
            let path = UIBezierPath(
                roundedRect: bounds,
                byRoundingCorners: corners,
                cornerRadii: CGSize(width: radius, height: radius)
            )
            let mask = CAShapeLayer()
            mask.path = path.cgPath
            layer.mask = mask
        }
    }
}
