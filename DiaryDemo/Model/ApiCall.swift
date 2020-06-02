//
//  ApiCall.swift
//  MY DAIRY
//
//  Created by Cp on 29/05/20.
//  Copyright © 2020 Cp. All rights reserved.
//

import Foundation
import RxSwift
import RxCocoa
public enum RequestType: String {
    case GET, POST, PUT,DELETE
}

class APIRequest {
    let baseURL = URL(string: "https://private-ba0842-gary23.apiary-mock.com/notes")!
    var method = RequestType.GET
    var parameters = [String: String]()
}

func request(with baseURL: URL) -> URLRequest {
   var request = URLRequest(url: baseURL)
    request.httpMethod = RequestType.GET.rawValue
    request.addValue("application/json", forHTTPHeaderField: "Accept")
    return request
}
//MARK: RequestObservable class
public class RequestObservable {
  private lazy var jsonDecoder = JSONDecoder()
  private var urlSession: URLSession
  public init(config:URLSessionConfiguration) {
      urlSession = URLSession(configuration:
                URLSessionConfiguration.default)
  }
//MARK: function for URLSession takes
  public func callAPI<ItemModel: Decodable>(request: URLRequest)
    -> Observable<ItemModel> {
  //MARK: creating our observable
  return Observable.create { observer in
  //MARK: create URLSession dataTask
  let task = self.urlSession.dataTask(with: request) { (data,
                response, error) in
  if let httpResponse = response as? HTTPURLResponse{
  let statusCode = httpResponse.statusCode
  do {
    let _data = data ?? Data()
    if (200...399).contains(statusCode) {
      let objs = try self.jsonDecoder.decode(ItemModel.self, from:
                          _data)
      //MARK: observer onNext event
      observer.onNext(objs)
    }
    else {
      observer.onError(error!)
    }
  } catch {
      //MARK: observer onNext event
      observer.onError(error)
     }
   }
     //MARK: observer onCompleted event
     observer.onCompleted()
   }
     task.resume()
     //MARK: return our disposable
     return Disposables.create {
       task.cancel()
     }
   }
  }
}
//MARK: extension for converting out RecipeModel to jsonObject
fileprivate extension Encodable {
  var dictionaryValue:[String: Any?]? {
      guard let data = try? JSONEncoder().encode(self),
      let dictionary = try? JSONSerialization.jsonObject(with: data,
        options: .allowFragments) as? [String: Any] else {
      return nil
    }
    return dictionary
  }
}
class APIClient {
    static var shared = APIClient()
    lazy var requestObservable = RequestObservable(config: .default)
    func getNotes() throws -> Observable<[notesModel]> {
        var request = URLRequest(url:
            URL(string:"https://private-ba0842-gary23.apiary-mock.com/notes")!)
        request.httpMethod = "GET"
        request.addValue("application/json", forHTTPHeaderField:
            "Content-Type")
        return requestObservable.callAPI(request: request)
    }
    
    
}
