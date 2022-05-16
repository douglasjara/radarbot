//
//  APIManager.swift
//  radarbot
//
//  Created by Douglas Jara Negrete on 16/5/22.
//

import Foundation

class APIManager
{
    private var url: URL
    private var session: URLSession
    
    init (url: String)
    {
        self.url = URL(string: url)!
        self.session = URLSession(configuration: .default)
    }
    
    public func get<T: Decodable>(completion: @escaping (T?) -> Void)
    {
        session.dataTask(with: url) { (data, response, error) in
            if let error = error {
                debugPrint("APIService: (get) \(error.localizedDescription). Método: \(self.url.absoluteString)")
                completion(nil)
                return
            }
            guard let data = data else {
                debugPrint("APIService: (get) Sin datos. Método: \(self.url.absoluteString)")
                completion(nil)
                return
            }
            guard let httpResponse = response as? HTTPURLResponse, 200 ..< 300 ~= httpResponse.statusCode else {
                debugPrint("APIService: (get) \(response?.description ?? "") Método: \(self.url.absoluteString). Response \(String(data: data, encoding: .utf8) ?? "(Cannot display)")")
                return
            }
            
            let decoder = JSONDecoder()
            guard let decodedData = try? decoder.decode(T.self, from: data) else {
                debugPrint("APIService: (get) No se pudo decodificar la respuesta. Método: \(self.url.absoluteString)")
                completion(nil)
                return
            }
            DispatchQueue.main.async {
                completion(decodedData)
            }
        }.resume()
    }
}
