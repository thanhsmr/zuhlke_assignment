//
//  NetworkingManager.swift
//  zuhlke_assignment
//

//

import Foundation
import Alamofire

class NetworkingManger {
    static let shared = NetworkingManger()
    /// af session attach the cached requests, interceptor and event logger to any request we do it
    let afSession: Session = {
        let configuration = URLSessionConfiguration.af.default
        configuration.requestCachePolicy = .returnCacheDataElseLoad
        let responseCacher = ResponseCacher(behavior: .modify { _, response in
            let userInfo = ["date": Date()]
            return CachedURLResponse(
                response: response.response,
                data: response.data,
                userInfo: userInfo,
                storagePolicy: .allowed)
        })
        let eventsMonitor = EventsMonitor()
        let RequestsInterceptor = RequestsInterceptor()
        return Session(
            configuration: configuration,
            interceptor: RequestsInterceptor,
            cachedResponseHandler: responseCacher,
            eventMonitors: [eventsMonitor])
    }()
    //MARK: - Main Function
    /// generic function take a model and router to perfrom a networking request
    func performRequest<T: Decodable>(model: T.Type, requestRouter: URLRequestConvertible, completion: @escaping (Result<T, Error>) -> Void) {
        self.afSession.request(requestRouter)
            .validate(statusCode: 200...300)
            .responseDecodable(of: T.self, completionHandler: { response in
                switch response.result {
                case .success(_):
                    guard let value = response.value else {return}
                    completion(.success(value))
                case .failure(let error):
                    completion(.failure(error))
                }
            })
    }
}
