//
//  SettingVC.swift
//  Vastika
//
//  Created by Mac on 22/09/21.
//

import UIKit

class SettingVC: UIViewController,UIPickerViewDelegate,UIPickerViewDataSource {

    @IBOutlet weak var lblUPSType: UILabel!
    @IBOutlet weak var lblBatteryType: UILabel!
    @IBOutlet weak var lblGridCharing: UILabel!
    @IBOutlet weak var lblLowVoltageCut: UILabel!
    @IBOutlet weak var lblTemperature: UILabel!
    @IBOutlet weak var lblWarrenty: UILabel!
    @IBOutlet weak var lblResourcePreiority: UILabel!
    var viewModel = DeviceDetailsViewModel()
    @IBOutlet weak var switchContro: UISwitch!
    @IBOutlet weak var lblBuzzer: UILabel!
    @IBOutlet weak var txtFieldAmount: UITextField!
    @IBOutlet weak var priceView: UIView!
    @IBOutlet weak var lblSolarRP: UILabel!
    let appDelegate = UIApplication.shared.delegate as! AppDelegate
    var deviceId = String()
    var arrayUPSType = NSMutableArray()
    var arrayBatteryType = NSMutableArray()
    var arrayGrid = NSMutableArray()
    var arrayLowVeltage = NSMutableArray()
    var arrayAmbientTemp = NSMutableArray()
    var arrayBuzzer = NSMutableArray()
    var arrayResourcePriority = NSMutableArray()
    var arrayPerUnit = NSMutableArray()
    var toolBarTextField = UIToolbar()
    var arrayGridCharging = NSMutableArray()
    var currencyList : [currencyModel]!
    var pickerView = UIPickerView()
    var toolBar = UIToolbar()
    var selectedId = String()
    var dicrDetails = NSDictionary()
    @IBOutlet weak var scrlView: UIScrollView!
    @IBOutlet weak var scrlHeight: NSLayoutConstraint!
    @IBOutlet weak var setBottomView: UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.priceView.layer.cornerRadius = 10
        self.priceView.layer.borderWidth = 1
        self.priceView.layer.borderColor = UIColor.black.cgColor
        self.priceView.clipsToBounds = true
        
        let height =  200
        self.scrlView.contentSize = CGSize(width: self.scrlView.frame.size.width, height: CGFloat(height))
        self.scrlHeight.constant = CGFloat(height)
        
        var dict = ["name" : "Buzzer Enable","ide" : "3"]
        self.arrayBuzzer.add(dict)
        dict = ["name" : "Buzzer Disabled","ide" : "2"]
        self.arrayBuzzer.add(dict)
        
        dict = ["name" : "Disable","ide" : "2"]
        self.arrayAmbientTemp.add(dict)
        dict = ["name" : "Enable","ide" : "3"]
        self.arrayAmbientTemp.add(dict)
                
        dict = ["name" : "Narrow Window (185-265V)","ide" : "2"]
        self.arrayUPSType.add(dict)
        dict = ["name" : "Wide Window (90-290V)","ide" : "3"]
        self.arrayUPSType.add(dict)
     
        
        dict = ["name" : "Tubular","ide" : "5"]
        self.arrayBatteryType.add(dict)
        dict = ["name" : "Sealed Maintenance Free","ide" : "6"]
        self.arrayBatteryType.add(dict)
        dict = ["name" : "Lithium Ion","ide" : "7"]
        self.arrayBatteryType.add(dict)
        
                
        dict = ["name" : "2.5A","ide" : "5"]
        self.arrayGrid.add(dict)
        dict = ["name" : "5A","ide" : "6"]
        self.arrayGrid.add(dict)
        dict = ["name" : "10A","ide" : "7"]
        self.arrayGrid.add(dict)
        dict = ["name" : "15A","ide" : "8"]
        self.arrayGrid.add(dict)
        
        dict = ["name" : "5%","ide" : "2"]
        self.arrayLowVeltage.add(dict)
        dict = ["name" : "0%","ide" : "3"]
        self.arrayLowVeltage.add(dict)
        dict = ["name" : "3%","ide" : "4"]
        self.arrayLowVeltage.add(dict)
        dict = ["name" : "8%","ide" : "5"]
        self.arrayLowVeltage.add(dict)
        dict = ["name" : "10%","ide" : "6"]
        self.arrayLowVeltage.add(dict)
        
        dict = ["name" : "Enable grid when battery at 13 V","ide" : "1"]
        self.arrayResourcePriority.add(dict)
        dict = ["name" : "Enable grid when battery at 12.2 V","ide" : "2"]
        self.arrayResourcePriority.add(dict)
        dict = ["name" : "Enable grid when battery at 11 V","ide" : "3"]
        self.arrayResourcePriority.add(dict)
        

       
        dict = ["name" : "Disabe","ide" : "2"]
        self.arrayGridCharging.add(dict)
        dict = ["name" : "Enable","ide" : "3"]
        self.arrayGridCharging.add(dict)
        
