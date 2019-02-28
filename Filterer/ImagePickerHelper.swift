//
//  ImagePickerHelper.swift
//  Filterer
//
//  Created by Jeferson Santos on 28/02/19.
//  Copyright © 2019 UofT. All rights reserved.
//

import Foundation
import UIKit

// Helper function inserted by Swift 4.2 migrator.
func convertFromUIImagePickerControllerInfoKeyDictionary(_ input: [UIImagePickerController.InfoKey:Any]) -> [String:Any] {
    return Dictionary(uniqueKeysWithValues: input.map {key, value in (key.rawValue, value)})
}

// Helper function inserted by Swift 4.2 migrator.
func convertFromUIImagePickerControllerInfoKey(_ input: UIImagePickerController.InfoKey) -> String {
    return input.rawValue
}