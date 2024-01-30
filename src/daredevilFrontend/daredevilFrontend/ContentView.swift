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
    @StateObject var viewModel = ViewModel()
    @State private var username = ""
    @State private var wrongUsername = 0
    @State private var userIsLoggedIn = false
    @State private var email = ""
    @State private var password = ""
    
    // MARK: - Main view
    var body: some View {
        content
    }
    
    private var content: some View{
        NavigationView {
            ZStack {
                Color.figmaBrown
                    .ignoresSafeArea()
                Circle()
                    .scale(1.7)
                    .foregroundColor(.white.opacity(0.40))
                Circle()
                    .scale(1.35)
                    .foregroundColor(.white)
                VStack{
                    Text("Daredevil")
                        .font(.largeTitle)
                        .italic()
                        .padding()
                    Text("Login")
                        .font(.largeTitle)
                        .bold()
                        .padding()
                    TextField("Username", text: $username)
                        .autocapitalization(.none)  // Disable autocapitalization
                        .padding()
                        .frame(width: 300, height: 50)
                        .background(Color.black.opacity(0.05))
                        .cornerRadius(10)
                        // Border that appears if user picks wrong username
                        .border(.red, width: CGFloat(wrongUsername))
                    TextField("Email", text: $email)
                        .autocapitalization(.none)  // Disable autocapitalization
                        .padding()
                        .frame(width: 300, height: 50)
                        .background(Color.black.opacity(0.05))
                        .cornerRadius(10)
                    SecureField("Password", text: $password)
                        .autocapitalization(.none)  // Disable autocapitalization
                        .padding()
                        .frame(width: 300, height: 50)
                        .background(Color.black.opacity(0.05))
                        .cornerRadius(10)
                    loginButton
                    NavigationLink(
                        destination: NewGoalView(),
                        isActive: $userIsLoggedIn
                    ) {
                        EmptyView()
                    }
                }
            }
        }
        .navigationBarHidden(true)
    }
    
    private var loginButton: some View {
        Button("Login"){
            let userInputObj = UserInput(name: self.username)
            
            // Create a dispatch group
            let dispatchGroup = DispatchGroup()

            // Enter the dispatch group before making the POST request
            dispatchGroup.enter()
            viewModel.createUser(userInput: userInputObj) {
                // Leave the dispatch group when done creating user
                dispatchGroup.leave()
                
               
            }

            // Finish user creation before navigating to NewGoalView
            dispatchGroup.notify(queue: .main) {
                // Now, navigate to NewGoalView by setting showingLoginScreen to false
                self.userIsLoggedIn = true
            }
        }
        .foregroundColor(.white)
        .frame(width: 300, height: 50)
        .background(Color.brown)
        .cornerRadius(10)
    }

}

#Preview {
    ContentView()
}
