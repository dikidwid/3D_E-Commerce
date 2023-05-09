//
//  LoginPageModel.swift
//  eCommerce
//
//  Created by Diki Dwi Diro on 25/09/22.
//

import SwiftUI
import LocalAuthentication
import Firebase

class LoginPageModel: ObservableObject {
    
    //User Properties
    @AppStorage("stored_Email") var storedEmail = ""
    
    @AppStorage("stored_Password") var storedPassword = ""
    
    @AppStorage("log_status") var log_status: Bool = false
    
    @Published var storeInfo:Bool = false
    
    //Login Properties
    @Published var fullName: String = ""
    @Published var email: String = ""
    @Published var password: String = ""
    @Published var address: String = "Kos Hj. Dayat No.13, RT.2/RW.6, Desa Simpangan, Cikarang Utara, Kabupaten Bekasi"
    @Published var showPassword: Bool = false
    
    //Alert Properties
    @Published var alert:Bool = false
    @Published var alertMsg:String = ""
    @Published var isSentResetPass: Bool = false
    
    //Register Properties
    @Published var registerUser: Bool = false
    @Published var re_Enter_Password: String = ""
    @Published var showReEnterPassword: Bool = false
    
    //Login Call
    func signIn(){
        Auth.auth().signIn(withEmail: email, password: password) { (res, err) in
            
            if let error = err{
                self.alertMsg = error.localizedDescription
                self.alert.toggle()
                return
            }
            
            // Success
            
            // Promoting User For Save data or not
            
            if self.storedEmail == "" || self.storedPassword == ""{
                self.storeInfo.toggle()
                return
            }
            
            // Else Goto Home...
            
            withAnimation{self.log_status = true}
        }
    }
    
    func signUp(){
        Auth.auth().createUser(withEmail: email, password: password) { (res, err) in
            
            if let error = err{
                self.alertMsg = error.localizedDescription
                self.alert.toggle()
                return
            }
            
            // Else Goto Home...
            
            withAnimation{self.log_status = true}
        }
    }
    
    func forgotPassword(){
        Auth.auth().sendPasswordReset(withEmail: email) { err in
            self.isSentResetPass.toggle()
        }
    }
    
    //Get Biometric types (FaceID or TouchID)
    func getBioMetricStatus() -> Bool {
        let scanner = LAContext()
        if email == storedEmail && scanner.canEvaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, error: .none){
            
            return true
        }
        
        return false
    }
    
    func authenticateUser(){
        let scanner = LAContext()
        scanner.evaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, localizedReason: "To Unlock \(email)") { status, err in
            if err != nil {
                print(err!.localizedDescription)
                return
            }
            
            // Settig User Password And Logging IN
            DispatchQueue.main.async {
                self.password = self.storedPassword
                self.signIn()
            }
            
        }
    }
}
