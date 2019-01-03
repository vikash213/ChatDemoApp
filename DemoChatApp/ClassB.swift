//
//  ClassB.swift
//  DemoChatApp
//
//  Created by Appinventiv on 01/01/19.
//  Copyright © 2019 Vikash. All rights reserved.
//

//Public class
import Foundation

//Only open class can be inherited not public class which is major difference. Public member cann't be override but open class members can be overriden.
public class B: A {
    
    public var age = 10;
    public func abc() {
        
    }
    
    public override func abc1() {
        //
    }
    
    override init() {
        
    }
    
    convenience init(name: String) {
        self.init()
    }
}
