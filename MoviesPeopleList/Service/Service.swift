//
//  Service.swift
//  MoviesPeopleList
//
//  Created by Ibrahim Salah on 2/15/20.
//  Copyright © 2020 Ibrahim Salah. All rights reserved.
//

import Foundation
import Alamofire
import RxSwift

class Service {
    
    private lazy var sessionManager = SessionManager()
    
    // For handling all types of errors
    enum APIError: Error {
        case noResponse
        case jsonDecodingError(error: Error)
        case networkError(error: Error)
    }
    
    func getResponse<T:Codable>(request:URLRequestConvertible, debug:Bool = true) -> Observable<T> {
        return Observable.create { observer in
            let requestRef = self.sessionManager.request(request).validate().debugLog().responseJSON { response in
                if debug {
                    if let JSONString = String(data: response.data ?? Data(), encoding: String.Encoding.utf8){
                        print(JSONString)
                    }
                }
                switch response.result {
                case .success:
                    guard let data = response.data else {
                        observer.onError(APIError.noResponse)
                        return
                    }
                    let decodedData = self.decode(data: data, model: T.self)
                    if let decodedData = decodedData.model {
                        observer.onNext(decodedData)
                    } else {
                        if let error = decodedData.error {
                            observer.onError(error)
                        }
                    }
                case .failure(let error):
                    observer.onError(error)
                }
            }
            return Disposables.create {
                requestRef.cancel()
            }
        }
    }
    
    func decode<T:Decodable>(data:Data , model:T.Type) -> (model:T?, error:APIError?) {
        do {
            let data = try JSONDecoder().decode(model.self, from: data)
            return (data, nil)
        } catch {
            print("Failed to decode json:- ", error)
            return (nil, APIError.jsonDecodingError(error: error))
        }
    }
    
    // Cancel all perivous network requests
    func invalidateAllRequests() {
        sessionManager.session.getAllTasks { tasks in
            tasks.forEach({
                $0.cancel()
            })
            print(tasks)
        }
    }
    
}
