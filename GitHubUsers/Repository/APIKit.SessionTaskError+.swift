//
//  APIKit.SessionTaskError+.swift
//  GitHubUsers
//
//  Created by Shigenari Oshio on 2023/12/02.
//

import APIKit

extension SessionTaskError: LocalizedError {
    public var errorDescription: String? {
        switch self {
        case .connectionError:
            return "接続をご確認ください。"
        case .requestError:
            return "リクエストに失敗しました。"
        case .responseError:
            return "データが取得できませんでした。"
        }
    }
}
