//
//  ConnectingVC.swift
//  Vastika
//
//  Created by Sunil on 13/01/23.
//

import UIKit
import CoreBluetooth


fileprivate func < <T : Comparable>(lhs: T?, rhs: T?) -> Bool {
    switch (lhs, rhs) {
    case let (l?, r?):
        return l < r
    case (nil, _?):
        return true
    default:
        return false
    }
}

fileprivate func > <T : Comparable>(lhs: T?, rhs: T?) -> Bool {
    switch (lhs, rhs) {
    case let (l?, r?):
        return l > r
    default:
        return rhs < lhs
    }
}

class ConnectingVC: UIViewController,BluetoothDelegate {
    
    let appDelegate = UIApplication.shared.delegate as! AppDelegate
    fileprivate var services : [CBService]?
    var properties : CBCharacteristicProperties?
    let bluetoothManager = BluetoothManager.getInstance()

    @IBOutlet weak var btnContinue: UIButton!
    @IBOutlet weak var lblDetails: UILabel!
    var reciveData = NSMutableArray()
    var index : Int = -1
    @IBOutlet weak var imgRefresh: UIImageView!
    var sendData = NSDictionary()
    var peripheral: CBPeripheral!
    var writableCharacteristic: CBCharacteristic?
    var writeType: CBCharacteristicWriteType?
    @IBOutlet weak var lblHeader: UILabel!
    @IBOutlet weak var containetV: UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let attrsSE1 = [NSAttributedString.Key.font : UIFont(name: "HelveticaNeue", size: 14), NSAttributedString.Key.foregroundColor : UIColor.black]
        let attrsSE2 = [NSAttributedString.Key.font : UIFont(name: "HelveticaNeue-Bold", size: 18), NSAttributedString.Key.foregroundColor : UIColor.black]
        let attributedStringSE1 = NSMutableAttributedString(string:"Connecting to UPS.." + "\n", attributes:attrsSE1 as [NSAttributedString.Key : Any])
        let attributedStringSE2 = NSMutableAttributedString(string:"PLEASE WAIT", attributes:attrsSE2 as [NSAttributedString.Key : Any])
        attributedStringSE1.append(attributedStringSE2)
        self.lblDetails.attributedText = attributedStringSE1
        
        self.containetV.dropShadow()
        self.lblHeader.font = UIFont(name: "Montserrat-Medium", size: 16)
        self.btnContinue.titleLabel?.font = UIFont(name: "Montserrat-Bold", size: 18)

        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        if appDelegate.ssid.count != 0
        {
            self.btnContinue.isHidden = true
            
        }
        else
        {
            self.btnContinue.isHidden = true
        }
        NotificationCenter.default.addObserver(self, selector: #selector(self.methodOfReceivedNotification(notification:)), name: Notification.Name("NotificationIdentifier"), object: nil)
        
        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.appDelegate.bluetoothManager.delegate = self
        self.appDelegate.peripheral = self.peripheral
        self.appDelegate.bluetoothManager.connectPeripheral(peripheral)
        self.appDelegate.bluetoothManager.discoverCharacteristics()
        services = self.appDelegate.bluetoothManager.connectedPeripheral?.services
        self.bluetoothManager.delegate = self
    }
    
    @objc func methodOfReceivedNotification(notification: Notification) {
        if self.appDelegate.ssid.count != 0
        {
            
        }
        else
        {
            let alert = UIAlertController(title: webServices.AppName, message: "Device is disconnected. Try to reconnect.", preferredStyle: UIAlertController.Style.alert)
            alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { (action) in
               
                self.appDelegate.bluetoothManager.delegate = self
                self.appDelegate.peripheral = self.peripheral
                self.appDelegate.bluetoothManager.connectPeripheral(self.peripheral)
                self.appDelegate.bluetoothManager.discoverCharacteristics()
                self.services = self.appDelegate.bluetoothManager.connectedPeripheral?.services
                self.bluetoothManager.delegate = self
            }))
            
