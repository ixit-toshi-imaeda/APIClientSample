//
//  LoginInfo.swift
//  APIClientSample
//
//  Created by 今枝 稔晴 on 2019/09/24.
//  Copyright © 2019 iXIT Corporation. All rights reserved.
//

import Foundation
import ObjectMapper

/// ログインAPIのレスポンス
final class LoginInfo: Mappable {

    var userId = ""
    var refreshToken = ""
    var sessionToken = ""

    required init?(map: Map) {}

    func mapping(map: Map) {
        userId <- map["user_id"]
        refreshToken <- map["refresh_token"]
        sessionToken <- map["session_token"]
    }

    static func map<T:Mappable>(json:Any,type:T.Type)->T?{
        return Mapper<T>().map(JSONObject: json)
    }

    static func mapArray<T:Mappable>(json:Any,type:T.Type)->[T]?{
        return Mapper<T>().mapArray(JSONObject: json)
    }
}
