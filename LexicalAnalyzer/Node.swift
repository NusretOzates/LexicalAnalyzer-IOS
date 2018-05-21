//
//  Node.swift
//  LexicalAnalyzer
//
//  Created by Nusret Özateş on 14.05.2018.
//  Copyright © 2018 Nusret Özateş. All rights reserved.
//

import Foundation

class Node: Equatable
{
    var node_word : Word
    var left:Node?
    var right:Node?
    
    init(node_word:Word) {
        self.node_word = node_word
        left = nil
        right = nil
    }
    static func == (lhs: Node, rhs: Node) -> Bool {
        return lhs.node_word == rhs.node_word
    }
}