        self.setUpPickerForTextField()
        
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        if appDelegate.isFrom == "BLE"
        {
            self.setBottomView.isHidden = true
            self.setUpBLEData()
        }
        else
        {
            dict = ["name" : "Lead Acid","ide" : "4"]
            self.arrayBatteryType.add(dict)
            self.setBottomView.isHidden = false
            self.getDeviceDeetails()
            self.getPriceDeetails()
        }
       
        // Do any additional setup after loading the view.
    }
    
    
    func setUpBLEData()
    {
        let onColor  = UIColor.green
        let offColor = UIColor.red
        self.arrayResourcePriority.removeAllObjects()
        var dict = ["name" : "On","ide" : "111"]
        self.arrayResourcePriority.add(dict)
        dict = ["name" : "Off","ide" : "000"]
        self.arrayResourcePriority.add(dict)
        
        self.lblSolarRP.text = "Notification Sound"
        self.lblResourcePreiority.text = "On"
        // check setting is on or off
        
        let settingSwitch = self.dicrDetails.object(forKey: "setting_remote_priority") as? String
        if settingSwitch == "0"
        {
            // off
            self.switchContro.isOn = false
            self.switchContro.tintColor = offColor
            self.switchContro.backgroundColor = offColor
            self.switchContro.layer.cornerRadius = self.switchContro.frame.height / 2.0
            self.switchContro.clipsToBounds = true
            self.getHideAllButtonFromViewRecursion(view: self.view)
        }
        else
        {
            // on
            let onColor = UIColor.green
            self.switchContro.isOn = true
            self.switchContro.onTintColor = onColor
            self.switchContro.layer.cornerRadius = self.switchContro.frame.height / 2.0
            self.switchContro.backgroundColor = onColor
            self.switchContro.clipsToBounds = true
            self.getShowAllButtonFromViewRecursion(view: self.view)
            self.txtFieldAmount.isUserInteractionEnabled = true
        }
        
        //
        let buzzer = self.dicrDetails.object(forKey: "setting_buzzer") as? String// obj.setting_buzzer
        if buzzer == "3"
        {
            self.lblBuzzer.text = "Buzzer Enable "
        }
        else  if buzzer == "2"
        {
            self.lblBuzzer.text = "Buzzer Disabled"
        }
        else
        {
            self.lblBuzzer.text = "Buzzer Enable "
        }
        
        
        let upsType = self.dicrDetails.object(forKey: "setting_ups_type") as? String

        switch (upsType) {
            case "2":
               self.lblUPSType.text = "Narrow Window (185-265V)"
              break;
            case "3":
               self.lblUPSType.text = "Wide Window (90-290V)"
                break
            case "1":
               self.lblUPSType.text = "Wide Window (90-290V)"
                break;
            default:
                self.lblUPSType.text = "Narrow Window (185-265V)"
                break
        }
        
        let batteryType = self.dicrDetails.object(forKey: "setting_battery_type") as? String
        switch (batteryType) {
            case "5":
               self.lblBatteryType.text = "Tubular"
              break;
            case "6":
               self.lblBatteryType.text = "Sealed Maintenance Free"
                break;
            case "7":
                self.lblBatteryType.text = "Lithium Ion"
                break;
            case "1":
               self.lblBatteryType.text = "Tubular"
              break;
            case "2":
               self.lblBatteryType.text = "Sealed Maintenance Free"
                break;
            case "3":
                self.lblBatteryType.text = "Lithium Ion"
                break;
            case "4":
                self.lblBatteryType.text = ""
                break;
            default:
                self.lblBatteryType.text = ""

                break
        }

        let gridCurrent = self.dicrDetails.object(forKey: "setting_grid_charging_current") as? String

        switch (gridCurrent) {
            case "5":
               self.lblGridCharing.text = "2.5A"
              break;
            case "6":
               self.lblGridCharing.text = "5A"
                break;
            case "7":
                self.lblGridCharing.text = "10A"
                break;
            case "8":
                self.lblGridCharing.text = "15A"
                break;
            case "1":
                self.lblGridCharing.text = "2.5 A"
                break;
            case "2":
                self.lblGridCharing.text = "5 A"
                break;
            case "3":
                self.lblGridCharing.text = "10 A"
                break;
            case "4":
                self.lblGridCharing.text = "15 A"
                break;
            default:
                self.lblGridCharing.text = "--"
                break
        }

        let gridStatus = self.dicrDetails.object(forKey: "setting_grid_charging") as? String

        switch (gridStatus) {
            case "0":
               self.lblTemperature.text = "Disable"
              break;
            case "1":
               self.lblTemperature.text = "Enable"
                break;
            case "2":
                self.lblTemperature.text = "Disable"
                break;
            case "3":
                self.lblTemperature.text = "Enable"
                break;
            default:
                self.lblTemperature.text = "Disable"
                break
        }
        
        
        let voltageCut = self.dicrDetails.object(forKey: "setting_low_voltage_cut") as? String

        switch (voltageCut) {
            case "2":
               self.lblLowVoltageCut.text = "5%"
              break;
            case "3":
               self.lblLowVoltageCut.text = "0%"
                break;
            case "1":
                self.lblLowVoltageCut.text = "10.5"
            break;
            case "4":
                self.lblLowVoltageCut.text = "3%"
                break;
            case "5":
                self.lblLowVoltageCut.text = "8%"
                break;
            case "6":
                self.lblLowVoltageCut.text = "10%"
                break;
            default:
                self.lblLowVoltageCut.text = "5%"
                break
        }

        let rPreority = self.dicrDetails.object(forKey: "setting_resource_priority") as? String
//
//        switch (rPreority) {
//             case "1":
//                self.lblResourcePreiority.text = "Enable grid when battery at 13 V"
//               break;
//             case "2":
//                self.lblResourcePreiority.text = "Enable grid when battery at 12.2 V"
//                 break;
//             case "3":
//                self.lblResourcePreiority.text = "Enable grid when battery at 11 V"
//               break;
//             case "4":
//                self.lblResourcePreiority.text = "-"
//               break;
//             case "5":
//                self.lblResourcePreiority.text = "Enable grid when battery at 13 V"
//               break;
//             case "6":
//                self.lblResourcePreiority.text =  "Enable grid when battery at 12.2 V"
//               break;
//             case "7":
//                self.lblResourcePreiority.text =  "Enable grid when battery at 11 V"
//               break;
//             default:
//                self.lblResourcePreiority.text =  "-"
//               break;
//           }
        
        
        
    }
    
    func setUpPicker()
    {
            self.pickerView.delegate = self
            self.pickerView.dataSource = self
            self.pickerView.backgroundColor = UIColor.white
            self.pickerView.setValue(UIColor.black, forKey: "textColor")
            self.pickerView.autoresizingMask = .flexibleWidth
            self.pickerView.contentMode = .center
            self.pickerView.frame = CGRect.init(x: 0.0, y: UIScreen.main.bounds.size.height - 300, width: UIScreen.main.bounds.size.width, height: 300)
            self.view.addSubview(self.pickerView)
                    
            toolBar.barStyle = UIBarStyle.default
            toolBar.isTranslucent = true
            toolBar.tintColor = UIColor.init(red: 103/255, green: 48/255, blue: 197/255, alpha: 1)
            toolBar.sizeToFit()
        
        
            toolBar = UIToolbar.init(frame: CGRect.init(x: 0.0, y: UIScreen.main.bounds.size.height - 250, width: UIScreen.main.bounds.size.width, height: 50))
            toolBar.items = [UIBarButtonItem.init(title: "Done", style: .done, target: self, action: #selector(onDoneButtonTapped))]
            toolBar.tag = 100
            self.view.addSubview(toolBar)
    }
    
    // MARK:- Setup Picker ---------

    func setUpPickerForTextField()
    {
       
        self.toolBarTextField.barStyle = UIBarStyle.default
        self.toolBarTextField.isTranslucent = true
        self.toolBarTextField.tintColor = UIColor.init(red: 103/255, green: 48/255, blue: 197/255, alpha: 1)
        self.toolBarTextField.sizeToFit()
       
       let doneButton = UIBarButtonItem(title: "Done", style: UIBarButtonItem.Style.plain, target: self, action: #selector(donePicker))
       
       let spaceButton = UIBarButtonItem(barButtonSystemItem: UIBarButtonItem.SystemItem.flexibleSpace, target: nil, action: nil)
       
       let cancelButton = UIBarButtonItem(title: "Cancel", style: UIBarButtonItem.Style.plain, target: self, action: #selector(cancelPicker))
       
        self.toolBarTextField.setItems([cancelButton, spaceButton, doneButton], animated: false)
        self.toolBarTextField.isUserInteractionEnabled = true
               
        self.txtFieldAmount.inputAccessoryView = toolBarTextField
        

}

    
    @objc func donePicker() {
        self.txtFieldAmount.resignFirstResponder()
        // call service for upadate currency
        self.updateCurrencyToServer()
        
    }
    
    func updateCurrencyToServer()
    {
        if !Reachability.isConnectedToNetwork()
        {
            let alert = UIAlertController(title: webServices.AppName, message: "Internet connection is not available. Please check your internet.", preferredStyle: UIAlertController.Style.alert)
            alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { (action) in
               
            }))
            self.present(alert, animated: true, completion: nil)
            return
        }
        
        self.viewModel.updateCurency(charge: self.txtFieldAmount.text!, currency: self.lblWarrenty.text!, deviceId: self.deviceId, viewController: self, isLoaderRequired: true) { errorString, obj in
            if errorString == "Success"
            {
                let alert = UIAlertController(title: webServices.AppName, message: obj, preferredStyle: UIAlertController.Style.alert)
                alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { (action) in
                   
                }))
                self.present(alert, animated: true, completion: nil)
            }
        }
        
    }
            
    @objc func cancelPicker()
    {
        self.txtFieldAmount.resignFirstResponder()
    }
    
    @objc func onDoneButtonTapped()
    {
        
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        if appDelegate.isFrom == "BLE"
        {
            self.view.resignFirstResponder()
            self.view.endEditing(true)
            var dict = NSMutableDictionary()
            dict.setValue(AppUtils.getCurrenTimeStamp(), forKey: "timestamp")

            for v in self.view.subviews{
                if v is UIToolbar
                {
                    v.removeFromSuperview()
                }
                else if v is UIPickerView{
                   v.removeFromSuperview()
                   switch v.tag {
                   case 9:
                       // ups type for ble
                       dict.setValue(self.selectedId, forKey: "setting_ups_type")

                       break
                   case 99:
                       // battery type for ble
                       dict.setValue(self.selectedId, forKey: "setting_battery_type")

                       break
                   case 999:
                       // grid charging current for ble
                       dict.setValue(self.selectedId, forKey: "setting_grid_charging_current")

                       break
                   case 99999:
                       // low voltage for ble
                       dict.setValue(self.selectedId, forKey: "setting_low_voltage_cut")

                       break
                   case 999999:
                       // Grid charging status for ble
                       dict.setValue(self.selectedId, forKey: "setting_grid_charging")

                       break
                   case 9999999:
                       // buzzer for ble
                       dict.setValue(self.selectedId, forKey: "setting_buzzer")

                       break
                   case 99999999:
                       // Resource preioty for ble
                       dict.setValue(self.selectedId, forKey: "setting_resource_priorty")
                      
                       break
                   case 999999999:
                       // Electricity per unit not for ble
                      
                       break
                   default: break
                       // nothing to do
                   }
               }

            }
            
            
            if self.selectedId == "111"
            {
                appDelegate.audioActive = 1
            }
            if self.selectedId == "000"
            {
                appDelegate.audioActive = 0
            }
            if self.selectedId == "000" && self.selectedId == "111"
            {
                return
            }
            
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

        }
              
        
        }
        else
        {
            self.view.resignFirstResponder()
            self.view.endEditing(true)
            
            for v in self.view.subviews{
                if v is UIToolbar
                {
                    v.removeFromSuperview()
                }
                else if v is UIPickerView{
                   v.removeFromSuperview()
                   switch v.tag {
                   case 9:
                       // ups type
                       self.callServiceForUpdate(value: self.selectedId, isfromTag: v.tag)
                       break
                   case 99:
                       // battery type
                       self.callServiceForUpdate(value: self.selectedId, isfromTag: v.tag)
                       break
                   case 999:
                       // grid charging
                       self.callServiceForUpdate(value: self.selectedId, isfromTag: v.tag)
                       break
                   case 99999:
                       // low voltage
                       self.callServiceForUpdate(value: self.selectedId, isfromTag: v.tag)
                       break
                   case 999999:
                       // ATC
                       self.callServiceForUpdate(value: self.selectedId, isfromTag: v.tag)
                       break
                   case 9999999:
                       // buzzer
                       self.callServiceForUpdate(value: self.selectedId, isfromTag: v.tag)
                       break
                   case 99999999:
                       // Resource preioty
                       self.callServiceForUpdate(value: self.selectedId, isfromTag: v.tag)
                       break
                   case 999999999:
                       // Electricity per unit
                      // self.callServiceForUpdate(value: self.selectedId, isfromTag: v.tag)
                       break
                   default: break
                       // nothing to do
                   }
               }

            }
        }
        
        
    }
    
    func callServiceForUpdate(value : String, isfromTag : Int)
    {
        switch isfromTag{
        case 9:
            // ups type
            let value = self.deviceId + "/" + String(self.selectedId)
            self.callServiceForUpdateValues(deviceIDAndValue: value, isFrom: "ut")
            break
        case 99:
            // battery type
            let value = self.deviceId + "/" + String(self.selectedId)
            self.callServiceForUpdateValues(deviceIDAndValue: value, isFrom: "bt")
            break
        case 999:
            // grid charging
            let value = self.deviceId + "/" + String(self.selectedId)
            self.callServiceForUpdateValues(deviceIDAndValue: value, isFrom: "gcc")
            break
        case 99999:
            // low voltage
            let value = self.deviceId + "/" + String(self.selectedId)
            self.callServiceForUpdateValues(deviceIDAndValue: value, isFrom: "lvc")
            break
        case 999999:
            // GRid Charging
            let value = self.deviceId + "/" + String(self.selectedId)
            self.callServiceForUpdateValues(deviceIDAndValue: value, isFrom: "grid")
            break
        case 9999999:
            // buzzer
            let value = self.deviceId + "/" + String(self.selectedId)
            self.callServiceForUpdateValues(deviceIDAndValue: value, isFrom: "buzzer")
            break
        case 99999999:
            // Resource preioty
            let value = self.deviceId + "/" + String(self.selectedId)
            self.callServiceForUpdateValues(deviceIDAndValue: value, isFrom: "srp")
            break
        default: break
            // nothing to do
        }
    }
    
    func callServiceForUpdateValues(deviceIDAndValue : String, isFrom : String)
    {
        if !Reachability.isConnectedToNetwork()
        {
            let alert = UIAlertController(title: webServices.AppName, message: "Internet connection is not available. Please check your internet.", preferredStyle: UIAlertController.Style.alert)
            alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { (action) in
               
            }))
            self.present(alert, animated: true, completion: nil)
            return
        }
        let devicedetails = isFrom + "/" + deviceIDAndValue
        
        self.viewModel.updateSettingValues(deviceId: devicedetails, viewController: self, isLoaderRequired: true) { errorString, obj in
            if errorString == "Success"
            {
                let alert = UIAlertController(title: webServices.AppName, message: obj, preferredStyle: UIAlertController.Style.alert)
                alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { (action) in
                   
                }))
                self.present(alert, animated: true, completion: nil)
            }
            else
            {
                let alert = UIAlertController(title: webServices.AppName, message: obj, preferredStyle: UIAlertController.Style.alert)
                alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { (action) in
                   
                }))
                self.present(alert, animated: true, completion: nil)
            }
        }
        
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
        
        self.viewModel.deviceDetails(deviceId: deviceId, viewController: self, isLoaderRequired: true) { status, obj in
            if status == "Success"
            {
                self.setupDetails(obj: obj)
            }
        }
    }
    
    func getPriceDeetails()
    {
        if !Reachability.isConnectedToNetwork()
        {
            let alert = UIAlertController(title: webServices.AppName, message: "Internet connection is not available. Please check your internet.", preferredStyle: UIAlertController.Style.alert)
            alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { (action) in
               
            }))
            self.present(alert, animated: true, completion: nil)
            return
        }
        
        self.viewModel.getCurrencyDetails(viewController: self, isLoaderRequired: true) { errorString, obj in
            if errorString == "Success"
            {
                self.currencyList = obj
            }
        }
        
    }
    
    func setupDetails(obj : DeviceDetailsModel)  {
        //self.lblWarrenty.text = String(obj.warranty_1) + " Months, " + String(obj.warranty_2) + " Days"
        let onColor  = UIColor.green
        let offColor = UIColor.red

        if obj.setting_remote_priority == 0
        {
            self.switchContro.isOn = false
            self.switchContro.tintColor = offColor
            self.switchContro.backgroundColor = offColor
            self.switchContro.layer.cornerRadius = self.switchContro.frame.height / 2.0
            self.switchContro.clipsToBounds = true
            self.getHideAllButtonFromViewRecursion(view: self.view)

        }
        else
        {
            self.switchContro.isOn = true
            self.switchContro.onTintColor = onColor
            self.switchContro.layer.cornerRadius = self.switchContro.frame.height / 2.0
            self.switchContro.backgroundColor = onColor
            self.switchContro.clipsToBounds = true
            self.getShowAllButtonFromViewRecursion(view: self.view)
            
        }
        
        
        self.lblWarrenty.text = obj.currency
        self.txtFieldAmount.text = obj.electricity_unit_charge
        
   
        let buzzer = obj.setting_buzzer
        if buzzer == 3
        {
            self.lblBuzzer.text = "Buzzer Enable "
        }
        else  if buzzer == 2
        {
            self.lblBuzzer.text = "Buzzer Disabled"
        }
        else
        {
            self.lblBuzzer.text = "Buzzer Enable "
        }
        
        switch (obj.setting_atc) {
            case "2":
                self.lblTemperature.text = "ATC Disable"
              break;
            case "3":
               self.lblTemperature.text = "ATC Enable"
                break;
            default:
                self.lblTemperature.text = "ATC Enable"
                break
        }
        
        switch (obj.setting_ups_type_is) {
            case 2:
               self.lblUPSType.text = "Narrow Window (185-265V)"
              break;
            case 3:
               self.lblUPSType.text = "Wide Window (90-290V)"
                break
            case 1:
               self.lblUPSType.text = "Wide Window (90-290V)"
                break;
            default:
                self.lblUPSType.text = "Narrow Window (185-265V)"
                break
        }
        
        
        switch (obj.setting_battery_type_is) {
            case 5:
               self.lblBatteryType.text = "Tubular"
              break;
            case 6:
               self.lblBatteryType.text = "Sealed Maintenance Free"
                break;
            case 7:
                self.lblBatteryType.text = "Lithium Ion"
                break;
            
            case 1:
               self.lblBatteryType.text = "Tubular"
              break;
            case 2:
               self.lblBatteryType.text = "Sealed Maintenance Free"
                break;
            case 3:
                self.lblBatteryType.text = "Lithium Ion"
                break;
            case 4:
                self.lblBatteryType.text = "Lead Acid"
                break;
            default:
                self.lblBatteryType.text = "Lead Acid"

                break
        }
        
        switch (obj.setting_grid_charging_is) {
            case 5:
               self.lblGridCharing.text = "2.5A"
              break;
            case 6:
               self.lblGridCharing.text = "5A"
                break;
            case 7:
                self.lblGridCharing.text = "10A"
                break;
            case 8:
                self.lblGridCharing.text = "15A"
                break;
            case 1:
                self.lblGridCharing.text = "2.5 A"
                break;
            case 2:
                self.lblGridCharing.text = "5 A"
                break;
            case 3:
                self.lblGridCharing.text = "10 A"
                break;
            case 4:
                self.lblGridCharing.text = "15 A"
                break;
            default:
                self.lblGridCharing.text = "--"
                break
        }
        
        switch (obj.setting_grid_charging) {
            case 0:
               self.lblTemperature.text = "Disable"
              break;
            case 1:
               self.lblTemperature.text = "Enable"
                break;
            case 2:
                self.lblTemperature.text = "Disable"
                break;
            case 3:
                self.lblTemperature.text = "Enable"
                break;
            default:
                self.lblTemperature.text = "Disable"
                break
        }
        
        
        switch (obj.setting_low_voltage_cut_is) {
            case 2:
               self.lblLowVoltageCut.text = "11.0"
              break;
            case 3:
               self.lblLowVoltageCut.text = "10.5"
                break;
            case 1:
                self.lblLowVoltageCut.text = "10.5"
            break;
            case 4:
                self.lblLowVoltageCut.text = "10.8"
                break;
            case 5:
                self.lblLowVoltageCut.text = "11.2"
                break;
            case 6:
                self.lblLowVoltageCut.text = "11.4"
                break;
            default:
                self.lblLowVoltageCut.text = "11.0"
                break
        }
        
        switch (obj.setting_resource_priority) {
             case 1:
                self.lblResourcePreiority.text = "Enable grid when battery at 13 V"
               break;
             case 2:
                self.lblResourcePreiority.text = "Enable grid when battery at 12.2 V"
                 break;
             case 3:
                self.lblResourcePreiority.text = "Enable grid when battery at 11 V"
               break;
             case 4:
                self.lblResourcePreiority.text = "-"
               break;
             case 5:
                self.lblResourcePreiority.text = "Enable grid when battery at 13 V"
               break;
             case 6:
                self.lblResourcePreiority.text =  "Enable grid when battery at 12.2 V"
               break;
             case 7:
                self.lblResourcePreiority.text =  "Enable grid when battery at 11 V"
               break;
             default:
                self.lblResourcePreiority.text =  "-"
               break;
           }
       
    }
    
    @IBAction func tapBack(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func tapBtnForAction(_ sender: UIButton) {
        self.setUpPicker()
        self.pickerView.tag = sender.tag
        self.pickerView.reloadAllComponents()
    }
    
    
    
    @IBAction func tapswitchChnageValue(_ sender: UISwitch) {
        
        
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        if appDelegate.isFrom == "BLE"
        {
            let alert = UIAlertController(title: webServices.AppName, message: "Are you sure, you want to switch On.", preferredStyle: UIAlertController.Style.alert)
            alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: { (action) in
                if sender.isOn == false
                            {
                                
                                let offColor = UIColor.red
                                self.switchContro.isOn = false
                                self.switchContro.tintColor = offColor
                                self.switchContro.backgroundColor = offColor
                                self.switchContro.layer.cornerRadius = self.switchContro.frame.height / 2.0
                                self.switchContro.clipsToBounds = true
                                self.getHideAllButtonFromViewRecursion(view: self.view)
                                self.txtFieldAmount.isUserInteractionEnabled = false
                                
                                // send data to ble off
                                let dict = NSMutableDictionary()
                                dict.setValue(AppUtils.getCurrenTimeStamp(), forKey: "timestamp")
                                dict.setValue("0", forKey: "setting_remote_priority")

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

                                }
                            }
                            else
                            {
                                let onColor = UIColor.green
                                self.switchContro.isOn = true
                                self.switchContro.onTintColor = onColor
                                self.switchContro.layer.cornerRadius = self.switchContro.frame.height / 2.0
                                self.switchContro.backgroundColor = onColor
                                self.switchContro.clipsToBounds = true
                                self.getShowAllButtonFromViewRecursion(view: self.view)
                                self.txtFieldAmount.isUserInteractionEnabled = true
                                // send data to ble on
                                let dict = NSMutableDictionary()
                                dict.setValue(AppUtils.getCurrenTimeStamp(), forKey: "timestamp")
                                dict.setValue("1", forKey: "setting_remote_priority")

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

                                }
                            }
            }))
            alert.addAction(UIAlertAction(title: "Cancel", style: .default, handler: { (action) in
               
            }))
            self.present(alert, animated: true, completion: nil)
        }
        else
        {
            if sender.isOn == false
            {
                // device is offline
                if !Reachability.isConnectedToNetwork()
                {
                    let alert = UIAlertController(title: webServices.AppName, message: "Internet connection is not available. Please check your internet.", preferredStyle: UIAlertController.Style.alert)
                    alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { (action) in
                       
                    }))
                    self.present(alert, animated: true, completion: nil)
                    return
                }
                
                self.viewModel.deviceOnoff(deviceId: self.deviceId, control: 0, viewController: self, isLoaderRequired: true) { errorString, obj in
                    if errorString == "Success"
                    {
                        let alert = UIAlertController(title: webServices.AppName, message: obj, preferredStyle: UIAlertController.Style.alert)
                        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { (action) in
                            DispatchQueue.main.async {
                                let offColor = UIColor.red
                                self.switchContro.isOn = false
                                self.switchContro.tintColor = offColor
                                self.switchContro.backgroundColor = offColor
                                self.switchContro.layer.cornerRadius = self.switchContro.frame.height / 2.0
                                self.switchContro.clipsToBounds = true
                                self.getHideAllButtonFromViewRecursion(view: self.view)
                                self.txtFieldAmount.isUserInteractionEnabled = false
                            }
                        }))
                        self.present(alert, animated: true, completion: nil)
                    }
                    else
                    {
                        let alert = UIAlertController(title: webServices.AppName, message: obj, preferredStyle: UIAlertController.Style.alert)
                        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { (action) in
                           
                        }))
                        self.present(alert, animated: true, completion: nil)
                    }
                }
            }
            
            else
            {
                // device is online
                if !Reachability.isConnectedToNetwork()
                {
                    let alert = UIAlertController(title: webServices.AppName, message: "Internet connection is not available. Please check your internet.", preferredStyle: UIAlertController.Style.alert)
                    alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { (action) in
                       
                    }))
                    self.present(alert, animated: true, completion: nil)
                    return
                }
                
                
                
                self.viewModel.deviceOnoff(deviceId: self.deviceId, control: 1, viewController: self, isLoaderRequired: true) { errorString, obj in
                    if errorString == "Success"
                    {
                        let alert = UIAlertController(title: webServices.AppName, message: obj, preferredStyle: UIAlertController.Style.alert)
                        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { (action) in
                            DispatchQueue.main.async {
                                let onColor = UIColor.green
                                self.switchContro.isOn = true
                                self.switchContro.onTintColor = onColor
                                self.switchContro.layer.cornerRadius = self.switchContro.frame.height / 2.0
                                self.switchContro.backgroundColor = onColor
                                self.switchContro.clipsToBounds = true
                                self.getShowAllButtonFromViewRecursion(view: self.view)
                                self.txtFieldAmount.isUserInteractionEnabled = true
                            }
                        }))
                        self.present(alert, animated: true, completion: nil)
                    }
                    else
                    {
                        let alert = UIAlertController(title: webServices.AppName, message: obj, preferredStyle: UIAlertController.Style.alert)
                        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { (action) in
                           
                        }))
                        self.present(alert, animated: true, completion: nil)
                    }
                }
            }
        }
        
        
    }
    
  
    
    func getHideAllButtonFromViewRecursion(view: UIView)  {

        for v in view.subviews {
            if v.subviews.count > 0 {
                self.getHideAllButtonFromViewRecursion(view: v)
            }
            else if (v.isKind(of: UIButton.self)) {
                if v.tag == 9 || v.tag == 99 || v.tag == 999 || v.tag == 9999 || v.tag == 99999 || v.tag == 999999 || v.tag == 9999999 || v.tag == 99999999 || v.tag == 999999999
                {
                    v.isHidden = true
                }
            }
            else if (v.isKind(of: UIImageView.self)) {
                if v.tag == 8 || v.tag == 88 || v.tag == 888 || v.tag == 8888 || v.tag == 88888 || v.tag == 888888 || v.tag == 8888888 || v.tag == 88888888 || v.tag == 888888888
                {
                    v.isHidden = true
                }
            }
        }
    }
    
    func getShowAllButtonFromViewRecursion(view: UIView)  {

        for v in view.subviews {
            if v.subviews.count > 0 {
                self.getShowAllButtonFromViewRecursion(view: v)
            }
            else if (v.isKind(of: UIButton.self)) {
                if v.tag == 9 || v.tag == 99 || v.tag == 999 || v.tag == 9999 || v.tag == 99999 || v.tag == 999999 || v.tag == 9999999 || v.tag == 99999999 || v.tag == 999999999
                {
                    v.isHidden = false
                }
            }
            else if (v.isKind(of: UIImageView.self)) {
                if v.tag == 8 || v.tag == 88 || v.tag == 888 || v.tag == 8888 || v.tag == 88888 || v.tag == 888888 || v.tag == 8888888 || v.tag == 88888888 || v.tag == 888888888
                {
                    v.isHidden = false
                }
            }
        }

    }
    
   
    
    
    //=====================================================
     // MARK: - UIPickerView delegate datasource method
     //=====================================================
     
     
     func numberOfComponents(in pickerVitew: UIPickerView) -> Int {
         return 1
     }
     
     func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int
     {
        if self.pickerView.tag == 9
        {
            return self.arrayUPSType.count
        }
        else if self.pickerView.tag == 99
        {
            return self.arrayBatteryType.count
        }
        else if self.pickerView.tag == 999
        {
            return self.arrayGrid.count
        }
         else if self.pickerView.tag == 99999
         {
             return self.arrayLowVeltage.count
         }
         else if self.pickerView.tag == 999999
         {
             return self.arrayGridCharging.count
         }
         else if self.pickerView.tag == 9999999
         {
             return self.arrayBuzzer.count
         }
         else if self.pickerView.tag == 999999999
         {
             return self.currencyList.count
         }
         else
         {
             return self.arrayResourcePriority.count
         }
         
     }
     
     
     func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
          
        var value = String()
         if self.pickerView.tag == 9
         {
             let dict = self.arrayUPSType[row] as? NSDictionary
             value = (dict?.object(forKey: "name") as? String)!
         }
         else if self.pickerView.tag == 99
         {
             let dict = self.arrayBatteryType[row] as? NSDictionary
             value = (dict?.object(forKey: "name") as? String)!
         }
         else if self.pickerView.tag == 999
         {
             let dict = self.arrayGrid[row] as? NSDictionary
             value = (dict?.object(forKey: "name") as? String)!
         }
          else if self.pickerView.tag == 99999
          {
              let dict = self.arrayLowVeltage[row] as? NSDictionary
              value = (dict?.object(forKey: "name") as? String)!
          }
          else if self.pickerView.tag == 999999
          {
              let dict = self.arrayGridCharging[row] as? NSDictionary
              value = (dict?.object(forKey: "name") as? String)!
          }
          else if self.pickerView.tag == 9999999
          {
              let dict = self.arrayBuzzer[row] as? NSDictionary
              value = (dict?.object(forKey: "name") as? String)!
          }
         else if self.pickerView.tag == 999999999
         {
          
             value = self.currencyList[row].country + "(" + self.currencyList[row].code + ")"
         }
          else
          {
              let dict = self.arrayResourcePriority[row] as? NSDictionary
              value = (dict?.object(forKey: "name") as? String)!
          }
        return value
     }
     
     
     func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
       
         if self.pickerView.tag == 9
         {
             let dict = self.arrayUPSType[row] as? NSDictionary
             self.lblUPSType.text = (dict?.object(forKey: "name") as? String)!
             self.selectedId = (dict?.object(forKey: "ide") as? String)!
         }
         else if self.pickerView.tag == 99
         {
             let dict = self.arrayBatteryType[row] as? NSDictionary
             self.lblBatteryType.text = (dict?.object(forKey: "name") as? String)!
             self.selectedId = (dict?.object(forKey: "ide") as? String)!

         }
         else if self.pickerView.tag == 999
         {
             let dict = self.arrayGrid[row] as? NSDictionary
             self.lblGridCharing.text = (dict?.object(forKey: "name") as? String)!
             self.selectedId = (dict?.object(forKey: "ide") as? String)!

         }
          else if self.pickerView.tag == 99999
          {
              let dict = self.arrayLowVeltage[row] as? NSDictionary
              self.lblLowVoltageCut.text = (dict?.object(forKey: "name") as? String)!
              self.selectedId = (dict?.object(forKey: "ide") as? String)!

          }
          else if self.pickerView.tag == 999999
          {
              let dict = self.arrayGridCharging[row] as? NSDictionary
              self.lblTemperature.text = (dict?.object(forKey: "name") as? String)!
              self.selectedId = (dict?.object(forKey: "ide") as? String)!

          }
          else if self.pickerView.tag == 9999999
          {
              let dict = self.arrayBuzzer[row] as? NSDictionary
              self.lblBuzzer.text = (dict?.object(forKey: "name") as? String)!
              self.selectedId = (dict?.object(forKey: "ide") as? String)!

          }
         else if self.pickerView.tag == 999999999
         {
             self.lblWarrenty.text = self.currencyList[row].country + "(" + self.currencyList[row].code + ")"
             self.selectedId = self.currencyList[row].symbol

         }
          else
          {
              let dict = self.arrayResourcePriority[row] as? NSDictionary
              self.lblResourcePreiority.text = (dict?.object(forKey: "name") as? String)!
              self.selectedId = (dict?.object(forKey: "ide") as? String)!

          }
      
     }
    
    
}
