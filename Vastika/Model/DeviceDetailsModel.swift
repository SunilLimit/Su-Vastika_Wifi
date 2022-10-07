//
//  DeviceDetailsModel.swift
//  Vastika
//
//  Created by Mac on 17/09/21.
//

import Foundation
import SwiftyJSON

class DeviceDetailsModel:NSObject,Codable{

    var status_mains : Int!
    var load_percent : Int!
    var syscap : Int!
    var id : Int!
    var bw : Int!
    var device_type : String!
    var load_wattage : Int!
    var load_sharing_1 : Int!
    var mipv : Int!
    var charge_sharing_1 : Int!
    var pvw : Int!
    var status_ups : Int!
    var bdw : Int!
    var warranty_1 : Int!
    var charge_sharing_2 : Int!
    var status_settings : Int!
    var updated_at : String!
    var pv_u : Double!
    var created_at : String!
    var dcbus : Int!
    var status_error : Int!
    var at : Int!
    var device_id : Int!
    var solar_mode_timer : String!
    var power_fail_timer : String!
    var device_name : String!
    var dsg_i : Double!
    var device_serial : String!
    var status_solar : Int!
    var setting_battery_type : String!
    var setting_priority : String!
    var status_front_switch : Int!
    var setting_atc : String!
    var warranty_2 : Int!
    var setting_grid_charging : Int!
    var battery_percent : Int!
    var load_sharing_2 : Int!
    var bv : Double!
    var mains_charging_timer : String!
    var status_charging : Int!
    var setting_low_voltage_cut : String!
    var chg_i : Double!
    var setting_ups_type : String!
    var setting_ups_type_is : Int!
    var setting_remote_priority : Int!
    var setting_battery_type_is : Int!
    var setting_grid_charging_is : Int!
    var setting_low_voltage_cut_is : Int!
    var setting_buzzer : Int!
    var setting_resource_priority : Int!
    var solar_electricity_savings : PriceModel!
    var electricity_unit_charge : String!
    var timestamp : String!
    var device_function_type : String!
    var currency : String!
    
    // * Instantiate the instance using the passed json values to set the properties values
    // */
    init(fromJson json: JSON!){
        if json.isEmpty{
            return
        }
        status_mains = json["status_mains"].intValue
        load_percent = json["load_percent"].intValue
        setting_ups_type_is = json["setting_ups_type_is"].intValue
        setting_remote_priority = json["setting_remote_priority"].intValue
        setting_battery_type_is = json["setting_battery_type_is"].intValue
        setting_grid_charging_is = json["setting_grid_charging_is"].intValue
        setting_low_voltage_cut_is = json["setting_low_voltage_cut_is"].intValue
        setting_buzzer = json["setting_buzzer"].intValue
        setting_resource_priority = json["setting_resource_priority"].intValue

        syscap = json["syscap"].intValue
        id = json["id"].intValue
        bw = json["bw"].intValue
        device_type = json["device_type"].stringValue
        device_function_type = json["device_function_type"].stringValue

        load_wattage = json["load_wattage"].intValue
        load_sharing_1 = json["load_sharing_1"].intValue
        mipv = json["mipv"].intValue
        charge_sharing_1 = json["charge_sharing_1"].intValue
        pvw = json["pvw"].intValue
        status_ups = json["status_ups"].intValue

        bdw = json["bdw"].intValue
        warranty_1 = json["warranty_1"].intValue
        charge_sharing_2 = json["charge_sharing_2"].intValue
        status_settings = json["status_settings"].intValue
        updated_at = json["updated_at"].stringValue
        pv_u = json["pv_u"].doubleValue
        
        created_at = json["created_at"].stringValue
        dcbus = json["dcbus"].intValue
        status_error = json["status_error"].intValue
        at = json["at"].intValue
        device_id = json["device_id"].intValue
        solar_mode_timer = json["solar_mode_timer"].stringValue
        
        currency = json["currency"].stringValue

        power_fail_timer = json["power_fail_timer"].stringValue
        device_name = json["device_name"].stringValue
        dsg_i = json["dsg_i"].doubleValue
        device_serial = json["device_serial"].stringValue
        status_solar = json["status_solar"].intValue
        setting_battery_type = json["setting_battery_type"].stringValue

        setting_priority = json["setting_priority"].stringValue
        status_front_switch = json["status_front_switch"].intValue
        setting_atc = json["setting_atc"].stringValue
        warranty_2 = json["warranty_2"].intValue
        setting_grid_charging = json["setting_grid_charging"].intValue
        battery_percent = json["battery_percent"].intValue
        
        load_sharing_2 = json["load_sharing_2"].intValue
        bv = json["bv"].doubleValue
        mains_charging_timer = json["mains_charging_timer"].stringValue
        status_charging = json["status_charging"].intValue
        setting_low_voltage_cut = json["setting_low_voltage_cut"].stringValue
        chg_i = json["chg_i"].doubleValue

        setting_ups_type = json["setting_ups_type"].stringValue
        timestamp = json["timestamp"].stringValue
        solar_electricity_savings = PriceModel(fromJson: json["solar_electricity_savings"])
        electricity_unit_charge = json["electricity_unit_charge"].stringValue

    }
    
