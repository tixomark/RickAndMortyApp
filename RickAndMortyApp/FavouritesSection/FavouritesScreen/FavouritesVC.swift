//
//  FavouritesVC.swift
//  RickAndMortyApp
//
//  Created by Tixon Markin on 12.12.2023.
//

import Foundation
import UIKit

protocol FavouritesVCInput: AnyObject {
    func displayEpisodes(_ viewModel: FetchFavouriteEpisodes.ViewModel)
    func deleteEpisode(_ viewModel: DeleteEpisode.ViewModel)
    func addEpisode(_ viewModel: AddEpisode.ViewModel)
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
    
    private lazy var dataSource: FavouritesDataSource = createDataSource()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setUI()
        setConstraints()
        
        collection.dataSource = dataSource
        collection.register(EpisodeCell.self,
                            forCellWithReuseIdentifier: EpisodeCell.description())
        
        let request = FetchFavouriteEpisodes.Request()
        interactor?.fetchFavouriteEpisodes(request)
    }
    
    private func setUI() {
        navigationItem.backBarButtonItem = UIBarButtonItem(image: UIImage(.goBackIcon),
                                                           style: .plain,
                                                           target: nil,
                                                           action: nil)
        navigationItem.titleView = header
        
        self.view.backgroundColor = .RMbackgroundColor
        
        let estimatedCellSize: CGSize = .init(width: view.bounds.width - 48,
                                              height: 450)
        (collection.collectionViewLayout as? UICollectionViewFlowLayout)?.estimatedItemSize = estimatedCellSize
        
        view.addSubviews(collection)
        
    }
    
    private func setConstraints() {
        UIView.doNotTranslateAutoLayoutIntoConstraints(for: collection)
        NSLayoutConstraint.activate([
            collection.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
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
    func displayEpisodes(_ viewModel: FetchFavouriteEpisodes.ViewModel) {
        Task { @MainActor in
            self.episodes = viewModel.episodes
            
            var snapshot = NSDiffableDataSourceSnapshot<FavouritesSection, Episode>()
            snapshot.appendSections([.first])
            snapshot.appendItems(episodes, toSection: .first)
            dataSource.apply(snapshot, animatingDifferences: true)
        }
    }
    
    func deleteEpisode(_ viewModel: DeleteEpisode.ViewModel) {
        Task { @MainActor in
            let deletionIndex = episodes.firstIndex { episode in
                episode.id == viewModel.id
            }
            
            guard let deletionIndex else { return }
            let episodeToDelete = episodes.remove(at: deletionIndex)
            
            var snapshot = dataSource.snapshot()
            snapshot.deleteItems([episodeToDelete])
            dataSource.apply(snapshot, animatingDifferences: true)
        }
    }
    
    func addEpisode(_ viewModel: AddEpisode.ViewModel) {
        Task { @MainActor in
            episodes.append(viewModel.episode)
            var snapshot = dataSource.snapshot()
            snapshot.appendItems([viewModel.episode], toSection: .first)
            dataSource.apply(snapshot, animatingDifferences: false)
        }
    }
}

// MARK: Diffable Datasource methods
extension FavouritesVC {
    enum FavouritesSection {
        case first
    }
    
    typealias FavouritesDataSource = UICollectionViewDiffableDataSource<FavouritesSection, Episode>
    
    private func createDataSource() -> FavouritesDataSource {
        let dataSource = FavouritesDataSource(collectionView: collection) { collectionView, indexPath, itemIdentifier in
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: EpisodeCell.description(),
                                                          for: indexPath) as! EpisodeCell
            
            cell.configure(using: self.episodes[indexPath.item])
            cell.delegate = self
            
            return cell
        }
        return dataSource
    }
}

extension FavouritesVC: EpisodeCellDelegate {
    func didTapLikeButton(in cell: EpisodeCell, newState state: LikeView.State) {
        guard let index = collection.indexPath(for: cell)?.item,
              index < episodes.count
        else { return }
        
        let id = episodes[index].id
        
        let request = DeleteEpisode.Request(id: id)
        interactor?.deleteEpisode(request)
    }
    
    func didTapImage(inCell cell: EpisodeCell) {
        guard let index = collection.indexPath(for: cell)?.item,
              let character = episodes[index].character
        else { return }
        
        let request = FavouritesTapCharacter.Request(character: character, index: index)
        interactor?.didTapCharacter(request)
        
        coordinator?.showCharacterScreen()
    }
    
    
}

