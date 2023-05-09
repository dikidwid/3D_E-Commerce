//
//  CartPage.swift
//  eCommerce
//
//  Created by Diki Dwi Diro on 09/10/22.
//

import SwiftUI
import SPAlert

struct CartPage: View {
    @EnvironmentObject var sharedData: SharedDataModel
    @EnvironmentObject var loginData: LoginPageModel

    //Delete option
    @State var showDeleteOption: Bool = false
    
    //Purchase alert
    @State var isPurchased: Bool = false
    
    var body: some View {
        NavigationView {
            VStack(spacing: 10){
                ScrollView(.vertical, showsIndicators: false) {
                    VStack{
                        HStack{
                            Text("Shopping Cart")
                                .font(.custom(customFont, size: 28).bold())
                            
                            Spacer()
                            
                            Button {
                                showDeleteOption.toggle()
                            } label: {
                                Image("Delete")
                                    .resizable()
                                    .aspectRatio(contentMode: .fit)
                                    .frame(width: 25, height: 25)
                            }
                            .opacity(sharedData.cartProducts.isEmpty ? 0 : 1)

                        }
                        //Checking if cart  products is empty
                        if sharedData.cartProducts.isEmpty {
                            Group {
                                Image("NoBasket")
                                    .resizable()
                                    .aspectRatio(contentMode: .fit)
                                    .padding()
                                    .padding(.top, 50)
                                
                                Text("No items added")
                                    .font(.custom(customFont, size: 25))
                                    .fontWeight(.semibold)
                                
                                Text("Hit the \"Add to Cart Button\" on each product page to save into this shopping cart.")
                                    .font(.custom(customFont, size: 18))
                                    .foregroundColor(Color.gray)
                                    .padding(.horizontal)
                                    .padding(.top, 10)
                                    .multilineTextAlignment(.center)
                            }
                        } else {
                            //Displaying product
                            VStack(spacing: 15){
                                //for designing
                                ForEach($sharedData.cartProducts ){ $product in
                                    HStack(spacing: 0){
                                        if showDeleteOption {
                                            Button {
                                                deleteProduct(product: product)
                                            } label: {
                                                Image(systemName: "minus.circle.fill")
                                                    .font(.title2)
                                                    .foregroundColor(Color.red)
                                            }
                                            .padding(.trailing)
                                        }
                                        CartView( product: $product)
                                    }
                                }
                                
                                HStack{
                                    Label{
                                        Text("Shipping")
                                            .font(.custom(customFont, size: 16))
                                            .fontWeight(.bold)
        
                                    } icon: {
                                         Image(systemName: "box.truck")
                                    }
                                    .foregroundColor(Color.black)
                                    
                                    Spacer()
                                    
                                    Picker("Shipping Option", selection: $sharedData.selectedShipper) {
                                        ForEach(Shipping.allCases, id: \.self) { shipper in
                                            Text(verbatim: "\(shipper.rawValue)")
                                                .tag(shipper.rawValue)
                                        
                                        }
                                    }
                                }
                                .foregroundColor(.white)
                                .padding(.horizontal, 10)
                                .padding(.vertical, 10)
                                .frame(maxWidth: .infinity, maxHeight: .infinity)
                                .background(Color.white.cornerRadius(10))
                                
                                HStack{
                                    Label{
                                        Text("Address")
                                            .font(.custom(customFont, size: 16))
                                            .fontWeight(.bold)
                                    } icon: {
                                         Image(systemName: "house")
                                    }
                                    .foregroundColor(Color.black)
                                    
                                    Spacer()
                                    
                                    TextEditor(text: $loginData.address)
                                        .font(.custom(customFont, size: 14))
                                        .frame(width: getRect().width/2.5, height: 100)
                                        .overlay(RoundedRectangle(cornerRadius: 14).stroke(.gray.opacity(0.2), lineWidth: 1))
                                        .foregroundColor(.black)
                                        .autocorrectionDisabled()
                                        .autocapitalization(.none)
                                }
                                .foregroundColor(.white)
                                .padding(.horizontal, 10)
                                .padding(.vertical, 10)
                                .frame(maxWidth: .infinity, maxHeight: .infinity)
                                .background(Color.white.cornerRadius(10))
                                
                                HStack{
                                    Label{
                                        Text("Voucher")
                                            .font(.custom(customFont, size: 16))
                                            .fontWeight(.bold)
                                    } icon: {
                                         Image(systemName: "dollarsign.arrow.circlepath")
                                    }
                                    .foregroundColor(Color.black)
                                    .padding(.vertical, 10)
                                    
                                    TextField(" ", text:$sharedData.discText)
                                        .textFieldStyle(RoundedBorderTextFieldStyle())
                                        .font(.custom(customFont, size: 14))
                                        .foregroundColor(Color("Purple"))
                                        .padding(.leading, 30)
                                        .autocorrectionDisabled()
                                        .autocapitalization(.allCharacters)
                                }
                                .foregroundColor(.white)
                                .padding(.horizontal, 10)
                                .padding(.vertical, 10)
                                .frame(maxHeight: .infinity)
                                .background(Color.white.cornerRadius(10))
                                
                                VStack(alignment: .leading){
                                    Label{
                                        Text("Payment Details")
                                            .font(.custom(customFont, size: 16))
                                            .fontWeight(.bold)
                                    } icon: {
                                         Image(systemName: "creditcard")
                                    }
                                    .foregroundColor(Color.black)
                                    .padding(.vertical, 10)
                                    
                                    HStack{
                                        Text("Shipping")
                                            .foregroundColor(Color.black)
                                            .font(.custom(customFont, size: 14))
                                            .fontWeight(.semibold)
                                        
                                        Spacer()
                                        
                                        Text(sharedData.getShippingPrice())
                                            .font(.custom(customFont, size: 13).bold())
                                            .foregroundColor(Color("Purple"))
                                    }
                                    .padding(.vertical, 5)
                                    
                                    HStack{
                                        Text("Subtotal")
                                            .foregroundColor(Color.black)
                                            .font(.custom(customFont, size: 14))
                                            .fontWeight(.semibold)
                                        
                                        Spacer()
                                        
                                        Text(sharedData.getSubtotalPrice())
                                            .font(.custom(customFont, size: 14).bold())
                                            .foregroundColor(Color("Purple"))
                                    }
                                    .padding(.vertical, 5)
                                    
                                    if sharedData.discText == sharedData.discCode {
                                        HStack{
                                            Text("Discount")
                                                .foregroundColor(Color.black)
                                                .font(.custom(customFont, size: 14))
                                                .fontWeight(.semibold)
                                            
                                            Spacer()
                                            
                                            Text("- $\(sharedData.discPrice)")
                                                .font(.custom(customFont, size: 14).bold())
                                                .foregroundColor(Color("Purple"))
                                        }
                                        .padding(.vertical, 5)
                                    }
                                    
                                    Divider()
                                        .background(Color.black.opacity(0.4))
                                    
                                    HStack{
                                        Label{
                                            Text("Total")
                                                .font(.custom(customFont, size: 18))
                                                .fontWeight(.bold)
                                        } icon: {
                                             Image(systemName: "dollarsign")
                                        }
                                        .foregroundColor(Color.black)
                                        .padding(.vertical, 10)
                                        
                                        Spacer()
                                        
                                        if sharedData.discText == sharedData.discCode {
                                            Text(sharedData.getTotalPrice())
                                                .font(.custom(customFont, size: 14).bold())
                                                .foregroundColor(Color("Purple"))
                                        } else {
                                            Text(sharedData.getTotalPrice())
                                                .font(.custom(customFont, size: 14).bold())
                                                .foregroundColor(Color("Purple"))
                                        }
                                    }
                                    .frame(height: 40)
                                }
                                .foregroundColor(.white)
                                .padding(.horizontal, 10)
                                .frame(maxHeight: .infinity)
                                .background(Color.white.cornerRadius(10))
                                
                                Button {
                                    isPurchased = true
                                    DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) {
                                        sharedData.cartProducts.removeAll()
                                    }
                                }
                                label: {
                                    Text("Checkout")
                                        .font(.custom(customFont, size: 18).bold())
                                        .foregroundColor(.white)
                                        .padding(.vertical, 18)
                                        .frame(maxWidth: .infinity)
                                        .background(Color("Purple"))
                                        .cornerRadius(15)
                                        .shadow(color: Color.black.opacity(0.5), radius: 5, x: 5, y: 5)
                                }
                                .SPAlert(
                                    isPresent: $isPurchased,
                                    title: "Success Purchased",
                                    message: "Shipping process takes 5-10 working days",
                                    duration: 2.0,
                                    dismissOnTap: true,
                                    preset: .done,
                                    haptic: .success,
                                    layout: .init(),
                                    completion: {
                                        print("Success")
                                    }
                                )
                            }
                            .padding(.top, 25)
                            .padding(.horizontal)
                        }
                    }
                    .padding()
                }
            }
            .navigationBarHidden(true)
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .background(
                Color("HomeBG")
                    .ignoresSafeArea()
            )
        }
    }
    
    func deleteProduct(product: Product) {
        if let index = sharedData.cartProducts.firstIndex(where: { currentProduct in
            return product.id == currentProduct.id
        }) {
            
            let _ = withAnimation {
                //removing
                sharedData.cartProducts.remove(at: index)
            }
        }
    }
}

