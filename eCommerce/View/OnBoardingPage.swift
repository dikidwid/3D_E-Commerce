//
//  OnBoardingPage.swift
//  eCommerce
//
//  Created by Diki Dwi Diro on 25/09/22.
//

import SwiftUI

//To Use the custom font on all pages
let customFont = "Raleway-Regular"

struct OnBoardingPage: View {
    //Showing Login Page
    @State var showLoginPage: Bool = false
    var body: some View {
        
        VStack(){
            
            Image("OnBoard")
                .resizable()
                .aspectRatio(contentMode: .fit)
            
            Text("Find your Gadget")
                .font(.custom(customFont, size: 30))
            //Since we added all three fonts in Info.plist
            //We can call all those fonts with any names
                .fontWeight(.bold)
                .foregroundColor(.white)
                .multilineTextAlignment(.center)
            
            Text("We provide all the latest and most popular gadget products from various types and various brands for a better life.")
                .font(.custom(customFont, size: 15))
                .fontWeight(.semibold)
                .foregroundColor(.white.opacity(0.7))
                .multilineTextAlignment(.center)
                .padding()
            
            Button {
                withAnimation {
                    showLoginPage = true
                }
            } label: {
                Text("Get Started")
                    .font(.custom(customFont, size: 18))
                    .fontWeight(.semibold)
                    .padding(.vertical, 18)
                    .frame(maxWidth: .infinity)
                    .background(Color.white)
                    .cornerRadius(10)
                    .shadow(color: Color.black.opacity(0.1), radius: 5, x: 5, y: 5)
                    .foregroundColor(Color("Purple"))
            }
            .padding(.horizontal, 30)
            //Adding some adjustments only for larger devices
            .offset(y: getRect().height < 750 ? 20 : 40)
            
            Spacer()
        }
        .padding()
        .padding(.top, getRect().height < 750 ? 0 : 20)
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(
            
            Color("Purple")
        )
        .overlay(
            Group{
                if showLoginPage{
                    LoginPage()
                        .transition(.move(edge: .bottom))
                }
            }
        )
    }
}

struct OnBoardingPage_Previews: PreviewProvider {
    static var previews: some View {
        OnBoardingPage()
            .previewDevice("iPhone 13 mini")
        
        OnBoardingPage()
            .previewDevice("iPhone 8")
    }
}

// Extending View Classes to get the screen bounds
extension View{
    func getRect()->CGRect {
        return UIScreen.main.bounds
    }
}
