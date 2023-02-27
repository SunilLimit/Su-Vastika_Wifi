//
//  DeviceMainSVC.swift
//  Vastika
//
//  Created by Sunil on 12/01/23.
//

import UIKit
import CoreBluetooth
import Toast_Swift  
import GDGauge
import AVFoundation
import Foundation

class DeviceMainSVC: UIViewController {

    @IBOutlet weak var lblMode: UILabel!
    @IBOutlet weak var lblSerialNumber: UILabel!
    @IBOutlet weak var lblTime: UILabel!
    @IBOutlet weak var secGuageView: UIView!
    @IBOutlet weak var lblSingleGrid: UILabel!
    @IBOutlet weak var btnSetting: UIButton!
    @IBOutlet weak var gaugeView: UIView!
    @IBOutlet weak var btnDiagnos: UIButton!
    @IBOutlet weak var btmView: UIView!
    
    @IBOutlet weak var lblVoltForFreq: UILabel!
    @IBOutlet weak var inputFrequencyView: UIView!
    @IBOutlet weak var boostView: UIView!
    @IBOutlet weak var batteryTypeView: UIView!
    @IBOutlet weak var gridView: UIView!
    @IBOutlet weak var voltageView: UIView!
    @IBOutlet weak var batteryView: UIView!
    @IBOutlet weak var imgBattery: UIImageView!
    @IBOutlet weak var lblBattery: UILabel!
    @IBOutlet weak var imgGrid: UIImageView!
    @IBOutlet weak var imgBatteryType: UIImageView!
    @IBOutlet weak var lblBatteryType: UILabel!
    @IBOutlet weak var imgBosst: UIImageView!
    @IBOutlet weak var imgATC: UIImageView!
    @IBOutlet weak var lblBoost: UILabel!
    @IBOutlet weak var lblHeaderTitle: UILabel!
    @IBOutlet weak var lblATC: UILabel!
    var priousError : String = "0"
    var errorCounter : Int = 0
    @IBOutlet weak var btmHeight: NSLayoutConstraint!
    var arrayCAl = [String]()
    var counterBatterypercent : Int = 0
    let appDelegate = UIApplication.shared.delegate as! AppDelegate
    fileprivate var services : [CBService]?
    var properties : CBCharacteristicProperties?
    @IBOutlet weak var lblTextATC: UILabel!
    let bluetoothManager = BluetoothManager.getInstance()
    var peripheral: CBPeripheral!
    
    var timerforMode : Timer!

    var counter = 1
    var timer : Timer!

    var dicrDta = NSDictionary()
    var outerBezelColor = UIColor(red: 0, green: 0.5, blue: 1, alpha: 1)
    var outerBezelWidth: CGFloat = 10

    var innerBezelColor = UIColor.white
    var innerBezelWidth: CGFloat = 5

    var insideColor = UIColor.white
    var getErrorString = String()

    var firstView : GaugeVWP!
    var secView : GaugeView!
    var highAlert : Bool = false

    
    // MARK: - View Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.otherTitleName(isFrom: "UPS Mode (Main Fail)")
        self.btnSetting.layer.cornerRadius = self.btnSetting.frame.size.height / 2
        self.btnSetting.clipsToBounds = true
        self.btmHeight.constant = 0
        self.btnDiagnos.layer.cornerRadius = self.btnDiagnos.frame.size.height / 2
        self.btnDiagnos.clipsToBounds = true
        
        self.gaugeView.backgroundColor = .clear
        self.secGuageView.backgroundColor = .clear
        

        let statusUPS = self.dicrDta.object(forKey: "status_ups") as? String
        let statusMains = self.dicrDta.object(forKey: "status_mains") as? String
        let errorN = self.dicrDta.object(forKey: "status_error") as? String
        var commintErrorCode = String()
        let eror10 = errorN?.contains("10")
        if eror10 == true
        {
            commintErrorCode = "10"
        }
        
        let eror11 = errorN?.contains("11")
        if eror11 == true
        {
            commintErrorCode = "11"

        }
       
        //"months":"23","Days":"29","hours":"22","minutes":"46"

