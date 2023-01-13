//
//  DeviceBLEVC.swift
//  Vastika
//
//  Created by Sunil on 11/01/23.
//

import UIKit
import SwiftyGif
import SwiftGifOrigin


class DeviceBLEVC: UIViewController {

    @IBOutlet weak var btnSetting: UIButton!
    @IBOutlet weak var lblMode: UILabel!
    @IBOutlet weak var lblName: UILabel!
    @IBOutlet weak var lblTime: UILabel!
    @IBOutlet weak var lblVolt: UILabel!
    @IBOutlet weak var imgSwitch: UIImageView!
    @IBOutlet weak var lblSwitch: UILabel!
    @IBOutlet weak var imgBattery: UIImageView!
    @IBOutlet weak var lblBattery: UILabel!
    @IBOutlet weak var imgUPSStatus: UIImageView!
    @IBOutlet weak var lblSolarSatsus: UILabel!
    @IBOutlet weak var imgSolarEnergy: UIImageView!
    @IBOutlet weak var lblSolarEnergy: UILabel!
    @IBOutlet weak var imgGreenBattery: UIImageView!
    @IBOutlet weak var lblGreenBattery: UILabel!
    @IBOutlet weak var imgLoadWattage: UIImageView!
    @IBOutlet weak var lblWalltege: UILabel!
    
    var dicrDta = NSDictionary()
    
