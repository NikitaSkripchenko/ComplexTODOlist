//
//  AuthModel.swift
//  Stepik
//
//  Created by Nikita Skrypchenko  on 8/11/19.
//  Copyright © 2019 iosdev. All rights reserved.
//

import Foundation

struct AccessToken:Decodable {
    let access_token: String
    let scope: String
    let token_type: String
}
