import Foundation
import UIKit

var userRegistered:[String:String] = [:]
let defaults = UserDefaults.standard
var spots:[[String:Any]] = []
var globalidReceived:Int?




func isValidEmail(YourEMailAddress: String) -> Bool {
    let REGEX: String
    REGEX = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,6}"
    return NSPredicate(format: "SELF MATCHES %@", REGEX).evaluate(with: YourEMailAddress)
}




func getDataInUserDefaults(key:String) -> String?{
    
    if defaults.object(forKey: "userRegistered") != nil{
        userRegistered = defaults.object(forKey: "userRegistered") as! [String:String]
        
        return userRegistered[key]
    }else{
        return nil
    }
    
}



func saveDataInUserDefaults(value:String, key:String){
    
    if defaults.object(forKey: "userRegistered") == nil {
        defaults.set(userRegistered, forKey: "userRegistered")
    }
    userRegistered = defaults.object(forKey: "userRegistered") as! [String:String]
    userRegistered.updateValue(value, forKey: key)
    
    defaults.set(userRegistered, forKey: "userRegistered")
    defaults.synchronize()
    
}
func clearDataInUserDefaults(key:String){
    
    if defaults.object(forKey: "userRegistered") != nil {
        userRegistered = defaults.object(forKey: "userRegistered") as! [String : String]
        userRegistered.removeValue(forKey: key)
        
        defaults.set(userRegistered, forKey: "userRegistered")
        defaults.synchronize()
    }
    
}

func clearUserDefaults(){
    defaults.set(nil, forKey: "userRegistered")
    defaults.synchronize()
}
