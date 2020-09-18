//
//  PickerViewControllerProtocol.swift
//  AirCollection
//
//  Created by Lysytsia Yurii on 19.09.2020.
//  Copyright © 2020 Developer Lysytsia. All rights reserved.
//

public protocol PickerViewControllerProtocol: class {
    /// Return an instanse of the picker view presented
    var pickerViewPresenter: PickerViewPresenterProtocol { get }
}

public protocol TextFieldPickerViewControllerProtocol: PickerViewControllerProtocol, TextFieldPickerViewDataSource, TextFieldPickerViewDelegate {
    
}
