//
//  CharacterCounterProtocol.swift
//  TwitterCharacterCounter
//
//  Created by Dodo's Mac on 07/01/2026.
//

import Foundation

public protocol CharacterCounterProtocol{
    func count(_ text: String) -> Int
    func remainingCharacters(_ text: String, limit: Int) -> Int
    func isValid(_ text: String, limit: Int) -> Bool
}
