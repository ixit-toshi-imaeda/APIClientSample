//
//  String+.swift
//  APIClientSample
//
//  Created by 今枝 稔晴 on 2019/09/23.
//  Copyright © 2019 iXIT Corporation. All rights reserved.
//

import Foundation

extension String {

    /// HMAC-SHA256でエンコードして、Base64でエンコードする
    ///
    /// - Parameters:
    ///   - algorithm: 暗号化アルゴリズム
    ///   - key: 暗号化キー
    /// - Returns: HMAC-SHA256でエンコードし、Base64でエンコードした文字列
    func hmacSHA256(key: String) -> String {
        let cKey = key.cString(using: String.Encoding.utf8)
        let cData = self.cString(using: String.Encoding.utf8)

        // SHA256以外にする場合は、CC_SHA256_DIGEST_LENGTHとkCCHmacAlgSHA256を修正
        let digestLength = Int(CC_SHA256_DIGEST_LENGTH)
        let toCCHmacAlgorithm = CCHmacAlgorithm(kCCHmacAlgSHA256)

        var result = [CUnsignedChar](repeating: 0, count: digestLength)
        CCHmac(toCCHmacAlgorithm,
               cKey!,
               Int(strlen(cKey!)),
               cData!,
               Int(strlen(cData!)),
               &result)
        let hmacData = Data(bytes: result, count: digestLength)
        let hmacBase64 = hmacData.base64EncodedString(options: .lineLength76Characters)
        return String(hmacBase64)
    }
}
