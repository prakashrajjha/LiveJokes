//
//  Preference.swift
//  LiveJoke
//
//  Created by Prakash Raj on 06/05/23.
//

import Foundation

public class Preference {
}

public extension Preference {
    class var usrDefaults: UserDefaults { return UserDefaults.standard }
    

    class func saveString(_ value:String, key:String) {
        Preference.usrDefaults.set(value, forKey: key)
        Preference.usrDefaults.synchronize()
    }
    
    class func saveInt(_ value:Int, key:String) {
        Preference.usrDefaults.set(value, forKey: key)
        Preference.usrDefaults.synchronize()
    }
    
    class func saveDouble(_ value:Double, key:String) {
        Preference.usrDefaults.set(value, forKey: key)
        Preference.usrDefaults.synchronize()
    }
    
    class func saveBool(_ value:Bool, key:String) {
        Preference.usrDefaults.set(value, forKey: key)
        Preference.usrDefaults.synchronize()
    }
    
    class func saveObject<T:Codable>(object:T, key: String) {
        let encoder = JSONEncoder()
        do {
            let encodedData = try encoder.encode(object)
            Preference.saveData(key: key, value: encodedData)
        } catch {
          //  CapPreference.logPreferenceError(message: "Falid to save model object generic(\(T.self)", error: error)
        }
    }
    
    class func removeObject(key: String) {
        Preference.usrDefaults.removeObject(forKey: key)
    }
    
    class func saveData(key:String, value:Data) {
        Preference.usrDefaults.set(value, forKey: key)
        Preference.usrDefaults.synchronize()
    }
}

public extension Preference {
    class func stringFor(key: String) -> String? { return Preference.usrDefaults.string(forKey: key) }
    class func intFor(key: String) -> Int        { return Preference.usrDefaults.integer(forKey: key) }
    class func doubleFor(key:String) -> Double   { return Preference.usrDefaults.double(forKey: key) }
    class func boolFor(key:String) -> Bool       { return Preference.usrDefaults.bool(forKey: key) }
    class func fetchData(key:String) -> Data?    { return Preference.usrDefaults.data(forKey: key) }

    class func fetchObject<T: Codable>(object:T.Type, key: String) -> T?{
        let data = self.fetchData(key: key)
        return data != nil ? try? JSONDecoder().decode(T.self, from: data!) : nil
    }
}
