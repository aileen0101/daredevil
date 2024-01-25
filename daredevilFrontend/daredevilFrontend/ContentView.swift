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
    // MARK: - Properties
    @State private var completed : Bool = false
    @StateObject var viewModel = ViewModel()
    @State private var goalText: String = ""
    
    // MARK: - Main view
    var body: some View {
        NavigationStack{
            homeFeed
        }
        
    }
    
    private var homeFeed: some View {
        NavigationView{
            VStack(spacing: 40){
                Text("Today, I dare you to . . .")
                    .font(.largeTitle)
                    .fontWeight(.light)
                    
                ZStack{
                    goalTextDisplay
                }
                HStack(spacing: 40){
                    Text("Dare completed:")
                        .font(.largeTitle)
                        .fontWeight(.thin)
                    completeToggleButton
                }
                
                Spacer()
                navBar
                
            }
            .padding(.top, 100)
            .navigationTitle(Text("Today's Dare"))
            .navigationBarTitleDisplayMode(.inline)
        }
    }
//    private func determineGoalText() -> String {
//        if viewModel.hasDayPassed() {
//            // Generate a new goal
//            print("A")
//            let randomGoal = viewModel.fetchRandomGoal()?.description ?? "You have no dares. Please enter goals in the New Goals page."
//                    
//            // Save the current date to UserDefaults
//            UserDefaults.standard.set(Date(), forKey: "lastGoalGenerationDate")
//                    
//            return randomGoal
//        } else {
//            print("B")
//            // Use the existing goal or a default message
//            return UserDefaults.standard.string(forKey: "lastGeneratedGoal") ?? "No goal generated yet."
//        }
//    }
    private func determineGoalText(completion: @escaping (String) -> Void) {
        if viewModel.hasDayPassed() {
            viewModel.fetchRandomGoal { randomGoal in
                // Handle the fetched result and update UI
                DispatchQueue.main.async {
                    if let randomGoal = randomGoal {
                        // Generate a new goal
                        let randomGoalDescription = randomGoal.description
                        UserDefaults.standard.set(randomGoalDescription, forKey: "lastGeneratedGoal")
                        self.goalText = randomGoalDescription
                        completion(randomGoalDescription)
                    } else {
                        // Handle the case when no goal is fetched
                        let defaultMessage = "No goal fetched"
                        self.goalText = defaultMessage
                        completion(defaultMessage)
                    }
                }
            }
        } else {
            // Use the existing goal or a default message
            let savedGoal = UserDefaults.standard.string(forKey: "lastGeneratedGoal") ?? "No goal generated yet."
            completion(savedGoal)
        }
    }
    
    private var goalTextDisplay : some View {
        Text("Placeholder goal")
        .font(.largeTitle)
        .fontWeight(.light)
        .foregroundColor(Color.black)
        .padding(EdgeInsets(top: 16, leading: 16, bottom: 16, trailing: 16))
        .background(RoundedRectangle(cornerRadius: 8)
            .foregroundColor(.figmaBeige) // Set background color
        )
    }
    
    private var incompleteButton : some View {
        RoundedRectangle(cornerRadius: 4)
            .frame(width: 40, height: 40)
            .foregroundColor(.figmaGreen)
            .overlay(
                RoundedRectangle(cornerRadius: 4)
                    .stroke(Color.black, lineWidth: 2) // border color + width
            )
    }
    
    private var completeToggleButton : some View {
        Button {
            completed.toggle()
        } label: {
            if completed == true {
                Image("done")
                    .resizable()
                    .frame(width: 42, height: 42)
                //somehow update the backend!
            } else {
                incompleteButton
            }
        }
    }
    
    private var navBar : some View {
        HStack(spacing: 40){
            Spacer()
            giftButton
            Spacer()
            NavigationLink(destination: NewGoalView()) {
                addNewButton
            }
            Spacer()
            NavigationLink(destination: AllGoalsView()) {
                seeTableButton
            }
            Spacer()
        }
        .padding(.top, 20) // Add padding above the buttons
        .background(Color.figmaGreen)
    }
    private var giftButton: some View {
        Image("gift")
            .resizable()
            .frame(width: 56, height: 56)
    }
    private var addNewButton: some View {
        Image("addNew")
            .resizable()
            .frame(width: 56, height: 56)
    }
    
    private var seeTableButton: some View {
        Image("table")
            .resizable()
            .frame(width: 56, height: 56)
    }
}

#Preview {
    ContentView()
}
