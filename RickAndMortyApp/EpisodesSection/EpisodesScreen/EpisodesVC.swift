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
    func displayDeselectLikeButton(_ viewModel: DeselectLikeButton.ViewModel)
}

final class EpisodesVC: UIViewController {
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
        layout.sectionInset = UIEdgeInsets(top: 8,
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
    
    private var searchView = SearchView()
    private var filterView = FilterView()
    
    private var episodes: [Episode] = []
    private var isWaitingForUpdate = true
    private var isLastPageReached = false
    private var filterType: NetworkService.QueryType = .name
    
    var interactor: EpisodesInteractorInput?
    weak var coordinator: EpisodesCoordinatorInput?

    override func viewDidLoad() {
        super.viewDidLoad()
        
        setUI()
        setConstraints()
        collection.dataSource = self
        collection.delegate = self
        collection.register(EpisodeCell.self,
                            forCellWithReuseIdentifier: EpisodeCell.description())
        
        searchView.delegate = self
        
        let request = FetchEpisodes.Request()
        interactor?.fetchEpisodes(request)
    }
    
    private func setUI() {
//        let backImage = UIImage(.arrowBackIcon)
//        self.navigationController?.navigationBar.backIndicatorImage = backImage
//        self.navigationController?.navigationBar.backIndicatorTransitionMaskImage = backImage
        
        self.view.backgroundColor = .RMbackgroundColor
        navigationItem.backBarButtonItem = UIBarButtonItem(image: UIImage(.goBackIcon),
                                                           style: .plain,
                                                           target: nil,
                                                           action: nil)
        let estimatedCellSize: CGSize = .init(width: view.bounds.width - 48,
                                      height: 450)
        (collection.collectionViewLayout as? UICollectionViewFlowLayout)?.estimatedItemSize = estimatedCellSize
        
        let tapGesture = UITapGestureRecognizer(target: self,
                                                action: #selector(didTapFilter))
        filterView.addGestureRecognizer(tapGesture)
        
        view.addSubviews(headerImage, collection, searchView, filterView)
    }
    
    private func setConstraints() {
        UIView.doNotTranslateAutoLayoutIntoConstraints(for: headerImage, collection, searchView, filterView)
        NSLayoutConstraint.activate([
            headerImage.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: -10),
            headerImage.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 24),
            headerImage.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -24),
            
            searchView.topAnchor.constraint(equalTo: headerImage.bottomAnchor, constant: 16),
            searchView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 24),
            searchView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -24),
            
            filterView.topAnchor.constraint(equalTo: searchView.bottomAnchor, constant: 12),
            filterView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 24),
            filterView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -24),
            
            collection.topAnchor.constraint(equalTo: filterView.bottomAnchor, constant: 8),
            collection.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            collection.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            collection.trailingAnchor.constraint(equalTo: view.trailingAnchor)
        ])
    }
    
    @objc private func didTapFilter() {
        let alert = UIAlertController(title: "Выберите поле для поиска",
                                      message: nil,
                                      preferredStyle: .actionSheet)
        let cancelAction = UIAlertAction(title: "Название эпизода",
                                         style: .default) {_ in self.filterType = .name }
        let allowAction = UIAlertAction(title: "Номер эпизода",
                                        style: .default) {_ in self.filterType = .episode }
       
        alert.addAction(cancelAction)
        alert.addAction(allowAction)
        self.present(alert, animated: true) {
            self.searchView.refreshText()
        }
    }
    
    deinit {
        print("deinit EpisodesVC")
    }
    
}

extension EpisodesVC: EpisodesVCInput {
    func displayFetchedEpisodes(_ viewModel: FetchEpisodes.ViewModel) {
        self.isLastPageReached = viewModel.lastPage
        
        let startIndex = self.episodes.count
        let endIndex = startIndex + viewModel.episodes.count - 1
        
        var indexesToInsert = [IndexPath]()
        for index in startIndex...endIndex {
            indexesToInsert.append(IndexPath(item: index, section: 0))
        }
        
        
            self.episodes += viewModel.episodes
        

        Task { @MainActor in
            self.collection.insertItems(at: indexesToInsert)
            self.isWaitingForUpdate = false
        }
    }
    
    func displayDeselectLikeButton(_ viewModel: DeselectLikeButton.ViewModel) {
        let episodeID = viewModel.episodeID
        
        guard let episodeIndex = episodes.firstIndex(where: { episode in
            episode.id == episodeID
        })
        else { return }
        
        let indexPathToUpdate = IndexPath(item: episodeIndex, section: 0)
        
        Task { @MainActor in
            episodes[episodeIndex].isFavourite = false
            collection.reloadItems(at: [indexPathToUpdate])
        }
    }
    
}

extension EpisodesVC: UICollectionViewDelegateFlowLayout, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        episodes.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: EpisodeCell.description(), for: indexPath) as! EpisodeCell
        
        cell.configure(using: episodes[indexPath.item])
        cell.delegate = self
        
        return cell
    }
   
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        guard !isWaitingForUpdate && !isLastPageReached
        else { return }
        
        let height = scrollView.frame.size.height
            let contentYOffset = scrollView.contentOffset.y
            let distanceFromBottom = scrollView.contentSize.height - contentYOffset
     
        if distanceFromBottom < height + 2000 {
            isWaitingForUpdate = true
            let request = FetchEpisodes.Request(nextPage: true)
            interactor?.fetchEpisodes(request)
        }
    }
}

extension EpisodesVC: EpisodeCellDelegate {
    func didTapLikeButton(in cell: EpisodeCell, newState state: LikeView.State) {
        guard let index = collection.indexPath(for: cell)?.item
        else { return }
        
        episodes[index].isFavourite = (state == .selected)
        let episode = episodes[index]
        
        let request = TapLikeButton.Request(episode: episode, state: state)
        interactor?.didTapLike(request)
    }
    
    func didTapImage(inCell cell: EpisodeCell) {
        guard let index = collection.indexPath(for: cell)?.item,
              let character = episodes[index].character
        else { return }
        
        let request = TapCharacter.Request(character: character, index: index)
        interactor?.didTapCharacter(request)
        
        coordinator?.showCharacterScreen()
    }
}

extension EpisodesVC: SearchViewDelegate {
    func textDidChangeIn(_ searchView: SearchView, toValue text: String) {
        guard text != ""
        else { return }
        
//
//        let request = QueryEpisodes.Request(type: filterType, query: text)
//        interactor?.queryEpisodes(request)
    }
}
