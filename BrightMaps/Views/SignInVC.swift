import Foundation
import Alamofire
import UIKit
import SwiftSpinner
import CPAlertViewController


class SignInVc: UIViewController {

@IBOutlet weak var emailText: UITextField!
@IBOutlet weak var passwordText: UITextField!
    override func viewDidLoad() {
    super.viewDidLoad()
    
}

    override func viewDidAppear(_ animated: Bool) {
        
        
        if getDataInUserDefaults(key: "isLoged") != nil{
            if(getDataInUserDefaults(key: "isLoged")! == "true"){

                SwiftSpinner.show("...")
                self.createLoginRequest(email: getDataInUserDefaults(key: "email")!, password: getDataInUserDefaults(key: "password")!)
            }
        }
        
    }



@IBAction func signInButton(_ sender: UIButton) {
    
    let alert = CPAlertViewController()
    
    if passwordText.text != "" && emailText.text != ""{
        
        if isValidEmail(YourEMailAddress: emailText.text!) {
            SwiftSpinner.show("...")
            self.createLoginRequest(email: emailText.text!, password: passwordText.text!)
        }else{
            alert.showError(title: "wrongEmail".localized(), buttonTitle: "OK")
        }
        
    }else{
        alert.showError(title: "allFieldsRequired".localized(), buttonTitle: "OK")
    }
}



func createLoginRequest(email:String, password:String){
    
    
    let url = "http://localhost:8888/brightmaps/public/api/login"
    let parameters: Parameters = ["email":email,"password":password]
    
    Alamofire.request(url, method: .post, parameters: parameters).responseJSON{response in
        
        if (response.result.value != nil)
        {
            
            var arrayResult = response.result.value as! Dictionary<String, Any>
            let alert = CPAlertViewController()
            
            switch response.result {
            case .success:
                switch arrayResult["code"] as! Int{
                case 200:
                    var arrayData = arrayResult["data"] as! Dictionary<String,Any>
                    var arrayUser = arrayData["user"] as! Dictionary<String,Any>
                    
                    SwiftSpinner.hide()
                    
                    let alert = CPAlertViewController()
                    
                    if getDataInUserDefaults(key: "isLoged") == nil{
                        alert.showSuccess(title: "correctLogin".localized(), message: "succesLogin".localized(), buttonTitle: "OK", action: nil)
                    }
                    
                    
                    saveDataInUserDefaults(value: "\(String(describing: arrayUser["id"]))" , key: "id")
                    
                    saveDataInUserDefaults(value: arrayUser["email"] as! String, key: "email")
                    saveDataInUserDefaults(value: arrayUser["password"] as! String, key: "password")
                    
                    
                    saveDataInUserDefaults(value: arrayData["token"] as! String, key: "token")
                    
                    saveDataInUserDefaults(value: "true", key: "isLoged")
                    self.goToMain()
                case 500:
                    // error del servidor
                    SwiftSpinner.hide()
                    if getDataInUserDefaults(key: "email") != nil {
                        self.emailText.text = getDataInUserDefaults(key: "email")
                    }
                    alert.showError(title: ("Error al conectar con el servidor" ), buttonTitle: "OK")
                    
                default:
                    // cualquier error
                    SwiftSpinner.hide()
                    if getDataInUserDefaults(key: "email") != nil {
                        self.emailText.text = getDataInUserDefaults(key: "email")
                    }
                    alert.showError(title: (arrayResult["message"] as! String), buttonTitle: "OK")
                }
            case .failure:
                SwiftSpinner.hide()
                if getDataInUserDefaults(key: "email") != nil {
                    self.emailText.text = getDataInUserDefaults(key: "email")
                }
                alert.showError(title: String(describing: response.error), buttonTitle: "OK")
            }
            SwiftSpinner.hide()
        }else{
            let alert = CPAlertViewController()
            if getDataInUserDefaults(key: "email") != nil {
                self.emailText.text = getDataInUserDefaults(key: "email")
            }
            
            alert.showError(title: "No se puede conectar al servidor", buttonTitle: "OK")
        }
    }
}
    func goToMain(){
        
        let tabbarVC = storyboard?.instantiateViewController(withIdentifier: "UITabBarController") as! UITabBarController
        
        self.present(tabbarVC, animated: false, completion: nil)
    }


    @IBAction func goToReg(_ sender: Any) {
        
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "RegisterVC") as! RegisterVC
        
        self.navigationController?.pushViewController(vc, animated: true)

    }
    


}


