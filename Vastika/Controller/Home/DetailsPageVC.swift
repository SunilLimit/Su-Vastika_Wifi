//
//  DetailsPageVC.swift
//  Vastika
//
//  Created by Mac on 16/09/21.
//

import UIKit

class DetailsPageVC: UIViewController {

    @IBOutlet weak var viewTop1: UIView!
    @IBOutlet weak var lblTitle: UILabel!
    @IBOutlet weak var lblTitlePower: UILabel!
    @IBOutlet weak var lblTitleDevice: UILabel!
    
    @IBOutlet weak var newAddedView: UIView!
    @IBOutlet weak var btnSeetting: UIButton!
    @IBOutlet weak var btnDiagnose: UIButton!
    @IBOutlet weak var btnAleert: UIButton!
    @IBOutlet var mainLoad: MainLoad!
    @IBOutlet var upsMode: UPSMode!
    @IBOutlet var solarMode: SolarMode!
    var viewModel = DeviceDetailsViewModel()
    var deviceId = String()
    
    var gameTimer: Timer?
    var counter = 9999999
    var count = 1
    var check = true
    // MARK:- View Life Cycle --------
    
    override func viewDidLoad() {
        super.viewDidLoad()
       
        self.btnAleert.layer.cornerRadius = self.btnAleert.frame.size.height/2
        self.btnAleert.clipsToBounds = true
       
        self.gameTimer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(runTimedCode), userInfo: nil, repeats: true)
        self.btnSeetting.layer.cornerRadius = self.btnSeetting.frame.size.height/2
        self.btnSeetting.clipsToBounds = true
        
        self.btnDiagnose.layer.cornerRadius = self.btnDiagnose.frame.size.height/2
        self.btnDiagnose.clipsToBounds = true
        self.getDeviceDeetails()
        self.setUpView(vw: self.viewTop1)
        self.newAddedView.addSubview(self.mainLoad)
        self.newAddedView.addSubview(self.upsMode)
        self.newAddedView.addSubview(self.solarMode)

