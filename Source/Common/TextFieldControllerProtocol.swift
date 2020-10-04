//
//  TextFieldControllerProtocol.swift
//  Source
//
//  Created by Lysytsia Yurii on 04.10.2020.
//  Copyright © 2020 Lysytsia Yurii. All rights reserved.
//

public protocol TextFieldControllerProtocol: TextFieldDelegate {
    /// Return an instanse of the text field presenter
    var textFieldPresenter: TextFieldPresenterProtocol { get }
}
