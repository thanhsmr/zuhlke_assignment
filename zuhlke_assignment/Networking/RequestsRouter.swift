//
//  RequestsRouter.swift
//  zuhlke_assignment
//

//

import Foundation
import Alamofire

enum RequestsRouter {
    case breed
    case dog(breed: String)
    var baseURL: String {
        switch self {
        case .breed, .dog:
            return "https://dog.ceo/api/"
        }
    }
    var path: String {
        switch self {
        case .breed:
            return "breeds/list/all"
        case .dog(let breed):
            return String(format: "breed/%@/images", breed)
        }
    }
    var method: HTTPMethod {
        switch self {
        case .breed:
            return .get
        case .dog:
            return .get
        }
    }
    var parameters: [String: String]? {
        switch self {
        case .breed:
            return nil
        case .dog:
            return nil
        }
    }
}

extension RequestsRouter: URLRequestConvertible {
  func asURLRequest() throws -> URLRequest {
    let url = try baseURL.asURL().appendingPathComponent(path)
    var request = URLRequest(url: url)
    request.method = method
    if method == .get {
      request = try URLEncodedFormParameterEncoder()
        .encode(parameters, into: request)
    } else if method == .post {
      request = try JSONParameterEncoder().encode(parameters, into: request)
    }
    return request
  }
}
