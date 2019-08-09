//
//  PokeController.swift
//  Pokedex
//
//  Created by Jeffrey Santana on 8/9/19.
//  Copyright © 2019 Lambda. All rights reserved.
//

import Foundation

class PokeController {
	
	private let baseURL = URL(string: "https://pokeapi.co/api/v2/")!
	private(set) var myPokemon = [String]()
	
	func add(pokemon: String) {
		if !myPokemon.contains(pokemon) {
			myPokemon.append(pokemon)
		}
	}
	
	func getPokemon(by searchTerm: String, completion: @escaping (Result<Pokemon, NetworkError>) -> Void) {
		let pokeURL = baseURL.appendingPathComponent("pokemon/\(searchTerm)")
		let request = URLRequest(url: pokeURL)
		
		URLSession.shared.dataTask(with: request) { (data, response, error) in
			if let error = error {
				NSLog(error.localizedDescription)
				completion(.failure(.other(error)))
				return
			}
			
			guard let data = data else {
				NSLog("Data is empty")
				completion(.failure(.noData))
				return
			}
			
			do {
				let pokemon = try JSONDecoder().decode(Pokemon.self, from: data)
				completion(.success(pokemon))
			} catch {
				completion(.failure(.notDecoding))
			}
		}.resume()
	}
}