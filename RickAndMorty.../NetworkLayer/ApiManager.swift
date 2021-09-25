//
//  ApiManager.swift
//  RickAndMorty...
//
//  Created by Андрей on 23.06.2021.
//

import Foundation

// MARK: - Models

typealias JSONTask = URLSessionDataTask
typealias JSONCompletionHandler = ([String : Any]?, HTTPURLResponse?, Error?) -> Void

public let NetworkingErrorDomain = "NetworkingErrorDomain"
public let MissingHTTPResponseError = 100
public let UnexpectedResponseError  = 101

enum APIResult<T> {
    case success(T)
    case failure(Error)
}

enum ForecastType: FinalURLPoint {
    
    case characters
    
    var baseURL: URL {
        return URL(string: "https://rickandmortyapi.com/api/")!
    }
    
    var path: String {
        switch self {
        case .characters:
            return "character"
//        case .current(let apiKey, let coordinates):
//            return "/forecast/\(apiKey)/\(coordinates.lat),\(coordinates.lon)"
        }
    }
    
    var request: URLRequest {
        let url = URL(string: path, relativeTo: baseURL)
        return URLRequest(url: url!)
    }
}

// MARK: - Protocols

protocol JSONDecodable {
    init?(JSON: [String : AnyObject])
}

protocol FinalURLPoint {
    
    var baseURL: URL { get }
    var path: String { get }
    var request: URLRequest { get }
}

protocol APIManagerProtocol {
    
    var sessionConfiguration: URLSessionConfiguration { get }
    var session: URLSession { get }
    
    func JSONTaskWith(request: URLRequest,
                      completionHandler: @escaping JSONCompletionHandler) -> JSONTask
    func fetch<T: JSONDecodable>(request: URLRequest,
                                 parse: @escaping ([String : AnyObject]) -> T?,
                                 completionHandler: @escaping (APIResult<T>) -> Void)
}

// MARK: - Extensions

extension APIManagerProtocol {
    
    var customError: Error {
        let errorDescription = NSLocalizedString("Missing HTTP Response", comment: "")
        let userInfo = [NSLocalizedDescriptionKey : errorDescription]
        let error = NSError(domain: NetworkingErrorDomain,
                            code: MissingHTTPResponseError,
                            userInfo: userInfo)
        return error
    }
    
    func JSONTaskWith(request: URLRequest,
                      completionHandler: @escaping JSONCompletionHandler) -> JSONTask {
        let dataTask = session.dataTask(with: request) { (data, response, error) in
            
            guard let HTTPResponse = response as? HTTPURLResponse else {
                completionHandler(nil, nil, customError)
                return
            }
            if data == nil {
                completionHandler(nil, HTTPResponse, (error == nil) ? customError : error)
            } else {
                switch HTTPResponse.statusCode {
                case 200:
                    do {
                        let json = try JSONSerialization.jsonObject(with: data!,
                                                                    options: []) as? [String : AnyObject]
                        completionHandler(json, HTTPResponse, nil)
                    } catch let error as NSError {
                        completionHandler(nil, HTTPResponse, error)
                    }
                default:
                    print("got response status \(HTTPResponse.statusCode)")
                    completionHandler(nil, HTTPResponse, error)
                }
            }
        }
        return dataTask
    }
    
    func fetch<T>(request: URLRequest,
                  parse: @escaping ([String : AnyObject]) -> T?,
                  completionHandler: @escaping (APIResult<T>) -> Void) {
        
        let dataTask = JSONTaskWith(request: request) { (json, response, error) in
            DispatchQueue.main.async {
                guard let json = json else {
                    if let error = error {
                        completionHandler(.failure(error))
                    }
                    return
                }
                if let value = parse(json as [String : AnyObject]) {
                    completionHandler(.success(value))
                } else {
                    let error = NSError(domain: NetworkingErrorDomain,
                                        code: UnexpectedResponseError,
                                        userInfo: nil)
                    completionHandler(.failure(error))
                }
            }
        }
        dataTask.resume()
    }
}

// MARK: - APIManager

class APIManager: APIManagerProtocol {
    
    // MARK: Properties
    
    let sessionConfiguration: URLSessionConfiguration = URLSessionConfiguration.default
    lazy var session: URLSession = {
        return URLSession(configuration: self.sessionConfiguration)
    }()
    
    // MARK: Api Methods
    
    func getCharacterList(completion: @escaping (APIResult<CharactersList>) -> Void) {
        let request = ForecastType.characters.request
        fetch(request: request, parse: { (json) -> CharactersList? in
            return CharactersList(JSON: json)
        }, completionHandler: completion)
    }
    
    func getCharacterList(nextRequestString: String,
                          completion: @escaping (APIResult<CharactersList>) -> Void) {
        let urlRequest = URL(string: nextRequestString)
        let request = URLRequest(url: urlRequest!)
        fetch(request: request, parse: { (json) -> CharactersList? in
            return CharactersList(JSON: json)
        }, completionHandler: completion)
    }
}
