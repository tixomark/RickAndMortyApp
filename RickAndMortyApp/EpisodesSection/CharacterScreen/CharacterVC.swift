//
//  CharacterVC.swift
//  RickAndMortyApp
//
//  Created by Tixon Markin on 12.12.2023.
//

import Foundation
import UIKit
import PhotosUI

protocol CharacterVCInput: AnyObject {
    func displayCharacter(_ viewModel: GetCharacter.ViewModel)
}

final class CharacterVC: UIViewController {
    private var imageView: UIImageView = {
        let view = UIImageView()
        view.contentMode = .scaleAspectFill
        view.layer.borderColor = UIColor.RMborderColor.cgColor
        view.layer.borderWidth = 5
        view.clipsToBounds = true
        return view
    }()
    
    private var cameraIcon: UIImageView = {
        let cameraImage = UIImage(.cameraIcon)
        let view = UIImageView(image: cameraImage)
        view.isUserInteractionEnabled = true
        view.backgroundColor = .clear
        view.clipsToBounds = true
        return view
    }()
    
    private var nameLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont(name: "Roboto-Regular",
                            size: 32)
        label.numberOfLines = 0
        return label
    }()
    
    private var informationLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont(name: "Roboto-Medium",
                            size: 20)
        label.text = "Information"
        return label
    }()
    
    private var characterDetailsTable: UITableView = {
        let table = UITableView()
        table.separatorStyle = .singleLine
        table.allowsSelection = false
//        table.isScrollEnabled = false
        table.showsVerticalScrollIndicator = false
        table.register(DetailCell.self,
                       forCellReuseIdentifier: DetailCell.description())
        return table
    }()
    
    var interactor: CharacterInteractorInput?
    weak var coordinator: ShowCharacterScreenCoordinatorInput?
    
    private var rowData = [String]()
    private var rowTitles = ["Gender",
                             "Status",
                             "Species",
                             "Origin",
                             "Type",
                             "Location"]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setUI()
        setConstraints()
        
        let request = GetCharacter.Request()
        interactor?.getCharacter(request)
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        let cornerRadius = imageView.frame.size.height / 2
        imageView.layer.cornerRadius = cornerRadius
    }
    
    private func setUI() {
        let RMIcon = UIImage(.blackLogo)?.withRenderingMode(.alwaysOriginal)
        let rightBarButtonItem = UIBarButtonItem(image: RMIcon)
        rightBarButtonItem.isEnabled = false
        navigationItem.rightBarButtonItem = rightBarButtonItem
        navigationItem.leftItemsSupplementBackButton = true
        
        
        view.backgroundColor = .RMbackgroundColor
        
        let tapGesture = UITapGestureRecognizer(target: self,
                                                action: #selector(didTapCameraIcon))
        cameraIcon.addGestureRecognizer(tapGesture)
        
        characterDetailsTable.dataSource = self
        
        view.addSubviews(imageView,
                         cameraIcon,
                         nameLabel,
                         informationLabel,
                         characterDetailsTable)
    }
    
    private func setConstraints() {
        UIView.doNotTranslateAutoLayoutIntoConstraints(for: imageView,
                                                       cameraIcon,
                                                       nameLabel,
                                                       informationLabel,
                                                       characterDetailsTable)
        NSLayoutConstraint.activate([
            imageView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 60),
            imageView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            imageView.widthAnchor.constraint(equalToConstant: view.bounds.width * 0.4),
            imageView.heightAnchor.constraint(equalTo: imageView.widthAnchor),
            
            cameraIcon.leadingAnchor.constraint(equalTo: imageView.trailingAnchor, constant: 8),
            cameraIcon.centerYAnchor.constraint(equalTo: imageView.centerYAnchor),
            cameraIcon.widthAnchor.constraint(equalToConstant: 32),
            cameraIcon.heightAnchor.constraint(equalTo: cameraIcon.widthAnchor),
            
            nameLabel.topAnchor.constraint(equalTo: imageView.bottomAnchor, constant: 42),
            nameLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            
            informationLabel.topAnchor.constraint(equalTo: nameLabel.bottomAnchor, constant: 18),
            informationLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 24),
            
            characterDetailsTable.topAnchor.constraint(equalTo: informationLabel.bottomAnchor, constant: 16),
            characterDetailsTable.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 24),
            characterDetailsTable.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -24),
            characterDetailsTable.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor)
        ])
    }
    
    @objc private func didTapCameraIcon() {
        let title = "Загрузите изображение"
        let alert = UIAlertController(title: title,
                                      message: nil,
                                      preferredStyle: .actionSheet)
        let cancelAction = UIAlertAction(title: "Отмена",
                                         style: .cancel)
        let galleryAction = UIAlertAction(title: "Галерея",
                                          style: .default) { _ in self.galleryAction() }
        let cameraAction = UIAlertAction(title: "Камера",
                                         style: .default) { _ in self.showCamera() }

        alert.addAction(cancelAction)
        alert.addAction(galleryAction)
        alert.addAction(cameraAction)
        present(alert, animated: true)
    }
    
    private func galleryAction() {
        PHPhotoLibrary.requestAuthorization(for: .readWrite) { status in
            switch status {
            case .notDetermined:
                print(status)
            case .restricted:
                print(status)
            case .denied:
                let title = "Разрешить доступ к «Фото»?"
                let message = "Это необходимо для добавления ваших фотографий"
                self.showAllowmentAlert(title: title,
                                        message: message) {
                    self.goToApplicationSettings()
                }
            case .authorized, .limited:
                self.showImagePicker()
            @unknown default:
                print(status)
            }
        }
    }
    
    private func showAllowmentAlert(title: String, message: String, completion: @escaping () -> ()) {
        DispatchQueue.main.async {
            let alert = UIAlertController(title: title,
                                          message: message,
                                          preferredStyle: .alert)
            let cancelAction = UIAlertAction(title: "Отменить",
                                             style: .cancel)
            let allowAction = UIAlertAction(title: "Разрешить",
                                            style: .default) { _ in
                completion()
            }
           
            alert.addAction(cancelAction)
            alert.addAction(allowAction)
            self.present(alert, animated: true)
        }
    }
    
    private func goToApplicationSettings() {
            guard let url = URL(string: UIApplication.openSettingsURLString),
                    UIApplication.shared.canOpenURL(url)
            else {
                assertionFailure("Not able to open App privacy settings")
                return
            }
        DispatchQueue.main.async {
            UIApplication.shared.open(url)
        }
    }
    
    private func showImagePicker() {
        DispatchQueue.main.async {
            var config = PHPickerConfiguration(photoLibrary: .shared())
            config.filter = .images
            config.selectionLimit = 1
            
            let picker = PHPickerViewController(configuration: config)
            picker.delegate = self
            
            self.present(picker, animated: true)
        }
    }
    
    private func showCamera() {
        
    }
    
    deinit {
        print("deinit CharacterVC")
    }
}

extension CharacterVC: CharacterVCInput {
    func displayCharacter(_ viewModel: GetCharacter.ViewModel) {
        rowData = viewModel.infoFields
        imageView.image = viewModel.image
        nameLabel.text = viewModel.name
        
        characterDetailsTable.reloadData()
    }
}

extension CharacterVC: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        rowTitles.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: DetailCell.description(), for: indexPath) as! DetailCell
        
        let index = indexPath.row
        let title = rowTitles[index]
        let info = rowData[index]
        
        cell.configure(title: title, info: info)
        
        return cell
    }
}

extension CharacterVC: PHPickerViewControllerDelegate {
    func picker(_ picker: PHPickerViewController, didFinishPicking results: [PHPickerResult]) {
        
        results.first?.itemProvider.loadObject(ofClass: UIImage.self) { object, error in
            if let image = object as? UIImage {
                DispatchQueue.main.async {
                    self.imageView.image = image
                    
                    picker.dismiss(animated: true)
                }
            }
        }
    }
    
    
}

