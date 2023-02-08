//
//  DeviceBLEVC.swift
//  Vastika
//
//  Created by Sunil on 11/01/23.
//

import UIKit
import SwiftyGif
import SwiftGifOrigin
import CoreBluetooth
import Toast_Swift
import Foundation
import GDGauge
import AVFoundation

class DeviceBLEVC: UIViewController {

    @IBOutlet weak var btnSetting: UIButton!
    @IBOutlet weak var lblMode: UILabel!
    @IBOutlet weak var lblName: UILabel!
    @IBOutlet weak var lblTime: UILabel!
    @IBOutlet weak var imgSwitch: UIImageView!
    @IBOutlet weak var lblSwitch: UILabel!
    @IBOutlet weak var imgBattery: UIImageView!
    @IBOutlet weak var lblBattery: UILabel!
    @IBOutlet weak var switchView: UIView!
    @IBOutlet weak var outputFrequencyView: UIView!
    @IBOutlet weak var batteryVoltage: UIView!
    @IBOutlet weak var batteryTypeView: UIView!
    @IBOutlet weak var loadPerView: UIView!
    @IBOutlet weak var batteryReserveModeView: UIView!
    @IBOutlet weak var imgLoadPerce: UIImageView!
    @IBOutlet weak var lblLoadPercentage: UILabel!
    @IBOutlet weak var imgBatteryType: UIImageView!
    @IBOutlet weak var lblBATTERYTYPE: UILabel!
    @IBOutlet weak var imgBatteryRMode: UIImageView!
    @IBOutlet weak var imgBatteryoltage: UIImageView!
    @IBOutlet weak var lblBatteryRMiode: UILabel!
    @IBOutlet weak var lblHeaderOutputFrequency: UILabel!
    @IBOutlet weak var lblHeaderBatteryVoltage: UILabel!
    @IBOutlet weak var lblBatteryVoltge: UILabel!
    @IBOutlet weak var outFreChart: UIView!
    @IBOutlet weak var lblBG: UILabel!
    @IBOutlet weak var lblChargingPercentage: UILabel!
    @IBOutlet weak var lblCH: UILabel!
    @IBOutlet weak var lblChargingWidth: NSLayoutConstraint!
    @IBOutlet weak var offlineView: UIView!
    @IBOutlet weak var innerOffline: UIView!
    @IBOutlet weak var bototmView: UIView!
    @IBOutlet weak var btmHeight: NSLayoutConstraint!
    var player: AVAudioPlayer?
    @IBOutlet weak var btnDignosis: UIButton!
    let appDelegate = UIApplication.shared.delegate as! AppDelegate
    fileprivate var services : [CBService]?
    var properties : CBCharacteristicProperties?
    let bluetoothManager = BluetoothManager.getInstance()
    var peripheral: CBPeripheral!
    var counter = 1
    var dicrDta = NSDictionary()
    var timer : Timer!
    var timerforMode : Timer!
    var firstView : GaugeVMain!
    var secView : GaugeLOWHIgh!
    var normalView : GaugeHigh!
    var gaugeView: GaugeView!
    var counterBatterypercent : Int = 0
    var getErrorString = String()
    var commingErrorCode = String()
    var priousError : String = "0"
    var previousRunningMode : String = "0"
    var errorCounter : Int = 0
    ///
    override func viewDidLoad() {
        super.viewDidLoad()
        self.btnSetting.layer.cornerRadius = self.btnSetting.frame.size.height / 2
        self.btnSetting.clipsToBounds = true
        
        self.btnDignosis.layer.cornerRadius = self.btnDignosis.frame.size.height / 2
        self.btnDignosis.clipsToBounds = true
        
        self.innerOffline.layer.cornerRadius = 10
        self.innerOffline.clipsToBounds = true
        
        self.lblBG.layer.cornerRadius = 5
        self.lblBG.layer.borderColor = UIColor.red.cgColor
        self.lblBG.layer.borderWidth = 1.0
        self.lblBG.clipsToBounds = true
        
        self.lblCH.layer.cornerRadius = 3
        self.lblCH.clipsToBounds = true
        
        self.makeRounded(vw: self.switchView)
        self.makeRounded(vw: self.outputFrequencyView)
        self.makeRounded(vw: self.batteryVoltage)
        self.makeRounded(vw: self.loadPerView)
        self.makeRounded(vw: self.batteryTypeView)
        self.makeRounded(vw: self.batteryReserveModeView)
        
        self.timer = Timer.scheduledTimer(timeInterval: 1.0, target: self, selector: #selector(updateCounter), userInfo: nil, repeats: true)
       
        
        // Do any additional setup after loading the view.
    }
    
    @IBAction func tapNewMenu(_ sender: UIButton) {
        sender.isSelected = !sender.isSelected
        if sender.isSelected == true
        {
            self.btmHeight.constant = 50
        }
        else
        {
            self.btmHeight.constant = 0
        }
    }
    
    
    func makeRounded(vw: UIView)
    {
        vw.layer.cornerRadius = 20
        vw.layer.borderWidth = 1
        vw.layer.borderColor = UIColor.init(red: 239.0/255.0, green: 239.0/255.0, blue: 239.0/255.0, alpha: 1.0).cgColor
        vw.clipsToBounds = true
    }
    
    func createErrorString(error : String) -> String
    {
        let statusUPS = self.dicrDta.object(forKey: "status_ups") as? String
        let statusMains = self.dicrDta.object(forKey: "status_mains") as? String
        
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
                }else if statusMains == "1" && error == "10" && statusUPS == "1"
                {
                    self.getErrorString = "Mains Low Voltage Cut"
                }
                else if statusMains == "0" && error == "10" && statusUPS == "1"
                {
                    self.getErrorString = "Mains Fail"
                }
                else if statusMains == "0" && error == "10" && statusUPS == "0"
                {
                    self.getErrorString = "Mains Fail"
                }
                else if (error == "11"){
                    self.getErrorString = "Mains High Voltage Cut"
                }else if (error == "12"){
                    self.getErrorString = "Solar High Voltage"
                }else if (error == "13"){
                    self.getErrorString = "Solar High Current"
                }
        return self.getErrorString
       
    }
    
