//
//  NetMacro.swift
//  full_lease_landlord
//
//  Created by apple on 2020/12/31.
//  Copyright © 2020 apple. All rights reserved.
//

import Foundation

enum SeverApiEnum: Int {
    case Production
    case Test1
    case Test2
}


let Server: SeverApiEnum = .Test1

let SelectServerApi:(SeverApiEnum)->SeverApiEnum = {
//    if FastTool.isDebug() {
        return $0
//    } else {
//        return .Production
//    }
}

class NetMacro: NSObject {
    @objc class func getServerApi(url: String) -> String {
        if url.hasPrefix("http") {
            return url
        }
        switch SelectServerApi(Server) {
        case .Production:
            return DevelopTool.selectProductServerApi(url) + url
        case .Test1:
            return "http://101.132.154.194/" + url
        case .Test2:
            return "https://sit.girders.cn/" + url
        }
    }
}





