//
//  ContentView.swift
//  daredevilFrontend
//
//  Created by Belle Hu on 1/22/24.
//

import SwiftUI

extension Color {
    static let figmaBeige = Color(red: 248 / 255, green: 238 / 255, blue: 229 / 255)
    static let figmaGreen = Color(red: 219 / 255, green: 222 / 255, blue: 209 / 255)
    static let figmaBrown = Color(red: 223 / 255, green: 207 / 255, blue: 196 / 255)
}


struct ContentView: View {
    var body: some View {
        
        NavigationView{
            VStack(spacing: 40){
                Text("Today, I dare you to ...")
                    .font(.largeTitle)
                    .fontWeight(.bold)
                    
                ZStack{
                    Text("Try a new food.")
                        .font(.largeTitle)
                        .fontWeight(.light)
                        .foregroundColor(Color.black)
                        .padding(EdgeInsets(top: 16, leading: 16, bottom: 16, trailing: 16))
                        .background(
                            RoundedRectangle(cornerRadius: 8)
                                .foregroundColor(.figmaBeige) // Set background color
                        )
                }
                HStack(spacing: 40){
                    Text("Goal completed:")
                        .font(.largeTitle)
                        .fontWeight(.medium)
                    RoundedRectangle(cornerRadius: 4)
                        .frame(width: 40, height: 40)
                        .foregroundColor(.figmaGreen)
                        .overlay(
                            RoundedRectangle(cornerRadius: 4)
                                .stroke(Color.black, lineWidth: 2) // border color + width
                        )
                }
                
                Spacer()
                navBar
                
            }
            .padding(.top, 100)
            .navigationTitle(Text("Today's Dare"))
            .navigationBarTitleDisplayMode(.inline)
        }
        
    }
    
    private var navBar : some View {
        HStack(spacing: 40){
            Spacer()
            Button {
                // TODO: do something here
                
            } label: {
                Image("gift")
                    .resizable()
                    .frame(width: 56, height: 56)
            }
            
            Spacer()
            Button {
                // TODO: do something here
            } label: {
                Image("addNew")
                    .resizable()
                    .frame(width: 56, height: 56)
            }
            Spacer()
            Button {
                // TODO: do something here
            } label: {
                Image("table")
                    .resizable()
                    .frame(width: 56, height: 56)
            }
            Spacer()
        }
        .padding(.top, 20) // Add padding above the buttons
        .background(Color.figmaGreen)
    }
}

#Preview {
    ContentView()
}