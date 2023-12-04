//
//  NetworkWorker.swift
//  CellcomHomeTask
//
//  Created by Евгений Кулиничев on 19.11.2023.
//

import Foundation
import CellcomHomeTaskModels
import CellcomHometaskProtocols

public class NetworkWorker {
    struct Config {
        static let apiKey = "2c46288716a18fb7aadcc2a801f3fc6b"
        static var accountId: Int?
        static var sessionId: String?
    }
    
    var config: Config = Config()
    
    enum Paths { }
    
    func createUrlWithApiKey(_ urlString: String) -> String {
        return "\(urlString)?api_key=\(Config.apiKey)"
    }
    
    public init() { }
}

extension NetworkWorker {
    func fetch<T: Decodable>(url: URL, completion: @escaping (Result<T, MovieFetchingError>) -> Void) -> CancelableDataLoadingTask? {
        let request = URLRequest(url: url)
        let dataTask = URLSession.shared.dataTask(with: request) { data, response, error in
             guard error == nil else {
                 switch (error as? URLError)?.code {
                 case .some(.timedOut):
                     completion(.failure(.timeout))
                 case .some(.notConnectedToInternet):
                     completion(.failure(.timeout))
                 default:
                     completion(.failure(.wrongRequest))
                 }
                
                return
            }
            
            guard let data = data else {
                completion(.failure(.noData))
                return
            }
            
            guard let httpResponse = response as? HTTPURLResponse,
                  httpResponse.statusCode != 401
            else {
                completion(.failure(.authDenied))
                return
            }
            
            let decoder = JSONDecoder()
            let formatter = DateFormatter()
            formatter.dateFormat = "YYYY-MM-DD"
            decoder.dateDecodingStrategy = .formatted(formatter)
            do {
                let result = try decoder.decode(T.self, from: data)
                completion(.success(result))
            } catch let decodingError as DecodingError {
                print(url.absoluteString)
                print(decodingError)
                completion(.failure(.decodingError))
            } catch {
                completion(.failure(.unknown))
            }
        }
        dataTask.resume()
        return dataTask
    }
    
    func fetchData(url: URL, completion: @escaping (Result<Data, MovieFetchingError>) -> Void) -> CancelableDataLoadingTask? {
        let request = URLRequest(url: url)
        let dataTask = URLSession.shared.dataTask(with: request) { data, response, error in
            guard error == nil else {
                completion(.failure(.wrongRequest))
                return
            }
            
            guard let data = data else {
                completion(.failure(.noData))
                return
            }
            completion(.success(data))
        }
        dataTask.resume()
        return dataTask
    }
    
    func post<G: Encodable, T: Decodable>(url: URL, object: G, completion: @escaping (Result<T, MovieFetchingError>) -> Void) -> CancelableDataLoadingTask? {
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.addValue("application/json", forHTTPHeaderField: "Accept")
        do {
            // convert parameters to Data and assign dictionary to httpBody of request
            request.httpBody = try JSONEncoder().encode(object)
          } catch let error {
            print(error.localizedDescription)
            return nil
          }
        
        let dataTask = URLSession.shared.dataTask(with: request) { data, response, error in
            guard error == nil else {
                completion(.failure(.wrongRequest))
                return
            }
            guard let data = data else {
                completion(.failure(.noData))
                return
            }
            let decoder = JSONDecoder()
            let formatter = DateFormatter()
            formatter.dateFormat = "YYYY-MM-DD"
            decoder.dateDecodingStrategy = .formatted(formatter)
            do {
                let result = try decoder.decode(T.self, from: data)
                completion(.success(result))
            } catch is DecodingError {
                completion(.failure(.decodingError))
            } catch {
                completion(.failure(.unknown))
            }
        }
        dataTask.resume()
        return dataTask
    }
}
