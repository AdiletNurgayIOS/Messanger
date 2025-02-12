//
//  Extension + RegisterView.swift
//  NewMessenger
//
//  Created by Adilet on 04.02.2025.
//

import UIKit
import PhotosUI
import TOCropViewController


//Разрешение доступа к камере
extension RegisterViewController: UIImagePickerControllerDelegate, PHPickerViewControllerDelegate, TOCropViewControllerDelegate {
    
    func presentPhotoActionSheet() {
        let actionSheet = UIAlertController(title: "Profile Picture",
                                            message: "How would you like to select a picture?",
                                            preferredStyle: .actionSheet)
        let actionAlertCanel = UIAlertAction(title: "Cancel", style: .cancel)
        
        
        
        if imageView.image != UIImage(systemName: "person.crop.circle.fill") {
            let actionEditPhoto = UIAlertAction(title: "Edit Photo", style: .default) { [weak self] _ in
                self?.editExistingPhoto()
            }
            actionSheet.addAction(actionEditPhoto)
        }
      
        let actionTakePhoto = UIAlertAction(title: "Take Photo",
                                            style: .default) { [weak self] _ in
            self?.checkCameraPermission()
        }
        
        let actionChosePhoto = UIAlertAction(title: "Chose Photo",
                                             style: .default) { [weak self] _  in
            self?.checkPhotoLibraryPermissions()
        }
        
        actionSheet.addAction(actionTakePhoto)
        actionSheet.addAction(actionAlertCanel)
        actionSheet.addAction(actionChosePhoto)
        
        present(actionSheet, animated: true)
    }
    
    
    private func checkCameraPermission() {
        let authStatus = AVCaptureDevice.authorizationStatus(for: .video)
        
        switch authStatus {
        case .authorized:
            presentCamera()
        case .notDetermined:
                   AVCaptureDevice.requestAccess(for: .video) { granted in
                       if granted {
                           DispatchQueue.main.async {
                               self.presentCamera()
                           }
                       }
                   }
        case .restricted, .denied:
            showSettingsAlert(title: "Разрешение", message: "Разрешите использовать камеру")
            
        @unknown default:
            break
        }
    }
    
    
    
    private func checkPhotoLibraryPermissions() {
           let status = PHPhotoLibrary.authorizationStatus()

           switch status {
           case .authorized, .limited:
               presentPhotoPicker()
           case .notDetermined:
               PHPhotoLibrary.requestAuthorization { newStatus in
                   if newStatus == .authorized || newStatus == .limited {
                       DispatchQueue.main.async {
                           self.presentPhotoPicker()
                       }
                   }
               }
           case .denied, .restricted:
               self.showSettingsAlert(title: "Разрешение",
                                      message: "Пожалуйста разрешите использовать галерею.")
           @unknown default:
               break
           }
       }
    
    
    private func showSettingsAlert(title: String, message: String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel))
        alert.addAction(UIAlertAction(title: "Settings", style: .default) { _ in
            if let url = URL(string: UIApplication.openSettingsURLString) {
                UIApplication.shared.open(url)
            }
        })
        
        present(alert, animated: true)
    }

    
    func presentCamera() {
        let vc = UIImagePickerController()
        vc.sourceType = .camera
        vc.delegate = self
        vc.allowsEditing = true
        present(vc, animated: true)
    }
    
    func presentPhotoPicker () {
        var config = PHPickerConfiguration()
           config.selectionLimit = 1
           config.filter = .images
        
           let picker = PHPickerViewController(configuration: config)
           picker.delegate = self
           present(picker, animated: true)
    }
    
    
    func picker(_ picker: PHPickerViewController, didFinishPicking results: [PHPickerResult]) {
        picker.dismiss(animated: true)
        
        guard let provider = results.first?.itemProvider, provider.canLoadObject(ofClass: UIImage.self) else {
            return
        }
        
        provider.loadObject(ofClass: UIImage.self) { [weak self] image, error in
            DispatchQueue.main.async {
                if let selectedImage = image as? UIImage {
                    self?.showCropViewController(image: selectedImage)
                }
            }
        }
    }
    
    func showCropViewController(image: UIImage) {
        let cropViewController = TOCropViewController(image: image)
        cropViewController.delegate = self
        present(cropViewController, animated: true)
    }

    // Получаем результат кадрирования
    func cropViewController(_ cropViewController: TOCropViewController, didCropTo image: UIImage, with cropRect: CGRect, angle: Int) {
        cropViewController.dismiss(animated: true)
        self.imageView.image = image
        self.imageView.contentMode = .scaleAspectFill
        self.imageView.clipsToBounds = true
    }
    
    func editExistingPhoto() {
        guard let image = imageView.image else { return }
        
        let cropViewController = TOCropViewController(image: image)
        cropViewController.delegate = self
        present(cropViewController, animated: true)
    }

    //для редактирование вставленного фото
    func cropViewController(_ cropViewController: TOCropViewController, didCropTo image: UIImage, withRect cropRect: CGRect, angle: Int) {
        cropViewController.dismiss(animated: true)
        imageView.image = image
    }

}