        let mon = self.dicrDta.object(forKey: "months") as? String
        let day = self.dicrDta.object(forKey: "Days") as? String
        let hr = self.dicrDta.object(forKey: "hours") as? String
        let min = self.dicrDta.object(forKey: "minutes") as? String
        var strHeader = String()
        strHeader = "M:" + mon! + "D:" + day!
        strHeader = strHeader + " | " + hr!
        strHeader = strHeader + ":" + min!
        self.lblHeaderTitle.text = strHeader
        
        
        if statusUPS == "1" && statusMains == "0"
        {
            self.lblMode.text = "UPS Mode (Main Fail)"
           
            if let vcToPresent = self.storyboard!.instantiateViewController(withIdentifier: "DeviceBLEVC") as? DeviceBLEVC{
                vcToPresent.dicrDta = self.appDelegate.globalDict
                self.navigationController?.pushViewController(vcToPresent, animated: true)
            }
        }
        else if statusUPS == "0" && statusMains == "1" && commintErrorCode == "10"
        {
            if let vcToPresent = self.storyboard!.instantiateViewController(withIdentifier: "DeviceBLEVC") as? DeviceBLEVC{
                vcToPresent.dicrDta = self.appDelegate.globalDict
                self.navigationController?.pushViewController(vcToPresent, animated: true)
            }
        }
        else if statusUPS == "0" && statusMains == "1" && commintErrorCode == "11"
        {
            if let vcToPresent = self.storyboard!.instantiateViewController(withIdentifier: "DeviceBLEVC") as? DeviceBLEVC{
                vcToPresent.dicrDta = self.appDelegate.globalDict
                self.navigationController?.pushViewController(vcToPresent, animated: true)
            }
        }
        else  if statusUPS == "1" && statusMains == "1"
        {
            self.lblMode.text = "UPS Mode (Main Fail)"
            if let vcToPresent = self.storyboard!.instantiateViewController(withIdentifier: "DeviceBLEVC") as? DeviceBLEVC{
                vcToPresent.dicrDta = self.appDelegate.globalDict
                self.navigationController?.pushViewController(vcToPresent, animated: true)
            }
        }
        else  if statusUPS == "0" && statusMains == "0"
        {
            self.lblMode.text = "UPS Mode (Main Fail)"
            if let vcToPresent = self.storyboard!.instantiateViewController(withIdentifier: "DeviceBLEVC") as? DeviceBLEVC{
                vcToPresent.dicrDta = self.appDelegate.globalDict
                self.navigationController?.pushViewController(vcToPresent, animated: true)
            }
        }

        self.updateDataForMainsMode()
        
        self.firstView = GaugeVWP(frame: CGRect(x: 0, y:20, width: 161, height: 129))
        self.firstView.backgroundColor = .white
        self.gaugeView.addSubview(self.firstView)
       
       
        self.secView = GaugeView(frame: CGRect(x: 0, y: 35, width: 160, height: 80))
        self.secGuageView.addSubview(self.secView)
        
