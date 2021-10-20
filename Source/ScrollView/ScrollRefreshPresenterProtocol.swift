//
//  ScrollRefreshPresenterProtocol.swift
//  AirCollection
//
//  Created by Lysytsia Yurii on 25.10.2020.
//  Copyright © 2020 Lysytsia Yurii. All rights reserved.
//

public protocol ScrollRefreshPresenterProtocol: AnyObject {
    
    /// Called when refresh indicator start animating
    func scrollDidShowRefreshControl()
    
    /// Called when refresh indicator stop animating and hidden
    func scrollDidHideRefreshControl()
    
}

public extension ScrollRefreshPresenterProtocol {
    
    func scrollDidHideRefreshControl() {
        
    }
    
}
