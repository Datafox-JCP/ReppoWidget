//
//  Repository.swift
//  ReppoWidget
//
//  Created by Juan Hernandez Pazos on 24/06/24.
//

import Foundation

struct Repository: Decodable {
    let name: String
    let owner: Owner
    let hasIssues: Bool
    let forks: Int
    let watchers: Int
    let openIssues: Int
    let pushedAt: String
    
    static let placeHolder = Repository(
        name: "Mi repositorio",
        owner: Owner(avatarUrl: ""),
        hasIssues: true,
        forks: 75,
        watchers: 145,
        openIssues: 5,
        pushedAt: "2024-06-24T18:19:30Z"
    )
}

struct Owner: Decodable {
    let avatarUrl: String
}
