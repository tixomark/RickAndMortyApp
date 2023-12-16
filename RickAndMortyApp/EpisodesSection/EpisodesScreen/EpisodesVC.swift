//
//  EpisodesVC.swift
//  RickAndMortyApp
//
//  Created by Tixon Markin on 12.12.2023.
//

import Foundation
import UIKit

protocol EpisodesVCInput: AnyObject {
    func displayFetchedEpisodes(_ viewModel: FetchEpisodes.ViewModel)
}

final class EpisodesVC: UIViewController {
    var interactor: EpisodesInteractorInput?
    weak var coordinator: EpisodesCoordinatorInput?
    
    private var headerImage: UIImageView = {
        let image = UIImage(.header)
        let view = UIImageView(image: image)
        view.backgroundColor = .RMbackgroundColor
        view.contentMode = .scaleAspectFit
        view.clipsToBounds = true
        return view
    }()
    
    private var collection: UICollectionView = {
        let spaceing: CGFloat = 16
        let inset: CGFloat = 24
        
        let layout = UICollectionViewFlowLayout()
        layout.minimumInteritemSpacing = spaceing
        layout.minimumLineSpacing = spaceing
        layout.sectionInset = UIEdgeInsets(top: inset,
                                           left: inset,
                                           bottom: inset,
                                           right: inset)
        
        let collection = UICollectionView(frame: .zero,
                                          collectionViewLayout: layout)
        collection.showsHorizontalScrollIndicator = false
        collection.showsVerticalScrollIndicator = false
        collection.backgroundColor = .RMbackgroundColor
        return collection
    }()
    
    private var cellSize: CGSize!
    private var episodes: [Episode] = []

    override func viewDidLoad() {
        super.viewDidLoad()
        
        setUI()
        collection.dataSource = self
        collection.delegate = self
        collection.register(EpisodeCell.self,
                            forCellWithReuseIdentifier: EpisodeCell.description())
        
        let request = FetchEpisodes.Request()
        interactor?.fetchEpisodes(request)
    }
    
    private var isLayoutCreated = false
    override func updateViewConstraints() {
        defer { super.updateViewConstraints() }
        if !isLayoutCreated {
            isLayoutCreated = true
            setConstraints()
        }
    }
    
    private func setUI() {
        self.view.backgroundColor = .rmBackground
        let estimatedCellSize: CGSize = .init(width: view.bounds.width - 48,
                                      height: UIView.layoutFittingExpandedSize.height)
        (collection.collectionViewLayout as? UICollectionViewFlowLayout)?.estimatedItemSize = estimatedCellSize
        view.addSubviews(headerImage, collection)
        
    }
    
    private func setConstraints() {
        UIView.doNotTranslateAutoLayoutIntoConstraints(for: headerImage, collection)
        NSLayoutConstraint.activate([
            headerImage.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 8),
            headerImage.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 24),
            headerImage.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -24),
            
            collection.topAnchor.constraint(equalTo: headerImage.bottomAnchor, constant: 16),
            collection.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            collection.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            collection.trailingAnchor.constraint(equalTo: view.trailingAnchor)
        ])
    }
    
    deinit {
        print("deinit EpisodesVC")
    }
}

extension EpisodesVC: EpisodesVCInput {
    func displayFetchedEpisodes(_ viewModel: FetchEpisodes.ViewModel) {
        self.episodes = viewModel.episodes
        Task { @MainActor in
            collection.reloadData()
        }
    }
    
    
}

extension EpisodesVC: UICollectionViewDelegateFlowLayout , UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        episodes.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: EpisodeCell.description(), for: indexPath) as! EpisodeCell
        
        cell.configure(using: episodes[indexPath.item])
        cell.delegate = self
        
        return cell
    }
}

extension EpisodesVC: EpisodeCellDelegate {
    func didTapImage(inCell cell: EpisodeCell) {
        guard let index = collection.indexPath(for: cell)?.item,
              let character = episodes[index].character
        else { return }
        
        coordinator?.showCharacterModule(character)
    }
    
    
}
