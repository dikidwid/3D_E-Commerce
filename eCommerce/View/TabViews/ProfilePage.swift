//
//  ProfilePage.swift
//  eCommerce
//
//  Created by Diki Dwi Diro on 13/10/22.
//

import SwiftUI

struct ProfilePage: View {
    var body: some View {
        VStack{
            Text("Profile")
                .font(.custom(customFont, size: 28).bold())
                .padding(.bottom, 20)
                .frame(maxWidth: .infinity, alignment: .leading)
            
            HStack {
                Image("profilePhoto")
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(width: 150, height: 150)
                
                VStack(alignment: .leading, spacing: 5){
                    Text("Diki Dwi Diro")
                        .fontWeight(.bold)
                        .font(.custom(customFont, size: 18))
                    
                    HStack {
                        Image(systemName: "star.square.fill")
                            .renderingMode(.template)
                            .foregroundColor(.yellow)
                        
                        Text("Gold merchant")
                            .font(.custom(customFont, size: 18))
                        .fontWeight(.bold)
                    }
                }

                
            }
            
            Spacer()
        }
        .padding()
    }
}

struct ProfilePage_Previews: PreviewProvider {
    static var previews: some View {
        ProfilePage()
    }
}
