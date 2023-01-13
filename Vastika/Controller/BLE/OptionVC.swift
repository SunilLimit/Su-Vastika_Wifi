//
//  OptionVC.swift
//  Vastika
//
//  Created by Sunil on 23/12/22.
//

import UIKit

class OptionVC: UIViewController {

    @IBOutlet weak var connectView: UIView!
    @IBOutlet weak var innerView: UIView!
    @IBOutlet weak var txtFieldSSID: UITextField!
    @IBOutlet weak var txtFieldPass: UITextField!
    @IBOutlet weak var btnSUbmit: UIButton!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.btnSUbmit.layer.cornerRadius = self.btnSUbmit.frame.size.height / 2
        self.btnSUbmit.clipsToBounds = true
        
        self.innerView.layer.cornerRadius = 30
        self.innerView.clipsToBounds = true
        
        self.navigationController?.setStatusBar(backgroundColor: Device.common_header_Color)
        self.navigationController?.setToolbarHidden(true, animated: true)
        // Do any additional setup after loading the view.
    }
    
    @IBAction func tapClose(_ sender: Any) {
        self.connectView.isHidden = true
    }
    
    @IBAction func tapBLE(_ sender: Any) {
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        appDelegate.isFrom = "BLE"
        if let vcToPresent = self.storyboard!.instantiateViewController(withIdentifier: "HomeVC") as? HomeVC{
            self.navigationController?.pushViewController(vcToPresent, animated: true);
        }
       // appDelegate.setHomeVieew()
    }
    
    @IBAction func tapSubmit(_ sender: Any) {
    }
    
    
    @IBAction func tapCLoud(_ sender: Any) {
        //self.connectView.isHidden = false
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        appDelegate.isFrom = "WIFI"
        if let vcToPresent = self.storyboard!.instantiateViewController(withIdentifier: "HomeVC") as? HomeVC{
            self.navigationController?.pushViewController(vcToPresent, animated: true);
        }
    }
    
}
