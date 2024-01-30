//
//  user.swift
//  daredevilFrontend
//
//  Created by Belle Hu on 1/22/24.
//

import Foundation

struct User{
    let id: Int
    let name: String
    let goals: [Goal]
}

var users = [
    User(id: 0, name: "Belle", goals: dummyGoals),
    User(id: 1, name: "Aileen", goals: [])
]
