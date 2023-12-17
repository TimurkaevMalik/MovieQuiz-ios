//
//  MostPopularMovies.swift
//  MovieQuiz
//
//  Created by Malik Timurkaev on 11.12.2023.
//

import Foundation

struct MostPopularMovies: Codable {
    let errorMessage: String
    let items: [MostPopularMovie]
}

struct MostPopularMovie: Codable {
    let title: String
    let rating: String
    let imageURL: URL
    
    var resizedImageURL: URL {
        let urlString = imageURL.absoluteString
        
        let imageURLString = urlString.components(separatedBy: "._")[0] + "._v0_UX600_.jpg"
        
        guard let newURL = URL(string: imageURLString) else {
            return imageURL
        }
        
        return newURL
    }
    
    private enum CodingKeys: String, CodingKey {
        case title = "fullTitle"
        case rating = "imDbRating"
        case imageURL = "image"
    }
}


