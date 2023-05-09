//
//  ContentView.swift
//  eCommerce
//
//  Created by Diki Dwi Diro on 25/09/22.
//

import SwiftUI

struct ContentView: View {
    @StateObject var loginData:LoginPageModel = LoginPageModel()
    var body: some View {
        Group {
            if loginData.log_status {
                MainPage()
            } else {
                OnBoardingPage()
            }
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
