//
//  CharacterVC.swift
//  RickAndMortyApp
//
//  Created by Tixon Markin on 12.12.2023.
//

import Foundation
import UIKit

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
        print("did ta camra icon")
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
        
        cell.configure(title: title,
                       info: info)
        
        return cell
    }
}
