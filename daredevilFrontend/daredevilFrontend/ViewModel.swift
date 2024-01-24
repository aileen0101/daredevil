//
//  ViewModel.swift
//  daredevilFrontend
//
//  Created by Belle Hu on 1/24/24.
//

import Foundation

struct GoalsResponse: Codable {
    let goals: [Goal]
}

class ViewModel: ObservableObject{
    @Published var goals: [Goal] = []
    
    func fetch(){
        guard let url = URL(string: "http://35.245.47.106/api/users/1/goal/all/")
        else{
            return
        }
        // use weak self so that no memory leak
        let task = URLSession.shared.dataTask(with: url){[weak self] data, _, error in
            // Validate that we didn't get an error
            guard let data = data, error == nil else{
                return
            }
        
            do {
                let response = try JSONDecoder().decode(GoalsResponse.self, from: data)
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
}
