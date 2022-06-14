//
//  NewDeviceDetailsVC.swift
//  Vastika
//
//  Created by Mac on 27/09/21.
//

import UIKit
import CocoaMQTT

class NewDeviceDetailsVC: UIViewController,UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout {
    
    @IBOutlet weak var collView: UICollectionView!
    @IBOutlet weak var viewTop1: UIView!
    @IBOutlet weak var lblTitle: UILabel!
    @IBOutlet weak var lblTitlePower: UILabel!
    @IBOutlet weak var lblTitleDevice: UILabel!
    
    @IBOutlet weak var btnSeetting: UIButton!
    @IBOutlet weak var btnDiagnose: UIButton!
    @IBOutlet weak var btnAleert: UIButton!
    var viewModel = DeviceDetailsViewModel()
    var deviceDetails = [DeviceDetailsModel]()
    var deviceId = String()
    var checkMode = String()
    var gameTimer: Timer?
    var counter = 9999999
    var count = 1
    var check = true
    
    let defaultHost = "208.79.235.136"

    var mqtt: CocoaMQTT?
    var clientId =  "mqttExample"
    
    
    
    // MARK:- View Life Cycle --------
    
    override func viewDidLoad() {
        super.viewDidLoad()
       
        self.btnAleert.layer.cornerRadius = self.btnAleert.frame.size.height/2
        self.btnAleert.clipsToBounds = true
       
        self.btnSeetting.layer.cornerRadius = self.btnSeetting.frame.size.height/2
        self.btnSeetting.clipsToBounds = true
        
        self.btnDiagnose.layer.cornerRadius = self.btnDiagnose.frame.size.height/2
        self.btnDiagnose.clipsToBounds = true
        self.getDeviceDeetails()
        self.setUpView(vw: self.viewTop1)
        self.collView.delegate = self
        self.collView.dataSource = self

        let layout: UICollectionViewFlowLayout = UICollectionViewFlowLayout()
        layout.sectionInset = UIEdgeInsets(top: 5, left: 0, bottom: 5, right: 0)
        layout.itemSize = CGSize(width: (self.collView.frame.size.width - 20)/2, height: (self.collView.frame.size.height - 60) / 3)
        self.collView!.collectionViewLayout = layout

        var nib = UINib(nibName: "cellOne", bundle: nil)
        self.collView.register(nib, forCellWithReuseIdentifier: "cellOne")
        nib = UINib(nibName: "CellTwo", bundle: nil)
        self.collView.register(nib, forCellWithReuseIdentifier: "CellTwo")
        nib = UINib(nibName: "CellThree", bundle: nil)
        self.collView.register(nib, forCellWithReuseIdentifier: "CellThree")
        nib = UINib(nibName: "CellFour", bundle: nil)
        self.collView.register(nib, forCellWithReuseIdentifier: "CellFour")
        nib = UINib(nibName: "CellFive", bundle: nil)
        self.collView.register(nib, forCellWithReuseIdentifier: "CellFive")
        self.checkMode = "Main"
        self.gameTimer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(runTimedCode), userInfo: nil, repeats: true)
      //  self.setUPMQTT()
//        self.mqtt!.didConnectAck = { mqtt, ack in
//            mqtt.subscribe("/pcupwm/brainy/30aea4997fe0", qos: CocoaMQTTQOS.qos1)
//            self.mqtt!.didReceiveMessage = { mqtt, message, id in
//              print("Message received in topic \(message.topic) with payload \(message.string!)")
//           }
//        }
       //  Do any additional setup after lZoading the view.
    
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        self.check = false
    }
    
    func setUPMQTT()
    {
        let clientID = "CocoaMQTT-\(self.clientId)-" + String(ProcessInfo().processIdentifier)
        mqtt = CocoaMQTT(clientID: clientID, host: defaultHost, port: 1890)
        mqtt!.username = "usrsukam"
        mqtt!.password = "passsUkAw@86"
      //  mqtt!.willMessage = CocoaMQTTWill(topic: "/will", message: "dieout")
        mqtt!.keepAlive = 60
        mqtt!.delegate = self
        self.connectMQTT()
        // add when server got SLL then below line will be uncmmented
       // mqtt!.enableSSL = true
    }
    
    func connectMQTT()
    {
        _ = self.mqtt?.connect()
        self.mqtt!.autoReconnect = true

    }
    
    // MARK:- UIAction Method -----------
    
     @objc func runTimedCode()
     {
         if counter != 0
         {
            self.counter = self.counter - 1
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
            let alert = UIAlertController(title: webServices.AppName, message: "Internet connection is not available. Please check your internet.", preferredStyle: UIAlertController.Style.alert)
            alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { (action) in
               
            }))
            self.present(alert, animated: true, completion: nil)
            return
        }
        
        self.viewModel.deviceDetails(deviceId: deviceId, viewController: self, isLoaderRequired: loader) { [self] status, obj in
            if status == "Success"
            {
                self.deviceDetails.removeAll()
                self.deviceDetails.append(obj)
               
                DispatchQueue.main.async {
                  // your code here
                    self.collView.reloadData()
                    self.setupDetails(obj: obj)
                }

            }
            else
            {
                self.lblTitle.text = "Device Offline"
                let alert = UIAlertController(title: webServices.AppName, message: "Device Offline", preferredStyle: UIAlertController.Style.alert)
                alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { (action) in
                    self.getDeviceDeetails()
                }))
                alert.addAction(UIAlertAction(title: "Back", style: .default, handler: { (action) in
                   // self.counter = 0
                    self.navigationController?.popViewController(animated: true)
                }))
                self.present(alert, animated: true, completion: nil)
            }
        }
    }
    
    func setupDetails(obj : DeviceDetailsModel)
    {
        if obj.status_error != 0
        {
            self.setPopErrorOnAllModes(str: String(obj.status_error))
        }
        
        if obj.status_ups == 1 && obj.status_mains == 0
        {
                let stringValue = obj.power_fail_timer +  " " + String(obj.syscap) + "VA / " + String(obj.dcbus) + "V"
                let attributedString: NSMutableAttributedString = NSMutableAttributedString(string: stringValue )
                attributedString.setColor(color: UIColor.init(red: 103.0/255.0, green: 163.0/255.0, blue: 59.0/255.0, alpha: 1.0), forText: obj.power_fail_timer)
                
                self.lblTitlePower.attributedText = attributedString
                self.lblTitle.text = "UPS Mode (Mains Fail)"
                self.checkMode = "UPS"
        }
        else if obj.status_ups == 0 && obj.status_mains == 1
        {
            let stringValue = obj.mains_charging_timer + " " + String(obj.syscap) + "VA / " + String(obj.dcbus) + "V"
            let attributedString: NSMutableAttributedString = NSMutableAttributedString(string: stringValue )
            attributedString.setColor(color: UIColor.init(red: 103.0/255.0, green: 163.0/255.0, blue: 59.0/255.0, alpha: 1.0), forText: obj.mains_charging_timer)
            
            self.lblTitlePower.attributedText = attributedString
            
            if obj.pvw > 0 && obj.bw == 0
            {
                self.lblTitle.text = "Solar Mode"
                self.checkMode = "Solar"
            }
            else
            {
                self.lblTitle.text = "Main Mode (Mains Present)"
                self.checkMode = "Main"
            }
        }
        else if obj.status_ups == 0 && obj.status_mains == 0
        {
            self.lblTitle.text = "Device Offline"
            self.gameTimer?.invalidate()
            self.counter = 0
            let alert = UIAlertController(title: webServices.AppName, message: "Device Offline", preferredStyle: UIAlertController.Style.alert)
            alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { (action) in
                self.getDeviceDeetails()

            }))
            alert.addAction(UIAlertAction(title: "Back", style: .default, handler: { (action) in
                self.navigationController?.popViewController(animated: true)
            }))
            self.present(alert, animated: true, completion: nil)
            
        }
        
        let stringValue = obj.device_name + " (" + obj.device_type + ") " + "\n" + obj.device_serial
        let attributedString: NSMutableAttributedString = NSMutableAttributedString(string: stringValue )
        attributedString.setColor(color: UIColor.init(red: 103.0/255.0, green: 163.0/255.0, blue: 59.0/255.0, alpha: 1.0), forText: obj.device_serial)
        
        self.lblTitleDevice.attributedText = attributedString
        
    }
    
    func setPopErrorOnAllModes(str : String)
    {
        self.gameTimer?.invalidate()
        switch str {
        case "1":
            let alert = UIAlertController(title: webServices.AppName, message: "Short Circuit Warning", preferredStyle: UIAlertController.Style.alert)
            alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { (action) in
                self.getDeviceDeetails()

            }))
            self.present(alert, animated: true, completion: nil)
            break
        case "2":
            let alert = UIAlertController(title: webServices.AppName, message: "Short Circuit Shutdown", preferredStyle: UIAlertController.Style.alert)
            alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { (action) in
                self.getDeviceDeetails()

            }))
            self.present(alert, animated: true, completion: nil)
            break
        case "3":
            let alert = UIAlertController(title: webServices.AppName, message: "Battery Low Warning", preferredStyle: UIAlertController.Style.alert)
            alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { (action) in
                self.getDeviceDeetails()

            }))
            self.present(alert, animated: true, completion: nil)
            break
        case "4":
            let alert = UIAlertController(title: webServices.AppName, message: "Battery Low Shutdown", preferredStyle: UIAlertController.Style.alert)
            alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { (action) in
                self.getDeviceDeetails()

            }))
            self.present(alert, animated: true, completion: nil)
            break
        case "5":
            let alert = UIAlertController(title: webServices.AppName, message: "Battery High Warning", preferredStyle: UIAlertController.Style.alert)
            alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { (action) in
                self.getDeviceDeetails()

            }))
            self.present(alert, animated: true, completion: nil)
            break
        case "6":
            let alert = UIAlertController(title: webServices.AppName, message: "Battery High Shutdown", preferredStyle: UIAlertController.Style.alert)
            alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { (action) in
                self.getDeviceDeetails()

            }))
            self.present(alert, animated: true, completion: nil)
            break
        case "7":
            let alert = UIAlertController(title: webServices.AppName, message: "Overload Warning", preferredStyle: UIAlertController.Style.alert)
            alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { (action) in
                self.getDeviceDeetails()
              

            }))
            self.present(alert, animated: true, completion: nil)
            break
        case "8":
            let alert = UIAlertController(title: webServices.AppName, message: "Overload Shutdown", preferredStyle: UIAlertController.Style.alert)
            alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { (action) in
                self.getDeviceDeetails()
             

            }))
            self.present(alert, animated: true, completion: nil)
            break
        case "9":
            let alert = UIAlertController(title: webServices.AppName, message: "Mains Fuse Blown", preferredStyle: UIAlertController.Style.alert)
            alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { (action) in
                self.getDeviceDeetails()
            

            }))
            self.present(alert, animated: true, completion: nil)
            break
        case "10":
            let alert = UIAlertController(title: webServices.AppName, message: "Mains Low Voltage Cut", preferredStyle: UIAlertController.Style.alert)
            alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { (action) in
                self.getDeviceDeetails()
             

            }))
            self.present(alert, animated: true, completion: nil)
            break
        case "11":
            let alert = UIAlertController(title: webServices.AppName, message: "Mains High Voltage Cut", preferredStyle: UIAlertController.Style.alert)
            alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { (action) in
                self.getDeviceDeetails()
             

            }))
            self.present(alert, animated: true, completion: nil)
            break
        case "12":
            let alert = UIAlertController(title: webServices.AppName, message: "Solar High Voltage", preferredStyle: UIAlertController.Style.alert)
            alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { (action) in
                self.getDeviceDeetails()
              

            }))
            self.present(alert, animated: true, completion: nil)
            break
        case "13":
            let alert = UIAlertController(title: webServices.AppName, message: "Solar High Current", preferredStyle: UIAlertController.Style.alert)
            alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { (action) in
                self.getDeviceDeetails()
             
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
    
    // MARK:- UIColl5ectionView Delegate And Datasource Method -----------
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if self.deviceDetails.count > 0
        {
            return 6
        }
        return 0
      
    }
    
    func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        if self.checkMode == "Main"
        {
            // First Set
            if indexPath.item == 0
            {
                let cell : cellOne = collectionView.dequeueReusableCell(withReuseIdentifier: "cellOne", for: indexPath) as! cellOne
                cell.layer.borderWidth = 1.0
                cell.layer.borderColor = UIColor.black.cgColor
                cell.clipsToBounds = true
                cell.lblTitle.text = "Main Input Voltage"
               
                if self.deviceDetails[0].mipv >= 220 && self.deviceDetails[0].mipv <= 235
                {
                    // green
                    cell.lblInfo.textColor = UIColor.init(red: 103.0/255.0, green: 163.0/255.0, blue: 59.0/255.0, alpha: 1.0)
                    cell.lblInfo.text = String(self.deviceDetails[0].mipv) + " V" + " Excellent"
                }
                else if self.deviceDetails[0].mipv >= 180 && self.deviceDetails[0].mipv <= 220  || self.deviceDetails[0].mipv >= 235 && self.deviceDetails[0].mipv <= 240
                {
                    // yellow
                    cell.lblInfo.textColor = UIColor.init(red: 243.0/255.0, green: 168.0/255.0, blue: 59.0/255.0, alpha: 1.0)
                    cell.lblInfo.text = String(self.deviceDetails[0].mipv) + " V" + " Good"
                }
                else if self.deviceDetails[0].mipv <= 180 && self.deviceDetails[0].mipv >= 240
                {
                    // red
                    cell.lblInfo.textColor = UIColor.red
                    cell.lblInfo.text = String(self.deviceDetails[0].mipv) + " V" + " Bad"
                }
                return cell
            }
            // Second set
            else if indexPath.item == 1
            {
                let cell : CellFour = collectionView.dequeueReusableCell(withReuseIdentifier: "CellFour", for: indexPath) as! CellFour
                cell.layer.borderWidth = 1.0
                cell.layer.borderColor = UIColor.black.cgColor
                cell.clipsToBounds = true

                cell.lblInfo.text =  "Battery Percentage : " + String(self.deviceDetails[0].battery_percent)
                if self.deviceDetails[0].battery_percent > 80
                {
                    // greeen
                    cell.imgIcon.image = UIImage(named: "mediumbattery Green")
                }
                else if self.deviceDetails[0].battery_percent > 50 && self.deviceDetails[0].battery_percent < 80
                {
                    // Yellow
                    cell.imgIcon.image = UIImage(named: "mediumbatteryYellow")
                }
                else if self.deviceDetails[0].battery_percent < 50
                {
                    // reed
                    cell.imgIcon.image = UIImage(named: "mediumbattery")
                }
                
                return cell
            }
            
            // Third Seet
            else if indexPath.item == 2
            {
                let cell : CellTwo = collectionView.dequeueReusableCell(withReuseIdentifier: "CellTwo", for: indexPath) as! CellTwo
                cell.layer.borderWidth = 1.0
                cell.layer.borderColor = UIColor.black.cgColor
                cell.clipsToBounds = true
                cell.lblTittle.text = "Charging Sharing Percentage"
                cell.lblDetails.text = "Grid : " + String(self.deviceDetails[0].charge_sharing_1) + "% ," + "Solar : " + String(self.deviceDetails[0].charge_sharing_2) + "%"
                
                if self.deviceDetails[0].charge_sharing_1 == 0
                {
                    // grid imagee will not show
                    cell.imgInfoOne.image = UIImage(named: "load_zero")
                }
                else
                {
                    // grid imagee will  show
                    cell.imgInfoOne.image = UIImage(named: "system_status_mains")
                }
                
                if self.deviceDetails[0].charge_sharing_2 == 0
                {
                    // grid imagee will not
                    cell.imgInfoTwo.image = UIImage(named: "solar_status_off")
                }
                else
                {
                    // grid imagee will  show
                    cell.imgInfoTwo.image = UIImage(named: "solorstatus")
                }
                return cell
            }
            // four set
            else if indexPath.item == 3
            {
                let cell : CellThree = collectionView.dequeueReusableCell(withReuseIdentifier: "CellThree", for: indexPath) as! CellThree
                cell.layer.borderWidth = 1.0
                cell.layer.borderColor = UIColor.black.cgColor
                cell.clipsToBounds = true
                cell.lblTitle.text = "Charing Power"
                
                cell.lblDetails.text = String(self.deviceDetails[0].bw) + " W"
                let status = self.deviceDetails[0].status_charging
                switch status {
                case 0:
                    cell.lblinfo.text = "Mode (Boost Charge)"
                    break
                case 1:
                    cell.lblinfo.text = "Mode (Trickle charge)"
                    break
                case 2:
                    cell.lblinfo.text = "Mode (Six-stage charge)"
                    break
                default:
                    cell.lblinfo.text = "Mode (Absorption Charge)"
                    break
                }
               return cell
            }
            else if indexPath.item == 4
            {
                let cell : CellFour = collectionView.dequeueReusableCell(withReuseIdentifier: "CellFour", for: indexPath) as! CellFour
                cell.layer.borderWidth = 1.0
                cell.layer.borderColor = UIColor.black.cgColor
                cell.clipsToBounds = true
                
                let stringValue1 = "Solar Status : " +  String(self.deviceDetails[0].pvw) + " W"
                let attributedString2: NSMutableAttributedString = NSMutableAttributedString(string: stringValue1 )
                attributedString2.setColor(color: UIColor.init(red: 243.0/255.0, green: 168.0/255.0, blue: 59.0/255.0, alpha: 1.0), forText: String(self.deviceDetails[0].pvw) + " W")
                
                cell.lblInfo.attributedText = attributedString2
                if self.deviceDetails[0].pvw == 0
                {
                    cell.imgIcon.image = UIImage(named: "solar_status_off")
                }
                else
                {
                    cell.imgIcon.image = UIImage(named: "solorstatus")
                }
                
                return cell
            }
            else if indexPath.item == 5
            {
                let cell : CellFive = collectionView.dequeueReusableCell(withReuseIdentifier: "CellFive", for: indexPath) as! CellFive
                cell.layer.borderWidth = 1.0
                cell.layer.borderColor = UIColor.black.cgColor
                cell.clipsToBounds = true
                cell.lblTitle.text = "ATC"
                cell.imgIcon.image = UIImage(named: "atc")
                cell.lblInfo.text = String(self.deviceDetails[0].at) + " ℃"

                
                return cell
            }
        }
        else if self.checkMode == "UPS"
        {
            let cell : CellFour = collectionView.dequeueReusableCell(withReuseIdentifier: "CellFour", for: indexPath) as! CellFour
            cell.layer.borderWidth = 1.0
            cell.layer.borderColor = UIColor.black.cgColor
            cell.clipsToBounds = true
            if indexPath.item == 0
            {
                // set section First
                if self.deviceDetails[0].status_front_switch == 0
                {
                    cell.imgIcon.image = UIImage(named: "switchoff")
                    cell.lblInfo.text = "Switch : OFF"
                }
                else
                {
                    cell.imgIcon.image = UIImage(named: "switchon")
                    cell.lblInfo.text = "Switch : ON"
                }
            }
            else if indexPath.item == 1
            {
                cell.imgIcon.image = UIImage(named: "atc")
                cell.lblInfo.text = "ATC (" + String(self.deviceDetails[0].at) + " ℃" + ")"

            }
            else if indexPath.item == 2
            {
                if self.deviceDetails[0].status_ups == 0
                {
                    cell.imgIcon.image = UIImage(named: "systemstatusun")
                    cell.lblInfo.text = "System Status : UPS Off"
                }
                else
                {
                    cell.imgIcon.image = UIImage(named: "systemstatus")
                    cell.lblInfo.text = "System Status : UPS On"
                }
            }
            else if indexPath.item == 3
            {
                if self.deviceDetails[0].pvw == 0
                {
                    cell.imgIcon.image = UIImage(named: "solar_status_off")
                    let stringValue = "Solar Status : 0 W"
                    let attributedString: NSMutableAttributedString = NSMutableAttributedString(string: stringValue)
                    attributedString.setColor(color: UIColor.init(red: 243.0/255.0, green: 168.0/255.0, blue: 59.0/255.0, alpha: 1.0), forText: "0 W")
                    cell.lblInfo.attributedText = attributedString
                }
                else
                {
                    cell.imgIcon.image = UIImage(named: "solorstatus")
                    let stringValue = "Solar Status : " + String(self.deviceDetails[0].pvw) + " W"
                    let attributedString: NSMutableAttributedString = NSMutableAttributedString(string: stringValue)
                    attributedString.setColor(color: UIColor.init(red: 243.0/255.0, green: 168.0/255.0, blue: 59.0/255.0, alpha: 1.0), forText: String(self.deviceDetails[0].pvw) + " W")
                    
                    cell.lblInfo.attributedText = attributedString//"Solar Status : " + String(obj.pvw) + " W"
                }
            }
            else if indexPath.item == 4
            {
                cell.lblInfo.text =  "Battery Percentage : " + String(self.deviceDetails[0].battery_percent)
                if self.deviceDetails[0].battery_percent > 80
                {
                    // greeen
                    cell.imgIcon.image = UIImage(named: "mediumbattery Green")
                }
                else if self.deviceDetails[0].battery_percent > 50 && self.deviceDetails[0].battery_percent < 80
                {
                    // Yellow
                    cell.imgIcon.image = UIImage(named: "mediumbatteryYellow")
                }
                else if self.deviceDetails[0].battery_percent < 50
                {
                    // reed
                    cell.imgIcon.image = UIImage(named: "mediumbattery")
                }
                
            }
            else if indexPath.item == 5
            {
                if self.deviceDetails[0].load_wattage == 0
                {
                    cell.imgIcon.image = UIImage(named: "loadwattageoff")
                    cell.lblInfo.text = "Load Wattage : 0 W"
                }
                else
                {
                    cell.imgIcon.image = UIImage(named: "loadwattageOn")
                    cell.lblInfo.text = "Load Wattage : " + String(self.deviceDetails[0].load_wattage) + " W"
                }
            }
            return cell
        }
        else
        {
            if indexPath.item == 0
            {
                let cell : cellOne = collectionView.dequeueReusableCell(withReuseIdentifier: "cellOne", for: indexPath) as! cellOne
                cell.layer.borderWidth = 1.0
                cell.layer.borderColor = UIColor.black.cgColor
                cell.clipsToBounds = true
                cell.lblTitle.text = "Main Input Voltage"
               
                // first set
                if self.deviceDetails[0].mipv >= 220 && self.deviceDetails[0].mipv <= 235
                {
                    // green
                    cell.lblInfo.textColor = UIColor.init(red: 103.0/255.0, green: 163.0/255.0, blue: 59.0/255.0, alpha: 1.0)
                    cell.lblInfo.text = String(self.deviceDetails[0].mipv) + " V" + " Excellent"
                }
                else if self.deviceDetails[0].mipv >= 180 && self.deviceDetails[0].mipv <= 220 || self.deviceDetails[0].mipv >= 235 && self.deviceDetails[0].mipv <= 240
                {
                    // yellow
                    cell.lblInfo.textColor = UIColor.init(red: 243.0/255.0, green: 168.0/255.0, blue: 59.0/255.0, alpha: 1.0)
                    cell.lblInfo.text = String(self.deviceDetails[0].mipv) + " V" + " Good"
                }
                else if self.deviceDetails[0].mipv <= 180 && self.deviceDetails[0].mipv >= 240
                {
                    // red
                    cell.lblInfo.textColor = UIColor.red
                    cell.lblInfo.text = String(self.deviceDetails[0].mipv) + " V" + " Bad"
                }
                return cell
            }
            else
            {
                let cell : CellFour = collectionView.dequeueReusableCell(withReuseIdentifier: "CellFour", for: indexPath) as! CellFour
                cell.layer.borderWidth = 1.0
                cell.layer.borderColor = UIColor.black.cgColor
                cell.clipsToBounds = true
                
                if indexPath.item == 1
                {
                    // set seecond
                    cell.lblInfo.text =  "Battery Percentage : " + String(self.deviceDetails[0].battery_percent)
                    if self.deviceDetails[0].battery_percent > 80
                    {
                        // greeen
                        cell.imgIcon.image = UIImage(named: "mediumbattery Green")
                    }
                    else if self.deviceDetails[0].battery_percent > 50 && self.deviceDetails[0].battery_percent < 80
                    {
                        // Yellow
                        cell.imgIcon.image = UIImage(named: "mediumbatteryYellow")
                    }
                    else if self.deviceDetails[0].battery_percent < 50
                    {
                        // reed
                        cell.imgIcon.image = UIImage(named: "mediumbattery")
                    }
                    
                }
                else if indexPath.item == 2
                {
                    cell.imgIcon.image = UIImage(named: "atc")
                    cell.lblInfo.text = String(self.deviceDetails[0].at) + " ℃"

                }
                else if indexPath.item == 3
                {
                    if self.deviceDetails[0].status_ups == 0
                    {
                        cell.imgIcon.image = UIImage(named: "systemstatusun")
                        cell.lblInfo.text = "System Status : (Shifted to Solar)"
                    }
                    else
                    {
                        cell.imgIcon.image = UIImage(named: "systemstatus")
                        cell.lblInfo.text = "System Status : (UPS ON)"
                    }
                }
                else if indexPath.item == 4
                {
                    // set fivee
                    if self.deviceDetails[0].status_mains == 0
                    {
                        cell.imgIcon.image = UIImage(named: "load_zero")
                        cell.lblInfo.text = "System Status : (Not Available)"
                    }
                    else
                    {
                        cell.imgIcon.image = UIImage(named: "system_status_mains")
                        cell.lblInfo.text = "Mains Status : (Available)"
                    }
                }
                else if indexPath.item == 5
                {
                    // set six
                    if self.deviceDetails[0].pvw == 0
                    {
                        cell.imgIcon.image = UIImage(named: "SolarStatus")
                        cell.lblInfo.text = "Solar Status : 0 W "
                    }
                    else
                    {
                        cell.imgIcon.image = UIImage(named: "solorstatus")
                        let stringValue = "Solar Status : " + String(self.deviceDetails[0].pvw) + " W"
                        let attributedString: NSMutableAttributedString = NSMutableAttributedString(string: stringValue )
                        attributedString.setColor(color: UIColor.init(red: 243.0/255.0, green: 168.0/255.0, blue: 59.0/255.0, alpha: 1.0), forText: String(self.deviceDetails[0].pvw) + " W")
                        
                        cell.lblInfo.attributedText = attributedString

                    }
                }
                
                return cell
            }
        }
                
        return UICollectionViewCell()
       
    }
    
   
}