        // Do any additional setup after loading the view.
    
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        self.check = false
    }
    // MARK:- UIAction Method -----------
     
     @objc func runTimedCode()
     {
         if counter != 0
         {
            self.counter = self.counter - 1
            self.gameTimer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(runTimedCode), userInfo: nil, repeats: true)
            self.getDeviceDeetails()
         }
         else
         {
             gameTimer?.invalidate()
         }
     }
    
    func getDeviceDeetails()
    {
        var loader = false
        if count == 1
        {
            loader = true
            count = count + 1
        }
        else
        {
            loader = false
        }
        
        if self.check == false
        {
            return
        }
        
        if !Reachability.isConnectedToNetwork()
        {
            let alert = UIAlertController(title: webServices.AppName, message: "Internet connection is not availbale. Please check your intertnet.", preferredStyle: UIAlertController.Style.alert)
            alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { (action) in
               
            }))
            self.present(alert, animated: true, completion: nil)
            return
        }
        
        self.viewModel.deviceDetails(deviceId: deviceId, viewController: self, isLoaderRequired: loader) { [self] status, obj in
            if status == "Success"
            {
                self.setupDetails(obj: obj)
                
            }
            else
            {
                //self.counter = 0
                self.lblTitle.text = "Device Offline"
                let alert = UIAlertController(title: webServices.AppName, message: "Device Offline", preferredStyle: UIAlertController.Style.alert)
                alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { (action) in
                    self.getDeviceDeetails()
                   // self.counter = 9999999
                }))
                alert.addAction(UIAlertAction(title: "Back", style: .default, handler: { (action) in
                   // self.counter = 0
                    self.navigationController?.popViewController(animated: true)
                }))
                self.present(alert, animated: true, completion: nil)
            }
        }
    }
    
    func setUpUPSMode(obj : DeviceDetailsModel)
    {
        // set section First
        if obj.status_front_switch == 0
        {
            self.upsMode.imgSwitchONOFF.image = UIImage(named: "switchoff")
            self.upsMode.lblSwitch.text = "Switch : OFF"
        }
        else
        {
            self.upsMode.imgSwitchONOFF.image = UIImage(named: "switchon")
            self.upsMode.lblSwitch.text = "Switch : ON"
        }
        // set section 2
        self.upsMode.lblATCValue.text = "ATC (" + String(obj.at) + " ℃" + ")"

        // set section 3
        if obj.status_ups == 0
        {
            self.upsMode.imgSystemStaus.image = UIImage(named: "systemstatusun")
            self.upsMode.lblSystemStatus.text = "System Status : UPS Off"
        }
        else
        {
            self.upsMode.imgSystemStaus.image = UIImage(named: "systemstatus")
            self.upsMode.lblSystemStatus.text = "System Status : UPS On"
        }
        
        // set sectino 4
        if obj.pvw == 0
        {
            self.upsMode.imgSolarSystem.image = UIImage(named: "solar_status_off")
            let stringValue = "Solar Status : 0 W"
            let attributedString: NSMutableAttributedString = NSMutableAttributedString(string: stringValue)
            attributedString.setColor(color: UIColor.init(red: 243.0/255.0, green: 168.0/255.0, blue: 59.0/255.0, alpha: 1.0), forText: "0 W")
            
            self.upsMode.lblSolarSystem.attributedText = attributedString//"Solar Status : " + String(obj.pvw) + " W"
        }
        else
        {
            self.upsMode.imgSolarSystem.image = UIImage(named: "solorstatus")
            let stringValue = "Solar Status : " + String(obj.pvw) + " W"
            let attributedString: NSMutableAttributedString = NSMutableAttributedString(string: stringValue)
            attributedString.setColor(color: UIColor.init(red: 243.0/255.0, green: 168.0/255.0, blue: 59.0/255.0, alpha: 1.0), forText: String(obj.pvw) + " W")
            
            self.upsMode.lblSolarSystem.attributedText = attributedString//"Solar Status : " + String(obj.pvw) + " W"
        }
        
        // set section 5
        self.upsMode.lblBattery.text =  "Battery Percentage : " + String(obj.battery_percent)
        if obj.battery_percent > 80
        {
            // greeen
            self.upsMode.imgBatteruy.image = UIImage(named: "mediumbattery Green")
        }
        else if obj.battery_percent > 50 && obj.battery_percent < 80
        {
            // Yellow
            self.upsMode.imgBatteruy.image = UIImage(named: "mediumbatteryYellow")
        }
        else if obj.battery_percent < 50
        {
            // reed
            self.upsMode.imgBatteruy.image = UIImage(named: "mediumbattery")
        }
        
        // set sectino 6
        if obj.load_wattage == 0
        {
            self.upsMode.imgLoadWattaeg.image = UIImage(named: "loadwattageoff")
            self.upsMode.lblLoadWattege.text = "Load Wattage : 0 W"
        }
        else
        {
            self.upsMode.imgLoadWattaeg.image = UIImage(named: "loadwattageOn")
            self.upsMode.lblLoadWattege.text = "Load Wattage : " + String(obj.load_wattage) + " W"
        }
        
    }
    
    func setUpSolarMode(obj : DeviceDetailsModel)
    {
        // first set
        if obj.mipv >= 220 && obj.mipv <= 235
        {
            // green
            self.solarMode.lblInputVoltage.textColor = UIColor.init(red: 103.0/255.0, green: 163.0/255.0, blue: 59.0/255.0, alpha: 1.0)
            self.solarMode.lblInputVoltage.text = String(obj.mipv) + " V" + " Excellent"
        }
        else if obj.mipv >= 180 && obj.mipv <= 220 || obj.mipv >= 235 && obj.mipv <= 240
        {
            // yellow
            self.solarMode.lblInputVoltage.textColor = UIColor.init(red: 243.0/255.0, green: 168.0/255.0, blue: 59.0/255.0, alpha: 1.0)
            self.solarMode.lblInputVoltage.text = String(obj.mipv) + " V" + " Good"
        }
        else if obj.mipv <= 180 && obj.mipv >= 240
        {
            // red
            self.solarMode.lblInputVoltage.textColor = UIColor.red
            self.solarMode.lblInputVoltage.text = String(obj.mipv) + " V" + " Bad"
        }
        
        // set seecond
        self.solarMode.lblBattery.text =  "Battery Percentage : " + String(obj.battery_percent)
        if obj.battery_percent > 80
        {
            // greeen
            self.solarMode.imgBattery.image = UIImage(named: "mediumbattery Green")
        }
        else if obj.battery_percent > 50 && obj.battery_percent < 80
        {
            // Yellow
            self.solarMode.imgBattery.image = UIImage(named: "mediumbatteryYellow")
        }
        else if obj.battery_percent < 50
        {
            // reed
            self.solarMode.imgBattery.image = UIImage(named: "mediumbattery")
        }
        
        // set third
        self.solarMode.lblAtcValue.text = String(obj.at) + " ℃"
    
        // set four
        if obj.status_ups == 0
        {
            self.solarMode.imgSystemStatus.image = UIImage(named: "systemstatusun")
            self.solarMode.lblSystemStatus.text = "System Status : (Shifted to Solar)"
        }
        else
        {
            self.solarMode.imgSystemStatus.image = UIImage(named: "systemstatus")
            self.solarMode.lblSystemStatus.text = "System Status : (UPS ON)"
        }
        
        // set fivee
        if obj.status_mains == 0
        {
            self.solarMode.imgMainStatus.image = UIImage(named: "load_zero")
            self.solarMode.lblMainStatus.text = "System Status : (Not Available)"
        }
        else
        {
            self.solarMode.imgMainStatus.image = UIImage(named: "system_status_mains")
            self.solarMode.lblMainStatus.text = "Mains Status : (Available)"
        }
        
        // set six
        if obj.pvw == 0
        {
            self.solarMode.imgSolarStatus.image = UIImage(named: "SolarStatus")
            self.solarMode.lblSolarStatus.text = "Solar Status : 0 W "
        }
        else
        {
            self.solarMode.imgSolarStatus.image = UIImage(named: "solorstatus")
            let stringValue = "Solar Status : " + String(obj.pvw) + " W"
            let attributedString: NSMutableAttributedString = NSMutableAttributedString(string: stringValue )
            attributedString.setColor(color: UIColor.init(red: 243.0/255.0, green: 168.0/255.0, blue: 59.0/255.0, alpha: 1.0), forText: String(obj.pvw) + " W")
            
            self.solarMode.lblSolarStatus.attributedText = attributedString

        }
    }
    
    
    func setUpMainDeettailsPage(obj : DeviceDetailsModel)
    {
        
    
        // First Set
        if obj.mipv >= 220 && obj.mipv <= 235
        {
            // green
            self.mainLoad.lblVoolttageCount.textColor = UIColor.init(red: 103.0/255.0, green: 163.0/255.0, blue: 59.0/255.0, alpha: 1.0)
            self.mainLoad.lblVoolttageCount.text = String(obj.mipv) + " V" + " Excellent"
        }
        else if obj.mipv >= 180 && obj.mipv <= 220  || obj.mipv >= 235 && obj.mipv <= 240
        {
            // yellow
            self.mainLoad.lblVoolttageCount.textColor = UIColor.init(red: 243.0/255.0, green: 168.0/255.0, blue: 59.0/255.0, alpha: 1.0)
            self.mainLoad.lblVoolttageCount.text = String(obj.mipv) + " V" + " Good"
        }
        else if obj.mipv <= 180 && obj.mipv >= 240
        {
            // red
            self.mainLoad.lblVoolttageCount.textColor = UIColor.red
            self.mainLoad.lblVoolttageCount.text = String(obj.mipv) + " V" + " Bad"
        }
        
        // Second Set
        self.mainLoad.lblBatteryPeerceentage.text =  "Battery Percentage : " + String(obj.battery_percent)
        if obj.battery_percent > 80
        {
            // greeen
            self.mainLoad.imgBatteery.image = UIImage(named: "mediumbattery Green")
        }
        else if obj.battery_percent > 50 && obj.battery_percent < 80
        {
            // Yellow
            self.mainLoad.imgBatteery.image = UIImage(named: "mediumbatteryYellow")
        }
        else if obj.battery_percent < 50
        {
            // reed
            self.mainLoad.imgBatteery.image = UIImage(named: "mediumbattery")
        }
        
        // Third Set
        self.mainLoad.lblChargingBothPerccentaageStatus.text = "Grid : " + String(obj.charge_sharing_1) + "% ," + "Solar : " + String(obj.charge_sharing_2) + "%"
        
        if obj.charge_sharing_1 == 0
        {
            // grid imagee will not show
            self.mainLoad.imgGrid.image = UIImage(named: "load_zero")
        }
        else
        {
            // grid imagee will  show
            self.mainLoad.imgGrid.image = UIImage(named: "system_status_mains")
        }
        
        if obj.charge_sharing_2 == 0
        {
            // grid imagee will not show
            self.mainLoad.imgSolar.image = UIImage(named: "solar_status_off")
        }
        else
        {
            // grid imagee will  show
            self.mainLoad.imgSolar.image = UIImage(named: "solorstatus")
        }
        
        
        // set four
        self.mainLoad.lblCharingPoweerWalt.text = String(obj.bw) + " W"
        let status = obj.status_charging
        switch status {
        case 0:
            self.mainLoad.lblModeeBoost.text = "Mode (Boost Charge)"
            break
        case 1:
            self.mainLoad.lblModeeBoost.text = "Mode (Trickle charge)"
            break
        case 2:
            self.mainLoad.lblModeeBoost.text = "Mode (Six-stage charge)"
            break
        default:
            self.mainLoad.lblModeeBoost.text = "Mode (Absorption Charge)"
            break
        }
        // set five
        let stringValue1 = "Solar Status : " +  String(obj.pvw) + " W"
        let attributedString2: NSMutableAttributedString = NSMutableAttributedString(string: stringValue1 )
        attributedString2.setColor(color: UIColor.init(red: 243.0/255.0, green: 168.0/255.0, blue: 59.0/255.0, alpha: 1.0), forText: String(obj.pvw) + " W")
        
        self.mainLoad.lblSolarStatusValue.attributedText = attributedString2
        if obj.pvw == 0
        {
            self.mainLoad.imgSolarStatus.image = UIImage(named: "solar_status_off")
        }
        else
        {
            self.mainLoad.imgSolarStatus.image = UIImage(named: "solorstatus")
        }
        // set six
        self.mainLoad.lblAtcTempraturee.text = String(obj.at) + " ℃"
    }
    
    func setupDetails(obj : DeviceDetailsModel)
    {
        
        if obj.status_ups == 1 && obj.status_mains == 0
        {
                self.upsMode.isHidden = false
                self.solarMode.isHidden = true
                self.mainLoad.isHidden = true
                self.upsMode.frame = CGRect(x: 0, y: 0, width: self.newAddedView.frame.size.width, height: self.newAddedView.frame.size.height)
                let stringValue = obj.power_fail_timer + " " + String(obj.syscap) + "VA / " + String(obj.dcbus) + "V"
                let attributedString: NSMutableAttributedString = NSMutableAttributedString(string: stringValue )
                attributedString.setColor(color: UIColor.init(red: 103.0/255.0, green: 163.0/255.0, blue: 59.0/255.0, alpha: 1.0), forText: obj.power_fail_timer)
                
                self.lblTitlePower.attributedText = attributedString
                self.lblTitle.text = "UPS Mode (Mains Fail)"
                self.setUpUPSMode(obj: obj)
                if obj.status_error != 0
                {
                    self.setPopErrorOnAllModes(str: String(obj.status_error))
                }
                self.getDeviceDeetails()
        }
        else if obj.status_ups == 0 && obj.status_mains == 1
        {
            if obj.pvw > 0 && obj.bw == 0
            {
                    self.upsMode.isHidden = true
                    self.solarMode.isHidden = false
                    self.mainLoad.isHidden = true
                    
                    let stringValue = obj.mains_charging_timer + " " + String(obj.syscap) + "VA / " + String(obj.dcbus) + "V"
                    let attributedString: NSMutableAttributedString = NSMutableAttributedString(string: stringValue )
                    attributedString.setColor(color: UIColor.init(red: 103.0/255.0, green: 163.0/255.0, blue: 59.0/255.0, alpha: 1.0), forText: obj.mains_charging_timer)
                    
                    self.lblTitlePower.attributedText = attributedString
                    self.lblTitle.text = "Solar Mode"
                    self.solarMode.frame = CGRect(x: 0, y: 0, width: self.newAddedView.frame.size.width, height: self.newAddedView.frame.size.height)
                    self.setUpSolarMode(obj: obj)
                    if obj.status_error != 0
                    {
                        self.setPopErrorOnAllModes(str: String(obj.status_error))
                    }
                   self.getDeviceDeetails()
            }
            else
            {
                    let stringValue = obj.mains_charging_timer + " " + String(obj.syscap) + "VA / " + String(obj.dcbus) + "V"
                    let attributedString: NSMutableAttributedString = NSMutableAttributedString(string: stringValue )
                    attributedString.setColor(color: UIColor.init(red: 103.0/255.0, green: 163.0/255.0, blue: 59.0/255.0, alpha: 1.0), forText: obj.mains_charging_timer)
                    self.upsMode.isHidden = true
                    self.solarMode.isHidden = true
                    self.mainLoad.isHidden = false
                    
                    self.lblTitlePower.attributedText = attributedString
                    self.mainLoad.frame = CGRect(x: 0, y: 0, width: self.newAddedView.frame.size.width, height: self.newAddedView.frame.size.height)
                    self.lblTitle.text = "Main Mode (Mains Present)"
                    self.setUpMainDeettailsPage(obj: obj)
                    if obj.status_error != 0
                    {
                        self.setPopErrorOnAllModes(str: String(obj.status_error))
                    }
                    self.getDeviceDeetails()
            }
        }
        else if obj.status_ups == 0 && obj.status_mains == 0
        {
           // self.counter = 0
            //self.gameTimer?.invalidate()
            self.lblTitle.text = "Device Offline"
            let alert = UIAlertController(title: webServices.AppName, message: "Device Offline", preferredStyle: UIAlertController.Style.alert)
            alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { (action) in
                self.getDeviceDeetails()
               // self.counter = 9999999

            }))
            alert.addAction(UIAlertAction(title: "Back", style: .default, handler: { (action) in
                self.navigationController?.popViewController(animated: true)
            }))
            self.present(alert, animated: true, completion: nil)
            
        }
        
        let deviceName = obj.device_name + " (" + obj.device_type + ") " + "- " + obj.device_serial
        self.lblTitleDevice.text = deviceName
        
    }
    
    func setPopErrorOnAllModes(str : String)
    {
       // self.gameTimer?.invalidate()
      //  self.counter = 0
        switch str {
        case "1":
            let alert = UIAlertController(title: webServices.AppName, message: "Short Circuit Warning", preferredStyle: UIAlertController.Style.alert)
            alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { (action) in
                self.getDeviceDeetails()
               // self.counter = 9999999

            }))
            self.present(alert, animated: true, completion: nil)
            break
        case "2":
            let alert = UIAlertController(title: webServices.AppName, message: "Short Circuit Shutdown", preferredStyle: UIAlertController.Style.alert)
            alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { (action) in
                self.getDeviceDeetails()
               // self.counter = 9999999

            }))
            self.present(alert, animated: true, completion: nil)
            break
        case "3":
            let alert = UIAlertController(title: webServices.AppName, message: "Battery Low Warning", preferredStyle: UIAlertController.Style.alert)
            alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { (action) in
                self.getDeviceDeetails()
                //self.counter = 9999999

            }))
            self.present(alert, animated: true, completion: nil)
            break
        case "4":
            let alert = UIAlertController(title: webServices.AppName, message: "Battery Low Shutdown", preferredStyle: UIAlertController.Style.alert)
            alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { (action) in
                self.getDeviceDeetails()
               // self.counter = 9999999

            }))
            self.present(alert, animated: true, completion: nil)
            break
        case "5":
            let alert = UIAlertController(title: webServices.AppName, message: "Battery High Warning", preferredStyle: UIAlertController.Style.alert)
            alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { (action) in
                self.getDeviceDeetails()
               // self.counter = 9999999

            }))
            self.present(alert, animated: true, completion: nil)
            break
        case "6":
            let alert = UIAlertController(title: webServices.AppName, message: "Battery High Shutdown", preferredStyle: UIAlertController.Style.alert)
            alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { (action) in
                self.getDeviceDeetails()
               // self.counter = 9999999

            }))
            self.present(alert, animated: true, completion: nil)
            break
        case "7":
            let alert = UIAlertController(title: webServices.AppName, message: "Overload Warning", preferredStyle: UIAlertController.Style.alert)
            alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { (action) in
                self.getDeviceDeetails()
               // self.counter = 9999999

            }))
            self.present(alert, animated: true, completion: nil)
            break
        case "8":
            let alert = UIAlertController(title: webServices.AppName, message: "Overload Shutdown", preferredStyle: UIAlertController.Style.alert)
            alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { (action) in
                self.getDeviceDeetails()
               // self.counter = 9999999

            }))
            self.present(alert, animated: true, completion: nil)
            break
        case "9":
            let alert = UIAlertController(title: webServices.AppName, message: "Mains Fuse Blown", preferredStyle: UIAlertController.Style.alert)
            alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { (action) in
                self.getDeviceDeetails()
               // self.counter = 9999999

            }))
            self.present(alert, animated: true, completion: nil)
            break
        case "10":
            let alert = UIAlertController(title: webServices.AppName, message: "Mains Low Voltage Cut", preferredStyle: UIAlertController.Style.alert)
            alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { (action) in
                self.getDeviceDeetails()
               // self.counter = 9999999

            }))
            self.present(alert, animated: true, completion: nil)
            break
        case "11":
            let alert = UIAlertController(title: webServices.AppName, message: "Mains High Voltage Cut", preferredStyle: UIAlertController.Style.alert)
            alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { (action) in
                self.getDeviceDeetails()
               // self.counter = 9999999

            }))
            self.present(alert, animated: true, completion: nil)
            break
        case "12":
            let alert = UIAlertController(title: webServices.AppName, message: "Solar High Voltage", preferredStyle: UIAlertController.Style.alert)
            alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { (action) in
                self.getDeviceDeetails()
              //  self.counter = 9999999

            }))
            self.present(alert, animated: true, completion: nil)
            break
        case "13":
            let alert = UIAlertController(title: webServices.AppName, message: "Solar High Current", preferredStyle: UIAlertController.Style.alert)
            alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { (action) in
                self.getDeviceDeetails()
              //  self.counter = 9999999

            }))
            self.present(alert, animated: true, completion: nil)
            break
        default:
            break
        }
    }
    
    func setUpView(vw : UIView)  {
        vw.layer.cornerRadius = 1.0
        vw.layer.borderWidth = 1.0
        vw.layer.borderColor = UIColor.black.cgColor
        vw.clipsToBounds = true
    }
    
    @IBAction func tapBack(_ sender: Any) {
        //self.gameTimer?.invalidate()
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func tapAlert(_ sender: Any) {
        if let vcToPresent = self.storyboard!.instantiateViewController(withIdentifier: "AlertVC") as? AlertVC{
            vcToPresent.deviceeId = self.deviceId
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
            vcToPresent.deviceId = self.deviceId
            self.navigationController?.pushViewController(vcToPresent, animated: true)
        }
    }
}