    ///
    override func viewDidLoad() {
        super.viewDidLoad()

        self.btnSetting.layer.cornerRadius = self.btnSetting.frame.size.height / 2
        self.btnSetting.clipsToBounds = true
        
        
        let statusUPS = self.dicrDta.object(forKey: "status_ups") as? String
        let statusMains = self.dicrDta.object(forKey: "status_mains") as? String
        
        let pvw = self.dicrDta.object(forKey: "pvw") as? String
        let bw = self.dicrDta.object(forKey: "bw") as? String

        let dcbus = self.dicrDta.object(forKey: "dcbus") as? String
        
        if statusUPS == "1" && statusMains == "0"
        {
            self.lblMode.text = "UPS Mode (Main Fail)"
            self.otherTitleName(isFrom: "UPS Mode (Main Fail)")
        }
        else if statusUPS == "0" && statusMains == "1"
        {
            if pvw == "0.0" && bw == "0.0"
            {
                self.lblMode.text = "Solar Mode"
            }
            else
            {
                self.lblMode.text = "Mains Mode"
            }
        }
        
        self.lblVolt.text = String(dcbus!) + "v"
        self.updatedDataForUPSMode()
        // Do any additional setup after loading the view.
    }
    
    
    func updatedDataForUPSMode()
    {
        let attrsSwitch1 = [NSAttributedString.Key.font : UIFont(name: "HelveticaNeue", size: 14), NSAttributedString.Key.foregroundColor : UIColor.darkGray]
        let attrsSwitch2 = [NSAttributedString.Key.font : UIFont(name: "HelveticaNeue-Bold", size: 14), NSAttributedString.Key.foregroundColor : UIColor.black]
        let attributedStringSwitch1 = NSMutableAttributedString(string:"Reset Switch : ", attributes:attrsSwitch1 as [NSAttributedString.Key : Any])
     
        // reset switch
        let resetSwitch = self.dicrDta.object(forKey: "status_front_switch") as? String
        if resetSwitch == "1"
        {
            self.imgSwitch.image = UIImage(named: "switchoff")
            let attributedStringSwitch2 = NSMutableAttributedString(string:"Off", attributes:attrsSwitch2 as [NSAttributedString.Key : Any])
            attributedStringSwitch1.append(attributedStringSwitch2)
            self.lblSwitch.attributedText = attributedStringSwitch1
        }
        else
        {
            self.imgSwitch.image = UIImage(named: "switchon")
            let attributedStringSwitch2 = NSMutableAttributedString(string:"On", attributes:attrsSwitch2 as [NSAttributedString.Key : Any])
            attributedStringSwitch1.append(attributedStringSwitch2)
            self.lblSwitch.attributedText = attributedStringSwitch1
        }
        
        
        // Battery section for ups mode
        let battery = self.dicrDta.object(forKey: "setting_grid_charging") as? String
        var strBattry = String()
        switch (battery) {
              case "1":
                strBattry = "25Ah"
                break;
              case "2":
                strBattry = "50Ah"
                  break;
              case "3":
                strBattry = "100Ah"
                break;
              case "4":
                strBattry = "150Ah"
                break;
              case "5":
                strBattry = "25Ah"
                break;
              case "6":
                strBattry = "50Ah"
                break;
              case "7":
                strBattry = "100Ah"
                break;
              case "8":
                strBattry = "150Ah"
                break;
              default:
                strBattry = "--"
                break;
            }
          
        let batteryType = self.dicrDta.object(forKey: "setting_battery_type") as? String
        var strBattryType = String()
        switch (batteryType) {
              case "1":
                strBattryType = "Tubular"
                self.imgBattery.image = UIImage(named: "tubular")
                break;
              case "2":
                strBattryType = "Sealed Maintenance Free"
                self.imgBattery.image = UIImage(named: "sealed_maintenance_free")
                  break;
              case "3":
                strBattryType = "Lithium Ion"
                self.imgBattery.image = UIImage(named: "lithium_Ion")
                break;
              case "4":
                strBattryType = "Lead Acid"
                self.imgBattery.image = UIImage(named: "lead_acid")
                break;
              case "5":
                strBattryType = "Tubular"
                self.imgBattery.image = UIImage(named: "tubular")
                break;
              case "6":
                strBattryType = "Sealed Maintenance Free"
                self.imgBattery.image = UIImage(named: "sealed_maintenance_free")
                break;
              case "7":
                strBattryType = "Lithium Ion"
                self.imgBattery.image = UIImage(named: "lithium_Ion")
                break;
              default:
                strBattryType = "Lead Acid"
                self.imgBattery.image = UIImage(named: "lead_acid")
                break;
            }
        
        self.lblBattery.text = strBattry + " " + strBattryType
        
        
        // system status
        
        let attrs1 = [NSAttributedString.Key.font : UIFont(name: "HelveticaNeue", size: 14), NSAttributedString.Key.foregroundColor : UIColor.darkGray]
        let attrs2 = [NSAttributedString.Key.font : UIFont(name: "HelveticaNeue-Bold", size: 14), NSAttributedString.Key.foregroundColor : UIColor.black]
        let attributedString1 = NSMutableAttributedString(string:"System Status : ", attributes:attrs1 as [NSAttributedString.Key : Any])
                
        let systemStatus = self.dicrDta.object(forKey: "status_ups") as? String
        if systemStatus == "0"
        {
            self.imgUPSStatus.image = UIImage(named: "system_status_off")
            let attributedString2 = NSMutableAttributedString(string:"UPS Off", attributes:attrs2 as [NSAttributedString.Key : Any])
            attributedString1.append(attributedString2)
            self.lblSolarSatsus.attributedText = attributedString1
        }
        else
        {
            self.imgUPSStatus.image = UIImage(named: "system_status_on")
            let attributedString2 = NSMutableAttributedString(string:"UPS On", attributes:attrs2 as [NSAttributedString.Key : Any])
            attributedString1.append(attributedString2)
            self.lblSolarSatsus.attributedText = attributedString1
        }
        
        // load wattege
        
        let loadwatge = self.dicrDta.object(forKey: "load_wattage") as? String

        if loadwatge == "2" || loadwatge == "7" || loadwatge == "8"
        {
            self.imgLoadWattage.loadGif(name: "lw-error")
            self.lblWalltege.text = "load Wattage : " + loadwatge! + " W"
        }
        else
        {
            // set two image condition
            self.imgLoadWattage.image = UIImage(named: "bulb_grey")
            self.lblWalltege.text = "load Wattage : " + loadwatge! + " W"

        }
        
        // solar energy
        
        let attrsSE1 = [NSAttributedString.Key.font : UIFont(name: "HelveticaNeue", size: 14), NSAttributedString.Key.foregroundColor : UIColor.darkGray]
        let attrsSE2 = [NSAttributedString.Key.font : UIFont(name: "HelveticaNeue-Bold", size: 14), NSAttributedString.Key.foregroundColor : UIColor.init(red: 240.0/255.0, green: 183.0/255.0, blue: 73.0/255.0, alpha: 1.0)]
        let attributedStringSE1 = NSMutableAttributedString(string:"Solar Energy : ", attributes:attrsSE1 as [NSAttributedString.Key : Any])
       
        
        let pvw = self.dicrDta.object(forKey: "pvw") as? String
        if pvw == "0.00"
        {
            self.imgSolarEnergy.image = UIImage(named: "solar_status_off")
            let attributedStringSE2 = NSMutableAttributedString(string:"0 W", attributes:attrsSE2 as [NSAttributedString.Key : Any])
            attributedStringSE1.append(attributedStringSE2)
            self.lblSolarEnergy.attributedText = attributedStringSE1
        }
        else
        {
            self.imgSolarEnergy.image = UIImage(named: "solar_status_on")
            let attributedStringSE2 = NSMutableAttributedString(string:pvw! + " W", attributes:attrsSE2 as [NSAttributedString.Key : Any])
            attributedStringSE1.append(attributedStringSE2)
            self.lblSolarEnergy.attributedText = attributedStringSE1
        }
        
        // green battery
        let bvBattery = self.dicrDta.object(forKey: "bv") as? String
        let bwBattery = self.dicrDta.object(forKey: "bw") as? String
        self.imgGreenBattery.image = UIImage(named: "battery")
        
        self.lblGreenBattery.text = bvBattery! + " | " + bwBattery!
    }
    
    func otherTitleName(isFrom : String)
    {
            //self.lblMode.text = "UPS Mode (Mains Fail)"
        let inverter_type = self.dicrDta.object(forKey: "inverter_type") as? String
        let dvcId = self.dicrDta.object(forKey: "device_id") as? String
        let userDetails = UserDefaults.standard.object(forKey: "user") as? NSDictionary
        let name = userDetails?.object(forKey: "name") as? String
        
        if (inverter_type == "1"){
            self.lblName.text = name! + " (Brainy S)" + " - " + dvcId!
        }else  if (inverter_type == "2"){
            self.lblName.text = name! +  " (Falcon HBU)" + " - " + dvcId!
        }else  if (inverter_type == "3"){
            self.lblName.text = name! + " (Fusion I)" + " - " + dvcId!
        }else  if (inverter_type == "4"){
            self.lblName.text  = name! +  " (Eco Brainy)" + " - " + dvcId!
        }else if (inverter_type == "5"){
            self.lblName.text  = name! + " (Falcon++)" + " - " + dvcId!
        }else{
            self.lblName.text = name! + " (Falcon+)" + " - " + dvcId!
        }
    }
    
    @IBAction func tapBack(_ sender: Any) {
        self.navigationController?.popViewController(animated: true
        )
    }
    
   

}
