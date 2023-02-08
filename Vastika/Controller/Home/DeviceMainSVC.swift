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
    @IBOutlet weak var lblATC: UILabel!
    var priousError : String = "0"
    var errorCounter : Int = 0
    @IBOutlet weak var btmHeight: NSLayoutConstraint!
    
    var counterBatterypercent : Int = 0
    let appDelegate = UIApplication.shared.delegate as! AppDelegate
    fileprivate var services : [CBService]?
    var properties : CBCharacteristicProperties?
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
        
        self.timer = Timer.scheduledTimer(timeInterval: 1.0, target: self, selector: #selector(updateCounter), userInfo: nil, repeats: true)

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
       
       
        self.secView = GaugeView(frame: CGRect(x: 0, y: 50, width: 160, height: 80))
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
        self.timerforMode = Timer.scheduledTimer(timeInterval: 3.0, target: self, selector: #selector(updateMode), userInfo: nil, repeats: true)
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
            if (error == "0"){
                self.getErrorString = ""
                }else if (error == "1"){
                    self.getErrorString = "Short Circuit Warning"
                }else if (error == "2"){
                    self.getErrorString = "Short Circuit Shutdown"
                }else if (error == "3"){
                    self.getErrorString = "Battery Low Warning"
                }else if (error == "4"){
                    self.getErrorString = "Battery Low Shutdown"
                }else if (error == "5"){
                    self.getErrorString = "Battery High Warning"
                }else if (error == "6"){
                    self.getErrorString = "Battery High Shutdown"
                }else if (error == "7"){
                    self.getErrorString = "Overload Warning"
                }else if (error == "8"){
                    self.getErrorString = "Overload Shutdown"
                }else if (error == "9"){
                    self.getErrorString = "Mains Fuse Blown"
                }else if (error == "10"){
                    self.getErrorString = "Mains Low Voltage Cut"
                }else if (error == "11"){
                    self.getErrorString = "Mains High Voltage Cut"
                }else if (error == "12"){
                    self.getErrorString = "Solar High Voltage"
                }else if (error == "13"){
                    self.getErrorString = "Solar High Current"
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
        let enrrnr = error?.contains(",")
        if enrrnr == false
        {
            if error == "0"
            {
                return
            }
            print("single")
            self.priousError = error!
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
            
            if self.appDelegate.audioActive == 1
            {
                self.priousError = String(newCodeError)
                self.view.makeToast(String(newCodeErrorString))
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
        let battery_percent = self.dicrDta.object(forKey: "battery_percent") as? String
        let bw = self.dicrDta.object(forKey: "bw") as? String
        
        if self.counterBatterypercent == 5
        {
            self.counterBatterypercent = 0
            // battery setup
          
           
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
        }
        else
        {
            self.counterBatterypercent = self.counterBatterypercent + 1
            self.lblBattery.text = "Updating"
        }
      
        
        
        if (battery_percent?.toDouble())! > 80.00
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
        switch (batteryType) {
              case "1":
                strBattryType = "Tubular"
                self.imgBatteryType.image = UIImage(named: "tubalr_CR")
                break;
              case "2":
                strBattryType = "Sealed Maintenance Free"
                self.imgBatteryType.image = UIImage(named: "sealed_maintenance_free")
                  break;
              case "3":
                strBattryType = "Lithium Ion"
                self.imgBatteryType.image = UIImage(named: "lithium_Ion")
                break;
              case "4":
                strBattryType = ""
                self.imgBatteryType.image = UIImage(named: "tubalr_CR")
                break;
              case "5":
                strBattryType = "Tubular"
                self.imgBatteryType.image = UIImage(named: "tubalr_CR")
                break;
              case "6":
                strBattryType = "Sealed Maintenance Free"
                self.imgBatteryType.image = UIImage(named: "sealed_maintenance_free")
                break;
              case "7":
                strBattryType = "Lithium Ion"
                self.imgBatteryType.image = UIImage(named: "lithium_Ion")
                break;
              default:
                strBattryType = "Tubular"
                self.imgBatteryType.image = UIImage(named: "tubalr_CR")
                break;
            }
        
        self.lblBatteryType.text =  strBattryType
        
        let atcValue = self.dicrDta.object(forKey: "at") as? String

        self.imgATC.image = UIImage(named: "169367")
        self.lblATC.text = String(atcValue!)
        
        let mipv = self.dicrDta.object(forKey: "mipv") as? String
        let voltageInt = Float((mipv?.floatValue.rounded())!)
        
        let inputfre = self.dicrDta.object(forKey: "Input_Frequency_Value") as? String
        var freVoltage = Float((inputfre?.floatValue.rounded())!)
        freVoltage = freVoltage - 15.0
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
            self.lblSerialNumber.text = "S/No.:" +  dvcId!
        }else  if (inverter_type == "2"){
            self.lblSerialNumber.text = "S/No.:" + dvcId!
        }else  if (inverter_type == "3"){
            self.lblSerialNumber.text =  "S/No.:" + dvcId!
        }else  if (inverter_type == "4"){
            self.lblSerialNumber.text  =  "S/No.:" + dvcId!
        }else if (inverter_type == "5"){
            self.lblSerialNumber.text  = "S/No.:" + dvcId!
        }else{
            self.lblSerialNumber.text = "S/No.:" + dvcId!
        }
    }
    
    @IBAction func tapBack(_ sender: Any) {
        let alert = UIAlertController(title: webServices.AppName, message: "Are you sure, you want to leave this page.", preferredStyle: UIAlertController.Style.alert)
        alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: { (action) in
            self.navigationController?.popToRootViewController(animated: true)
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