            self.present(alert, animated: true, completion: nil)
        }
      
    }
    
    func updateChararcterices()
    {
        properties = self.appDelegate.writableCharacteristic!.properties
        if properties!.contains(.read) {
            print("Read")
        } else {
            if properties!.contains(.notify) {
                print("Notify")
            } else if properties!.contains(.indicate) {
                print("indicate")
            }
        }
       
        if properties!.contains(.write) || properties!.contains(.writeWithoutResponse) {
           print("write")
        }
    }
    
    @IBAction func tapBack(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func tapContinue(_ sender: Any) {
        if self.appDelegate.ssid.count != 0
        {
            assert(self.appDelegate.writableCharacteristic != nil || writeType != nil, "The EditValueController didn't initilize correct!")
            let data = Data(self.appDelegate.ssid.utf8)
            self.appDelegate.bluetoothManager.writeValue(data: data, forCharacteristic: self.writableCharacteristic!, type: .withResponse)
            if let vcToPresent = self.storyboard!.instantiateViewController(withIdentifier: "HomeVC") as? HomeVC{
                self.navigationController?.pushViewController(vcToPresent, animated: true)
            }
        }
       else
        {
           if self.index == 0
           {
               let statusUPS = self.appDelegate.globalDict.object(forKey: "status_ups") as? String
               let statusMains = self.appDelegate.globalDict.object(forKey: "status_mains") as? String
               let mainsOKN = self.appDelegate.globalDict.object(forKey: "Mains_Ok") as? String
               var errorN = self.appDelegate.globalDict.object(forKey: "status_error") as? String
              
               let valSatus = (errorN?.contains("10"))
               
               if statusUPS == "1" && statusMains == "0"
               {
                   if let vcToPresent = self.storyboard!.instantiateViewController(withIdentifier: "DeviceBLEVC") as? DeviceBLEVC{
                       vcToPresent.dicrDta = self.appDelegate.globalDict
                       self.navigationController?.pushViewController(vcToPresent, animated: true)
                   }
               }
               else if statusUPS == "0" && statusMains == "1" && mainsOKN == "1"
               {
                   // Mains Mode
                   if let vcToPresent = self.storyboard!.instantiateViewController(withIdentifier: "DeviceMainSVC") as? DeviceMainSVC{
                       vcToPresent.dicrDta = self.appDelegate.globalDict
                       self.navigationController?.pushViewController(vcToPresent, animated: true)
                   }
                
               }
               else if statusUPS == "0" && statusMains == "1" && ((errorN?.contains("10")) != nil)
               {
                   // low voltage
                   if let vcToPresent = self.storyboard!.instantiateViewController(withIdentifier: "DeviceBLEVC") as? DeviceBLEVC{
                       vcToPresent.dicrDta = self.appDelegate.globalDict
                       self.navigationController?.pushViewController(vcToPresent, animated: true)
                   }
               }
               else if statusUPS == "0" && statusMains == "1" && ((errorN?.contains("11")) != nil)
               {
                   // low voltage
                   if let vcToPresent = self.storyboard!.instantiateViewController(withIdentifier: "DeviceBLEVC") as? DeviceBLEVC{
                       vcToPresent.dicrDta = self.appDelegate.globalDict
                       self.navigationController?.pushViewController(vcToPresent, animated: true)
                   }
               }
               else if statusUPS == "1" && statusMains == "1"
               {
                   if let vcToPresent = self.storyboard!.instantiateViewController(withIdentifier: "DeviceBLEVC") as? DeviceBLEVC{
                       vcToPresent.dicrDta = self.appDelegate.globalDict
                       self.navigationController?.pushViewController(vcToPresent, animated: true)
                   }
               }
               else if statusUPS == "0" && statusMains == "0"
               {
                   if let vcToPresent = self.storyboard!.instantiateViewController(withIdentifier: "DeviceBLEVC") as? DeviceBLEVC{
                       vcToPresent.dicrDta = self.appDelegate.globalDict
                       self.navigationController?.pushViewController(vcToPresent, animated: true)
                   }
               }
                   
           }
       }
    }
  
    func convertStringToDictionary(text: String) -> [String:AnyObject]? {
       if let data = text.data(using: .utf8) {
           do {
               let json = try JSONSerialization.jsonObject(with: data, options: .mutableContainers) as? [String:AnyObject]
               self.reciveData.removeAllObjects()
               return json
           } catch {
               print("Something went wrong")
               self.reciveData.removeAllObjects()
           }
       }
       return nil
   }
    
    
    /*
    - parameter state: The bluetooth state
    */
   func didUpdateState(_ state: CBCentralManagerState) {
       print("MainController --> didUpdateState:\(state)")
       switch state {
       case .resetting:
           print("MainController --> State : Resetting")
           
       case .poweredOn:
           print("Bluetooth State: Powered On")
           self.appDelegate.bluetoothManager.startScanPeripheral()
       case .poweredOff:
           print(" MainController -->State : Powered Off")
           let alert = UIAlertController(title: webServices.AppName, message: "Bluethooth is off. Please turn on bluethooth from setting.", preferredStyle: UIAlertController.Style.alert)
           alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { (action) in
//               UIApplication.shared.open(NSURL(string: "App-Prefs:root=Bluetooth")! as URL)
           }))
           
           self.present(alert, animated: true, completion: nil)
           fallthrough
       case .unauthorized:
           print("MainController --> State : Unauthorized")
           fallthrough
       case .unknown:
           print("MainController --> State : Unknown")
           fallthrough
       case .unsupported:
           print("MainController --> State : Unsupported")
           self.appDelegate.bluetoothManager.stopScanPeripheral()
           self.appDelegate.bluetoothManager.disconnectPeripheral()
       @unknown default: break
           
       }
   }
    
    
    
    func getReciveData(msg : String)
    {
        if msg == "#1#MEND#"
        {
            self.reciveData.add(msg)
            self.getUpdatedString()
        }else
        {
            self.reciveData.add(msg)
        }
    }
    
    func getUpdatedString()
    {
    
        var statusCount : Int = 0
        var str = String()
        for item in self.reciveData
        {
            //|| item as! String == "MSTAT#2#" || item as! String == "#2#MEND#"
            if item as! String == "MSTAT#1#" || item as! String == "#1#MEND#"
            {
                statusCount = statusCount + 1
                continue
            }
            else
            {
                str = str + String(item as! String)
            }
            
        }
        print(statusCount)
        self.reciveData.removeAllObjects()
        if statusCount != 2
        {
            return
        }
        statusCount = 0
        var newSTr = str.replacingOccurrences(of: " ", with: "")
        newSTr = newSTr.replacingOccurrences(of: "\n", with: "")
        newSTr = newSTr.replacingOccurrences(of: "{", with: "")
        newSTr = newSTr.replacingOccurrences(of: "}", with: ",")
        newSTr = String(newSTr.dropLast())
        newSTr = "{" + newSTr + "}"

        print("New updated string : ", "\(newSTr)")
        
        let convertedDict = self.convertStringToDictionary(text: newSTr)
        print("converted json : ", "\(convertedDict)")
        if convertedDict?.count > 0
        {
            self.appDelegate.globalDict = convertedDict! as NSDictionary
            if self.index == -1
            {
                if convertedDict!.count > 0
                {
                    self.btnContinue.isHidden = false
                   // self.imgRefresh.image = UIImage(named: "Su-vastika")
                    self.sendData = (convertedDict as? NSDictionary)!
                    self.index = self.index + 1
                    self.lblDetails.text = "Connecting to Su-vastika UPS"
                }
            }
        }
    }
    
    
    func getString()
    {
        if self.reciveData.lastObject as! String == "#1#MEND#"
        {
            var str = String()
            self.reciveData.removeObject(at: 0)
            self.reciveData.removeLastObject()
            for item in self.reciveData
            {
                str = str + String(item as! String)
            }
            self.reciveData.removeAllObjects()
            var newSTr = str.replacingOccurrences(of: " ", with: "")
            newSTr = newSTr.replacingOccurrences(of: "\n", with: "")
            print("New updated string : ", "\(newSTr)")
            
            let convertedDict = self.convertStringToDictionary(text: newSTr)
            print("converted json : ", "\(convertedDict)")
            if convertedDict?.count > 0
            {
                self.appDelegate.globalDict = convertedDict! as NSDictionary
                if self.index == -1
                {
                    if convertedDict!.count > 0
                    {
                        self.btnContinue.isHidden = false
                        //self.imgRefresh.image = UIImage(named: "Su-vastika")
                        self.sendData = (convertedDict as? NSDictionary)!
                        self.index = self.index + 1
                        self.lblDetails.text = "Connecting to Su-vastika UPS"
                    }
                }
            }
            
            
        }
        else
        {
            self.reciveData.removeAllObjects()
        }
    }
    
    private func discoverDescriptor(_ characteristic: CBCharacteristic) {
        if peripheral != nil  {
            peripheral?.discoverDescriptors(for: characteristic)
        }
    }
        /**
         The callback function when central manager connected the peripheral successfully.
         
         - parameter connectedPeripheral: The peripheral which connected successfully.
         */
        func didConnectedPeripheral(_ connectedPeripheral: CBPeripheral) {
            print("MainController --> didConnectedPeripheral")
            
            
        }

        /**
         The peripheral services monitor
         
         - parameter services: The service instances which discovered by CoreBluetooth
         */
        func didDiscoverServices(_ peripheral: CBPeripheral) {
            print("MainController --> didDiscoverService:\(peripheral.services?.description ?? "Unknow Service")")
            
            self.appDelegate.bluetoothManager.discoverCharacteristics()
            self.services = self.appDelegate.bluetoothManager.connectedPeripheral?.services
            
            guard let services = peripheral.services else {
                return
            }

            if let service = services.first {
                peripheral.discoverCharacteristics(nil, for: service)
            }

        }

        /**
         The method invoked when interrogated fail.
         
         - parameter peripheral: The peripheral which interrogation failed.
         */
        func didFailedToInterrogate(_ peripheral: CBPeripheral) {
            print("The perapheral disconnected while being interrogated.")
        }

        func didDiscoverCharacteritics(_ service: CBService) {
            print("Service.characteristics:\(service.characteristics?.description ?? "Unknow Characteristics")")
            guard let characteristics = service.characteristics else {
                return
            }
            print(service.uuid)
           
            self.appDelegate.writableCharacteristic = characteristics.first!
            service.peripheral!.readValue(for: characteristics.first!)
            for characteristic in characteristics {
                if characteristic.properties.contains(.write) || characteristic.properties.contains(.writeWithoutResponse) {
                    self.writableCharacteristic = characteristic
                    self.appDelegate.writableCharacteristic = self.writableCharacteristic
                }
                // true for getting continue data from ble
                service.peripheral!.setNotifyValue(true, for: characteristic)
            }
            
            self.discoverDescriptor(self.appDelegate.writableCharacteristic!)
            self.updateChararcterices()
        }
    
        func didReadValueForCharacteristic(_ characteristic: String) {
            self.getReciveData(msg: characteristic)
        }
    
    }

