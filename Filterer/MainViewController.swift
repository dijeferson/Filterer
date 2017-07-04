//
//  ViewController.swift
//  Filterer
//
//  Created by Jeferson Santos on 14/04/16.
//  Copyright © 2016 Jeferson Santos. All rights reserved.
//

import UIKit

class MainViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate
{
    //MARK: - Private Properties
    private let processor = ImageProcessing()
    private let originalImage = UIImage(named: "sample")!
    private var processedImage : UIImage? = nil
    
    //MARK: - Public Properties
    private var currentView: MainView
    {
        return self.view as! MainView
    }
    
    //MARK: - Overrides
    override func viewDidLoad()
    {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        //currentView.imageToggle.setTitle("Show Original Image", for: .selected)
        
        currentView.imageView.image = originalImage
        processedImage = originalImage
    }

    override func didReceiveMemoryWarning()
    {
        super.didReceiveMemoryWarning()
        processedImage = nil
    }
    
    //MARK: - Functions
    func applyFilter(_ filter: String, level:Int) -> Void
    {
        //dispatch_async(dispatch_get_main_queue(), {
            self.processedImage = self.processor.process(self.originalImage, amount: level, filter:filter)
        //})
        
        self.currentView.imageView.image = processedImage
    }

    //MARK: - Actions
    @IBAction func didTouchUpInsideImageToggle(_ sender: UIButton)
    {
        
        if currentView.imageToggle.isSelected
        {
            currentView.imageView.image = originalImage
        }
        else
        {
            applyFilter("warm", level:100)
        }
        
        currentView.imageToggle.isSelected = !currentView.imageToggle.isSelected;
    }
}

