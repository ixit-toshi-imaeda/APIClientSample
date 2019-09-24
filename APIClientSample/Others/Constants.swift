//
//  Constants.swift
//  APIClientSample
//
//  Created by 今枝 稔晴 on 2019/09/23.
//  Copyright © 2019 iXIT Corporation. All rights reserved.
//

import Foundation

enum Constants {

    /// UserDefaults
    enum UserDefaultsKey {
        static let userId = "userId"
        static let sessionToken = "sessionToken"
        static let refreshToken = "refreshToken"
    }

    /// カスタムヘッダフィールド
    enum CustomHTTPHeaderFields {
        /// アプリケーションキー (required)
        static let appKey = "X-COIN-Application-Key"
        /// シグネチャ (required)
        static let signature = "X-COIN-Signature"
        /// タイムスタンプ (required)
        static let timeStamp = "X-COIN-Timestamp"
        /// セッショントークン
        static let sessionToken = "X-COIN-Session-Token"
        static let requestedAPI = "X-COIN-RequestedAPI"
    }
}
