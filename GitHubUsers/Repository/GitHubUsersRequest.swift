//
//  GitHubUsersRequest.swift
//  GitHubUsers
//
//  Created by Shigenari Oshio on 2023/12/01.
//

import APIKit
import Foundation

final class GitHubUsersRequest: Request {
    typealias Response = [User]

    let baseURL: URL = .init(string: "https://api.github.com")!
    let path: String = "/users"
    let method: HTTPMethod = .get

    var queryParameters: [String: Any]? { _queryParameters }
    private var _queryParameters: [String: Any]? = nil
    // RequestプロトコルのqueryParametersがgetオンリーのためセッターを実装
    func setQuery(since: Int, perPage: Int) {
        _queryParameters = [
            "since": since,
            "per_page": perPage,
        ]
    }

    let dataParser: DataParser = GitHubUsersDataParser()
    // Decodableにパースする独自のDataParser
    private class GitHubUsersDataParser: DataParser {
        var contentType: String? = "application/json"

        func parse(data: Data) throws -> Any {
            try JSONDecoder().decode(Response.self, from: data)
        }
    }

    func response(from object: Any, urlResponse _: HTTPURLResponse) throws -> Response {
        guard let result = object as? Response else {
            throw ResponseError.unexpectedObject(object)
        }
        return result
    }
}
