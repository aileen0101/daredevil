//
//  AllGoalsView.swift
//  daredevilFrontend
//
//  Created by Belle Hu on 1/22/24.
//

import SwiftUI

struct AllGoalsView: View {
    var body: some View {
        VStack{
            VStack{
                List(goals, id: \.self) {
                    goal in GoalInfoRow(goal)
                    
                    
                }
                
            }
            
            HorizontalBar
        }
        .padding(.top, 10)
        .navigationTitle(Text("All Dares"))
}

private func GoalInfoRow(_ goal: Goal) -> some View {
    
    ZStack {
        let color = determineColor(goal)
        let imageGoal = determineImage(goal)
        Rectangle()
            .foregroundStyle(color)
        HStack{
            Image(imageGoal)
                .resizable()
                .frame(width: 55, height: 55)
                .padding(.trailing, 100)
                .offset(x: 12)
            VStack(alignment: .leading){
                Text(goal.title)
                    .fontWeight(.bold)
                    .font(.system(size: 21))
                Text(goal.description)
                    .font(.system(size: 21))
            }
            .font(.title)
            .fontWeight(.light)
            
            .offset(x: -10)
            Spacer()
        }
    }
}

    private func determineColor(_ goal: Goal) -> Color {
        var color : Color
        if goal.done == true{
            color = Color.figmaGreen
        }else{
            color = Color.figmaBeige
        }
        return color
    }
    private func determineImage(_ goal: Goal) -> String {
        var image: String
        if goal.done == true{
            image = "done"
        }else{
            image = "notDone"
        }
        return image
    }
    
private var HorizontalBar: some View {
    handleIcons
  }

private var handleIcons: some View {
    NavigationStack {
        
    HStack(spacing: 70) {
    
    NavigationLink {
        ContentView()
    } label: {
        backIcon
    }
    NavigationLink {
        NewGoalView()
    } label: {
    addIcon
    }
    
    }
    .foregroundColor(.figmaGreen)
    .padding(.top, 20)
    

}

}
private var backIcon: some View {
       Image("backButton")
       .resizable()
       .frame(width: 57, height: 57)
 }

private var addIcon: some View {
       Image("addNew")
        .resizable()
        .frame(width: 57, height: 57)
}

}
#Preview {
    AllGoalsView()
}
