//
//  MainView.swift
//  Filterer
//
//  Created by Jeferson Santos on 14/04/16.
//  Copyright © 2016 Jeferson Santos. All rights reserved.
//

import Foundation
import UIKit

class MainView : UIView
{
    //----------------------------------------------------
    // MARK: - Outlets
    //----------------------------------------------------
    @IBOutlet var filtersMenu: FilterMenuView!
    @IBOutlet var editMenu: EditMenuView!
    @IBOutlet var imageView: UIImageView!
    @IBOutlet var imageToggle: UIButton!
    @IBOutlet var bottomMenu: UIView!
    @IBOutlet var filterButton: UIButton!
    @IBOutlet var originalLabel: UILabel!
    @IBOutlet var processingLabel: UILabel!
    @IBOutlet var editButton: UIButton!
    
    func setup()
    {
        _ = setupRoundedLabel(originalLabel)
        _ = setupRoundedLabel(processingLabel)
    }
    
    func setupRoundedLabel(_ label: UILabel) -> UILabel
    {
        label.layer.cornerRadius = 10
        label.layer.masksToBounds = true
        label.clipsToBounds = true
        
        return label
    }
    
}
