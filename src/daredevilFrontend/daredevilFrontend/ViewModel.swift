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

struct Done: Codable {
    let done: Bool
    
}

struct GoalsResponse: Codable {
    let goals: [Goal]
}

struct UserInput: Codable {
    let name: String
}

struct UncompletedGoals: Codable {
    let uncompletedGoals: [Goal]
}

class ViewModel: ObservableObject{
    @Published var goals: [Goal] = []
    @Published var randomGoalDisplay: Goal = Goal(id: 0, title: "", description:"", done: false) // need a default goal to replace later
    private var lastDisplayedDate: Date?
    @Published var uncompletedGoals : [Goal] = []
    @Published var uncompletedGoal: Goal?
    
    // MARK: - INIT function - save the time you first open the app in User Defaults
    init() {
        // if firstDate is not nil, set it to first opened time
        if UserDefaults.standard.value(forKey: "firstDate") == nil {
            UserDefaults.standard.set(Date(), forKey: "firstDate")
        }
    }
    // MARK: - GET API handler
    func fetchGoals(completion: @escaping () -> Void) {
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
                    
                    // Call the completion handler after fetching goals
                    completion()
                }
            }
            catch {
                print(error)
            }
        }
        task.resume()
    }
    
    // MARK: - GET API handler to retrieve uncompleted goals
    func fetchUncompletedGoals(completion: @escaping () -> Void) {
        guard let url = URL(string: "http://35.245.47.106/api/1/goals/uncompleted/")
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
                let response = try JSONDecoder().decode(UncompletedGoals.self, from: data)
                
                // UI update -- tasks in main thread so that app does not freeze
                DispatchQueue.main.async {
                    self?.uncompletedGoals = response.uncompletedGoals
                    
                    // Call the completion handler after fetching goals
                    completion()
                }
            }
            catch {
                print(error)
            }
        }
        task.resume()
    }
    
    // MARK: - Grab random goal from all goals. Could be nil.
    func fetchRandomGoal(completion: @escaping (Goal?) -> Void) {
        fetchGoals {
            DispatchQueue.main.async {
                let randomGoal = self.goals.randomElement()
                
                // Save the last generated goal description to UserDefaults
                if let randomGoalDescription = randomGoal?.description {
                    UserDefaults.standard.set(randomGoalDescription, forKey: "lastGeneratedGoal")
                }
                
                completion(randomGoal)
            }
        }
    }
    
    // MARK: - determine whether a day has passed since the last goal was generated
    func hasDayPassed() -> Bool {
        guard let lastGenerationDate = UserDefaults.standard.value(forKey: "lastGoalGenerationDate") as? Date else {
            // If there's no stored date, a day has definitely passed
            return true
        }
        print("last generation date: \(lastGenerationDate)")
        let currentDate = Date()
        print("current date: \(currentDate)")
        let calendar = Calendar.current
        let componentsDays = calendar.dateComponents([.day], from: lastGenerationDate, to: currentDate)
        let daysPassed = componentsDays.day ?? 0
        print("Days passed \(daysPassed)")
        return daysPassed > 0
        // MARK: - for testing purposes, use minutes to demonstrate a new goal is incrementally fetched
//        let componentsMinutes = calendar.dateComponents([.minute], from: lastGenerationDate, to: currentDate)
//        let minutesPassed = componentsMinutes.minute ?? 0
//        print("minutes passed \(minutesPassed)")
//        return minutesPassed > 0
    }
    
    // MARK: - mark goal as completed (POST)
    func markGoalComplete(done: Done){
        guard let url = URL(string: "http://35.245.47.106/api/goals/1/")
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
            request.httpBody = try encoder.encode(done)
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
                let response = try JSONDecoder().decode(Done.self, from: data)
                print("SUCCESS:  \(response)")
            }
            catch {
                print(error)
            }
        }
        task.resume()
        
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
    
    // MARK: - Create user/user login
    func createUser(userInput: UserInput, completion: @escaping () -> Void) {
        guard let url = URL(string: "http://35.245.47.106/api/users") else {
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
            request.httpBody = try encoder.encode(userInput)
        } catch {
            print(error)
            return
        }

        // 3. Make the request
        DispatchQueue.global(qos: .background).async {
            let task = URLSession.shared.dataTask(with: request) { data, _, error in
                // unwrap and make sure we have data and error is nil
                guard let data = data, error == nil else {
                    print("Invalid URL")
                    return
                }

                // convert data into JSON
                do {
                    let response = try JSONDecoder().decode(UserInput.self, from: data)
                    print("SUCCESS:  \(response)")

                    // Call the completion closure on the main thread
                    DispatchQueue.main.async {
                        completion()
                    }
                } catch {
                    print(error)
                }
            }

            task.resume()
        }
    }
}

