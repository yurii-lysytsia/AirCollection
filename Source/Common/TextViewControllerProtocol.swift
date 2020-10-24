//
//  TextViewControllerProtocol.swift
//  Source
//
//  Created by Lysytsia Yurii on 04.10.2020.
//  Copyright © 2020 Lysytsia Yurii. All rights reserved.
//

public protocol TextViewControllerProtocol: TextViewDelegate {
    
    /// Return an instanse of the text view presenter
    var textViewPresenter: TextViewPresenterProtocol { get }
    
}

