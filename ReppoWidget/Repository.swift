//
//  Repository.swift
//  ReppoWidget
//
//  Created by Juan Hernandez Pazos on 24/06/24.
//

import Foundation

struct Repository {
    let name: String
    let owner: Owner
    let hasIssues: Bool
    let forks: Int
    let watchers: Int
    let openIssues: Int
    let pushedAt: String
    var avatarData: Data
    
    // quitar en el paso 33
//    static let placeHolder = Repository(
//        name: "Mi repositorio",
//        owner: Owner(avatarUrl: ""),
//        hasIssues: true,
//        forks: 75,
//        watchers: 145,
//        openIssues: 5,
//        pushedAt: "2023-06-24T18:19:30Z",
//        avatarData: Data()
//    )
}

// 28
extension Repository {
    struct CodingData: Decodable {
        let name: String
        let owner: Owner
        let hasIssues: Bool
        let forks: Int
        let watchers: Int
        let openIssues: Int
        let pushedAt: String
        
        var repo: Repository {
            Repository(
                name: name,
                owner: owner,
                hasIssues: hasIssues,
                forks: forks,
                watchers: watchers,
                openIssues: openIssues,
                pushedAt: pushedAt,
                avatarData: Data()
            )
        }
    }
}

struct Owner: Decodable {
    let avatarUrl: String
}
