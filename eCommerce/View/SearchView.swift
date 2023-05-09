//
//  SearchView.swift
//  eCommerce
//
//  Created by Diki Dwi Diro on 01/12/22.
//

import SwiftUI

struct SearchView: View {
    var animation: Namespace.ID
    
    @EnvironmentObject var sharedData: SharedDataModel
    @EnvironmentObject var homeData: HomeViewModel
    @FocusState var startTF: Bool
    
    var body: some View {
        VStack{
            HStack(spacing: 20){
                Button {
                    withAnimation {
                        homeData.searchActivated = false
                    }
                    homeData.searchText = ""
                } label: {
                    Image(systemName: "arrow.left")
                        .font(.title2)
                        .foregroundColor(Color.black.opacity(0.7))
                }
                
                HStack(spacing: 15){
                    Image(systemName: "magnifyingglass")
                        .font(.title2)
                        .foregroundColor(.gray)
                    
                    TextField("Search", text: $homeData.searchText)
                        .focused($startTF)
                        .textCase(.lowercase)
                        .disableAutocorrection(true)
                }
                .padding(.vertical, 12)
                .padding(.horizontal)
                .background(
                    Capsule()
                        .strokeBorder(Color("Purple"), lineWidth: 1.5)
                )
                .matchedGeometryEffect(id: "SEARCHBAR", in: animation)
                .padding(.trailing, 20)
            }
            .padding([.horizontal, .top])
            .padding(.bottom, 10)
            
            if let products = homeData.searchedProducts {
                if products.isEmpty {
                    VStack(spacing: 10){
                        Image("NotFound")
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .padding(.top,60)
                        
                        Text("Item Not Found")
                            .font(.custom(customFont,size: 22).bold())
                        
                        Text("Try a more generic search term or try looking for alternative products.")
                            .font(.custom(customFont,size: 16))
                            .foregroundColor(.gray)
                            .multilineTextAlignment(.center)
                            .padding(.horizontal,30)
                    }
                    .padding()
                    
                } else {
                    ScrollView(.vertical, showsIndicators: false){
                        VStack(spacing: 0){
                            
                            Text("Found \(products.count) results")
                                .font(.custom(customFont, size: 24).bold())
                                .padding(.vertical)
                            
                            StaggeredGrid(columns: 2, spacing: 20, list: products) { product in
                                ProductCardView(product: product)
                            }
                            .padding()
                        }
                    }
                }
            } else {
                ProgressView()
                    .padding(.top, 30)
                    .opacity(homeData.searchText == "" ? 0 : 1)
            }
            
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .top)
        .background(
            Color("HomeBG")
                .ignoresSafeArea()
        )
        .onAppear{
            startTF = true
        }
    }
    
    @ViewBuilder
    func ProductCardView(product: Product)-> some View{
        
        VStack(spacing: 10) {
            ZStack{
                if sharedData.showDetailProduct{
                    Image(product.productImage)
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                    
                } else {
                    Image(product.productImage)
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .matchedGeometryEffect(id: "\(product.id)IMAGE", in: animation)
                }
            }
            //Moving image to top to look like its fixed at half top...
            .offset(y: -50)
            .padding(.bottom, -50)
            
            Text(product.title)
                .font(.custom(customFont, size: 18))
                .foregroundColor(Color.black)
                .fontWeight(.semibold)
                .padding(.top)
            
            Text(product.subtitle)
                .font(.custom(customFont, size: 14))
                .foregroundColor(Color.gray)
            
            Text(product.price)
                .font(.custom(customFont, size: 16))
                .foregroundColor(Color("Purple"))
                .fontWeight(.bold)
                .padding(.top, 5)
        }
        .padding(.horizontal, 20)
        .padding(.bottom, 20)
        .background(
                
            Color.white
                .cornerRadius(25)
        )
        .padding(.top, 50)
        //Showing detail product detail when tapped
        .onTapGesture {
            withAnimation(.easeInOut){
                sharedData.detailProduct = product
                sharedData.showDetailProduct = true
            }
        }
    }
}



struct SearchView_Previews: PreviewProvider {
    static var previews: some View {
        MainPage()
    }
}
