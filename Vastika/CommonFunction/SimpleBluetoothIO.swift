import CoreBluetooth
import UIKit

protocol SimpleBluetoothIODelegate: AnyObject {
    func simpleBluetoothIO(simpleBluetoothIO: SimpleBluetoothIO, didReceiveValue value: String)
}

class SimpleBluetoothIO: NSObject {
    let serviceUUID: String
    weak var delegate: SimpleBluetoothIODelegate?
    
    var centralManager: CBCentralManager!
    var connectedPeripheral: CBPeripheral?
    var targetService: CBService?
    var writableCharacteristic: CBCharacteristic?
    
    init(serviceUUID: String, delegate: SimpleBluetoothIODelegate?) {
        self.serviceUUID = serviceUUID
        self.delegate = delegate
        
        super.init()
        
        centralManager = CBCentralManager(delegate: self, queue: nil)
        
    }
    
    func writeValue(value: String) {
        guard let peripheral = connectedPeripheral, let characteristic = writableCharacteristic else {
            return
        }
        
        let data = Data(value.utf8)
        peripheral.writeValue(data, for: characteristic, type: .withResponse)
    }
    
}

extension SimpleBluetoothIO: CBCentralManagerDelegate {
    func centralManager(_ central: CBCentralManager, didConnect peripheral: CBPeripheral) {
        peripheral.discoverServices(nil)
        
        if let name = peripheral.name {
            print("Connected! With \(name)")
            print(peripheral.maximumWriteValueLength(for: .withResponse))
            
            
            
        }
    }
    
    func centralManager(_ central: CBCentralManager, didDiscover peripheral: CBPeripheral, advertisementData: [String : Any], rssi RSSI: NSNumber) {
        connectedPeripheral = peripheral
        if let name = peripheral.name {
            print("Discovered \(name)")
            print(connectedPeripheral?.identifier)
            if let connectedPeripheral = connectedPeripheral {
                connectedPeripheral.delegate = self
                centralManager.connect(connectedPeripheral, options: nil)
            }
            centralManager.stopScan()
        }
        
    }
    
    func centralManagerDidUpdateState(_ central: CBCentralManager) {
        if central.state == .poweredOn {
            centralManager.scanForPeripherals(withServices: nil, options: nil)
        }
    }
}

extension SimpleBluetoothIO: CBPeripheralDelegate {
    func peripheral(_ peripheral: CBPeripheral, didDiscoverServices error: Error?) {
        guard let services = peripheral.services else {
            return
        }
        
        targetService = services.first
        if let service = services.first {
            targetService = service
            peripheral.discoverCharacteristics(nil, for: service)
            
        }
    }
    
    func peripheral(_ peripheral: CBPeripheral, didDiscoverCharacteristicsFor service: CBService, error: Error?) {
        guard let characteristics = service.characteristics else {
            return
        }
        print(service.uuid)
        peripheral.readValue(for: characteristics.first!)
        for characteristic in characteristics {
            if characteristic.properties.contains(.write) || characteristic.properties.contains(.writeWithoutResponse) {
                writableCharacteristic = characteristic
            }
            // true for getting continue data from ble
            peripheral.setNotifyValue(true, for: characteristic)
        }
    }
    
    func peripheral(_ peripheral: CBPeripheral, didUpdateNotificationStateFor characteristic: CBCharacteristic, error: Error?) {
        peripheral.readValue(for: characteristic)
        print(peripheral.state.rawValue)
    }
    
    func peripheral(_ peripheral: CBPeripheral, didUpdateValueFor characteristic: CBCharacteristic, error: Error?) {
        guard let data = characteristic.value, let delegate = delegate else {
            return
        }
        
        let str = String(decoding: data, as: UTF8.self)
        delegate.simpleBluetoothIO(simpleBluetoothIO: self, didReceiveValue: str)
       
    }
}
