//
//  LJJokePresenter.swift
//  LiveJoke
//
//  Created by Prakash Raj on 06/05/23.
//

import Foundation

struct LJJokeInfo: Codable {
  let title:String?
  let content:String?
}


protocol LJJokePresenterDelegate: AnyObject {
    func insert(joke: LJJokeInfo, at: Int)
    func remove(joke: LJJokeInfo?, from: Int)
}

class LJJokePresenter {
    private(set) var allJokes = [LJJokeInfo]()
    private static let kAPIPath = "https://geek-jokes.sameerkumar.website/api?format=json"
    static let interval = 5.0
    private let maxContain = 10
    private var shouldFetchNext = true
    
    weak var delegate: LJJokePresenterDelegate?
    
    init() {
        self.allJokes = LJJokeCache.localJokes ?? []
    }
    
    func stop() {
        shouldFetchNext = false
    }
    
    func start() {
        shouldFetchNext = true
    }
    
    func cacheCurrentList() {
        LJJokeCache.save(jokes: self.allJokes)
    }

    func getNextJoke() {
        NetworkRequest(path: LJJokePresenter.kAPIPath).execute { response in
            if self.shouldFetchNext {
                self.scheduleNext()
            }
            
            if response.sCode == .kSuccessCode, let sResp = response.responseDict as? kJSONDictionary {
                if let joke = sResp["joke"] as? String, joke.count > 0 {
                    let jInfo = LJJokeInfo(title: "Joke",content: joke)
                    self.insertNew(joke: jInfo)
                    self.cacheCurrentList()
                }
            }
        }
   }
    
    func scheduleNext() {
        DispatchQueue.global(qos: .background).async {
            DispatchQueue.main.asyncAfter(deadline: .now() + LJJokePresenter.interval, execute: {
                self.getNextJoke()
            })
        }
    }
    
    private func insertNew(joke: LJJokeInfo) {
       self.allJokes.insert(joke, at: 0)
        if self.allJokes.count > maxContain {
            self.allJokes.removeLast()
        }
        self.delegate?.insert(joke: joke, at: 0)
    }
}



