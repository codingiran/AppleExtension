//
//  Data+.swift
//  AppleExtension
//
//  Created by iran.qiu on 2023/6/19.
//

import Foundation

public extension Data {
    var tunnelMsgStr: String? {
        let str = String(data: self, encoding: .utf8)
        return str
    }

    var tunnelMsgJSON: [String: Any]? {
        let json = try? JSONSerialization.jsonObject(with: self) as? [String: Any]
        return json
    }

    /// 将 msg 转为 Data 数据格式
    static func fromTunnelMsg(_ msg: Any?) -> Data? {
        guard let msg else { return nil }
        let data = dataWithMsg(msg)
        return data
    }

    private static func dataWithMsg(_ msg: Any) -> Data? {
        if let msgData = msg as? Data {
            return msgData
        }
        if let msgStr = msg as? String {
            return dataWithMsg(msgStr.data(using: .utf8) as Any)
        }
        if let jsonData = try? JSONSerialization.data(withJSONObject: msg, options: []) {
            return dataWithMsg(jsonData)
        }
        return nil
    }
}
