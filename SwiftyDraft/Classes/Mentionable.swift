//
//  Mentionable.swift
//  Pods-SwiftyDraftExample
//
//  Created by YAMAMOTOHIROKI on 2018/05/17.
//

import Foundation

public protocol SwiftyDraftMentionable {
    var id: String { get }
    var userName: String { get }
    var name: String { get }
    var email: String { get }
    var avatarURL: String { get }
}

extension SwiftyDraftMentionable {
    func toDict() -> Dictionary<String, String> {
        return [
            "id": id,
            "userName": userName,
            "name": name,
            "email": email,
            "avatarURL": avatarURL
        ]
    }
}
