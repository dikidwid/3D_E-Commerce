//
//  LoginPage.swift
//  eCommerce
//
//  Created by Diki Dwi Diro on 25/09/22.
//

import SwiftUI
import LocalAuthentication

struct LoginPage: View {
    @StateObject var loginData: LoginPageModel = LoginPageModel()
    @AppStorage("stored_Email") var storedEmail = ""
    @AppStorage("stored_Password") var storedPassword = ""
    @AppStorage("log_status") var log_status: Bool = false
    
    var body: some View {
        
        VStack{
            //Welcome back text for 3 half of the screen...
            Text("Welcome\nBack")
                .font(.custom(customFont, size: 40).bold())
                .foregroundColor(.white)
                .frame(maxWidth: .infinity, alignment: .leading)
                .frame(height: getRect().height / 3.5)
                .padding()
                .background(
                    ZStack {
                        //Gradient Circle
                        LinearGradient(colors: [
                            
                            Color("LoginCircle"),
                            Color("LoginCircle")
                                .opacity(0.8),
                            Color("Purple")
                        ], startPoint: .top, endPoint: .bottom)
                        .frame(width:  100, height: 100)
                        .clipShape(Circle())
                        .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .topTrailing)
                        .padding(.trailing)
                        .offset(y: -25)
                        .ignoresSafeArea()
                        
                        Circle()
                            .strokeBorder(Color.white.opacity(0.3), lineWidth: 3)
                            .frame(width: 30, height: 30)
                            .blur(radius: 3)
                            .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .bottomLeading)
                            .padding(.leading, 230)
                        
                        Circle()
                            .strokeBorder(Color.white.opacity(0.3), lineWidth: 3)
                            .frame(width: 23, height: 23)
                            .blur(radius: 2)
                            .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .topLeading )
                            .padding(.leading, 30)
                        
                        Image("LoginVector")
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .frame(maxWidth: .infinity, alignment: .bottomTrailing)
                            .padding(.trailing, 15)
                            .padding(.top, 70)
                        
                        Text(loginData.registerUser ? "Register to continue" : "Log in now to continue")
                            .font(.custom(customFont, size: 16))
                            .fontWeight(.semibold)
                            .foregroundColor(.white.opacity(0.7))
                            .frame(maxWidth: .infinity, alignment: .bottomLeading)
                            .padding()
                            .padding(.top, 150)
                    }
                )
            
            ScrollView(.vertical, showsIndicators: false) {
                
                //Login Page Form...
                VStack(spacing: 15){
                    Text(loginData.registerUser ? "Register" : "Login")
                        .font(.custom(customFont, size: 22).bold())
                        .foregroundColor(Color.black)
                        .frame(maxWidth: .infinity, alignment: .leading)
                    
                    //Custom Text Field...
                    if loginData.registerUser{
                        CustomTextField(icon: "person", title: "Full Name", hint:" Diki Dwi Diro", value: $loginData.fullName, showPassword: .constant(false))
                            .padding(.top, 10)
                    }
                    
                    CustomTextField(icon: "envelope", title: "Email", hint:" dikidwid@gmail.com", value: $loginData.email, showPassword: .constant(false))
                        .padding(.top, 10)
                    
                    CustomTextField(icon: "lock", title: "Password", hint:" Dikidwid0123*", value: $loginData.password, showPassword: $loginData.showPassword)
                        .padding(.top, 10)
                    
                    //Register Re-enter Password
                    if loginData.registerUser{
                        CustomTextField(icon: "lock", title: "Re-Enter Password", hint:" Dikidwid0123*", value: $loginData.re_Enter_Password, showPassword: $loginData.showReEnterPassword)
                            .padding(.top, 10)
                    }
                    
                    //Forgot Password Button...
                    if !loginData.registerUser && loginData.email != "" {
                        Button {
                            loginData.forgotPassword()
                        } label: {
                            Text("Forgot Password")
                                .font(.custom(customFont, size: 14))
                                .fontWeight(.semibold)
                                .foregroundColor(Color("Purple"))
                        }
                        .alert("Check your email to reset the password", isPresented: $loginData.isSentResetPass) {
                                    Button("OK", role: .cancel) { }
                            
                        }
                        .padding(.top, 8)
                        .frame(maxWidth: .infinity, alignment: .leading)
                    }
                    
                    //Login Button...
                    Button {
                        if loginData.registerUser{
                            loginData.signUp()
                        } else {
                            loginData.signIn()
                        }
                    } label: {
                        HStack {
                            Text(loginData.registerUser ? "Create" : "Login")
                                .font(.custom(customFont, size: 17).bold())
                                .padding(.vertical, 20)
                                .frame(maxWidth: .infinity)
                                .foregroundColor(.white)
                                .background(Color("Purple"))
                                .cornerRadius(20)
                                .shadow(color: .black.opacity(0.7), radius: 5, x: 5, y: 5)
                            
                            if !loginData.registerUser {
                                if loginData.getBioMetricStatus(){
                                    Button {
                                        loginData.authenticateUser()
                                    } label: {
                                        Image(systemName: LAContext().biometryType == .faceID ? "faceid" : "touchid")
                                            .font(.title)
                                            .padding()
                                            .foregroundColor(.white)
                                            .background(Color("Purple"))
                                            .clipShape(Circle())
                                            .shadow(color: .black.opacity(0.7), radius: 5, x: 5, y: 5)
                                    }

                                }
                            }
                        }
                    }
                    .padding(.top, 8)
                    .padding(.horizontal)
                    .alert(isPresented: $loginData.alert, content: {
                        Alert(title: Text("Error"), message: Text(loginData.alertMsg), dismissButton: .destructive(Text("Ok")))
                    })
                    
                    //Register User Button...
                    Button {
                        withAnimation{loginData.registerUser.toggle()
                        }
                    } label: {
                        Text(loginData.registerUser ? "Back to login" : "Create account")
                            .font(.custom(customFont, size: 14))
                            .fontWeight(.semibold)
                            .foregroundColor(Color("Purple"))
                    }
                    .alert(isPresented: $loginData.storeInfo, content: {
                        Alert(title: Text("Message"), message: Text("Store Information For Future Login Using BioMetric Authentication ?"), primaryButton: .default(Text("Accept"), action: {
                            
                            // storing Info For BioMetric
                            storedEmail = loginData.email
                            storedPassword = loginData.password
                            
                            withAnimation{self.log_status = true}
                            
                        }), secondaryButton: .cancel({
                            // redirecting to Home
                            withAnimation{self.log_status = true}
                        }))
                    })
                    .padding(.top, 8)
                }
                .padding(30)
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .background(
                Color.white
                //Applying custom corners
                    .clipShape(CustomCorners(corners: [.topLeft, .topRight], radius: 25))
                    .ignoresSafeArea()

            )
        }
        .frame(
            maxWidth: .infinity, maxHeight: .infinity)
        .background(Color("Purple"))
        
        //Clear Data When Changes
        .onChange(of: loginData.registerUser) { newValue in
            loginData.email = ""
            loginData.password = ""
            loginData.re_Enter_Password = ""
            loginData.showPassword = false
            loginData.showReEnterPassword = false
        }
    }
    
    @ViewBuilder
    func CustomTextField(icon: String, title: String, hint: String, value: Binding<String>, showPassword: Binding<Bool> )-> some View{
        
        VStack(alignment: .leading, spacing: 12){
            
            Label{
                Text(title)
                    .font(.custom(customFont, size: 14))
            } icon: {
                 Image(systemName: icon)
            }
            .foregroundColor(Color.black.opacity(0.8 ))
            
            if title.contains("Password") && !showPassword.wrappedValue{
                SecureField(hint, text: value)
                    .font(.custom(customFont, size: 14))
                    .autocapitalization(.none)
                    .foregroundColor(Color.black)
                    .padding(2)
                    
            } else {
                TextField(hint, text: value)
                    .font(.custom(customFont, size: 14))
                    .autocapitalization(.none)
                    .foregroundColor(Color.black)
                    .padding(2)
                    .autocorrectionDisabled()
            }
            
            Divider()
                .background(Color.black.opacity(0.4))
        }
        .overlay(
            
            Group{
                if title.contains("Password"){
                    Button(action: {
                        showPassword.wrappedValue.toggle()
                    }, label: {
                        Text(showPassword.wrappedValue ? "Hide" : "Show")
                            .font(.custom(customFont, size: 13).bold())
                            .foregroundColor(Color("Purple"))
                    })
                    .offset(y: 8)
                }
            }
            
            ,alignment: .trailing
        )
    }
}

struct LoginPage_Previews: PreviewProvider {
    static var previews: some View {
        LoginPage()
            .previewDevice("iPhone 13 mini")
        LoginPage()
            .previewDevice("iPhone 8")
    }
}
