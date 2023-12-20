//
//  FavouritesVC.swift
//  RickAndMortyApp
//
//  Created by Tixon Markin on 12.12.2023.
//

import Foundation
import UIKit

protocol FavouritesVCInput: AnyObject {
    func displayFavouriteEpisodes(_ viewModel: FetchFavouriteEpisodes.ViewModel)
}

final class FavouritesVC: UIViewController {
    private var header: UILabel = {
        let label = UILabel()
        label.font = UIFont(name: "Karla-Bold",
                            size: 24)
        label.text = "Favourite Episodes"
        label.numberOfLines = 1
        return label
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
    
    private var episodes: [Episode] = []
    
    var interactor: FavouritesInteractorInput?
    weak var coordinator: FavouritesCoordinatorInput?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setUI()
        setConstraints()
        
        collection.dataSource = self
        collection.delegate = self
        collection.register(EpisodeCell.self,
                            forCellWithReuseIdentifier: EpisodeCell.description())
        
        let request = FetchFavouriteEpisodes.Request()
        interactor?.fetchFavouriteEpisodes(request)
    }
    
    private func setUI() {
        self.view.backgroundColor = .RMbackgroundColor
        
        let estimatedCellSize: CGSize = .init(width: view.bounds.width - 48,
                                      height: 450)
        (collection.collectionViewLayout as? UICollectionViewFlowLayout)?.estimatedItemSize = estimatedCellSize
        
        view.addSubviews(header, collection)
        
    }
    
    private func setConstraints() {
        UIView.doNotTranslateAutoLayoutIntoConstraints(for: header, collection)
        NSLayoutConstraint.activate([
            header.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: -10),
            header.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            
            collection.topAnchor.constraint(equalTo: header.bottomAnchor, constant: 29),
            collection.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            collection.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            collection.trailingAnchor.constraint(equalTo: view.trailingAnchor)
        ])
    }
    
    deinit {
        print("deinit FavouritesVC")
    }
}

extension FavouritesVC: FavouritesVCInput {
    func displayFavouriteEpisodes(_ viewModel: FetchFavouriteEpisodes.ViewModel) {
        self.episodes = viewModel.episodes
        Task { @MainActor in
            collection.reloadData()
        }
    }
    
    
}

extension FavouritesVC: UICollectionViewDelegateFlowLayout , UICollectionViewDataSource {
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

extension FavouritesVC: EpisodeCellDelegate {
    func didTapLikeButton(in cell: EpisodeCell, newState state: LikeView.State) {
        
    }
    
    func didTapImage(inCell cell: EpisodeCell) {
        guard let index = collection.indexPath(for: cell)?.item,
              let character = episodes[index].character
        else { return }
        
        coordinator?.showCharacterScreen()
    }
    
    
}

