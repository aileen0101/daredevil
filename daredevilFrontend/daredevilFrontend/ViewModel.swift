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
        
//        let body : [String: AnyHashable] = [
//            "title": "Social",
//            "description": "Go try a new restaurant in downtown Ithaca",
//            "done": false
//        ]
        
        
        do {
            let encoder = JSONEncoder()
            encoder.keyEncodingStrategy = .convertToSnakeCase
            request.httpBody = try encoder.encode(newGoalBody)
        } catch {
            print(error)
            return
        }
        // use JSON serialization to get data from an object. Conversion of JSON might fail
//        request.httpBody = try? JSONSerialization.data(withJSONObject: body, options: .fragmentsAllowed)
        
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
//                let response = try JSONSerialization.jsonObject(with: data, options: .fragmentsAllowed)
                print("SUCCESS:  \(response)")
            }
            catch {
                print(error)
            }
        }
        task.resume()
        
    }
}

