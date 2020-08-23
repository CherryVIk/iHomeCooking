//
//  ItemImageViewController.swift
//  iHomeCooking
//
//  Created by Victoria Boichenko on 22.08.2020.
//  Copyright © 2020 Victoria Boichenko. All rights reserved.
//

import UIKit
import CoreML
import Vision

class ItemImageViewController: UIViewController{
    
    @IBOutlet weak var itemImageView: UIImageView!
    // MARK: - Photo Actions
    
    @IBAction func takePicture() {
        // Show options for the source picker only if the camera is available.
        guard UIImagePickerController.isSourceTypeAvailable(.camera) else {
            presentPhotoPicker(sourceType: .photoLibrary)
            return
        }
        
        let photoSourcePicker = UIAlertController()
        let takePhoto = UIAlertAction(title: "Take Photo", style: .default) { [unowned self] _ in
            self.presentPhotoPicker(sourceType: .camera)
        }
        let choosePhoto = UIAlertAction(title: "Choose Photo", style: .default) { [unowned self] _ in
            self.presentPhotoPicker(sourceType: .photoLibrary)
        }
        
        photoSourcePicker.addAction(takePhoto)
        photoSourcePicker.addAction(choosePhoto)
        photoSourcePicker.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        
        present(photoSourcePicker, animated: true)
    }
    
    func presentPhotoPicker(sourceType: UIImagePickerController.SourceType) {
        let picker = UIImagePickerController()
        picker.delegate = self
        picker.sourceType = sourceType
        present(picker, animated: true)
    }
}

//MARK: - UIImagePickerControllerDelegate

extension ItemImageViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        // We always expect `imagePickerController(:didFinishPickingMediaWithInfo:)` to supply the original image.
            
        if let userPickedImage = info[UIImagePickerController.InfoKey.originalImage] as? UIImage {
            itemImageView.image = userPickedImage
            
            guard let ciimage = CIImage(image: userPickedImage) else {
                fatalError("Couldn't convert to CIImage")
            }
            
            detect(image: ciimage)
        }
        picker.dismiss(animated: true, completion: nil)

    }
    
    /**
            Using machine learning model we try to detect special image
         */
        func detect(image: CIImage){
            guard let model = try? VNCoreMLModel(for: MobileNetV2().model) else {
                fatalError("Loading CoreML model failed")
            }
            let request = VNCoreMLRequest(model: model) { (request, error) in
                guard let results = request.results as? [VNClassificationObservation ] else {
                    fatalError("Failed to get results from request ")
                }
                if let firstResult = results.first {
                    let text = String(format: "%.2f %@", firstResult.confidence, firstResult.identifier)
                    
                    let alert = UIAlertController(title: "Your image is ...", message: text, preferredStyle: .alert)
                    alert.addAction(UIAlertAction(title: "Add this item", style: .default){ (action) in
                        self.addItem()
                    })
                    alert.addAction(UIAlertAction(title: "Close", style: .cancel, handler: nil))
                    
                    self.present(alert, animated: true, completion: nil)
                    print(text)
                }
            }
            
            let handler = VNImageRequestHandler(ciImage: image)
            
            do {
                try handler.perform([request])
            } catch {
                print(error)
            }
        }
        
    func addItem(){
        
    }
}
