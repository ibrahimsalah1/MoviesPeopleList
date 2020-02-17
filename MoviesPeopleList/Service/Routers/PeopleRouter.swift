//
//  PeopularPeopleRouter.swift
//  MoviesPeopleList
//
//  Created by Ibrahim Salah on 2/15/20.
//  Copyright © 2020 Ibrahim Salah. All rights reserved.
//


import Alamofire
enum PeopleRouter: URLRequestConvertible {
    case getPopularPeople(page:Int)
    case getPersonImages(id:Int)
    case searchPeople(query:String, page:Int)
    
    var method: HTTPMethod {
        return .get
    }
    
    var url: URL {
        let relativePath : String?
        switch self {
        case .getPopularPeople:
            relativePath = Constants.popularPeople
        case .getPersonImages(let id):
            relativePath = Constants.person + "/\(id)/images"
        case .searchPeople:
            relativePath = Constants.search
        }
        var url = URL(string: Constants.baseURL)!
        if let relativePath = relativePath {
            url = url.appendingPathComponent(relativePath)
        }
        return url
    }
    
    var parameters: [String: Any]? {
        switch self {
        case .getPopularPeople(let page):
            return ["page":page]
        case .searchPeople(let query, let page):
            return ["query":query, "page":page]
        default:
            return nil
        }
    }
    
    var encoding: ParameterEncoding {
        return URLEncoding.default
    }
    
    func asURLRequest() throws -> URLRequest {
        var components = URLComponents(url: url, resolvingAgainstBaseURL: true)!
        // Adding Api key and language as default parameters for all requests
        components.queryItems = [
            URLQueryItem(name: "api_key", value: Constants.APIKey),
            URLQueryItem(name: "language", value: Locale.preferredLanguages[0])
        ]
        var urlRequest = URLRequest(url: components.url!)
        urlRequest.httpMethod = method.rawValue
        return try encoding.encode(urlRequest, with: parameters)
    }
}
