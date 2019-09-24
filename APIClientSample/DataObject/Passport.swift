//
//  Passport.swift
//  APIClientSample
//
//  Created by 今枝 稔晴 on 2019/09/23.
//  Copyright © 2019 iXIT Corporation. All rights reserved.
//

import Foundation
import ObjectMapper

class Passport {

    var passportId = ""
    var passportCode = ""
    var passportName = ""
    var useFlag = ""
    var aliasImagePath = ""
    var detailImagePath = ""
    var registImagePath = ""
    var unregistImagePath = ""
    var useCount = ""
    var remainCount = ""
    var totalCount = ""
    var description = ""
    var fromDatetime = ""
    var toDatetime = ""
    var fromUseTime = ""
    var toUseTime = ""
    var useDay = ""
    var spanId = ""
    var authMethod = ""
    var authCodeCoupons = ""

    func mapping(map: Map) {
        passportId <- map["coupon_id"]
        passportCode <- map["coupon_code"]
        passportName <- map["coupon_name"]
        useFlag <- map["use_flag"]
        aliasImagePath <- map["alias_image_path"]
        detailImagePath <- map["detail_image_path"]
        registImagePath <- map["regist_image_path"]
        unregistImagePath <- map["unregist_image_path"]
        useCount <- map["use_count"]
        remainCount <- map["remain_count"]
        totalCount <- map["total_count"]
        description <- map["description"]
        fromDatetime <- map["from_datetime"]
        toDatetime <- map["to_datetime"]
        fromUseTime <- map["from_use_time"]
        toUseTime <- map["to_use_time"]
        useDay <- map["use_day"]
        spanId <- map["span_id"]
        authMethod <- map["auth_method"]
        authCodeCoupons <- map["auth_code_coupons"]
    }
}