    @IBAction func tapDiagnosis(_ sender: Any) {
        if let vcToPresent = self.storyboard!.instantiateViewController(withIdentifier: "DeviceDiagonsisVC") as? DeviceDiagonsisVC{
            vcToPresent.isFrom = "BLE"
            self.navigationController?.pushViewController(vcToPresent, animated: true)
        }
    }
    
    @IBAction func tapSwitchONOFF(_ sender: UIButton) {
        
        
        let resetSwitch = self.dicrDta.object(forKey: "status_front_switch") as? String
        if resetSwitch == "1"
        {
            //off
            let alert = UIAlertController(title: webServices.AppName, message: "Are you sure, you want to switch On.", preferredStyle: UIAlertController.Style.alert)
            alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: { (action) in
                let dict = ["status_front_switch_remote":"2"]
                if let theJSONData = try?  JSONSerialization.data(
                      withJSONObject: dict,
                      options: .prettyPrinted
                      ),
                      let theJSONText = String(data: theJSONData,
                                               encoding: String.Encoding.ascii) {
                          print("JSON string = \n\(theJSONText)")
                    var newSTr = theJSONText.replacingOccurrences(of: " ", with: "")
                    newSTr = newSTr.replacingOccurrences(of: "\n", with: "")

                    let data = Data(newSTr.utf8)
                    self.appDelegate.bluetoothManager.writeValue(data: data, forCharacteristic: self.appDelegate.writableCharacteristic!, type: .withResponse)
                    
                    self.view.makeToast("Device is switched On")

            }
            }))
            alert.addAction(UIAlertAction(title: "Cancel", style: .default, handler: { (action) in
               
            }))
            self.present(alert, animated: true, completion: nil)
        }
        else
        {
            // on
            let alert = UIAlertController(title: webServices.AppName, message: "Are you sure, you want to switch Off.", preferredStyle: UIAlertController.Style.alert)
            alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: { (action) in
                let dict = ["status_front_switch_remote":"1"]
                if let theJSONData = try?  JSONSerialization.data(
                      withJSONObject: dict,
                      options: .prettyPrinted
                      ),
                      let theJSONText = String(data: theJSONData,
                                               encoding: String.Encoding.ascii) {
                          print("JSON string = \n\(theJSONText)")
                    var newSTr = theJSONText.replacingOccurrences(of: " ", with: "")
                    newSTr = newSTr.replacingOccurrences(of: "\n", with: "")

                    let data = Data(newSTr.utf8)
                    self.appDelegate.bluetoothManager.writeValue(data: data, forCharacteristic: self.appDelegate.writableCharacteristic!, type: .withResponse)
                    self.view.makeToast("Device is switched Off")
            }
            }))
            alert.addAction(UIAlertAction(title: "Cancel", style: .default, handler: { (action) in
               
            }))
            self.present(alert, animated: true, completion: nil)
        }
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        self.timerforMode = Timer.scheduledTimer(timeInterval: 3.0, target: self, selector: #selector(updateMode), userInfo: nil, repeats: true)
        let statusUPS = self.dicrDta.object(forKey: "status_ups") as? String
        let statusMains = self.dicrDta.object(forKey: "status_mains") as? String
        let mainsOKN = self.dicrDta.object(forKey: "Mains_Ok") as? String
        let errorN = self.dicrDta.object(forKey: "status_error") as? String
        self.otherTitleName(isFrom: "UPS Mode (Main Fail)")
        self.gettingErrorCode()
        var commintErrorCodeNN = String()
        let eror10 = errorN?.contains("10")
        if eror10 == true
        {
            commintErrorCodeNN = "10"
        }
        
        let eror11 = errorN?.contains("11")
        if eror11 == true
        {
            commintErrorCodeNN = "11"

        }
        
        
        if statusUPS == "1" && statusMains == "0"
        {
            self.lblMode.text = "UPS Mode \n (Mains Fail)"
            self.previousRunningMode = "1"
            if Device.IS_IPHONE_X
            {
//                self.firstView = GaugeVMain(frame: CGRect(x: 0, y:20, width: 161, height: 130))
//                self.firstView.backgroundColor = .white
                gaugeView = GaugeView(frame: CGRect(x: 0, y: 50, width: 160, height: 80))
                self.outFreChart.addSubview(gaugeView)
                
                // To setup the gauge view
                gaugeView
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
             //   self.outFreChart.addSubview(self.firstView)
            }
            else
            {
//                self.firstView = GaugeVMain(frame: CGRect(x: 0, y:0, width: 161, height: 120))
//                self.firstView.backgroundColor = .white
                gaugeView = GaugeView(frame: CGRect(x: 0, y: 50, width: 160, height: 80))
                self.outFreChart.addSubview(gaugeView)
                
                // To setup the gauge view
                gaugeView
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
                //self.outFreChart.addSubview(self.firstView)
            }
           
            self.offlineView.isHidden = true
            
        }
        else if statusUPS == "0" && statusMains == "1" && mainsOKN == "1"
        {
            
                self.lblMode.text = "Mains Mode"
                // switch to mains mode view
                if let vcToPresent = self.storyboard!.instantiateViewController(withIdentifier: "DeviceMainSVC") as? DeviceMainSVC{
                    vcToPresent.dicrDta = self.appDelegate.globalDict
                    self.navigationController?.pushViewController(vcToPresent, animated: true)
                }
            
            self.offlineView.isHidden = true

        }
        else if statusUPS == "0" && statusMains == "1" && commintErrorCodeNN == "10"
        {
            self.previousRunningMode = "3"
            self.lblMode.text = "UPS Mode \n (Mains On - Low Voltage)"
            self.lblHeaderBatteryVoltage.text = "Battery Discharge"
            self.lblHeaderOutputFrequency.text = "Low Voltage"
            self.secView = GaugeLOWHIgh(frame: CGRect(x: 0, y:20, width: 161, height: 129))
            self.secView.backgroundColor = .white
            self.outFreChart.addSubview(self.secView)
           
            self.offlineView.isHidden = true

        }
        else if statusUPS == "0" && statusMains == "1" && commintErrorCodeNN == "11"
        {
            self.previousRunningMode = "2"
            self.lblMode.text = "UPS Mode \n (Mains On - High Voltage)"
            self.lblHeaderBatteryVoltage.text = "Battery Discharge"
            self.lblHeaderOutputFrequency.text = "High Voltage"
            self.normalView = GaugeHigh(frame: CGRect(x: 0, y:20, width: 161, height: 129))
            self.normalView.backgroundColor = .white
            self.outFreChart.addSubview(self.normalView)
            
            self.offlineView.isHidden = true

        }
        else if statusUPS == "1" && statusMains == "1"
        {
          
            let mainsOK = self.dicrDta.object(forKey: "Mains_Ok") as? String
            let error = self.dicrDta.object(forKey: "status_error") as? String
            let chg_i = self.dicrDta.object(forKey: "chg_i") as? String
            var commintErrorCode = String()
            let eror10 = error?.contains("10")
            if eror10 == true
            {
                commintErrorCode = "10"
            }
            
            let eror11 = errorN?.contains("11")
            if eror11 == true
            {
                commintErrorCode = "11"

            }
            
            // getting error code
            
            if mainsOK == "0" && chg_i == "0.00" && commintErrorCode == "11"
            {
                self.previousRunningMode = "2"
                self.lblMode.text = "UPS Mode \n (Mains On - High Voltage)"
                self.lblHeaderBatteryVoltage.text = "Battery Discharge"
                self.lblHeaderOutputFrequency.text = "High Voltage"
                self.normalView = GaugeHigh(frame: CGRect(x: 0, y:20, width: 161, height: 129))
                self.normalView.backgroundColor = .white
                self.outFreChart.addSubview(self.normalView)
            }
            else if mainsOK == "0" && chg_i == "0.00" && commintErrorCode == "10"
            {
                self.previousRunningMode = "3"
                self.lblMode.text = "UPS Mode \n (Mains On - Low Voltage)"
                self.lblHeaderBatteryVoltage.text = "Battery Discharge"
                self.lblHeaderOutputFrequency.text = "Low Voltage"
                self.secView = GaugeLOWHIgh(frame: CGRect(x: 0, y:20, width: 161, height: 129))
                self.secView.backgroundColor = .white
                self.outFreChart.addSubview(self.secView)
            }
            self.offlineView.isHidden = true

        }
        else if statusUPS == "0" && statusMains == "0"
        {
          
            self.updatedDataForUPSMode()
            self.offlineView.isHidden = true
//            self.firstView = GaugeVMain(frame: CGRect(x: 0, y:10, width: 161, height: 120))
//            self.firstView.backgroundColor = .white
//            self.outFreChart.addSubview(self.firstView)

            gaugeView = GaugeView(frame: CGRect(x: 0, y: 50, width: 160, height: 80))
            self.outFreChart.addSubview(gaugeView)
            
            // To setup the gauge view
            gaugeView
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
            
            
            self.previousRunningMode = "1"

            let attrsSE1 = [NSAttributedString.Key.font : UIFont(name: "HelveticaNeue", size: 22), NSAttributedString.Key.foregroundColor : UIColor.init(red: 27.0/255.0, green: 30.0/255.0, blue: 130.0/255.0, alpha: 1.0)]
            let attrsSE2 = [NSAttributedString.Key.font : UIFont(name: "HelveticaNeue", size: 22), NSAttributedString.Key.foregroundColor : UIColor.init(red: 27.0/255.0, green: 30.0/255.0, blue: 130.0/255.0, alpha: 1.0)]
            
            let attrsSE3 = [NSAttributedString.Key.font : UIFont(name: "HelveticaNeue", size: 18), NSAttributedString.Key.foregroundColor : UIColor.red]
            
            let attributedStringSE1 = NSMutableAttributedString(string:"UPS Mode" + "\n", attributes:attrsSE1 as [NSAttributedString.Key : Any])
            let attributedStringSE2 = NSMutableAttributedString(string:"Mains Fail" + "\n", attributes:attrsSE2 as [NSAttributedString.Key : Any])
            let attributedStringSE3 = NSMutableAttributedString(string:"Device is Offline", attributes:attrsSE3 as [NSAttributedString.Key : Any])
            attributedStringSE1.append(attributedStringSE2)
            attributedStringSE1.append(attributedStringSE3)

            self.lblMode.attributedText = attributedStringSE1
            
            
        }
        self.updatedDataForUPSMode()
        
    }
    
    @objc func updateMode() {
        self.dicrDta = self.appDelegate.globalDict
        let statusUPS = self.dicrDta.object(forKey: "status_ups") as? String
        let statusMains = self.dicrDta.object(forKey: "status_mains") as? String
        let mainsOKN = self.dicrDta.object(forKey: "Mains_Ok") as? String
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
      
        
        
        self.otherTitleName(isFrom: "UPS Mode (Main Fail)")
        var commintErrorCodeNN = String()
        let eror10 = errorN?.contains("10")
        if eror10 == true
        {
            commintErrorCodeNN = "10"
        }
        
        let eror11 = errorN?.contains("11")
        if eror11 == true
        {
            commintErrorCodeNN = "11"

        }
        
        
        if statusUPS == "1" && statusMains == "0"
        {
            self.lblMode.text = "UPS Mode \n (Mains Fail)"
            self.lblHeaderOutputFrequency.text = "Output Frequency"
            self.updatedDataForUPSMode()
            self.offlineView.isHidden = true
           
            
            if self.previousRunningMode != "1"
            {
                
                if Device.IS_IPHONE_X
                {
//                    self.firstView = GaugeVMain(frame: CGRect(x: 0, y:20, width: 161, height: 130))
//                    self.firstView.backgroundColor = .white
//                    self.outFreChart.addSubview(self.firstView)
                    gaugeView = GaugeView(frame: CGRect(x: 0, y: 50, width: 160, height: 80))
                    self.outFreChart.addSubview(gaugeView)
                    
                    // To setup the gauge view
                    gaugeView
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
                }
                else
                {
//                    self.firstView = GaugeVMain(frame: CGRect(x: 0, y:0, width: 161, height: 120))
//                    self.firstView.backgroundColor = .white
//                    self.outFreChart.addSubview(self.firstView)
                    gaugeView = GaugeView(frame: CGRect(x: 0, y: 50, width: 160, height: 80))
                    self.outFreChart.addSubview(gaugeView)
                    
                    // To setup the gauge view
                    gaugeView
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
                }
            }

        }
        else if statusUPS == "0" && statusMains == "1" && mainsOKN == "1"
        {
            
            self.lblMode.text = "Mains Mode"
            // switch to mains mode view
            self.timer.invalidate()
            if let vcToPresent = self.storyboard!.instantiateViewController(withIdentifier: "DeviceMainSVC") as? DeviceMainSVC{
                vcToPresent.dicrDta = self.appDelegate.globalDict
                self.navigationController?.pushViewController(vcToPresent, animated: true)
            }
        
            self.offlineView.isHidden = true

        }
        else if statusUPS == "0" && statusMains == "1" && commintErrorCodeNN == "10"
        {
            if self.previousRunningMode != "3"
            {
                self.secView = GaugeLOWHIgh(frame: CGRect(x: 0, y:20, width: 161, height: 129))
                self.secView.backgroundColor = .white
                self.outFreChart.addSubview(self.secView)
            }
            self.lblMode.text = "UPS Mode \n (Mains On - Low Voltage)"
            self.lblHeaderBatteryVoltage.text = "Battery Discharge"
            self.lblHeaderOutputFrequency.text = "Low Voltage"
            self.updatedDataForUPSMode()
            self.offlineView.isHidden = true
            
        }
        else if statusUPS == "0" && statusMains == "1" && commintErrorCodeNN == "11"
        {
            if self.previousRunningMode != "2"
            {
                self.normalView = GaugeHigh(frame: CGRect(x: 0, y:20, width: 161, height: 129))
                self.normalView.backgroundColor = .white
                self.outFreChart.addSubview(self.normalView)
            }
            self.lblMode.text = "UPS Mode \n (Mains On - High Voltage)"
            self.lblHeaderBatteryVoltage.text = "Battery Discharge"
            self.lblHeaderOutputFrequency.text = "High Voltage"
            self.updatedDataForUPSMode()
            self.offlineView.isHidden = true
            
        }
        else if statusUPS == "1" && statusMains == "1"
        {
            let mainsOK = self.dicrDta.object(forKey: "Mains_Ok") as? String
            let error = self.dicrDta.object(forKey: "status_error") as? String
            let chg_i = self.dicrDta.object(forKey: "chg_i") as? String
            // getting error code
            var commintErrorCode = String()
            let eror10 = error?.contains("10")
            if eror10 == true
            {
                commintErrorCode = "10"
            }
            
            let eror11 = errorN?.contains("11")
            if eror11 == true
            {
                commintErrorCode = "11"

            }
            self.updatedDataForUPSMode()
            
            if mainsOK == "0" && chg_i == "0.00" && commintErrorCode == "11"
            {
                if self.previousRunningMode != "2"
                {
                    self.previousRunningMode = "2"
                    self.normalView = GaugeHigh(frame: CGRect(x: 0, y:20, width: 161, height: 129))
                    self.normalView.backgroundColor = .white
                    self.outFreChart.addSubview(self.normalView)
                }
                self.lblMode.text = "UPS Mode \n (Mains On - High Voltage)"
                self.lblHeaderBatteryVoltage.text = "Battery Discharge"
                self.lblHeaderOutputFrequency.text = "High Voltage"
            }
            else if mainsOK == "0" && chg_i == "0.00" && commintErrorCode == "10"
            {
                if self.previousRunningMode != "3"
                {
                    self.previousRunningMode = "3"
                    self.secView = GaugeLOWHIgh(frame: CGRect(x: 0, y:20, width: 161, height: 129))
                    self.secView.backgroundColor = .white
                    self.outFreChart.addSubview(self.secView)
                }
                self.lblMode.text = "UPS Mode \n (Mains On - Low Voltage)"
                self.lblHeaderBatteryVoltage.text = "Battery Discharge"
                self.lblHeaderOutputFrequency.text = "Low Voltage"
            }
            self.offlineView.isHidden = true

        }
        else if statusUPS == "0" && statusMains == "0"
        {
            self.updatedDataForUPSMode()
            self.offlineView.isHidden = true
           
            if self.previousRunningMode != "1"
            {
                if Device.IS_IPHONE_X
                {
//                    self.firstView = GaugeVMain(frame: CGRect(x: 0, y:20, width: 161, height: 130))
//                    self.firstView.backgroundColor = .white
//                    self.outFreChart.addSubview(self.firstView)
                    gaugeView = GaugeView(frame: CGRect(x: 0, y: 50, width: 160, height: 80))
                    self.outFreChart.addSubview(gaugeView)
                    
                    // To setup the gauge view
                    gaugeView
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
                }
                else
                {
//                    self.firstView = GaugeVMain(frame: CGRect(x: 0, y:0, width: 161, height: 120))
//                    self.firstView.backgroundColor = .white
//                    self.outFreChart.addSubview(self.firstView)
                    gaugeView = GaugeView(frame: CGRect(x: 0, y: 50, width: 160, height: 80))
                    self.outFreChart.addSubview(gaugeView)
                    
                    // To setup the gauge view
                    gaugeView
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
                }
            }
            
            let attrsSE1 = [NSAttributedString.Key.font : UIFont(name: "HelveticaNeue", size: 22), NSAttributedString.Key.foregroundColor : UIColor.init(red: 27.0/255.0, green: 30.0/255.0, blue: 130.0/255.0, alpha: 1.0)]
            let attrsSE2 = [NSAttributedString.Key.font : UIFont(name: "HelveticaNeue", size: 22), NSAttributedString.Key.foregroundColor : UIColor.init(red: 27.0/255.0, green: 30.0/255.0, blue: 130.0/255.0, alpha: 1.0)]
            
            let attrsSE3 = [NSAttributedString.Key.font : UIFont(name: "HelveticaNeue", size: 18), NSAttributedString.Key.foregroundColor : UIColor.red]
            
            let attributedStringSE1 = NSMutableAttributedString(string:"UPS Mode" + "\n", attributes:attrsSE1 as [NSAttributedString.Key : Any])
            let attributedStringSE2 = NSMutableAttributedString(string:"(Mains Fail)" + "\n", attributes:attrsSE2 as [NSAttributedString.Key : Any])
            let attributedStringSE3 = NSMutableAttributedString(string:"Device is Offline", attributes:attrsSE3 as [NSAttributedString.Key : Any])
            attributedStringSE1.append(attributedStringSE2)
            attributedStringSE1.append(attributedStringSE3)

            self.lblMode.attributedText = attributedStringSE1
            
        }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        self.timer.invalidate()
        self.timerforMode.invalidate()
        
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
            self.view.makeToast(String(newCodeErrorString))
            
            if self.appDelegate.audioActive == 1
            {
                let systemSoundID: SystemSoundID = 1315
                AudioServicesPlaySystemSound (systemSoundID)
            }
            
        }
    }
    
    func playSound(_ soundName: String) {
        guard let url = Bundle.main.url(forResource: "beep-06", withExtension: "mp3") else {
            print("URL is wrong")
            return
        }
        do {
            player = try AVAudioPlayer(contentsOf: url)
            guard let player = player else { return }

            player.prepareToPlay()
            
            player.play()

        } catch {
           print(error)
        }
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
                timerTime = String(hr) + ":"
            }
            if min == 0
            {
                timerTime = timerTime + "00:"
            }
            else
            {
                timerTime = timerTime + String(min) + ":"
            }
            
            timerTime = timerTime + String(sec)
            self.lblTime.text = timerTime
            
        }
    }

    
    func updatedVoltageInpercentage()
    {
        let bv = self.dicrDta.object(forKey: "bv") as? String
        let bvInInt = Int(Float((bv?.floatValue.rounded())!))
        
        let noBattery = Float(bvInInt / 15)
        var totalbattery : Int = 0
        if noBattery < 1.0
        {
            totalbattery = 1
        }
        else if noBattery > 1.0 && noBattery < 2.0
        {
            totalbattery = 2
        }
        else if noBattery > 2.0 && noBattery < 3.0
        {
            totalbattery = 3
        }
        else
        {
            totalbattery = 4
        }
        
        let batteryVoltge = self.dicrDta.object(forKey: "setting_low_voltage_cut") as? String
        var newbatteryVoltge = String()

        switch (batteryVoltge) {
            case "0":
                newbatteryVoltge = "11.0"
                break;
            case "1":
                newbatteryVoltge = "10.5"
                break;
            case "4":
                newbatteryVoltge = "10.8"
                break;
            case "5":
                newbatteryVoltge = "11.2"
                break;
            case "6":
                newbatteryVoltge = "11.4"
            break;
            default:
                newbatteryVoltge = "--"
              break;
        }
        
        let v1 = Float(newbatteryVoltge.floatValue)
        
        let oneForActualPersent = Int(((15.0 - Float(v1)) / 15.0) * 100.0)
        let totalPercent = oneForActualPersent * totalbattery
        print(totalPercent)
        let commingPercent = Int(((15.0 - Float(bvInInt)) / 15.0) * 100)
        print(commingPercent)
        print(v1)
        
        let tempPlacePercent = Int(Float(Float(oneForActualPersent - commingPercent) / Float(oneForActualPersent)) * 100)
        let finalpercent = 100 - tempPlacePercent
        print(finalpercent)
        
        self.lblBatteryVoltge.text = String(finalpercent) + " %"
        
        
        
        let lblWidth =  Float(60.0 / 100.0)
        let nww = Int(lblWidth * Float(finalpercent))
        self.lblChargingWidth.constant = CGFloat(nww)
        
        
    }
    
    func updatedDataForUPSMode()
    {
        if self.counterBatterypercent == 5
        {
            self.counterBatterypercent = 0
            self.updatedVoltageInpercentage()
        }
        else
        {
            self.counterBatterypercent = self.counterBatterypercent + 1
        }
      
        let attrsSwitch1 = [NSAttributedString.Key.font : UIFont(name: "HelveticaNeue", size: 14), NSAttributedString.Key.foregroundColor : UIColor.darkGray]
        let attrsSwitch2 = [NSAttributedString.Key.font : UIFont(name: "HelveticaNeue-Bold", size: 14), NSAttributedString.Key.foregroundColor : UIColor.black]
        let attributedStringSwitch1 = NSMutableAttributedString(string:"", attributes:attrsSwitch1 as [NSAttributedString.Key : Any])
     
        // reset switch
        let resetSwitch = self.dicrDta.object(forKey: "status_front_switch") as? String
        if resetSwitch == "0"
        {
            self.imgSwitch.image = UIImage(named: "off_CR")
            let attributedStringSwitch2 = NSMutableAttributedString(string:"Off", attributes:attrsSwitch2 as [NSAttributedString.Key : Any])
            attributedStringSwitch1.append(attributedStringSwitch2)
            self.lblSwitch.attributedText = attributedStringSwitch1
        }
        else
        {
            self.imgSwitch.image = UIImage(named: "on_CR")
            let attributedStringSwitch2 = NSMutableAttributedString(string:"On", attributes:attrsSwitch2 as [NSAttributedString.Key : Any])
            attributedStringSwitch1.append(attributedStringSwitch2)
            self.lblSwitch.attributedText = attributedStringSwitch1
        }
        
        self.imgBatteryoltage.image = UIImage(named: "mediumbattery")
        
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
                strBattryType = "Lead Acid"
                self.imgBatteryType.image = UIImage(named: "lead_acid")
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
                strBattryType = "Lead Acid"
                self.imgBatteryType.image = UIImage(named: "lead_acid")
                break;
            }
        
        self.lblBATTERYTYPE.text =  strBattryType
        let loadPerce = self.dicrDta.object(forKey: "load_percent") as? String
        let doubLoadPre = Double(loadPerce!)
        if loadPerce == "0.00"
        {
            self.imgLoadPerce.loadGif(name: "load_percentage")
        }
        else
        {
            self.imgLoadPerce.loadGif(name: "load_percentage_green")
        }
        if doubLoadPre! > 100.00
        {
            self.imgLoadPerce.loadGif(name: "load_percentage")
        }
        
        self.lblLoadPercentage.text = String(loadPerce!) + " %"
       
        
        let reserveMode = self.dicrDta.object(forKey: "setting_low_voltage_cut") as? String
        var resValue = String()
        switch (reserveMode) {
              case "0":
                resValue = "5%"
                break;
              case "1":
                strBattry = "0%"
                  break;
              case "4":
                strBattry = "3%"
                break;
              case "5":
                strBattry = "8%"
                break;
              case "6":
                strBattry = "10%"
                break;
              default:
                strBattry = "--"
                break;
            }
        self.lblBatteryRMiode.text = strBattry
        self.imgBatteryRMode.image = UIImage(named:  "battery_reserved")
        
        
        let statusUPS = self.dicrDta.object(forKey: "status_ups") as? String
        let statusMains = self.dicrDta.object(forKey: "status_mains") as? String
        let errorN = self.dicrDta.object(forKey: "status_error") as? String
        var commintErrorCode : String = ""
        let eror10  = errorN?.contains("10")
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
            let inputfre = self.dicrDta.object(forKey: "Output_Frequency_Value") as? String
            var freVoltage = Float((inputfre?.floatValue.rounded())!)
            freVoltage = freVoltage - 15.0
            DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                        UIView.animate(withDuration: 1) {
                            //self.firstView.value = Int(freVoltage)
                            self.gaugeView.updateValueTo(CGFloat(freVoltage))
                        }
                    }
            
        }
        else if statusUPS == "1" && statusMains == "1"
        {
            let mainsOK = self.dicrDta.object(forKey: "Mains_Ok") as? String
            let error = self.dicrDta.object(forKey: "status_error") as? String
            let chg_i = self.dicrDta.object(forKey: "chg_i") as? String
            var mipv = self.dicrDta.object(forKey: "mipv") as? String
            if mipv == "0.00"
            {
                mipv = "10.00"
            }
            let voltageInt = Float((mipv?.floatValue.rounded())!)
           
            if mainsOK == "0" && chg_i == "0.00" && error == "11"
            {
                self.lblHeaderOutputFrequency.text = "High Voltage"
               
                DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                            UIView.animate(withDuration: 1) {
                                self.normalView.value = Int(voltageInt)
                            }
                        }
                
            }
            else if mainsOK == "0" && chg_i == "0.00" && error == "10"
            {
                self.lblHeaderOutputFrequency.text = "Low Voltage"
                DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                            UIView.animate(withDuration: 1) {
                                self.secView.value = Int(voltageInt)
                            }
                        }
            }
        }
        else if statusUPS == "0" && statusMains == "1" && commintErrorCode == "10"
        {
            var mipv = self.dicrDta.object(forKey: "mipv") as? String
            if mipv == "0.00"
            {
                mipv = "10.00"
            }
            let voltageInt = Float((mipv?.floatValue.rounded())!)
           
            self.lblHeaderOutputFrequency.text = "Low Voltage"
            DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                        UIView.animate(withDuration: 1) {
                            self.secView.value = Int(voltageInt)
                        }
                    }
        }
        else if statusUPS == "0" && statusMains == "1" && commintErrorCode == "11"
        {
            self.lblHeaderOutputFrequency.text = "High Voltage"
            var mipv = self.dicrDta.object(forKey: "mipv") as? String
            if mipv == "0.00"
            {
                mipv = "10.00"
            }
            let voltageInt = Float((mipv?.floatValue.rounded())!)
           

            DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                        UIView.animate(withDuration: 1) {
                            self.normalView.value = Int(voltageInt)
                        }
                    }
        }
        
        else
        {
            let inputfre = self.dicrDta.object(forKey: "Output_Frequency_Value") as? String
            var freVoltage = Float((inputfre?.floatValue.rounded())!)
            freVoltage = freVoltage - 15.0

            DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                        UIView.animate(withDuration: 1) {
                           // self.firstView.value = Int(freVoltage)
                            self.gaugeView.updateValueTo(CGFloat((freVoltage ?? 0.0)))
                        }
                    }
        }
    }
    
    func otherTitleName(isFrom : String)
    {
            //self.lblMode.text = "UPS Mode (Mains Fail)"
        let inverter_type = self.dicrDta.object(forKey: "inverter_type") as? String
        let dvcId = self.dicrDta.object(forKey: "device_id") as? String
        let userDetails = UserDefaults.standard.object(forKey: "user") as? NSDictionary
        let name = userDetails?.object(forKey: "name") as? String
        
        if (inverter_type == "1"){
            self.lblName.text =  "S/No.:" + (dvcId ?? "0")
        }else  if (inverter_type == "2"){
            self.lblName.text =  "S/No.:" + (dvcId ?? "0")
        }else  if (inverter_type == "3"){
            self.lblName.text = "S/No.:" + (dvcId ?? "0")
        }else  if (inverter_type == "4"){
            self.lblName.text  =  "S/No.:" + (dvcId ?? "0")
        }else if (inverter_type == "5"){
            self.lblName.text  =  "S/No.:" + (dvcId ?? "0")
        }else{
            self.lblName.text =  "S/No.:" + (dvcId ?? "0")
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
    
    @IBAction func tapSetting(_ sender: Any) {
        if let vcToPresent = self.storyboard!.instantiateViewController(withIdentifier: "SettingVC") as? SettingVC{
            vcToPresent.dicrDetails = self.dicrDta
            self.navigationController?.pushViewController(vcToPresent, animated: true)
        }
    }
    


    
}

extension UIView {


  // OUTPUT 2
  func dropShadow(color: UIColor, opacity: Float = 0.5, offSet: CGSize, radius: CGFloat = 1, scale: Bool = true) {
    layer.masksToBounds = false
    layer.shadowColor = color.cgColor
    layer.shadowOpacity = opacity
    layer.shadowOffset = offSet
    layer.shadowRadius = radius
    layer.cornerRadius = 20
    layer.shadowPath = UIBezierPath(rect: self.bounds).cgPath
    layer.shouldRasterize = true
    layer.rasterizationScale = scale ? UIScreen.main.scale : 1
  }
    
}
