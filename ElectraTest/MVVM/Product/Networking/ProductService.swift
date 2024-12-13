//
//  ProductService.swift
//  ElectraTest
//
//  Created by Gil Alfredo Casimiro Ramírez on 11/12/24.
//

import Foundation

protocol ProductFetchingProtocol {
    func fetchProducts(completion: @escaping (Result<[Product], Error>) -> Void)
}

class ProductService: ProductFetchingProtocol {
    private let urlSession: URLSession
    private let jsonDecoder: JSONDecoder
    private let urlString: String
    
    init(urlSession: URLSession = .shared,
         jsonDecoder: JSONDecoder = JSONDecoder(),
         urlString: String = "http://alb-dev-ekt-875108740.us-east-1.elb.amazonaws.com/apps/moviles/caso-practico/plp") {
        self.urlSession = urlSession
        self.jsonDecoder = jsonDecoder
        self.urlString = urlString
    }
    
    func fetchProducts(completion: @escaping (Result<[Product], Error>) -> Void) {
        guard let url = URL(string: urlString) else {
            completion(.failure(NSError(domain: "Invalid URL", code: 0, userInfo: nil)))
            return
        }
        let task = urlSession.dataTask(with: url) { [weak self] data, response, error in
            if let error = error {
                completion(.failure(error))
                return
            }
            guard let data = data else {
                completion(.failure(NSError(domain: "No data", code: 0, userInfo: nil)))
                return
            }
            do {
                guard let self = self else { return }
                let apiResponse = try self.jsonDecoder.decode(APIResponse.self, from: data)
                completion(.success(apiResponse.result.products))
            } catch {
                completion(.failure(error))
            }
        }
        task.resume()
    }
}
