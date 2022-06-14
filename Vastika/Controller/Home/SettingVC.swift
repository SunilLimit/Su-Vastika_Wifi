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
    @IBOutlet weak var lblPriority: UILabel!
    @IBOutlet weak var lblLowVoltageCut: UILabel!
    @IBOutlet weak var lblTemperature: UILabel!
    @IBOutlet weak var lblWarrenty: UILabel!
    @IBOutlet weak var lblResourcePreiority: UILabel!
    var viewModel = DeviceDetailsViewModel()
    @IBOutlet weak var switchContro: UISwitch!
    @IBOutlet weak var lblBuzzer: UILabel!
    
    var deviceId = String()
    var arrayUPSType = NSMutableArray()
    var arrayBatteryType = NSMutableArray()
    var arrayGrid = NSMutableArray()
    var arrayLowVeltage = NSMutableArray()
    var arrayAmbientTemp = NSMutableArray()
    var arrayBuzzer = NSMutableArray()
    var arrayResourcePriority = NSMutableArray()

    var pickerView = UIPickerView()
    var toolBar = UIToolbar()
    var selectedId = String()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        var dict = ["name" : "Buzzer Enable","ide" : "3"]
        self.arrayBuzzer.add(dict)
        dict = ["name" : "Buzzer Disabled","ide" : "2"]
        self.arrayBuzzer.add(dict)
        
        dict = ["name" : "ATC Disable","ide" : "2"]
        self.arrayAmbientTemp.add(dict)
        dict = ["name" : "ATC Enable","ide" : "3"]
        self.arrayAmbientTemp.add(dict)
                
        dict = ["name" : "Narrow Window","ide" : "2"]
        self.arrayUPSType.add(dict)
        dict = ["name" : "Wide Window","ide" : "3"]
        self.arrayUPSType.add(dict)
     
        
        dict = ["name" : "Tubular","ide" : "5"]
        self.arrayBatteryType.add(dict)
        dict = ["name" : "Sealed Maintenance Free","ide" : "6"]
        self.arrayBatteryType.add(dict)
        dict = ["name" : "Lithium Ion","ide" : "7"]
        self.arrayBatteryType.add(dict)
        dict = ["name" : "Lead Acid","ide" : "4"]
        self.arrayBatteryType.add(dict)
                
        dict = ["name" : "2.5A","ide" : "5"]
        self.arrayGrid.add(dict)
        dict = ["name" : "5A","ide" : "6"]
        self.arrayGrid.add(dict)
        dict = ["name" : "10A","ide" : "7"]
        self.arrayGrid.add(dict)
        dict = ["name" : "15A","ide" : "8"]
        self.arrayGrid.add(dict)
        
        dict = ["name" : "11.0","ide" : "2"]
        self.arrayLowVeltage.add(dict)
        dict = ["name" : "10.5","ide" : "3"]
        self.arrayLowVeltage.add(dict)
        dict = ["name" : "10.8","ide" : "4"]
        self.arrayLowVeltage.add(dict)
        dict = ["name" : "11.2","ide" : "5"]
        self.arrayLowVeltage.add(dict)
        dict = ["name" : "11.6","ide" : "6"]
        self.arrayLowVeltage.add(dict)
        
        dict = ["name" : "Enable grid when battery at 13 V","ide" : "1"]
        self.arrayResourcePriority.add(dict)
        dict = ["name" : "Enable grid when battery at 12.2 V","ide" : "2"]
        self.arrayResourcePriority.add(dict)
        dict = ["name" : "Enable grid when battery at 11 V","ide" : "3"]
        self.arrayResourcePriority.add(dict)
        
        self.getDeviceDeetails()
        // Do any additional setup after loading the view.
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
                    
            toolBar = UIToolbar.init(frame: CGRect.init(x: 0.0, y: UIScreen.main.bounds.size.height - 300, width: UIScreen.main.bounds.size.width, height: 50))
            toolBar.items = [UIBarButtonItem.init(title: "Done", style: .done, target: self, action: #selector(onDoneButtonTapped))]
            toolBar.tag = 100
            self.view.addSubview(toolBar)
    }

    @objc func onDoneButtonTapped()
    {
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
               default: break
                   // nothing to do
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
            // ATC
            let value = self.deviceId + "/" + String(self.selectedId)
            self.callServiceForUpdateValues(deviceIDAndValue: value, isFrom: "atc")
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
    
    func setupDetails(obj : DeviceDetailsModel)  {
        self.lblPriority.text = obj.setting_priority
        self.lblWarrenty.text = String(obj.warranty_1) + " Months, " + String(obj.warranty_2) + " Days"
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
               self.lblUPSType.text = "Narrow Window"
              break;
            case 3:
               self.lblUPSType.text = "Wide Window"
                break
            case 1:
               self.lblUPSType.text = "Wide Window"
                break;
            default:
                self.lblUPSType.text = "Narrow Window"
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
    
  
    
    func getHideAllButtonFromViewRecursion(view: UIView)  {

        for v in view.subviews {
            if v.subviews.count > 0 {
                self.getHideAllButtonFromViewRecursion(view: v)
            }
            else if (v.isKind(of: UIButton.self)) {
                if v.tag == 9 || v.tag == 99 || v.tag == 999 || v.tag == 9999 || v.tag == 99999 || v.tag == 999999 || v.tag == 9999999 || v.tag == 99999999
                {
                    v.isHidden = true
                }
            }
            else if (v.isKind(of: UIImageView.self)) {
                if v.tag == 8 || v.tag == 88 || v.tag == 888 || v.tag == 8888 || v.tag == 88888 || v.tag == 888888 || v.tag == 8888888 || v.tag == 88888888
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
                if v.tag == 9 || v.tag == 99 || v.tag == 999 || v.tag == 9999 || v.tag == 99999 || v.tag == 999999 || v.tag == 9999999 || v.tag == 99999999
                {
                    v.isHidden = false
                }
            }
            else if (v.isKind(of: UIImageView.self)) {
                if v.tag == 8 || v.tag == 88 || v.tag == 888 || v.tag == 8888 || v.tag == 88888 || v.tag == 888888 || v.tag == 8888888 || v.tag == 88888888
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
             return self.arrayAmbientTemp.count
         }
         else if self.pickerView.tag == 9999999
         {
             return self.arrayBuzzer.count
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
              let dict = self.arrayAmbientTemp[row] as? NSDictionary
              value = (dict?.object(forKey: "name") as? String)!
          }
          else if self.pickerView.tag == 9999999
          {
              let dict = self.arrayBuzzer[row] as? NSDictionary
              value = (dict?.object(forKey: "name") as? String)!
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
              let dict = self.arrayAmbientTemp[row] as? NSDictionary
              self.lblTemperature.text = (dict?.object(forKey: "name") as? String)!
              self.selectedId = (dict?.object(forKey: "ide") as? String)!

          }
          else if self.pickerView.tag == 9999999
          {
              let dict = self.arrayBuzzer[row] as? NSDictionary
              self.lblBuzzer.text = (dict?.object(forKey: "name") as? String)!
              self.selectedId = (dict?.object(forKey: "ide") as? String)!

          }
          else
          {
              let dict = self.arrayResourcePriority[row] as? NSDictionary
              self.lblResourcePreiority.text = (dict?.object(forKey: "name") as? String)!
              self.selectedId = (dict?.object(forKey: "ide") as? String)!

          }
      
     }
    
    
}
