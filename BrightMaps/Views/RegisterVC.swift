import Foundation
import UIKit
import Alamofire
import SwiftSpinner
import CPAlertViewController

class RegisterVC: UIViewController {
    
    
    @IBOutlet weak var nameText: UITextField!
    @IBOutlet weak var emailText: UITextField!
    @IBOutlet weak var passwordText: UITextField!
    @IBOutlet weak var repeatPasswordText: UITextField!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()

    }
    
    
    @IBAction func registerAction(_ sender: Any)  {
        
        let alert = CPAlertViewController()
        

        if emailText.text != "" && passwordText.text != "" && repeatPasswordText.text != ""{
            
            if isValidEmail(YourEMailAddress: emailText.text!) {
                
                if repeatPasswordText.text! == passwordText.text!{
                    
                    let password:String = passwordText.text!
                    
                    if password.count > 7 && password.count < 20{


                        self.registerRequest(email: emailText.text!, password: passwordText.text!, name: nameText.text!)

                    }else{
                        alert.showError(title: "lengthPassword".localized(), buttonTitle: "OK")
                    }
                    
                }
                else{
                    alert.showError(title: "wrongRepeatPassword".localized(), buttonTitle: "OK")
                }
                
            }else {
                alert.showError(title: "wrongEmail".localized(), buttonTitle: "OK")
            }
            
        }else{
            alert.showError(title: "allFieldsRequired".localized(), buttonTitle: "OK")
        }
    }
    
    


func registerRequest(email:String, password:String, name:String){
        

    let url = "http://localhost:8888/brightmaps/public/index.php/api/register"
        
    let parameters : Parameters = ["email":email,"password":password, "name":name]
        
        SwiftSpinner.show("...")
        
        Alamofire.request(url, method: .post, parameters: parameters).responseJSON{response in
            
            var arrayResult = response.result.value as! Dictionary<String, Any>
            let alert = CPAlertViewController()
            
            switch response.result {
            case .success:
                switch arrayResult["code"] as! Int{
                case 200:
                    self.alertUser(alertTitle: "Register succesful", alertMessage: "")
                    break
                    
                default:
                    
                    SwiftSpinner.hide()
                    alert.showError(title: (arrayResult["message"] as! String), buttonTitle: "OK")
                }
            case .failure:
                SwiftSpinner.hide()
            }
            

}
}
    
   
    
    
    private func alertUser( alertTitle title: String, alertMessage  message: String )
    {
        let alert = UIAlertController(title: title, message: message,   preferredStyle: .alert)
        let actionTaken = UIAlertAction(title: "Ok", style: .default) { (hand) in
            let storyBoard = UIStoryboard(name: "Main", bundle: nil)
            let destinationVC = storyBoard.instantiateViewController(withIdentifier: "HomeVC") as? SignInVc
            self.present(destinationVC!, animated: true, completion: nil)
            
        }
        alert.addAction(actionTaken)
        self.present(alert, animated: true) {}
    }
    @IBAction func goHome(_ sender: Any) {
        
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "HomeVC") as! SignInVc
        
        self.navigationController?.pushViewController(vc, animated: true)
    }
}
