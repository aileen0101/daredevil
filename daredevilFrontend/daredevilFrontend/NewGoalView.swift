//
//  NewGoalView.swift
//  daredevilFrontend
//
//  Created by Belle Hu on 1/22/24.
//

import SwiftUI



struct NewGoalView: View {
    
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
            .navigationTitle(Text("New Dares"))
            .navigationBarTitleDisplayMode(.inline)
        }
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
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .padding(EdgeInsets(top: 16, leading: 30, bottom: 16, trailing: 30))

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
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .padding(EdgeInsets(top: 16, leading: 30, bottom: 32, trailing: 30))

        }
    }
    
    private var navBar : some View {
        HStack{
            Spacer()
            NavigationLink(destination: ContentView()){
                backToMainViewButton
            }
            Spacer()
        }
        .padding(.top, 30) // Add padding above the button
        .padding(.bottom,40)
        .background(Color.figmaGreen)
    }
    
    private var addGoalButton : some View {
        Button {
            let newGoal = Goal(id:1, title: newDareTitle, description: newDareDescription, done: false)
            dummyGoals.append(newGoal)
            
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