    /**
     * Returns all the available property values in the form of [String:Any] object where the key is the approperiate json key and the value is the value of the corresponding property
     */
    func toDictionary() -> [String:Any]
    {
        var dictionary = [String:Any]()
        if status_mains != nil{
            dictionary["status_mains"] = status_mains
        }
        if load_percent != nil{
            dictionary["load_percent"] = load_percent
        }
        if setting_ups_type_is != nil{
            dictionary["setting_ups_type_is"] = setting_ups_type_is
        }
        if setting_remote_priority != nil{
            dictionary["setting_remote_priority"] = setting_remote_priority
        }
        if setting_battery_type_is != nil{
            dictionary["setting_battery_type_is"] = setting_battery_type_is
        }
        if setting_grid_charging_is != nil{
            dictionary["setting_grid_charging_is"] = setting_grid_charging_is
        }
        if setting_low_voltage_cut_is != nil{
            dictionary["setting_low_voltage_cut_is"] = setting_low_voltage_cut_is
        }
        if setting_buzzer != nil{
            dictionary["setting_buzzer"] = setting_buzzer
        }
        if setting_resource_priority != nil{
            dictionary["setting_resource_priority"] = setting_resource_priority
        }
        
        if device_function_type != nil{
            dictionary["device_function_type"] = device_function_type
        }
        
        if currency != nil{
            dictionary["currency"] = currency
        }
        
        if syscap != nil{
            dictionary["syscap"] = syscap
        }
        if id != nil{
            dictionary["id"] = id
        }
        if bw != nil{
            dictionary["bw"] = bw
        }
        if device_type != nil{
            dictionary["device_type"] = device_type
        }
        
        if load_wattage != nil{
            dictionary["load_wattage"] = load_wattage
        }
        if load_percent != nil{
            dictionary["load_percent"] = load_percent
        }
        if load_sharing_1 != nil{
            dictionary["load_sharing_1"] = load_sharing_1
        }
        if mipv != nil{
            dictionary["mipv"] = mipv
        }
        if charge_sharing_1 != nil{
            dictionary["charge_sharing_1"] = charge_sharing_1
        }
        if pvw != nil{
            dictionary["pvw"] = pvw
        }
        
        if status_ups != nil{
            dictionary["status_ups"] = status_ups
        }
        if bdw != nil{
            dictionary["bdw"] = bdw
        }
        if warranty_1 != nil{
            dictionary["warranty_1"] = warranty_1
        }
        if charge_sharing_2 != nil{
            dictionary["charge_sharing_2"] = charge_sharing_2
        }
        if status_settings != nil{
            dictionary["status_settings"] = status_settings
        }
        if updated_at != nil{
            dictionary["updated_at"] = updated_at
        }
        
        if pv_u != nil{
            dictionary["pv_u"] = pv_u
        }
        if created_at != nil{
            dictionary["created_at"] = created_at
        }
        if dcbus != nil{
            dictionary["dcbus"] = dcbus
        }
        if status_error != nil{
            dictionary["status_error"] = status_error
        }
        if at != nil{
            dictionary["at"] = at
        }
        if device_id != nil{
            dictionary["device_id"] = device_id
        }
        
        if solar_mode_timer != nil{
            dictionary["solar_mode_timer"] = solar_mode_timer
        }
        if power_fail_timer != nil{
            dictionary["power_fail_timer"] = power_fail_timer
        }
        if device_name != nil{
            dictionary["device_name"] = device_name
        }
        if dsg_i != nil{
            dictionary["dsg_i"] = dsg_i
        }
        if device_serial != nil{
            dictionary["device_serial"] = device_serial
        }
        if status_solar != nil{
            dictionary["status_solar"] = status_solar
        }
        
        if setting_battery_type != nil{
            dictionary["setting_battery_type"] = setting_battery_type
        }
        if setting_priority != nil{
            dictionary["setting_priority"] = setting_priority
        }
        if status_front_switch != nil{
            dictionary["status_front_switch"] = status_front_switch
        }
        if setting_atc != nil{
            dictionary["setting_atc"] = setting_atc
        }
        if warranty_2 != nil{
            dictionary["warranty_2"] = warranty_2
        }
        if setting_grid_charging != nil{
            dictionary["setting_grid_charging"] = setting_grid_charging
        }
        
        if battery_percent != nil{
            dictionary["battery_percent"] = battery_percent
        }
        if load_sharing_2 != nil{
            dictionary["load_sharing_2"] = load_sharing_2
        }
        if bv != nil{
            dictionary["bv"] = bv
        }
        if mains_charging_timer != nil{
            dictionary["mains_charging_timer"] = mains_charging_timer
        }
        if status_charging != nil{
            dictionary["status_charging"] = status_charging
        }
        if setting_low_voltage_cut != nil{
            dictionary["setting_low_voltage_cut"] = setting_low_voltage_cut
        }
        
        if chg_i != nil{
            dictionary["chg_i"] = chg_i
        }
        if setting_ups_type != nil{
            dictionary["setting_ups_type"] = setting_ups_type
        }
        if timestamp != nil{
            dictionary["timestamp"] = timestamp
        }
        
        if solar_electricity_savings != nil{
            dictionary["solar_electricity_savings"] = solar_electricity_savings
        }
        
        if electricity_unit_charge != nil{
            dictionary["electricity_unit_charge"] = electricity_unit_charge
        }
        
        return dictionary
    }
    
