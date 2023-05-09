//
//  MoreProductsView.swift
//  eCommerce
//
//  Created by Diki Dwi Diro on 09/10/22.
//

import SwiftUI

struct MoreProductsView: View {
    var body: some View {
        VStack{
            Text("More Products")
                .font(.custom(customFont, size: 24).bold())
                .foregroundColor(Color.black)
                .frame(maxWidth: .infinity, alignment: .leading)
        }
        .padding()
        .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .topLeading)
        .background(
            Color("HomeBG")
                .ignoresSafeArea()
        )
        
    }
}

struct MoreProductsView_Previews: PreviewProvider {
    static var previews: some View {
        MoreProductsView()
    }
}
