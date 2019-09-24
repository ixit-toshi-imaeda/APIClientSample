//
//  CustomHTTPHeadersBuilder.swift
//  APIClientSample
//
//  Created by 今枝 稔晴 on 2019/09/23.
//  Copyright © 2019 iXIT Corporation. All rights reserved.
//

import Alamofire

/// HTTPヘッダ情報生成クラス
final class CustomHTTPHeadersBuilder {

    // アプリケーションキー
    static let appKey = "30E21ADD16F0EEB3CE71A65F496D604DD938C8CF6D9C87E07C177FF875C2724C"

    /// シグネチャ生成
    static func createSignature(httpMethod: HTTPMethod,
                                fqdn: String,
                                apiPath: String,
                                timeStamp: String) -> String {

        let signatureMethod = "HmacSHA256"
        var signature = ""

        // リクエストメソッド
        signature += "\(httpMethod.rawValue)\n"
        // FQDN
        signature += "\(fqdn)\n"
        // APIパス
        signature += "\(apiPath)\n"
        // アプリケーションキー・シグネチャメソッド・タイムスタンプを「&」で連結
        signature += "\(appKey)"
        signature += "&\(signatureMethod)"
        signature += "&\(timeStamp)"

        print("---HmacSHA256エンコード・Base64エンコードする前の文字列---")
        print("\(signature)")
        let encodedStr = signature.hmacSHA256(key: appKey)
        print("---HmacSHA256エンコード・Base64エンコード後の文字列---")
        print("\(encodedStr)")
        print("------")

        return signature.hmacSHA256(key: appKey)
    }

    /// タイムスタンプ生成
    static func createTimeStamp(date: Date) -> String {
        let df = DateFormatter()
        df.dateFormat = "yyyy/MM/dd HH:mm"
        return df.string(from: date)
    }

    /// UserDefaultsに保存されているセッショントークンを取得
    ///
    /// - Parameter ifNeeded: セッショントークンの指定が必要か (default: true)
    /// - Returns: セッショントークン
    static func sessionToken(ifNeeded: Bool = true) -> String? {
        guard ifNeeded else {
            return nil
        }
        return UserDefaults.standard.string(forKey: Constants.UserDefaultsKey.sessionToken)
    }
}
