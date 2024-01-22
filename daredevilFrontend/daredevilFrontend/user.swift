//
//  user.swift
//  daredevilFrontend
//
//  Created by Belle Hu on 1/22/24.
//

import Foundation

struct User{
    let userId: Int
    let name: String
    let goalsList: [Goal]
}

var users = [
    User(userId: 0, name: "Belle", goalsList: goals),
    User(userId: 1, name: "Aileen", goalsList: [])
]
