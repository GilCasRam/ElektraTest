//
//  ProductService.swift
//  ElectraTest
//
//  Created by Gil Alfredo Casimiro Ramírez on 11/12/24.
//

import Foundation

class ProductService {
    func fetchProducts(completion: @escaping (Result<[Product], Error>) -> Void) {
        guard let url = URL(string: "http://alb-dev-ekt-875108740.us-east-1.elb.amazonaws.com/apps/moviles/caso-practico/plp") else {
            completion(.failure(NSError(domain: "Invalid URL", code: 0, userInfo: nil)))
            return
        }
        let task = URLSession.shared.dataTask(with: url) { data, response, error in
            if let error = error {
                completion(.failure(error))
                return
            }
            guard let data = data else {
                completion(.failure(NSError(domain: "No data", code: 0, userInfo: nil)))
                return
            }
            do {
                let apiResponse = try JSONDecoder().decode(APIResponse.self, from: data)
                completion(.success(apiResponse.result.products))
            } catch {
                print("Decoding error: \(error)")
                completion(.failure(error))
            }
        }
        task.resume()
    }
}
