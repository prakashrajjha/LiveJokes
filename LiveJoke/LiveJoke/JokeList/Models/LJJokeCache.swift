//
//  LJJokeCache.swift
//  LiveJoke
//
//  Created by Prakash Raj on 06/05/23.
//

import Foundation

class LJJokeCache {
    private static let kKeyJokeList      = "kKeyJokeList"

    private init() {}
    
    class func save(jokes: [LJJokeInfo]) {
        let encoder = JSONEncoder()
        do {
            let encodedData = try encoder.encode(jokes)
            Preference.saveData(key: LJJokeCache.kKeyJokeList, value: encodedData)
            
        } catch {
            print("Couldn't save")
        }
        Preference.usrDefaults.synchronize()
    }
    
    class var localJokes: [LJJokeInfo]? {
        guard let jokeData = Preference.fetchData(key: LJJokeCache.kKeyJokeList) else { return nil }
        do {
            let aJokes = try JSONDecoder().decode([LJJokeInfo].self, from: jokeData)
            return aJokes
            
        } catch {
            return nil
        }
    }
}
