//
//  BinarySearchTree.swift
//  LexicalAnalyzer
//
//  Created by Nusret Özateş on 15.05.2018.
//  Copyright © 2018 Nusret Özateş. All rights reserved.
//

import Foundation
class BinarySearchTree
{
    var root : Node?
    
    init()
    {
        self.root = nil
    }
    
    func find(p_word :String) -> Bool {
        var current :Node? = root
        while current != nil
        {
            if current?.node_word.getWord().caseInsensitiveCompare(p_word) == ComparisonResult.orderedSame
            {
                return true
            }else if current?.node_word.getWord().caseInsensitiveCompare(p_word) == ComparisonResult.orderedDescending
            {
                current = current?.left
            }else
            {
                current = current?.right
            }
        }
        return false;
    }
    
    func getSuccessor(deleteNode : Node) -> Node {
        var successsor : Node? = nil
        var successsorParent : Node? = nil
        var current : Node? = deleteNode.right
        
        while current != nil
        {
            successsorParent = successsor;
            successsor = current;
            current = current?.left;
        }
        if (successsor != deleteNode.right) {
            successsorParent?.left = successsor?.right;
            successsor?.right = deleteNode.right;
        }
        return successsor!;
    }
    func insert(p_word:Word)
    {
        let newNode = Node(node_word:p_word)
        if (root == nil) {
            root = newNode;
            return;
        }
        var current : Node? = root
        var parent : Node? = nil
        while true
        {
            parent = current
            if p_word.getWord().caseInsensitiveCompare(current!.node_word.getWord()) == ComparisonResult.orderedAscending
            {
                current = current?.left;
                if (current == nil) {
                    parent?.left = newNode;
                    return;
                }
            }else {
                current = current?.right;
                if (current == nil) {
                    parent!.right = newNode;
                    return;
                }
            }
        }
    }
    
}

