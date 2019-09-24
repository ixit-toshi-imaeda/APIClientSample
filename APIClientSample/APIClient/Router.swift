//
//  Router.swift
//  APIClientSample
//
//  Created by 今枝 稔晴 on 2019/09/19.
//  Copyright © 2019 iXIT Corporation. All rights reserved.
//

import Foundation
import Alamofire

enum Router: URLRequestConvertible {

    static let fqdn = "coin.dev.ixit.jp"
    static let baseURLString = "https://\(fqdn)"

    case login(parameters: [String: Any])
    case getPassports(parameters: [String: Any])

    /// セッショントークンを必要とするか（ログイン後にしか使用を許可しないか）
    var needSessionToken: Bool {
        switch self {
        case .login:
            return true
        case .getPassports:
            return true
        }
    }

    var method: Alamofire.HTTPMethod {
        switch self {
        case .login:
            return .post
        case .getPassports:
            return .get
        }
    }

    var path: String {
        let prefix = "/Core/api"
        switch self {
        case .login:
            return prefix + "/login"
        case .getPassports:
            return prefix + "/coupon_lists"
        }
    }

    /// API名取得
    var apiName: String {
        switch self {
        case .login:
            return "login"
        case .getPassports:
            return "passportLists"
        }
    }

    func asURLRequest() throws -> URLRequest {
        let url = URL(string: Router.baseURLString)!
        var urlRequest = URLRequest(url: url.appendingPathComponent(path))
        urlRequest.httpMethod = method.rawValue

        // -----------------------------
        // Custom Header Fields
        // -----------------------------
        // アプリケーションキー (required)
        urlRequest.setValue(CustomHTTPHeadersBuilder.appKey, forHTTPHeaderField: Constants.CustomHTTPHeaderFields.appKey)

        // タイムスタンプ (required)
        let now = Date()
        let timeStamp = CustomHTTPHeadersBuilder.createTimeStamp(date: now)
        urlRequest.setValue(timeStamp, forHTTPHeaderField: Constants.CustomHTTPHeaderFields.timeStamp)

        // シグネチャ (required)
        let signature = CustomHTTPHeadersBuilder.createSignature(httpMethod: method, fqdn: Router.fqdn, apiPath: path, timeStamp: timeStamp)
        urlRequest.setValue(signature, forHTTPHeaderField: Constants.CustomHTTPHeaderFields.signature)

        // セッショントークン
        if let sessionToken = CustomHTTPHeadersBuilder.sessionToken(ifNeeded: self.needSessionToken) {
            urlRequest.setValue(sessionToken, forHTTPHeaderField: Constants.CustomHTTPHeaderFields.sessionToken)
        }
        // リクエストAPI
        urlRequest.setValue(self.apiName, forHTTPHeaderField: Constants.CustomHTTPHeaderFields.requestedAPI)

        switch self {
        case .login(let parameters):
            return try encoder.encode(urlRequest, with: parameters)
        case .getPassports(let parameters):
            return try encoder.encode(urlRequest, with: parameters)
        }
    }

    fileprivate var encoder: ParameterEncoding {
        switch self.method {
        case .get:
            return  Alamofire.URLEncoding.default
        default:
            return  Alamofire.JSONEncoding.default
        }
    }
}

/// MARK: - デバッグ用
fileprivate extension Router {

    func debugLog(request: URLRequest) {

        print("-----URLRequest-----")
        if let allHTTPHeaderFields = request.allHTTPHeaderFields {
            allHTTPHeaderFields.forEach {
                print("HTTPHeaderFields: [\($0) : \($1)]")
            }
        } else {
            print("allHTTPHeaderFields are nil.")
        }
        self.debugInBrief(request: request)
        print("----------")
    }

    func debugInBrief(request: URLRequest){
        if let url = request.url?.absoluteString{
            print("URL:\(url)")
        }else {
            print("URL is nil.")
        }
        guard let data = request.httpBody else{
            print("HTTPBody is nil.")
            return
        }
        if let httpBody = String(data: data, encoding: .utf8){
            print("HTTPBody: \(httpBody)")
        }else {
            print("HTTPBody is nil.")
        }
    }
}