    /**
     * NSCoding required initializer.
     * Fills the data from the passed decoder
     */
    @objc required init(coder aDecoder: NSCoder)
    {
        status_mains = aDecoder.decodeObject(forKey: "status_mains") as? Int
        load_percent = aDecoder.decodeObject(forKey: "load_percent") as? Int
        setting_ups_type_is = aDecoder.decodeObject(forKey: "setting_ups_type_is") as? Int
        setting_remote_priority = aDecoder.decodeObject(forKey: "setting_remote_priority") as? Int
        setting_battery_type_is = aDecoder.decodeObject(forKey: "setting_battery_type_is") as? Int
        setting_grid_charging_is = aDecoder.decodeObject(forKey: "setting_grid_charging_is") as? Int
        setting_low_voltage_cut_is = aDecoder.decodeObject(forKey: "setting_low_voltage_cut_is") as? Int
        setting_buzzer = aDecoder.decodeObject(forKey: "setting_buzzer") as? Int
        setting_resource_priority = aDecoder.decodeObject(forKey: "setting_resource_priority") as? Int

        syscap = (aDecoder.decodeObject(forKey: "syscap") as? Int)!
        id = (aDecoder.decodeObject(forKey: "id") as? Int)!
        bw = (aDecoder.decodeObject(forKey: "bw") as? Int)!
        device_type = (aDecoder.decodeObject(forKey: "device_type") as? String)!
        device_function_type = (aDecoder.decodeObject(forKey: "device_function_type") as? String)!
        currency = (aDecoder.decodeObject(forKey: "currency") as? String)!

        
        load_wattage = aDecoder.decodeObject(forKey: "load_wattage") as? Int
        load_sharing_1 = aDecoder.decodeObject(forKey: "load_sharing_1") as? Int
        mipv = (aDecoder.decodeObject(forKey: "mipv") as? Int)!
        charge_sharing_1 = (aDecoder.decodeObject(forKey: "charge_sharing_1") as? Int)!
        pvw = (aDecoder.decodeObject(forKey: "pvw") as? Int)!
        status_ups = (aDecoder.decodeObject(forKey: "status_ups") as? Int)!
        
        bdw = aDecoder.decodeObject(forKey: "bdw") as? Int
        warranty_1 = aDecoder.decodeObject(forKey: "warranty_1") as? Int
        charge_sharing_2 = (aDecoder.decodeObject(forKey: "charge_sharing_2") as? Int)!
        status_settings = (aDecoder.decodeObject(forKey: "status_settings") as? Int)!
        updated_at = (aDecoder.decodeObject(forKey: "updated_at") as? String)!
        pv_u = (aDecoder.decodeObject(forKey: "pv_u") as? Double)!
        
        created_at = aDecoder.decodeObject(forKey: "created_at") as? String
        dcbus = aDecoder.decodeObject(forKey: "dcbus") as? Int
        status_error = (aDecoder.decodeObject(forKey: "status_error") as? Int)!
        at = (aDecoder.decodeObject(forKey: "at") as? Int)!
        device_id = (aDecoder.decodeObject(forKey: "device_id") as? Int)!
        solar_mode_timer = (aDecoder.decodeObject(forKey: "solar_mode_timer") as? String)!
        
        power_fail_timer = aDecoder.decodeObject(forKey: "power_fail_timer") as? String
        device_name = aDecoder.decodeObject(forKey: "device_name") as? String
        dsg_i = (aDecoder.decodeObject(forKey: "dsg_i") as? Double)!
        device_serial = (aDecoder.decodeObject(forKey: "device_serial") as? String)!
        status_solar = (aDecoder.decodeObject(forKey: "status_solar") as? Int)!
        setting_battery_type = (aDecoder.decodeObject(forKey: "setting_battery_type") as? String)!
        
        setting_priority = aDecoder.decodeObject(forKey: "setting_priority") as? String
        status_front_switch = aDecoder.decodeObject(forKey: "status_front_switch") as? Int
        setting_atc = (aDecoder.decodeObject(forKey: "setting_atc") as? String)!
        warranty_2 = (aDecoder.decodeObject(forKey: "warranty_2") as? Int)!
        setting_grid_charging = (aDecoder.decodeObject(forKey: "setting_grid_charging") as? Int)!
        battery_percent = (aDecoder.decodeObject(forKey: "battery_percent") as? Int)!
        
        load_sharing_2 = aDecoder.decodeObject(forKey: "load_sharing_2") as? Int
        bv = aDecoder.decodeObject(forKey: "bv") as? Double
        mains_charging_timer = (aDecoder.decodeObject(forKey: "mains_charging_timer") as? String)!
        status_charging = (aDecoder.decodeObject(forKey: "status_charging") as? Int)!
        setting_low_voltage_cut = (aDecoder.decodeObject(forKey: "setting_low_voltage_cut") as? String)!
        chg_i = (aDecoder.decodeObject(forKey: "chg_i") as? Double)!
        
        setting_ups_type = aDecoder.decodeObject(forKey: "setting_ups_type") as? String
        timestamp = aDecoder.decodeObject(forKey: "timestamp") as? String
       
        electricity_unit_charge = aDecoder.decodeObject(forKey: "electricity_unit_charge") as? String
        solar_electricity_savings = aDecoder.decodeObject(forKey: "solar_electricity_savings") as? PriceModel
        
    }

