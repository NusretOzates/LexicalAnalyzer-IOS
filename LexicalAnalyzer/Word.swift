//
//  Word.swift
//  LexicalAnalyzer
//
//  Created by Nusret Özateş on 14.05.2018.
//  Copyright © 2018 Nusret Özateş. All rights reserved.
//

import Foundation
class Word : CustomStringConvertible,Equatable
{
    var root:String!
    var word:String!
    
    init(word:String,root:String)
    {
       self.word = word
       self.root = root
    }
    init(word:String) {
        self.word = word
        self.root = "undefined"
    }
    
    func getWord() -> String {
        return self.word
    }
    
    func getRoot() -> String {
        return self.root
    }
    func setWord(word:String) {
        self.word = word
    }
    func setRoot(root:String) {
        self.root = root
    }
    var description : String
    {
        if(getRoot() != "undefined")
        {
            return "\(getWord())  \(getRoot())"
        }else
        {
          return getWord()
        }
    }

    static func == (lhs: Word, rhs: Word) -> Bool {
        return lhs.getWord()==rhs.getWord()
    }
}
