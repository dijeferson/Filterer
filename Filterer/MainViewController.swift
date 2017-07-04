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
    //----------------------------------------------------
    //MARK: - Private Properties
    //----------------------------------------------------
    fileprivate let processor = ImageProcessing()
    fileprivate var originalImage = UIImage(named: "sample")!
    fileprivate var processedImage : UIImage? = nil
    fileprivate var isOriginalLabelHidden : Bool = false
    fileprivate var currentFilter : String = ""
    
    //----------------------------------------------------
    // MARK: - Public Properties
    //----------------------------------------------------
    fileprivate var currentView: MainView
    {
        return self.view as! MainView
    }
    
    //----------------------------------------------------
    // MARK: - Overrides
    //----------------------------------------------------
    override func viewDidLoad()
    {
        super.viewDidLoad()
        currentView.imageView.image = originalImage
        processedImage = originalImage
        
        currentView.filtersMenu.backgroundColor = UIColor.white.withAlphaComponent(0.5)
        currentView.filtersMenu.translatesAutoresizingMaskIntoConstraints = false
        
        currentView.editMenu.backgroundColor = UIColor.white.withAlphaComponent(0.5)
        currentView.editMenu.translatesAutoresizingMaskIntoConstraints = false
        
        
        let tapGestureRecognizer =  UILongPressGestureRecognizer(target:self, action:#selector(MainViewController.imageTouchUpInside(_:)))
        currentView.imageView.addGestureRecognizer(tapGestureRecognizer)
        
        currentView.setup()
        
    }
    
    override func didReceiveMemoryWarning()
    {
        super.didReceiveMemoryWarning()
        processedImage = nil
    }
    
    //----------------------------------------------------
    // MARK: - Actions
    //----------------------------------------------------
    @IBAction func didTouchUpInsideImageToggle(_ sender: UIButton)
    {
        sender.isSelected = switchBetweenOriginalAndProcessed(!sender.isSelected)
    }
    
    
    @IBAction func onShare(_ sender: AnyObject)
    {
        let activityController = UIActivityViewController(activityItems: ["Check out our really cool app", currentView.imageView.image!], applicationActivities: nil)
        present(activityController, animated: true, completion: nil)
    }
    
    @IBAction func onNewPhoto(_ sender: AnyObject)
    {
        let actionSheet = UIAlertController(title: "New Photo", message: nil, preferredStyle: .actionSheet)
        
        actionSheet.addAction(UIAlertAction(title: "Camera", style: .default, handler: { action in
            self.showCamera()
        }))
        
        actionSheet.addAction(UIAlertAction(title: "Album", style: .default, handler: { action in
            self.showAlbum()
        }))
        
        actionSheet.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        
        self.present(actionSheet, animated: true, completion: nil)
    }
    
    @IBAction func onFilter(_ sender: UIButton) {
        if (sender.isSelected)
        {
            hideSecondaryMenu()
        }
        else
        {
            hideEditMenu()
            currentView.editButton.isSelected = false 
            showSecondaryMenu()
        }
        sender.isSelected = !sender.isSelected
    }
    
    
    @IBAction func didTouchFilter(_ sender: UIButton)
    {
        let selected = sender.currentTitle!
        
        // DEBUG:
        print("pressed \(selected)")
        
        currentView.editMenu.fxSlider.value = 50
        
        switch selected
        {
        case "F1":
            currentFilter = "warm"
            applyFilter(currentFilter, level:50)
        case "F2":
            currentFilter = "cold"
            applyFilter("cold", level:50)
        case "F3":
            currentFilter = "poster"
            applyFilter(currentFilter, level:50)
        case "F4":
            currentFilter = "colorize"
            applyFilter(currentFilter, level:50)
        case "F5":
            currentFilter = "brightness"
            applyFilter(currentFilter, level:50)
        default:
            print("Why is the button \(sender.currentTitle) bounded to this action?")
        }
        
        currentView.originalLabel.isHidden = true
        currentView.editButton.isEnabled = true
        currentView.imageToggle.isEnabled = true
    }

    @IBAction func didTouchEdit(_ sender: UIButton, forEvent event: UIEvent)
    {
        if (sender.isSelected)
        {
            hideEditMenu()
        }
        else
        {
            hideSecondaryMenu()
            currentView.filterButton.isSelected = false
            showEditMenu()
        }
        sender.isSelected = !sender.isSelected
    }
    
    @IBAction func didChangeValueFxSlider(_ sender: UISlider)
    {
        applyFilter(currentFilter, level: Int(sender.value))
    }
    
    
    //----------------------------------------------------
    // MARK: - Functions
    //----------------------------------------------------
    func applyFilter(_ filter: String, level:Int) -> Void
    {
        // Show the processing overlay
        currentView.processingLabel.isHidden = false
        
        currentView.layoutIfNeeded()
        
        //dispatch_async(dispatch_get_main_queue(), {
            self.processedImage = self.processor.process(self.originalImage, amount: level, filter:filter)
        //})
        
        self.currentView.imageView.image = processedImage
        
        // hide the processing overlay
        currentView.processingLabel.isHidden = true
        
        currentView.layoutIfNeeded()
    }
    
    func showCamera()
    {
        let cameraPicker = UIImagePickerController()
        cameraPicker.delegate = self
        cameraPicker.sourceType = .camera
        
        present(cameraPicker, animated: true, completion: nil)
    }
    
    func showAlbum()
    {
        let cameraPicker = UIImagePickerController()
        cameraPicker.delegate = self
        cameraPicker.sourceType = .photoLibrary
        
        present(cameraPicker, animated: true, completion: nil)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        dismiss(animated: true, completion: nil)
        if let image = info[UIImagePickerControllerOriginalImage] as? UIImage {
            currentView.imageView.image = image
            originalImage = image
            processedImage = image
        }
        
        currentFilter = ""
        currentView.editButton.isEnabled = false
        currentView.imageToggle.isEnabled = false
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        dismiss(animated: true, completion: nil)
    }
    
    func showSecondaryMenu() {
        view.addSubview(currentView.filtersMenu)
        
        let bottomConstraint = currentView.filtersMenu.bottomAnchor.constraint(equalTo: currentView.bottomMenu.topAnchor)
        let leftConstraint = currentView.filtersMenu.leftAnchor.constraint(equalTo: view.leftAnchor)
        let rightConstraint = currentView.filtersMenu.rightAnchor.constraint(equalTo: view.rightAnchor)
        
        let heightConstraint = currentView.filtersMenu.heightAnchor.constraint(equalToConstant: 64)
        
        NSLayoutConstraint.activate([bottomConstraint, leftConstraint, rightConstraint, heightConstraint])
        
        view.layoutIfNeeded()
        
        self.currentView.filtersMenu.alpha = 0
        UIView.animate(withDuration: 0.4, animations: {
            self.currentView.filtersMenu.alpha = 1.0
        }) 
    }
    
    func hideSecondaryMenu() {
        UIView.animate(withDuration: 0.4, animations: {
            self.currentView.filtersMenu.alpha = 0
        }, completion: { completed in
            if completed == true {
                self.currentView.filtersMenu.removeFromSuperview()
            }
        }) 
    }
    
    func showEditMenu() {
        view.addSubview(currentView.editMenu)
        
        let bottomConstraint = currentView.editMenu.bottomAnchor.constraint(equalTo: currentView.bottomMenu.topAnchor)
        let leftConstraint = currentView.editMenu.leftAnchor.constraint(equalTo: view.leftAnchor)
        let rightConstraint = currentView.editMenu.rightAnchor.constraint(equalTo: view.rightAnchor)
        
        let heightConstraint = currentView.editMenu.heightAnchor.constraint(equalToConstant: 44)
        
        NSLayoutConstraint.activate([bottomConstraint, leftConstraint, rightConstraint, heightConstraint])
        
        view.layoutIfNeeded()
        
        self.currentView.editMenu.alpha = 0
        UIView.animate(withDuration: 0.4, animations: {
            self.currentView.editMenu.alpha = 1.0
        }) 
    }
    
    func hideEditMenu() {
        UIView.animate(withDuration: 0.4, animations: {
            self.currentView.editMenu.alpha = 0
        }, completion: { completed in
            if completed == true {
                self.currentView.editMenu.removeFromSuperview()
            }
        }) 
    }
    
    func imageTouchUpInside(_ sender: AnyObject)
    {
        // NOTE: Using the "first" because there is only one. :)
        let state = currentView.imageView.gestureRecognizers?.first?.state
        
        switchBetweenOriginalAndProcessed(state == UIGestureRecognizerState.began || state == UIGestureRecognizerState.changed)
        
    }
    
    func switchBetweenOriginalAndProcessed(_ condition: Bool) -> Bool
    {
        if(condition)
        {
            currentView.imageView.image = originalImage
        }
        else
        {
            currentView.imageView.image = processedImage
        }
        
        currentView.originalLabel.isHidden = !condition
        
        return condition
    }
    
    
    
    //----------------------------------------------------
    
    
}


























