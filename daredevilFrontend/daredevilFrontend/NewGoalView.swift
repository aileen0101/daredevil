//
//  NewGoalView.swift
//  daredevilFrontend
//
//  Created by Belle Hu on 1/22/24.
//

import SwiftUI



struct NewGoalView: View {
    // MARK: - Properties
    @StateObject var viewModel = ViewModel()
    
    // MARK: - Data
    @State private var newDareTitle : String = ""
    @State private var newDareDescription : String = ""
    var body: some View {
        NavigationStack{
            newGoalFeed
        }
    }
    
    private var newGoalFeed: some View {
        NavigationView{
            VStack(spacing: 120){
                mainBody
                navBar
            }
//            .navigationTitle(Text("New Dares"))
//            .navigationBarTitleDisplayMode(.inline)
        }
        .navigationBarHidden(true)
    }
    
    private var mainBody: some View{
        VStack(spacing: 120){
            VStack{
                titleTextBundle
                descriptionTextBundle
            }
            addGoalButton
        }
        
    }
    
    private var titleTextBundle: some View {
        VStack{
            HStack{
                Spacer()
                Text("Title:")
                    .font(.largeTitle)
                    .fontWeight(.light)
                Spacer()
                Spacer()
                Spacer()
                Spacer()
                Spacer()
                Spacer()
                Spacer()
                Spacer()
                Spacer()
                Spacer()
                
            }
               
            TextField("Enter title . . .", text: $newDareTitle)
                .autocapitalization(.none)  // Disable autocapitalization
                .padding()
                .frame(width: 350, height: 50)
                .background(Color.black.opacity(0.05))
                .cornerRadius(10)

        }
    }
    
    private var descriptionTextBundle: some View {
        VStack{
            HStack{
                Spacer()
                Text("Description:")
                    .font(.largeTitle)
                    .fontWeight(.light)
                Spacer()
                Spacer()
                Spacer()
                Spacer()
                Spacer()
                Spacer()
                
            }
            TextField("Enter description . . .", text: $newDareDescription)
                .autocapitalization(.none)  // Disable autocapitalization
                .padding()
                .frame(width: 350, height: 150)
                .background(Color.black.opacity(0.05))
                .cornerRadius(10)

        }
    }
    
    private var navBar : some View {
        HStack(spacing: 40){
            Spacer()
            NavigationLink(destination: DailyGoalView()) {
                giftButtonLayout
            }
            Spacer()
            NavigationLink(destination: AllGoalsView()) {
                seeTableButton
            }
            Spacer()
        }
        .padding(.top, 20) // Add padding above the buttons
        .padding(.bottom, 40)
        .background(Color.figmaGreen)
    }
    
    private var giftButton: some View {
        Button {
            // TODO: - Update nav link
        } label: {
            giftButtonLayout
        }
    }

    
    private var giftButtonLayout: some View {
        Image("gift")
            .resizable()
            .frame(width: 56, height: 56)
    }
    
    private var seeTableButton: some View {
        Image("table")
            .resizable()
            .frame(width: 56, height: 56)
    }
    
    private var addGoalButton : some View {
        Button {
            let newGoalBody = NewGoalResponse(title: newDareTitle, description: newDareDescription, done: false)
            viewModel.makePostRequest(newGoalBody: newGoalBody)
            newDareTitle = ""
            newDareDescription = ""
        } label:{
            addGoalLayout
        }
    }
    
    private var addGoalLayout: some View {
        ZStack{
            HStack(spacing: 77) {
                Image("pointer")
                    .resizable()
                    .frame(width: 56, height: 56)
                Text("Add Goal")
                    .font(.largeTitle)
                    .fontWeight(.light)
                    .foregroundColor(Color.black)
            }
            .padding(EdgeInsets(top: 16, leading: 30, bottom: 16, trailing: 30))
            .background(
                RoundedRectangle(cornerRadius: 8)
                    .foregroundColor(.figmaGreen) // Set background color
            )
            
        }
    }
    
    
    private var backToMainViewButton: some View {
        Image("arrow")
            .resizable()
            .frame(width: 56, height: 56)
    }
}

#Preview {
    NewGoalView()
}
