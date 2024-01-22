//
//  goal.swift
//  daredevilFrontend
//
//  Created by Belle Hu on 1/22/24.
//

import Foundation

struct Goal{
    let title: String
    let description: String
    let done: Bool
    let userId: Int
}

var goals = [
    Goal(title:"Health", description: "Sleep 8 hours", done: false, userId: 0),
    Goal(title:"School", description: "Attend lecture", done: false, userId: 0),
    Goal(title:"Health", description: "Go skiing", done: false, userId: 0),
    Goal(title:"Nutrition", description: "Try a new fruit", done: false, userId: 0),
    Goal(title:"Social", description: "Join a dance club", done: false, userId: 0),
    Goal(title:"Health", description: "Walk 5 miles", done: false, userId: 0),
    Goal(title:"Fun", description: "Go hiking at Cascadilla Gorge", done: false, userId: 0),
    Goal(title:"Health", description: "Drink 70 oz water", done: false, userId: 0),
    Goal(title:"Social", description: "Watch the Boy and the Heron", done: true, userId: 0)
]
