//
//  DeviceMainSVC.swift
//  Vastika
//
//  Created by Sunil on 12/01/23.
//

import UIKit
import SmartGauge


class DeviceMainSVC: UIViewController {

    @IBOutlet weak var lblMode: UILabel!
    @IBOutlet weak var lblSerialNumber: UILabel!
    @IBOutlet weak var lblTime: UILabel!
    @IBOutlet weak var lblVolt: UILabel!
    @IBOutlet weak var imgBattery: UIImageView!
    @IBOutlet weak var lblBattery: UILabel!
    @IBOutlet weak var imgGrid: UIImageView!
    @IBOutlet weak var imgSolar: UIImageView!
    @IBOutlet weak var lblGridSolar: UILabel!
    @IBOutlet weak var lblTotalChargingPower: UILabel!
    @IBOutlet weak var imgSingleGrid: UIImageView!
    @IBOutlet weak var lblSingleGrid: UILabel!
    @IBOutlet weak var imgSolarEnergy: UIImageView!
    @IBOutlet weak var lblSolarEnergy: UILabel!
    @IBOutlet weak var btnSetting: UIButton!
    @IBOutlet weak var gaugeView: SmartGauge!
    
    var dicrDta = NSDictionary()

    
    // MARK: - View Life Cycle
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
        self.otherTitleName(isFrom: "")
        self.setupGaugeView()
        self.lblVolt.text = String(dcbus!) + "v"
        self.updateDataForMainsMode()
        // Do any additional setup after loading the view.
    }
    
    func updateDataForMainsMode()
    {
        
        // battery setup
        let battery_percent = self.dicrDta.object(forKey: "battery_percent") as? String
        let bw = self.dicrDta.object(forKey: "bw") as? String
        if (battery_percent == "100.00" && bw == "0.00") {
                self.lblBattery.text = "Battery: " + battery_percent! + "%"
        } else if    (battery_percent?.toDouble() == 100.00 && (bw?.toDouble())! > 0.00) {
                   self.lblBattery.text = "Battery: 99 %"
        } else if (battery_percent != "100.00" && (bw?.toDouble())! > 0.00) {
                    self.lblBattery.text = " Battery:" + battery_percent! + "%"
               }
        else
        {
            self.lblBattery.text = " Battery:" + battery_percent! + "%"
        }
        
        if (battery_percent?.toDouble())! > 80.00
        {
            self.imgBattery.loadGif(name: "battery")
        }
        else if (battery_percent?.toDouble())! < 50.00 && (battery_percent?.toDouble())! < 79
        {
            self.imgBattery.loadGif(name: "medium_battery")
        }
        else
        {
            self.imgBattery.loadGif(name: "low_battery")
        }
        
        // Charge sharing power
        let pvw = self.dicrDta.object(forKey: "pvw") as? String
        
        var totalCharging: Double = (bw?.toDouble())! + (pvw?.toDouble())!
        self.lblTotalChargingPower.text =  "Total Charging Power " + String(totalCharging) + "W"
        
        let chargeSharing = self.dicrDta.object(forKey: "charge_sharing") as? NSArray
        let ch1 = (chargeSharing![0] as AnyObject).description.toDouble()
        let ch2 = (chargeSharing![1] as AnyObject).description.toDouble()

        var gridSolar = "Grid = " + String(ch1!)
        if ch1 == 0.00
        {
            self.imgGrid.image = UIImage(named: "grid")
        }
        else
        {
            self.imgGrid.loadGif(name: "grid")
        }
        gridSolar = gridSolar + ",Solar = " + String(ch1!) + "%"
        if ch2 == 0.00
        {
            self.imgSolar.image = UIImage(named: "solar_status_off")
        }
        else
        {
            self.imgSolar.image = UIImage(named: "solar_status_on")
        }
        
        self.lblGridSolar.text = gridSolar
        
        // Grid charging power
        
        self.lblSingleGrid.text = "Grid Charging Power : " + bw! + " W"
        
        if (bw?.toDouble())! <= 0.0 && battery_percent?.toDouble() == 100.00
        {
            self.imgSingleGrid.image = UIImage(named: "grid")
        }
        else if (bw?.toDouble())! <= 0.0 && battery_percent?.toDouble() != 100.00
        {
            self.imgSingleGrid.image = UIImage(named: "grid")
        }
        else if (bw?.toDouble())! > 0.0
        {
            self.imgSingleGrid.loadGif(name: "grid")
        }
        
        // solar energy
        
        let attrsSE1 = [NSAttributedString.Key.font : UIFont(name: "HelveticaNeue", size: 14), NSAttributedString.Key.foregroundColor : UIColor.darkGray]
        let attrsSE2 = [NSAttributedString.Key.font : UIFont(name: "HelveticaNeue-Bold", size: 14), NSAttributedString.Key.foregroundColor : UIColor.init(red: 240.0/255.0, green: 183.0/255.0, blue: 73.0/255.0, alpha: 1.0)]
        let attributedStringSE1 = NSMutableAttributedString(string:"Solar Energy : ", attributes:attrsSE1 as [NSAttributedString.Key : Any])
       
        
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
    }
    
    func setupGaugeView() {
        
        let mipv = self.dicrDta.object(forKey: "mipv") as? String
        
        gaugeView.numberOfMajorTicks = 4
        gaugeView.numberOfMinorTicks = 0
        
        gaugeView.gaugeAngle = 60
        gaugeView.gaugeValue = CGFloat(mipv!.floatValue)
        gaugeView.valueFont = UIFont.systemFont(ofSize: 10, weight: .thin)
        gaugeView.gaugeTrackColor = UIColor.white
        gaugeView.enableLegends = false
        gaugeView.gaugeViewPercentage = 1
        gaugeView.legendSize = CGSize(width: 25, height: 20)
        if let font = CTFontCreateUIFontForLanguage(.system, 30.0, nil) {
            gaugeView.legendFont = font
        }
        gaugeView.coveredTickValueColor = UIColor.darkGray
        
        let first = SGRanges("80 - 140", fromValue: 0, toValue: 20, color: GaugeRangeColorsSet.first)
        let second = SGRanges("140 - 170", fromValue: 20, toValue: 40, color: GaugeRangeColorsSet.second)
        let third = SGRanges("170 - 250", fromValue: 40, toValue: 80, color: GaugeRangeColorsSet.third)
        let fourth = SGRanges("250 - 300", fromValue: 80, toValue: 90, color: GaugeRangeColorsSet.fourth)
       
        
        gaugeView.rangesList = [first, second, third, fourth]
        gaugeView.gaugeMaxValue = fourth.toValue
        gaugeView.enableRangeColorIndicator = true
    }
    
    
    @IBAction func tapSetting(_ sender: Any) {
    }
    
    func otherTitleName(isFrom : String)
    {
            //self.lblMode.text = "UPS Mode (Mains Fail)"
        let inverter_type = self.dicrDta.object(forKey: "inverter_type") as? String
        let dvcId = self.dicrDta.object(forKey: "device_id") as? String
        let userDetails = UserDefaults.standard.object(forKey: "user") as? NSDictionary
        let name = userDetails?.object(forKey: "name") as? String
        
        if (inverter_type == "1"){
            self.lblSerialNumber.text = name! + " (Brainy S)" + " - " + dvcId!
        }else  if (inverter_type == "2"){
            self.lblSerialNumber.text = name! +  " (Falcon HBU)" + " - " + dvcId!
        }else  if (inverter_type == "3"){
            self.lblSerialNumber.text = name! + " (Fusion I)" + " - " + dvcId!
        }else  if (inverter_type == "4"){
            self.lblSerialNumber.text  = name! +  " (Eco Brainy)" + " - " + dvcId!
        }else if (inverter_type == "5"){
            self.lblSerialNumber.text  = name! + " (Falcon++)" + " - " + dvcId!
        }else{
            self.lblSerialNumber.text = name! + " (Falcon+)" + " - " + dvcId!
        }
    }
    
    @IBAction func tapBack(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
}

struct GaugeRangeColorsSet {
    static var first: UIColor   { return UIColor.red }
    static var second: UIColor  { return UIColor.init(red: 240.0/255.0, green: 183.0/255.0, blue: 73.0/255.0, alpha: 1.0) }
    static var third: UIColor   { return UIColor.systemGreen }
    static var fourth: UIColor  { return UIColor.red }
    
    static var all: [UIColor] = [first, second, third, fourth]
}
