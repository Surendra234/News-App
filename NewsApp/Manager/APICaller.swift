//
//  APICaller.swift
//  NewsApp
//
//  Created by Admin on 06/09/22.
//

import Foundation

final class APICaller {
    
    static let shared = APICaller()
    
    private init() {}
    
    struct Constant {
        static let topHeadlineURL = URL(string: "https://newsapi.org/v2/top-headlines?country=us&category=business&apiKey=477d6188de1a4eaba92c8cb44cdac60e")
        static let searchUrlString = "https://newsapi.org/v2/everything?sortBy=popularity&apiKey=477d6188de1a4eaba92c8cb44cdac60e&q="
    }
    
    public func getTopStories(completion: @escaping (Result<[Article], Error>) -> (Void)) {
        
        guard let url = Constant.topHeadlineURL else { return}
        let task = URLSession.shared.dataTask(with: url) { data, _, error in
            guard let data = data, error == nil else { return}
            
            do {
                let result = try JSONDecoder().decode(APIResponse.self, from: data)
                completion(.success(result.articles))
            } catch {
                completion(.failure(error))
            }
        }
        task.resume()
    }
    
    public func search(with query: String, completion: @escaping (Result<[Article], Error>) -> (Void)) {
        
        guard !query.trimmingCharacters(in: .whitespaces).isEmpty else { return}
        let  urlString = Constant.searchUrlString + query
        guard let url = URL(string: urlString) else { return}
        let task = URLSession.shared.dataTask(with: url) { data, _, error in
            guard let data = data, error == nil else { return}
            
            do {
                let result = try JSONDecoder().decode(APIResponse.self, from: data)
                completion(.success(result.articles))
            } catch {
                completion(.failure(error))
            }
        }
        task.resume()
    }
}
