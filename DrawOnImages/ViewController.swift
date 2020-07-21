//
//  ViewController.swift
//  DrawOnImages
//
//  Created by Tobias Lewinzon on 16/07/2020.
//  Copyright © 2020 tobiaslewinzon. All rights reserved.
//

import UIKit
import Photos

class ViewController: UIViewController {
    
    // MARK: - Global properties
    let canvas = Canvas()
    let image = UIImage(named: "corn")
    
    // MARK: - View loading
    override func viewDidLoad() {
        super.viewDidLoad()
        
        addBackgroundImage()
        addCanvasView()
        addControls()
    }
    
    // MARK: - View configuration
    private func addCanvasView() {
        // Setup canvas.
        view.addSubview(canvas)
        canvas.backgroundColor = .clear
        canvas.frame = view.frame
    }
    
    private func addBackgroundImage() {
        // Adding a UIImage covering the whole frame to simulate the possible feature of making annotations over a fieldNote photo.
        let imageView = UIImageView(image: image)
        imageView.frame = view.frame
        imageView.contentMode = .scaleAspectFill
        view.addSubview(imageView)
    }
    
    private func addControls() {
        
        // Undo button.
        let undoButton = UIButton(type: .system)
        undoButton.setTitle("Undo", for: .normal)
        undoButton.titleLabel?.font = .boldSystemFont(ofSize: 20)
        undoButton.titleLabel?.textColor = .white
        undoButton.tintColor = .white
        undoButton.backgroundColor = .darkGray
        undoButton.layer.cornerRadius = 12
        undoButton.clipsToBounds = true
        undoButton.layer.maskedCorners = [.layerMinXMinYCorner, .layerMinXMaxYCorner]
        undoButton.addTarget(self, action: #selector(undo), for: .touchUpInside)
        
        // Clear button.
        let clearButton = UIButton(type: .system)
        clearButton.setTitle("Clear", for: .normal)
        clearButton.titleLabel?.font = .boldSystemFont(ofSize: 20)
        clearButton.titleLabel?.textColor = .white
        clearButton.tintColor = .white
        clearButton.backgroundColor = .darkGray
        clearButton.layer.cornerRadius = 12
        clearButton.clipsToBounds = true
        clearButton.layer.maskedCorners = [.layerMaxXMaxYCorner, .layerMaxXMinYCorner]
        clearButton.addTarget(self, action: #selector(clear), for: .touchUpInside)
        
        // Red color button.
        let color1Button = UIButton(type: .system)
        color1Button.backgroundColor = .red
        color1Button.addTarget(self, action: #selector(changeStrokeColor), for: .touchUpInside)
        
        // White color button.
        let color2Button = UIButton(type: .system)
        color2Button.backgroundColor = .white
        color2Button.addTarget(self, action: #selector(changeStrokeColor), for: .touchUpInside)
        
        // Black color button.
        let color3Button = UIButton(type: .system)
        color3Button.backgroundColor = .black
        color3Button.addTarget(self, action: #selector(changeStrokeColor), for: .touchUpInside)
        
        // Save button.
        let saveButton = UIButton(type: .system)
        saveButton.setTitle("Save", for: .normal)
        saveButton.titleLabel?.font = .boldSystemFont(ofSize: 20)
        saveButton.titleLabel?.textColor = .white
        saveButton.tintColor = .white
        saveButton.backgroundColor = .darkGray
        saveButton.addTarget(self, action: #selector(save), for: .touchUpInside)
        saveButton.layer.cornerRadius = 12
        saveButton.clipsToBounds = true
        
        // Stack view containing undo, clear and color buttons.
        let stack = UIStackView(arrangedSubviews: [undoButton, color1Button, color2Button, color3Button ,clearButton])
        stack.distribution = .fillEqually
        
        // Stack view constraints.
        view.addSubview(stack)
        stack.translatesAutoresizingMaskIntoConstraints = false
        stack.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 20).isActive = true
        stack.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor).isActive = true
        stack.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -20).isActive = true
        
        // Save button constraints.
        view.addSubview(saveButton)
        saveButton.translatesAutoresizingMaskIntoConstraints = false
        saveButton.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 20).isActive = true
        saveButton.widthAnchor.constraint(equalToConstant: 60).isActive = true
        saveButton.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor).isActive = true
    }
    
    /// Removes all elements intended to be excluded from saved image.
    private func removeControls() {
        for view in view.subviews {
            if let stack = view as? UIStackView {
                stack.removeFromSuperview()
            } else if let button = view as? UIButton {
                button.removeFromSuperview()
            }
        }
    }
    
    // MARK: - Action methods
    @objc func undo() {
        canvas.undo()
    }
    
    @objc func clear() {
        canvas.clear()
    }
    
    @objc func changeStrokeColor(button: UIButton) {
        canvas.changeColor(to: button.backgroundColor ?? .white)
    }
    
    @objc func save() {
        // Prepare view.
        removeControls()
        
        // Generate snapshot.
        let image = UIImage(view: self.view)
        
        // Save to camera roll.
        PHPhotoLibrary.shared().performChanges({
            PHAssetChangeRequest.creationRequestForAsset(from: image)
        }) { (success, error) in
            if let error = error {
                (print(error))
            }
        }
        
        // Restore view.
        addControls()
    }
}

extension UIImage {
    
    /// Generates image with passed view drawn as a snapshot.
    convenience init(view: UIView) {
        // Create image context from desired view's frame (size and position)
        UIGraphicsBeginImageContextWithOptions(view.bounds.size, view.isOpaque, 0.0)
        
        // Call drawHierarchy on view. This method renders the view content into the current image context.
        // afterScreenUpdates waits for the IU changes to be rendered before drawing.
        view.drawHierarchy(in: view.bounds, afterScreenUpdates: true)
        
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        if let image = image?.cgImage {
            self.init(cgImage: image)
        } else {
            self.init()
        }
    }
}