extension NewDeviceDetailsVC: CocoaMQTTDelegate {
    func mqtt(_ mqtt: CocoaMQTT, didUnsubscribeTopics topics: [String]) {
        print("check")
        
    }
    
    func mqtt(_ mqtt: CocoaMQTT, didUnsubscribeTopic topic: String) {
        print("Uncheck")
    }

    
    // Optional ssl CocoaMQTTDelegate
    func mqtt(_ mqtt: CocoaMQTT, didReceive trust: SecTrust, completionHandler: @escaping (Bool) -> Void) {
        TRACE("trust: \(trust)")
        completionHandler(true)
    }
    
    func mqtt(_ mqtt: CocoaMQTT, didConnectAck ack: CocoaMQTTConnAck) {
        TRACE("ack: \(ack)")
    
     }
    
    func mqtt(_ mqtt: CocoaMQTT, didStateChangeTo state: CocoaMQTTConnState) {
        TRACE("new state: \(state)")
    }
    
    func mqtt(_ mqtt: CocoaMQTT, didPublishMessage message: CocoaMQTTMessage, id: UInt16) {
        TRACE("message: \(message.string.description), id: \(id)")
    }
    
    func mqtt(_ mqtt: CocoaMQTT, didPublishAck id: UInt16) {
        TRACE("id: \(id)")
    }
    
