//
//  goal.swift
//  daredevilFrontend
//
//  Created by Belle Hu on 1/22/24.
//

import Foundation

struct Goal: Hashable, Codable {
    let id: Int
    let title: String
    let description: String
    let done: Bool
}

var dummyGoals = [
    Goal(id: 1, title:"Health", description: "Sleep 8 hours", done: false),
    Goal(id: 1, title:"School", description: "Attend lecture", done: false),
    Goal(id: 1, title:"Health", description: "Go skiing", done: false),
    Goal(id: 1, title:"Nutrition", description: "Try a new fruit", done: false),
    Goal(id: 1, title:"Social", description: "Join a dance club", done: false),
    Goal(id: 1, title:"Health", description: "Walk 5 miles", done: false),
    Goal(id: 1, title:"Fun", description: "Go hiking at Cascadilla Gorge", done: false),
    Goal(id: 1, title:"Health", description: "Drink 70 oz water", done: false),
    Goal(id: 1, title:"Social", description: "Watch the Boy and the Heron", done: true)
]
