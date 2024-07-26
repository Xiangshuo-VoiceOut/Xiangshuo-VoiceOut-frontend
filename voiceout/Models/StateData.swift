//
//  StateData.swift
//  voiceout
//
//  Created by J. Wu on 7/8/24.
//
import Foundation

class StateData: Codable, Identifiable {
    let name: String
    let code: String
    
    static let allStates : [StateData] = Bundle.main.decode("states.json")
}

extension Bundle {
    func decode<T : Codable> (_ file : String) -> T{
        guard let url = self.url(forResource: file, withExtension: nil) else { fatalError("There is error in \(file)")}
        
        guard let data = try? Data(contentsOf: url) else {
            fatalError("There is error in \(url)")
        }
        
        let decoder = JSONDecoder()
        
        guard let states = try? decoder.decode(T.self, from: data) else {fatalError("There is a problem in parsing the data")}
        
        return states
    }
}

