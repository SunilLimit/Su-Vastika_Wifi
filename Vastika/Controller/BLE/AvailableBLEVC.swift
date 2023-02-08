//
//  AvailableBLEVC.swift
//  Vastika
//
//  Created by Sunil on 23/12/22.
//

import UIKit
import CoreBluetooth
import SwiftyGif
import SwiftGifOrigin
import QuartzCore

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

class AvailableBLEVC: UIViewController,UITableViewDelegate,UITableViewDataSource ,BluetoothDelegate{
    
    fileprivate class PeripheralInfos: Equatable, Hashable {
        let peripheral: CBPeripheral
        var RSSI: Int = 0
        var advertisementData: [String: Any] = [:]
        var lastUpdatedTimeInterval: TimeInterval
        
        init(_ peripheral: CBPeripheral) {
            self.peripheral = peripheral
            self.lastUpdatedTimeInterval = Date().timeIntervalSince1970
        }
        
        static func == (lhs: PeripheralInfos, rhs: PeripheralInfos) -> Bool {
            return lhs.peripheral.isEqual(rhs.peripheral)
        }
        var hashValue: Int {
            return peripheral.hash
        }
        
        
    }
    let appDelegate = UIApplication.shared.delegate as! AppDelegate
    fileprivate var nearbyPeripheralInfos: [PeripheralInfos] = []
    var selectedVirtualPeriperalIndex: Int = -1
    let cellReuseIdentifier = "cell"
    var preferences: Preferences? {
        return PreferencesStore.shared.preferences
    }
    var cachedVirtualPeripherals: [VirtualPeripheral] {
        return VirtualPeripheralStore.shared.cachedVirtualPeripheral
    }

    @IBOutlet weak var outerView: UIView!
    @IBOutlet weak var btnMenu: UIButton!
    @IBOutlet weak var imgHeader: UIImageView!
    @IBOutlet weak var lblHeader: UILabel!
    @IBOutlet weak var tblView: UITableView!
    @IBOutlet weak var btnScan: UIButton!
   
    
    var ssid = String()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.btnMenu.isHidden = true
        self.lblHeader.isHidden = true
        self.tblView.register(UITableViewCell.self, forCellReuseIdentifier: cellReuseIdentifier)
        self.tblView.delegate = self
        self.tblView.dataSource = self
        self.appDelegate.ssid = self.ssid
        
        self.btnScan.layer.borderColor = UIColor.init(red: 159.0/255.0, green: 179.0/255.0, blue: 202.0/255.0,alpha: 1.0).cgColor
        self.btnScan.layer.borderWidth = 8
        self.btnScan.layer.cornerRadius = self.btnScan.frame.size.height / 2
        self.btnScan.clipsToBounds = true
        
        
        self.btnScan.titleLabel?.font = UIFont(name: "Montserrat-Bold", size: 25)
        self.lblHeader.font = UIFont(name: "Montserrat-Medium", size: 16)
        
        // Do any additional setup after loading the view.
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
    }
    
    @IBAction func tapBack(_ sender: Any) {
        if let vcToPresent = self.storyboard!.instantiateViewController(withIdentifier: "SideMenuVC") as? SideMenuVC{
            self.navigationController?.pushViewController(vcToPresent, animated: true)
        }
    }
    
    @IBAction func tapScan(_ sender: Any) {
        
        self.imgHeader.isHidden = false
        self.btnMenu.isHidden = true
        self.lblHeader.isHidden = true
        self.nearbyPeripheralInfos.removeAll()
        self.btnScan.isHidden = false
        self.appDelegate.bluetoothManager = BluetoothManager.getInstance()
        if self.appDelegate.bluetoothManager.connectedPeripheral != nil {
            self.appDelegate.bluetoothManager.disconnectPeripheral()
        }
        self.appDelegate.bluetoothManager.delegate = self
    }
    
    
    // MARK: Delegates
    // MARK: UITableViewDelegate
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let hView = UIView(frame: CGRect(x: 0, y: 0, width: self.view.frame.size.width, height: 50))
        let lblHdr = UILabel(frame: CGRect(x: 15, y: 0, width: hView.frame.size.width - 50, height: hView.frame.size.height))
        lblHdr.textColor = UIColor.black
        lblHdr.font = UIFont(name: "Montserrat-Medium", size: 16)
        lblHdr.text = "Scan Devices"
        hView.addSubview(lblHdr)
        return hView
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 50
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let peripheral = nearbyPeripheralInfos[indexPath.row].peripheral
        if let vcToPresent = self.storyboard!.instantiateViewController(withIdentifier: "ConnectingVC") as? ConnectingVC{
            vcToPresent.peripheral = nearbyPeripheralInfos[indexPath.row].peripheral
            self.navigationController?.pushViewController(vcToPresent, animated: true);
        }
    }
    
    // MARK： UITableViewDataSource
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell:UITableViewCell = (self.tblView.dequeueReusableCell(withIdentifier: cellReuseIdentifier) as UITableViewCell?)!
        let peripheralInfo = nearbyPeripheralInfos[indexPath.row]
        let peripheral = peripheralInfo.peripheral
        cell.textLabel?.text = peripheral.name == nil || peripheral.name == ""  ? "Unnamed" : peripheral.name
        cell.textLabel?.textColor = UIColor.black
        cell.accessoryType = .disclosureIndicator
        cell.backgroundColor = UIColor.white
        return cell
        
    }
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return nearbyPeripheralInfos.count == 0 ? 0 : nearbyPeripheralInfos.count
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    // MARK: BluetoothDelegate
    func didDiscoverPeripheral(_ peripheral: CBPeripheral, advertisementData: [String : Any], RSSI: NSNumber) {
        let peripheralInfo = PeripheralInfos(peripheral)
        
        if peripheralInfo.peripheral.name?.count != 0 && peripheralInfo.peripheral.name != nil
        {
            if peripheralInfo.peripheral.name!.contains("BLE")
            {
                if self.nearbyPeripheralInfos.count > 0     
                {
                    for item in self.nearbyPeripheralInfos
                    {
                        if item.peripheral.name != peripheralInfo.peripheral.name
                        {
                            self.nearbyPeripheralInfos.append(peripheralInfo)
                           
                        }
                    }
                }
                else
                {
                    self.nearbyPeripheralInfos.append(peripheralInfo)
                }
              
                self.appDelegate.bluetoothManager.stopScanPeripheral()
            }
        }
        
        if self.nearbyPeripheralInfos.count > 0
        {
            self.outerView.isHidden = true
        }
        else
        {
            self.outerView.isHidden = false
        }
        self.tblView.reloadData()
    }
    
    /**
     The bluetooth state monitor
     
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
    
}

extension UIView {
    func dropShadow(scale: Bool = true) {
        layer.masksToBounds = false
        layer.shadowColor = UIColor.black.cgColor
        layer.shadowOpacity = 0.2
        layer.shadowOffset = .zero
        layer.shadowRadius = 1
        layer.shouldRasterize = true
        layer.rasterizationScale = scale ? UIScreen.main.scale : 1
    }
}