extension String {
    
    /// Create NSData from hexadecimal string representation
    ///
    /// This takes a hexadecimal representation and creates a NSData object. Note, if the string has any spaces, those are removed. Also if the string started with a '<' or ended with a '>', those are removed, too. This does no validation of the string to ensure it's a valid hexadecimal string
    ///
    /// The use of `strtoul` inspired by Martin R at http://stackoverflow.com/a/26284562/1271826
    ///
    /// - returns: NSData represented by this hexadecimal string. Returns nil if string contains characters outside the 0-9 and a-f range.
    
    func dataFromHexadecimalString() -> Data? {
        let trimmedString = self.trimmingCharacters(in: CharacterSet(charactersIn: "<> ")).replacingOccurrences(of: " ", with: "")
        
        // make sure the cleaned up string consists solely of hex digits, and that we have even number of them
        
        let regex = try! NSRegularExpression(pattern: "^[0-9a-f]*$", options: .caseInsensitive)
        
        let found = regex.firstMatch(in: trimmedString, options: [], range: NSMakeRange(0, trimmedString.count))
        if found == nil || found?.range.location == NSNotFound || trimmedString.count % 2 != 0 {
            return nil
        }
        
        // everything ok, so now let's build NSData
        
        let data = NSMutableData(capacity: trimmedString.count / 2)
        
        var index = trimmedString.startIndex
        while index < trimmedString.endIndex {
            let byteString = String(trimmedString[index ..< trimmedString.index(after: trimmedString.index(after: index))])
            let num = UInt8(byteString.withCString { strtoul($0, nil, 16) })
            data?.append([num] as [UInt8], length: 1)
            index = trimmedString.index(after: trimmedString.index(after: index))
        }
        
        
        return data as Data?
    }
}
