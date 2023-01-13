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

class AvailableBLEVC: UIViewController,UITableViewDelegate,UITableViewDataSource {

    
    @IBOutlet weak var tblView: UITableView!
    @IBOutlet weak var btnScan: UIButton!
    var simpleBluetoothIO: SimpleBluetoothIO!
    var peripherals:[CBPeripheral] = []
    var centralManager: CBCentralManager!
    let cellReuseIdentifier = "cell"
    @IBOutlet weak var imgLoading: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.btnScan.layer.cornerRadius = self.btnScan.frame.size.height / 2
        self.btnScan.clipsToBounds = true
        
        self.tblView.register(UITableViewCell.self, forCellReuseIdentifier: cellReuseIdentifier)
        self.tblView.delegate = self
        self.tblView.dataSource = self
    
        self.imgLoading.loadGif(name: "")
        
        // Do any additional setup after loading the view.
    }
    

    @IBAction func tapBack(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func tapScan(_ sender: Any) {
        self.centralManager = CBCentralManager(delegate: self, queue: .main)
        let options: [String: Any] = [CBCentralManagerScanOptionAllowDuplicatesKey:NSNumber(value: false)]
        self.centralManager?.scanForPeripherals(withServices: nil, options: options)
        self.btnScan.isHidden = true
        self.imgLoading.isHidden = false
        DispatchQueue.main.asyncAfter(deadline: .now() + 20.0) {
            self.centralManager.stopScan()
            print("Scanning stop")
            var tempPeripherals:[CBPeripheral] = []

            if self.peripherals.count > 0
            {
                for device in self.peripherals
                {
                    if device.name?.count != 0 && device.name != nil
                    {
                        tempPeripherals.append(device)
                    }
                }
                self.peripherals = tempPeripherals
                self.tblView.reloadData()
                self.btnScan.isHidden = false
                self.imgLoading.isHidden = true
            }
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
           return self.peripherals.count
       }
       
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
            
        let cell:UITableViewCell = (self.tblView.dequeueReusableCell(withIdentifier: cellReuseIdentifier) as UITableViewCell?)!
        cell.textLabel?.text = self.peripherals[indexPath.row].name
        cell.accessoryType = .disclosureIndicator
        return cell
    }
       
       // method to run when table view cell is tapped
   func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
       print("You tapped cell number \(indexPath.row).")
   }
    
}

extension AvailableBLEVC : CBPeripheralDelegate, CBCentralManagerDelegate{
    
    func centralManager(_ central: CBCentralManager, didDiscover peripheral: CBPeripheral, advertisementData: [String : Any], rssi RSSI: NSNumber) {
        self.peripherals.append(peripheral)
        print("Discovered \(peripheral.name ?? "")")
        print("Discovered \(peripheral.identifier)")
       
    }
    
    
    func centralManagerDidUpdateState( _ central: CBCentralManager) {
        
        switch central.state {
        case .unknown:
            print("central.state is .unknown")
        case .resetting:
            print("central.state is .resetting")
        case .unsupported:
            print("central.state is .unsupported")
        case .unauthorized:
            print("central.state is .unauthorized")
        case .poweredOff:
            print("central.state is .poweredOff")
        case .poweredOn:
            print("central.state is .poweredOn")
            self.centralManager?.scanForPeripherals(withServices: nil, options: nil)
        @unknown default:
            fatalError()
            
        }
        
    }
    
    
    func centralManager( central: CBCentralManager, didConnect peripheral: CBPeripheral) {
        print("Connected to "+peripheral.name!)
        
    }

    private func centralManager( central: CBCentralManager, didFailToConnect peripheral: CBPeripheral, error: Error?) {
        print(error!)
        
    }
    
}


extension AvailableBLEVC: SimpleBluetoothIODelegate {
    func simpleBluetoothIO(simpleBluetoothIO: SimpleBluetoothIO, didReceiveValue value: String) {
        // revice value of BLE
    }
}
