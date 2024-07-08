//
//  MockData.swift
//  ReppoWidget
//
//  Created by Juan Hernandez Pazos on 08/07/24.
//

import Foundation

struct MockData {
    static let repoOne = Repository(name: "Repository 1",
                                    owner: Owner(avatarUrl: ""),
                                    hasIssues: true,
                                    forks: 75,
                                    watchers: 145,
                                    openIssues: 5,
                                    pushedAt: "2023-06-24T18:19:30Z",
                                    avatarData: Data()
    )
    
    static let repoTwo = Repository(name: "Repository 2",
                                    owner: Owner(avatarUrl: ""),
                                    hasIssues: false,
                                    forks: 15,
                                    watchers: 1545,
                                    openIssues: 33,
                                    pushedAt: "2024-05-12T10:43:30Z",
                                    avatarData: Data()
    )
}
