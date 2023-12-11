//
//  MoviesLoader.swift
//  MovieQuiz
//
//  Created by Malik Timurkaev on 11.12.2023.
//

import Foundation

protocol MoviesLoading {
    func loadMovies (handler: @escaping (Result<MostPopularMovies, Error>) -> Void)
}


struct MoviesLoader: MoviesLoading {
    private let networkClient = NetworkClient()
    
    private var mostPopularMoviesUrl: URL {
        guard let url = URL(string: "https://imdb-api.com/en/API/Top250Movies/k_zcuw1ytf") else { preconditionFailure("Unable to construct mostPopularMoviesUrl")
        }
        
        return url
    }
    
    func loadMovies(handler: @escaping (Result<MostPopularMovies, Error>) -> Void) {
        <#code#>
    }
    
    
}
