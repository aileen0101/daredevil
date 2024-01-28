//
//  DailyGoalView.swift
//  daredevilFrontend
//
//  Created by Belle Hu on 1/26/24.
//

import SwiftUI

struct DailyGoalView: View {
    // MARK: - Properties
    @State private var completed : Bool = false
    @State private var giveGoal : Bool = false
    @StateObject var viewModel = ViewModel()
    @State private var goalText: String = ""
    @State private var username = ""
    @State private var wrongUsername = 0
    @State private var showingLoginScreen = false
    
    // MARK: - Main view
    var body: some View {
        NavigationStack{
            homeFeed
        }
        .onAppear {
                    determineGoalText { fetchedGoalText in
                        goalText = fetchedGoalText
                    }
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
//            .navigationTitle(Text("Today's Dare"))
//            .navigationBarTitleDisplayMode(.inline)
            .navigationBarHidden(true)
        }
    }

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
        Text(self.goalText)
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
            let isDoneObj = Done(done: self.completed)
            print("Completed? \(self.completed)")
            viewModel.markGoalComplete(done: isDoneObj)
        } label: {
            if completed{
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
        Button {
            giveGoal.toggle()
            if giveGoal {
                viewModel.fetchUncompletedGoals {
                    if let firstUncompletedGoal = viewModel.uncompletedGoals.first(where: { !$0.done }) {
                        viewModel.uncompletedGoal = firstUncompletedGoal

                        // Update goalText
                        self.goalText = firstUncompletedGoal.description
                    }
                }
            } else {
                print("Error fetching a new goal")
            }
        } label: {
            giftButtonLayout
        }
    }

    
    private var giftButtonLayout: some View {
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
    DailyGoalView()
}