    func mqtt(_ mqtt: CocoaMQTT, didReceiveMessage message: CocoaMQTTMessage, id: UInt16 ) {
        TRACE("message: \(message.string.description), id: \(id)")
       
//        let name = NSNotification.Name(rawValue: "MQTTMessageNotification" + animal!)
//        NotificationCenter.default.post(name: name, object: self, userInfo: ["message": message.string!, "topic": message.topic])
    }
    
    func mqtt(_ mqtt: CocoaMQTT, didSubscribeTopics success: NSDictionary, failed: [String]) {
        TRACE("subscribed: \(success), failed: \(failed)")
    }
    
    func mqttDidPing(_ mqtt: CocoaMQTT) {
        TRACE()
    }
    
    func mqttDidReceivePong(_ mqtt: CocoaMQTT) {
        TRACE()
        print(mqtt.description)
    }

    func mqttDidDisconnect(_ mqtt: CocoaMQTT, withError err: Error?) {
        TRACE("\(err.description)")
    }
    
    
}

extension NSMutableAttributedString {

    func setColor(color: UIColor, forText stringValue: String) {
       let range: NSRange = self.mutableString.range(of: stringValue, options: .caseInsensitive)
        self.addAttribute(NSAttributedString.Key.foregroundColor, value: color, range: range)
    }

}
extension UIView {

    func subviewsRecursive() -> [UIView] {
        return subviews + subviews.flatMap { $0.subviewsRecursive() }
    }

}

extension NewDeviceDetailsVC {
    func TRACE(_ message: String = "", fun: String = #function) {
        let names = fun.components(separatedBy: ":")
        var prettyName: String
        if names.count == 2 {
            prettyName = names[0]
        } else {
            prettyName = names[1]
        }
        
        if fun == "mqttDidDisconnect(_:withError:)" {
            prettyName = "didDisconnect"
        }

        print("[TRACE] [\(prettyName)]: \(message)")
    }
}

extension Optional {
    // Unwrap optional value for printing log onlfy
    var description: String {
        if let self = self {
            return "\(self)"
        }
        return ""
    }
}