struct CartPage_Previews: PreviewProvider {
    static var previews: some View {
        CartPage()
            .environmentObject(SharedDataModel())
            .environmentObject(LoginPageModel())
    }
}

struct CartView: View {
    
    @Binding var product: Product
    
    var body: some View{
        HStack(spacing: 15){
            Image(product.productImage)
                .resizable()
                .aspectRatio(contentMode: .fit)
                .frame(width: 100, height: 100)
            
            VStack(alignment: .leading, spacing: 8) {
                Text(product.title)
                    .font(.custom(customFont, size: 14).bold())
                    .lineLimit(1)
                
                Text(product.subtitle)
                    .font(.custom(customFont, size: 12))
                    .fontWeight(.semibold)
                    .foregroundColor(Color.gray)
                
                Text(product.price)
                    .font(.custom(customFont, size: 17))
                    .fontWeight(.semibold)
                    .foregroundColor(Color("Purple"))
                
                //Quantity button
                HStack(spacing: 10){
                    Text("Quantity: ")
                        .font(.custom(customFont, size: 12))
                        .foregroundColor(Color.gray)
                    
                    Button {
                        product.quantity = (product.quantity > 0 ? (product.quantity - 1) : 0 )
                    } label: {
                        Image(systemName: "minus")
                            .font(.caption)
                            .foregroundColor(Color.white)
                            .frame(width: 20, height: 20)
                            .background(
                                Color("Quantity")
                            )
                            .cornerRadius(4)
                    }
                    
                    Text("\(product.quantity)")
                        .font(.custom(customFont, size: 14))
                        .fontWeight(.semibold)
                        .foregroundColor(Color.black)
                    
                    Button {
                        product.quantity += 1
                    } label: {
                        Image(systemName: "plus")
                            .font(.caption)
                            .foregroundColor(Color.white)
                            .frame(width: 20, height: 20)
                            .background(
                                Color("Quantity")
                            )
                            .cornerRadius(4)
                    }
                }
            }
        }
        .padding(.horizontal, 10)
        .padding(.vertical, 20)
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(
            Color.white
                .cornerRadius(10)
        )
    }
}

