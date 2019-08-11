//
//  GistModel.swift
//  Stepik
//
//  Created by Nikita Skrypchenko  on 8/11/19.
//  Copyright © 2019 iosdev. All rights reserved.
//

import Foundation

struct GistRequest: Codable {
    let description: String
    let `public`: Bool
    let files: [String: GistFileInfo]
    
}
struct GistFileInfo: Codable {
    let filename: String
    let content: String?
    
    init(content: String,
         name: String) {
        self.content = content
        self.filename = name
    }
}

struct GistResponse: Codable {
    let files: [String: GistFile]
    let id: String
    let url: String
}

struct GistFile: Codable {
    let filename: String
    let rawUrl: String
    
    enum CodingKeys: String, CodingKey {
        case filename
        case rawUrl = "raw_url"
    }
}

class GistApi {
    static let apiUrl = "https://api.github.com/gists"
    static let gistFileName = "ios-course-notes-db"
    static var apiKey = ""
    static var gistID = ""
    static var raw_url = ""
}