        self.secView
            .setupGuage(
                startDegree: 90,
                endDegree: 270,
                sectionGap: 10,
                minValue: 30,
                maxValue: 70
            )
            .setupContainer(options: [
                .showContainerBorder
            ])
            .setupUnitTitle(title: "")
            .buildGauge()
        
        
        self.gettingErrorCode()
        
        
        // Do any additional setup after loading the view.
    }
    
    @IBAction func tapThreeDot(_ sender: UIButton) {
        sender.isSelected = !sender.isSelected
        if sender.isSelected == true{
            self.btmHeight.constant = 50
        }
        else
        {
            self.btmHeight.constant = 0
        }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        self.timer.invalidate()
        self.timerforMode.invalidate()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.makeRounded(vw: self.voltageView)
        self.makeRounded(vw: self.inputFrequencyView)
        self.makeRounded(vw: self.batteryView)
        self.makeRounded(vw: self.batteryTypeView)
        self.makeRounded(vw: self.gridView)
        self.makeRounded(vw: self.boostView)
        self.timer = Timer.scheduledTimer(timeInterval: 1.0, target: self, selector: #selector(updateCounter), userInfo: nil, repeats: true)
        self.timerforMode = Timer.scheduledTimer(timeInterval: 3.0, target: self, selector: #selector(updateMode), userInfo: nil, repeats: true)
        self.setUpBatteryAndBoostVoltage()
    }
    
    func setUpBatteryAndBoostVoltage()
    {
        
        if self.appDelegate.batteryName == "Tubular"
        {
            self.imgBatteryType.image = UIImage(named: "tubular")
            self.imgATC.isHidden = false
            self.lblATC.isHidden = false
            self.lblTextATC.isHidden = false
        }
        else if self.appDelegate.batteryName == "Lithium Ion"
        {
            self.imgATC.isHidden = true
            self.lblATC.isHidden = true
            self.lblTextATC.isHidden = true
            self.imgBatteryType.image = UIImage(named: "lithium_Ion")
        }
        else
        {
            self.imgBatteryType.image = UIImage(named: "sealed_maintenance_free")
            self.imgATC.isHidden = false
            self.lblATC.isHidden = false
            self.lblTextATC.isHidden = false
        }
        
        self.lblBatteryType.text =  self.appDelegate.batteryName
    }
    
    @objc func updateMode() {
        self.dicrDta = self.appDelegate.globalDict
        let statusUPS = self.dicrDta.object(forKey: "status_ups") as? String
        let statusMains = self.dicrDta.object(forKey: "status_mains") as? String
        let errorN = self.dicrDta.object(forKey: "status_error") as? String
        if errorCounter == 6
        {
            self.gettingErrorCode()
            errorCounter = 0
        }
        else
        {
            errorCounter = errorCounter + 3
        }
        var commintErrorCode = String()
        let eror10 = errorN?.contains("10")
        if eror10 == true
        {
            commintErrorCode = "10"
        }
        
        let eror11 = errorN?.contains("11")
        if eror11 == true
        {
            commintErrorCode = "11"

        }
       

        self.otherTitleName(isFrom: "UPS Mode (Main Fail)")
        if statusUPS == "1" && statusMains == "0"
        {
            self.lblMode.text = "UPS Mode (Main Fail)"
           
            if let vcToPresent = self.storyboard!.instantiateViewController(withIdentifier: "DeviceBLEVC") as? DeviceBLEVC{
                vcToPresent.dicrDta = self.appDelegate.globalDict
                self.navigationController?.pushViewController(vcToPresent, animated: true)
            }
        }
        else if statusUPS == "0" && statusMains == "1" && commintErrorCode == "10"
        {
            if let vcToPresent = self.storyboard!.instantiateViewController(withIdentifier: "DeviceBLEVC") as? DeviceBLEVC{
                vcToPresent.dicrDta = self.appDelegate.globalDict
                self.navigationController?.pushViewController(vcToPresent, animated: true)
            }
        }
        else if statusUPS == "0" && statusMains == "1" && commintErrorCode == "11"
        {
            if let vcToPresent = self.storyboard!.instantiateViewController(withIdentifier: "DeviceBLEVC") as? DeviceBLEVC{
                vcToPresent.dicrDta = self.appDelegate.globalDict
                self.navigationController?.pushViewController(vcToPresent, animated: true)
            }
        }
        else  if statusUPS == "1" && statusMains == "1"
        {
            self.lblMode.text = "UPS Mode (Main Fail)"
            if let vcToPresent = self.storyboard!.instantiateViewController(withIdentifier: "DeviceBLEVC") as? DeviceBLEVC{
                vcToPresent.dicrDta = self.appDelegate.globalDict
                self.navigationController?.pushViewController(vcToPresent, animated: true)
            }
        }
        else  if statusUPS == "0" && statusMains == "0"
        {
            self.lblMode.text = "UPS Mode (Main Fail)"
            if let vcToPresent = self.storyboard!.instantiateViewController(withIdentifier: "DeviceBLEVC") as? DeviceBLEVC{
                vcToPresent.dicrDta = self.appDelegate.globalDict
                self.navigationController?.pushViewController(vcToPresent, animated: true)
            }
        }

        self.updateDataForMainsMode()
        
    }
    
    func createErrorString(error : String) -> String
    {
        let statusUPS = self.dicrDta.object(forKey: "status_ups") as? String
        let statusMains = self.dicrDta.object(forKey: "status_mains") as? String
        
            if (error == "0"){
                self.getErrorString = ""
                }else if (error == "1"){
                    self.getErrorString = "UPS sense Short-cicuit happened please check the wiring"
                    // coming
                    self.highAlert = true
                }else if (error == "2"){
                    self.getErrorString = "Short-circuit shutdown please reset the reset switch"
                    //coming
                    self.highAlert = true
                }else if (error == "3"){
                    self.getErrorString = "Battery low warning, Please reduce the Load"
                    //coming
                    self.highAlert = true
                }else if (error == "4"){
                    self.getErrorString = "Battery low cutoff warning, please wait for the Mains Grid to come back"
                    
                }else if (error == "5"){
                    self.getErrorString = "Battery High Warning, the UPS will switch off automatically"
                    //coming
                    self.highAlert = true
                }else if (error == "6"){
                    self.getErrorString = "Battery high shutdown please turn on UPS after 2 minutes."
                }else if (error == "7"){
                    self.getErrorString = "Overload status, please reduce the load"
                    //coming
                    self.highAlert = true
                }else if (error == "8"){
                    self.getErrorString = "Overload shutdown status, please reset the front switch"
                    //coming
                    self.highAlert = true
                }else if (error == "9"){
                    self.getErrorString = "Mains MCB trip please reduce the load & lift the MCB from the back panel."
                    //coming
                    self.highAlert = true
                }else if statusMains == "1" && error == "10" && statusUPS == "1"
                {
                    self.getErrorString = "Mains Voltage is very low shifted to UPS Mode, pls check the Mains power"
                }
                else if statusMains == "0" && error == "10" && statusUPS == "1"
                {
                    self.getErrorString = "Mains grid Failed  "
                }
                else if statusMains == "0" && error == "10" && statusUPS == "0"
                {
                    self.getErrorString = "Mains Grid Failed & Front switch is off mode,Pls switch on the front switch"
                }
                else if (error == "11"){
                    self.getErrorString = "Mains Grid voltage is very high shifted to UPS Mode."
                }else if (error == "12"){
                    self.getErrorString = "Solar High Voltage"
                }else if (error == "13"){
                    self.getErrorString = "Solar High Current"
                }
                else if (error == "14"){
                    self.getErrorString = "The Input and Output wiring connections are reversed pls correct the wiring"
                    //coming
                    self.highAlert = true
                }
        return self.getErrorString
       
    }
    
    func gettingErrorCode()
    {
        let error = self.dicrDta.object(forKey: "status_error") as? String
        if error == nil || error == "" || error == " " || ((error?.isEmpty) == nil)
        {
            return
        }
        let ernp = error?.contains(",")
        if ernp == false
        {
            if error == "0"
            {
                return
            }
            print("single")
            self.priousError = error!
            var completeError = String()
            let statusFrontOff = self.dicrDta.object(forKey: "status_front_switch") as? String
//            if statusFrontOff == "0"
//            {
//                completeError = completeError + "Front switch is off so please turn ON switch to get the power." + "\n"
//                completeError = completeError + self.createErrorString(error: error!)
//                self.view.makeToast(completeError)
//            }
//            else
//            {
//                self.view.makeToast(self.createErrorString(error: error!))
//            }
           
            
            self.view.makeToast(self.createErrorString(error: error!))
            if self.appDelegate.audioActive == 1
            {
                let systemSoundID: SystemSoundID = 1315
                AudioServicesPlaySystemSound (systemSoundID)
            }
            
        }
        else
        {
            print("multipal")
            let newCollectError = error?.split(separator: ",")
            let newCodeError = NSMutableString()
            let newCodeErrorString = NSMutableString()

            for erorN in newCollectError!
            {
                newCodeErrorString.append(self.createErrorString(error: String(erorN)))
                newCodeErrorString.append("\n")
                newCodeError.append(String(erorN))
            }
            print(newCodeError)
            print(newCodeErrorString)
   
            self.priousError = String(newCodeError)
            var completeError = String()
            let statusFrontOff = self.dicrDta.object(forKey: "status_front_switch") as? String
//            if statusFrontOff == "0"
//            {
//                completeError = completeError + "Front switch is off so please turn ON switch to get the power." + "\n"
//                completeError = completeError + String(newCodeErrorString)
//                self.view.makeToast(completeError)
//            }
//            else
//            {
//                self.view.makeToast(self.createErrorString(error: error!))
//            }
            
            self.view.makeToast(self.createErrorString(error: error!))
            
            self.view.makeToast(String(newCodeErrorString))
            
            if self.appDelegate.audioActive == 1
            {
                let systemSoundID: SystemSoundID = 1315
                AudioServicesPlaySystemSound (systemSoundID)
            }
            
        }
    }
    
    func makeRounded(vw: UIView)
    {
        vw.layer.cornerRadius = 20
        vw.layer.borderWidth = 1
        vw.layer.borderColor = UIColor.init(red: 239.0/255.0, green: 239.0/255.0, blue: 239.0/255.0, alpha: 1.0).cgColor
        vw.clipsToBounds = true
    }
    
    @objc func updateCounter() {
        //example functionality
        if counter > 0 {
            print("\(counter) seconds to the end of the world")
            counter += 1
            var sec : Int = 0
            var min : Int = 0
            var hr  : Int = 0
            
            sec = counter % 60
            min = counter / 60
            hr = min / 60
            var timerTime : String = ""
            if hr == 0
            {
                timerTime = "00:"
            }
            else
            {
                if hr < 10
                {
                    timerTime = timerTime + "0" + String(hr) + ":"
                }
                else
                {
                    timerTime = timerTime + String(hr) + ":"
                }
            }
            if min == 0
            {
                timerTime = timerTime + "00:"
            }
            else
            {
                if min < 10
                {
                    timerTime = timerTime + "0" + String(min) + ":"
                }
                else
                {
                    timerTime = timerTime + String(min) + ":"
                }
                
            }
            
            if sec < 10
            {
                timerTime = timerTime + "0" + String(sec)
                self.lblTime.text = timerTime
            }
            else
            {
                timerTime = timerTime + String(sec)
                self.lblTime.text = timerTime
            }
        }
    }
    
    
    func updateDataForMainsMode()
    {
        let mon = self.dicrDta.object(forKey: "months") as? String
        let day = self.dicrDta.object(forKey: "Days") as? String
        let hr = self.dicrDta.object(forKey: "hours") as? String
        let min = self.dicrDta.object(forKey: "minutes") as? String
        var strHeader = String()
        strHeader = "M:" + mon! + "D:" + day!
        strHeader = strHeader + " | " + hr!
        strHeader = strHeader + ":" + min!
        self.lblHeaderTitle.text = strHeader
        
        
        let battery_percent = self.dicrDta.object(forKey: "battery_percent") as? String
        let bw = self.dicrDta.object(forKey: "bw") as? String
        
        if self.counterBatterypercent == 5
        {
            
            var ind = 0
            for item in self.arrayCAl
            {
                if ind == 4
                {
                    continue
                }
                self.arrayCAl[ind] =  self.arrayCAl[ind + 1]
                ind = ind + 1
            }
            self.arrayCAl.removeLast()
            self.arrayCAl.append(battery_percent!)
            print(self.arrayCAl)
            var avgValue : Double = 0
            for item in self.arrayCAl
            {
                avgValue = avgValue + Double(item)!
            }
            
            avgValue = avgValue / Double(self.arrayCAl.count)
            print(avgValue)
            // battery setup
            if (battery_percent == "100.00" && bw == "0.00") {
                    self.lblBattery.text =  battery_percent! + "%"
            } else if    (battery_percent?.toDouble() == 100.00 && (bw?.toDouble())! > 0.00) {
                       self.lblBattery.text = "99 %"
            } else if (battery_percent != "100.00" && (bw?.toDouble())! > 0.00) {
                        self.lblBattery.text =  battery_percent! + "%"
                   }
            else
            {
                self.lblBattery.text =  battery_percent! + "%"
            }
        }
        else
        {
            self.arrayCAl.append(battery_percent!)
            print(self.arrayCAl)
            self.counterBatterypercent = self.counterBatterypercent + 1
            self.lblBattery.text = "Updating"
        }
      
        
        if (battery_percent?.toDouble())! == 100.00
        {
            self.imgBattery.image = UIImage(named: "battery_full")
        }
        else if (battery_percent?.toDouble())! > 80.00
        {
            self.imgBattery.loadGif(name: "battery")
        }
        else if (battery_percent?.toDouble())! < 50.00 && (battery_percent?.toDouble())! < 79
        {
            self.imgBattery.loadGif(name: "battery")
        }
        else
        {
            self.imgBattery.loadGif(name: "battery")
        }
        
        
        
        // Charge sharing power
        let pvw = self.dicrDta.object(forKey: "pvw") as? String
        
        let totalCharging: Double = (bw?.toDouble())! + (pvw?.toDouble())!
        let intCharing = Int(totalCharging)
        self.lblSingleGrid.text =   String(intCharing) + " W"
        
        
        // Grid charging power
        if battery_percent == "100.00"
        {
            self.imgGrid.loadGif(name: "comGridImg")
        }
        else
        {
            self.imgGrid.loadGif(name: "chargingGrid")
        }
       
//        if (bw?.toDouble())! <= 0.0 && battery_percent?.toDouble() == 100.00
//        {
//            self.imgGrid.image = UIImage(named: "grid_charging_CR")
//        }
//        else if (bw?.toDouble())! <= 0.0 && battery_percent?.toDouble() != 100.00
//        {
//            self.imgGrid.image = UIImage(named: "grid_charging_CR")
//        }
//        else if (bw?.toDouble())! > 0.0
//        {
//            self.imgGrid.loadGif(name: "grid_charging_CR")
//        }
        
        
        let bosstValue = self.dicrDta.object(forKey: "Boost_Voltage") as? String
        self.lblBoost.text = String(format: "%.1f", (bosstValue?.toDouble())!) + " V"
        
        self.imgBosst.image = UIImage(named: "boost_CR")
        
        
        let batteryType = self.dicrDta.object(forKey: "setting_battery_type") as? String
        var strBattryType = String()
        strBattryType = self.appDelegate.batteryName
//        switch (batteryType) {
//              case "1":
//                strBattryType = "Tubular"
//                self.imgBatteryType.image = UIImage(named: "tubular")
//                self.imgATC.isHidden = false
//                self.lblATC.isHidden = false
//                self.lblTextATC.isHidden = false
//                break;
//              case "2":
//                strBattryType = "Sealed Maintenance Free"
//                self.imgBatteryType.image = UIImage(named: "sealed_maintenance_free")
//                self.imgATC.isHidden = false
//                self.lblATC.isHidden = false
//                self.lblTextATC.isHidden = false
//                  break;
//              case "3":
//                strBattryType = "Lithium Ion"
//                self.imgBatteryType.image = UIImage(named: "lithium_Ion")
//                self.imgATC.isHidden = true
//                self.lblATC.isHidden = true
//                self.lblTextATC.isHidden = true
//                break;
//              case "4":
//                strBattryType = ""
//                self.imgBatteryType.image = UIImage(named: "tubular")
//                self.imgATC.isHidden = false
//                self.lblATC.isHidden = false
//                self.lblTextATC.isHidden = false
//                break;
//              case "5":
//                strBattryType = "Tubular"
//                self.imgBatteryType.image = UIImage(named: "tubular")
//                self.imgATC.isHidden = false
//                self.lblATC.isHidden = false
//                self.lblTextATC.isHidden = false
//                break;
//              case "6":
//                strBattryType = "Sealed Maintenance Free"
//                self.imgBatteryType.image = UIImage(named: "sealed_maintenance_free")
//                self.imgATC.isHidden = false
//                self.lblATC.isHidden = false
//                self.lblTextATC.isHidden = false
//                break;
//              case "7":
//                self.imgATC.isHidden = true
//                self.lblATC.isHidden = true
//                self.lblTextATC.isHidden = true
//                strBattryType = "Lithium Ion"
//                self.imgBatteryType.image = UIImage(named: "lithium_Ion")
//                break;
//              default:
//            self.imgATC.isHidden = true
//            self.lblATC.isHidden = true
//            self.lblTextATC.isHidden = true
//            strBattryType = "Lithium Ion"
//            self.imgBatteryType.image = UIImage(named: "lithium_Ion")
//                break;
//            }
//
//        self.lblBatteryType.text =  strBattryType
//
//
        
        let atcValue = self.dicrDta.object(forKey: "at") as? String
        let cmpV = Int((atcValue?.toDouble())!)
        let secV = Double(cmpV / 10)
        let ftValue = Double(cmpV % 10)
        
        let boostValue =  14.85 - Float(secV * 0.18) - Float(ftValue * 0.018)
        if strBattryType == "Lithium Ion"
        {
            self.lblBoost.text = String(14.44) + " V"
        }
        else
        {
            self.lblBoost.text = String(format: "%.2f", (boostValue)) + " V"
        }
        
        self.imgATC.image = UIImage(named: "169367")
        self.lblATC.text = String(atcValue!) + "℃"
        
        let mipv = self.dicrDta.object(forKey: "mipv") as? String
        let voltageInt = Float((mipv?.floatValue.rounded())!)
        
        let inputfre = self.dicrDta.object(forKey: "Input_Frequency_Value") as? String
        var freVoltage = Float((inputfre?.floatValue.rounded())!)
        freVoltage = freVoltage - 15.0

        if Int((inputfre?.floatValue.rounded())!) < 50
        {
            self.lblVoltForFreq.text = "50 Hz"
        }
        else if Int((inputfre?.floatValue.rounded())!) > 60
        {
            self.lblVoltForFreq.text = "60 Hz"
        }
        else
        {
            self.lblVoltForFreq.text = (inputfre!) + " Hz"
        }
        
        
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                    UIView.animate(withDuration: 1) {
                        self.secView.updateValueTo(CGFloat((freVoltage ?? 0.0)))
                        
//                        self.secView.value = Int(freVoltage)
                    }
                }
        
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                    UIView.animate(withDuration: 1) {
                        self.firstView.value = Int(voltageInt)
                    }
                }
    }
    
    @IBAction func tapDiagnose(_ sender: Any) {
        if let vcToPresent = self.storyboard!.instantiateViewController(withIdentifier: "DeviceDiagonsisVC") as? DeviceDiagonsisVC{
            vcToPresent.isFrom = "BLE"
            self.navigationController?.pushViewController(vcToPresent, animated: true)
        }
    }
    
    @IBAction func tapSetting(_ sender: Any) {
        if let vcToPresent = self.storyboard!.instantiateViewController(withIdentifier: "SettingVC") as? SettingVC{
            vcToPresent.dicrDetails = self.dicrDta
            self.navigationController?.pushViewController(vcToPresent, animated: true)
        }
    }
    
    func otherTitleName(isFrom : String)
    {
            //self.lblMode.text = "UPS Mode (Mains Fail)"
        let inverter_type = self.dicrDta.object(forKey: "inverter_type") as? String
        let dvcId = self.dicrDta.object(forKey: "device_id") as? String
        let userDetails = UserDefaults.standard.object(forKey: "user") as? NSDictionary
        let name = ""
        
        if (inverter_type == "1"){
            self.lblSerialNumber.text = "S/No.:" +  (dvcId ?? "")
        }else  if (inverter_type == "2"){
            self.lblSerialNumber.text = "S/No.:" + (dvcId ?? "")
        }else  if (inverter_type == "3"){
            self.lblSerialNumber.text =  "S/No.:" + (dvcId ?? "")
        }else  if (inverter_type == "4"){
            self.lblSerialNumber.text  =  "S/No.:" + (dvcId ?? "")
        }else if (inverter_type == "5"){
            self.lblSerialNumber.text  = "S/No.:" + (dvcId ?? "")
        }else{
            self.lblSerialNumber.text = "S/No.:" + (dvcId ?? "")
        }
    }
    
    @IBAction func tapBack(_ sender: Any) {
        let alert = UIAlertController(title: webServices.AppName, message: "Are you sure, you want to leave this page.", preferredStyle: UIAlertController.Style.alert)
        alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: { (action) in
            self.navigationController?.popToRootViewController(animated: true)
            self.timer.invalidate()
        }))
        alert.addAction(UIAlertAction(title: "Cancel", style: .default, handler: { (action) in
           
        }))
        self.present(alert, animated: true, completion: nil)
        
    }
    
   
}

struct GaugeRangeColorsSet {
    static var first: UIColor   { return UIColor.red }
    static var second: UIColor  { return UIColor.init(red: 240.0/255.0, green: 183.0/255.0, blue: 73.0/255.0, alpha: 1.0) }
    static var third: UIColor   { return UIColor.systemGreen }
    static var fourth: UIColor  { return UIColor.red }
    
    static var all: [UIColor] = [first, second, third, fourth]
}