    /**
     * NSCoding required method.
     * Encodes mode properties into the decoder
     */
    func encode(with aCoder: NSCoder)
    {
        if status_mains != nil{
            aCoder.encode(status_mains, forKey: "status_mains")
        }
        if device_function_type != nil{
            aCoder.encode(device_function_type, forKey: "device_function_type")
        }
        if load_percent != nil{
            aCoder.encode(load_percent, forKey: "load_percent")
        }
        if setting_ups_type_is != nil{
            aCoder.encode(setting_ups_type_is, forKey: "setting_ups_type_is")
        }
        if setting_remote_priority != nil{
            aCoder.encode(setting_remote_priority, forKey: "setting_remote_priority")
        }
        if setting_battery_type_is != nil{
            aCoder.encode(setting_battery_type_is, forKey: "setting_battery_type_is")
        }
        
        if setting_grid_charging_is != nil{
            aCoder.encode(setting_grid_charging_is, forKey: "setting_grid_charging_is")
        }
        
        if setting_low_voltage_cut_is != nil{
            aCoder.encode(setting_low_voltage_cut_is, forKey: "setting_low_voltage_cut_is")
        }
        
        if currency != nil{
            aCoder.encode(currency, forKey: "currency")
        }
        
        
        if setting_buzzer != nil{
            aCoder.encode(setting_buzzer, forKey: "setting_buzzer")
        }
        
        if setting_resource_priority != nil{
            aCoder.encode(setting_resource_priority, forKey: "setting_resource_priority")
        }
        
        if syscap != nil{
            aCoder.encode(syscap, forKey: "syscap")
        }
        if id != nil{
            aCoder.encode(id, forKey: "id")
        }
        if bw != nil{
            aCoder.encode(bw, forKey: "bw")
        }
        if device_type != nil{
            aCoder.encode(device_type, forKey: "device_type")
        }
        
        if load_wattage != nil{
            aCoder.encode(load_wattage, forKey: "load_wattage")
        }
        if load_sharing_1 != nil{
            aCoder.encode(load_sharing_1, forKey: "load_sharing_1")
        }
        if mipv != nil{
            aCoder.encode(mipv, forKey: "mipv")
        }
        if charge_sharing_1 != nil{
            aCoder.encode(charge_sharing_1, forKey: "charge_sharing_1")
        }
        if pvw != nil{
            aCoder.encode(pvw, forKey: "pvw")
        }
        if status_ups != nil{
            aCoder.encode(status_ups, forKey: "status_ups")
        }
        
        if bdw != nil{
            aCoder.encode(bdw, forKey: "bdw")
        }
        if warranty_1 != nil{
            aCoder.encode(warranty_1, forKey: "warranty_1")
        }
        if charge_sharing_2 != nil{
            aCoder.encode(charge_sharing_2, forKey: "charge_sharing_2")
        }
        if status_settings != nil{
            aCoder.encode(status_settings, forKey: "status_settings")
        }
        if updated_at != nil{
            aCoder.encode(updated_at, forKey: "updated_at")
        }
        if pv_u != nil{
            aCoder.encode(pv_u, forKey: "pv_u")
        }
        
        if created_at != nil{
            aCoder.encode(created_at, forKey: "created_at")
        }
        if dcbus != nil{
            aCoder.encode(dcbus, forKey: "dcbus")
        }
        if status_error != nil{
            aCoder.encode(status_error, forKey: "status_error")
        }
        if at != nil{
            aCoder.encode(at, forKey: "at")
        }
        if device_id != nil{
            aCoder.encode(device_id, forKey: "device_id")
        }
        if solar_mode_timer != nil{
            aCoder.encode(solar_mode_timer, forKey: "solar_mode_timer")
        }
        
        
        if power_fail_timer != nil{
            aCoder.encode(power_fail_timer, forKey: "power_fail_timer")
        }
        if device_name != nil{
            aCoder.encode(device_name, forKey: "device_name")
        }
        if dsg_i != nil{
            aCoder.encode(dsg_i, forKey: "dsg_i")
        }
        if device_serial != nil{
            aCoder.encode(device_serial, forKey: "device_serial")
        }
        if status_solar != nil{
            aCoder.encode(status_solar, forKey: "status_solar")
        }
        if setting_battery_type != nil{
            aCoder.encode(setting_battery_type, forKey: "setting_battery_type")
        }
        
        if setting_priority != nil{
            aCoder.encode(setting_priority, forKey: "setting_priority")
        }
        if status_front_switch != nil{
            aCoder.encode(status_front_switch, forKey: "status_front_switch")
        }
        if setting_atc != nil{
            aCoder.encode(setting_atc, forKey: "setting_atc")
        }
        if warranty_2 != nil{
            aCoder.encode(warranty_2, forKey: "warranty_2")
        }
        if setting_grid_charging != nil{
            aCoder.encode(setting_grid_charging, forKey: "setting_grid_charging")
        }
        if battery_percent != nil{
            aCoder.encode(battery_percent, forKey: "battery_percent")
        }
        
        if load_sharing_2 != nil{
            aCoder.encode(load_sharing_2, forKey: "load_sharing_2")
        }
        if bv != nil{
            aCoder.encode(bv, forKey: "bv")
        }
        if mains_charging_timer != nil{
            aCoder.encode(mains_charging_timer, forKey: "mains_charging_timer")
        }
        if status_charging != nil{
            aCoder.encode(status_charging, forKey: "status_charging")
        }
        if setting_low_voltage_cut != nil{
            aCoder.encode(setting_low_voltage_cut, forKey: "setting_low_voltage_cut")
        }
        if chg_i != nil{
            aCoder.encode(chg_i, forKey: "chg_i")
        }
        
        if setting_ups_type != nil{
            aCoder.encode(setting_ups_type, forKey: "setting_ups_type")
        }
        if timestamp != nil{
            aCoder.encode(timestamp, forKey: "timestamp")
        }
        
        if solar_electricity_savings != nil{
            aCoder.encode(solar_electricity_savings, forKey: "solar_electricity_savings")
        }
        if electricity_unit_charge != nil{
            aCoder.encode(electricity_unit_charge, forKey: "electricity_unit_charge")
        }
        
    }
}



