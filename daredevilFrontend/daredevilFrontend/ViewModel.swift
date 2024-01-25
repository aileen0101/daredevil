//
//  ViewModel.swift
//  daredevilFrontend
//
//  Created by Belle Hu on 1/24/24.
//

import Foundation

struct NewGoalResponse: Codable {
    let title: String
    let description: String
    let done: Bool
}

struct GoalsResponse: Codable {
    let goals: [Goal]
}

class ViewModel: ObservableObject{
    @Published var goals: [Goal] = []
    @Published var randomGoalDisplay: Goal = Goal(id: 0, title: "", description:"", done: false) // need a default goal to replace later
    private var lastDisplayedDate: Date?
    
    // MARK: - INIT function - save the time you first open the app in User Defaults
    init() {
        // if firstDate is not nil, set it to first opened time
        if UserDefaults.standard.value(forKey: "firstDate") == nil {
            UserDefaults.standard.set(Date(), forKey: "firstDate")
        }
    }
    // MARK: - GET API handler
    func fetchGoals(){
        guard let url = URL(string: "http://35.245.47.106/api/users/1/goal/all/")
        else{
            return
        }
        // use weak self so that no memory leak
        let task = URLSession.shared.dataTask(with: url){[weak self] data, _, error in
            // Validate that we didn't get an error
            guard let data = data, error == nil else{
                print("Invalid URL")
                return
            }
        
            do {
                let response = try JSONDecoder().decode(GoalsResponse.self, from: data)
                
                // UI update -- tasks in main thread so that app does not freeze
                DispatchQueue.main.async {
                    self?.goals = response.goals
                }
            }
            catch {
                print(error)
            }
        }
        task.resume()
    }
    
    // MARK: - Grab random goal from all goals. Could be nil.
//    func fetchRandomGoal() -> Goal? {
//        fetchGoals()
//        let randomGoal = goals.randomElement()
//        // Save the last generated goal to UserDefaults
//        if let randomGoalDescription = randomGoal?.description {
//            UserDefaults.standard.set(randomGoalDescription, forKey: "lastGeneratedGoal")
//        }
//        return randomGoal
//        
//    }
    func fetchRandomGoal(completion: @escaping (Goal?) -> Void) {
        fetchGoals()
        let randomGoal = goals.randomElement()
        // Save the last generated goal to UserDefaults
        if let randomGoalDescription = randomGoal?.description {
            UserDefaults.standard.set(randomGoalDescription, forKey: "lastGeneratedGoal")
        }
        completion(randomGoal)
    }
    
    // MARK: - determine whether a day has passed since the last goal was generated
    func hasDayPassed() -> Bool {
        guard let lastGenerationDate = UserDefaults.standard.value(forKey: "lastGoalGenerationDate") as? Date else {
            // If there's no stored date, a day has definitely passed
            print("I am inside the guard let")
            return true
        }
        print("last generation date: \(lastGenerationDate)")
        let currentDate = Date()
        print("current date: \(currentDate)")
        let calendar = Calendar.current
//        let components = calendar.dateComponents([.day], from: lastGenerationDate, to: currentDate)
//        let daysPassed = components.day ?? 0
//        print("days passed \(daysPassed)")
//        return daysPassed > 0
        let componentsMinutes = calendar.dateComponents([.minute], from: lastGenerationDate, to: currentDate)
        let minutesPassed = componentsMinutes.minute ?? 0
        print("minutes passed \(minutesPassed)")
        return minutesPassed > 0
    }
    
    // MARK: - POST API handler
    func makePostRequest(newGoalBody: NewGoalResponse){
        guard let url = URL(string: "http://35.245.47.106/api/users/1/goal/")
        else{
            return
        }
        // 1. Create a URL request
        var request = URLRequest(url: url)
        
        // 2. set the method, body, and headers the endpoint requires
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        do {
            let encoder = JSONEncoder()
            encoder.keyEncodingStrategy = .convertToSnakeCase
            request.httpBody = try encoder.encode(newGoalBody)
        } catch {
            print(error)
            return
        }
        
        // 3. Make the request
        let task = URLSession.shared.dataTask(with: request){data, _, error in
            // unwrap and make sure we have data and error is nil
            guard let data = data, error == nil else{
                print("Invalid URL")
                return
            }
            
            // convert data into JSON
            do {
                let response = try JSONDecoder().decode(NewGoalResponse.self, from: data)
                print("SUCCESS:  \(response)")
            }
            catch {
                print(error)
            }
        }
        task.resume()
        
    }
}

