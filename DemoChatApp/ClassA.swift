//
//  ClassA.swift
//  DemoChatApp
//
//  Created by Appinventiv on 01/01/19.
//  Copyright © 2019 Vikash. All rights reserved.
//

// Open class
import Foundation

open class A  {
    
    private var newName: String?
    
    public var name: String {
        get {
           return "vik"
        }
        set {
            self.newName = newValue
        }
        
    }
    
    public func abc1() {
        
    }
    
    
}
