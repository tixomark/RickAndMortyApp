//
//  EpisodeCell.swift
//  RickAndMortyApp
//
//  Created by Tixon Markin on 13.12.2023.
//

import UIKit

protocol EpisodeCellDelegate: AnyObject {
    func didTapImage(inCell cell: EpisodeCell)
}

class EpisodeCell: UICollectionViewCell {
    private var mainImageView: UIImageView = {
        let view = UIImageView()
        view.backgroundColor = .red
        view.layer.cornerRadius = 4
        view.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
        view.contentMode = .scaleAspectFill
        view.clipsToBounds = true
        view.isUserInteractionEnabled = true
        return view
    }()
    
    private var nameLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont(name: "Roboto-Medium", size: 30)
        label.numberOfLines = 0
        return label
    }()
    
    private var bottomView: UIView = {
        let view = UIView()
        view.layer.cornerRadius = 16
        view.backgroundColor = .RMsecondaryColor
        return view
    }()
    
    private var monitorImageView: UIImageView = {
        let icon = UIImage(.monitorIcon)
        let view = UIImageView(image: icon)
        view.backgroundColor = .clear
        view.contentMode = .scaleAspectFit
        view.clipsToBounds = true
        return view
    }()
    
    private var episodeLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont(name: "Inter-Regular", size: 16)
        label.numberOfLines = 0
        return label
    }()
    
    private var likeView = LikeView()
    
    weak var delegate: EpisodeCellDelegate?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setUI()
        setConstraints()
    }
    
    override func preferredLayoutAttributesFitting(_ layoutAttributes: UICollectionViewLayoutAttributes) -> UICollectionViewLayoutAttributes {
        
        setNeedsLayout()
        layoutIfNeeded()
        
        var size = contentView.systemLayoutSizeFitting(layoutAttributes.size,
                                                       withHorizontalFittingPriority: .required,
                                                       verticalFittingPriority: .fittingSizeLevel)
        
        size.height = size.height.rounded()
        layoutAttributes.frame.size = size
        return layoutAttributes
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setUI() {
        contentView.backgroundColor = .RMbackgroundColor
        contentView.layer.cornerRadius = 4
        contentView.layer.shadowOffset = CGSize(width: 0, height: 2)
        contentView.layer.shadowColor = UIColor.black.cgColor
        contentView.layer.shadowOpacity = 0.14
        contentView.layer.masksToBounds = false
        
        likeView.delegate = self
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(didTapOnImage))
        mainImageView.addGestureRecognizer(tapGesture)
        
        bottomView.addSubviews(monitorImageView, episodeLabel, likeView)
        contentView.addSubviews(mainImageView, nameLabel, bottomView)
    }
    
    private func setConstraints() {
        UIView.doNotTranslateAutoLayoutIntoConstraints(for:  mainImageView, nameLabel, bottomView, monitorImageView, episodeLabel, likeView, contentView)

        NSLayoutConstraint.activate([
            contentView.topAnchor.constraint(equalTo: self.topAnchor),
            contentView.leadingAnchor.constraint(equalTo: self.leadingAnchor),
            contentView.trailingAnchor.constraint(equalTo: self.trailingAnchor),
            contentView.bottomAnchor.constraint(equalTo: self.bottomAnchor),
            
            mainImageView.topAnchor.constraint(equalTo: contentView.topAnchor),
            mainImageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            mainImageView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            mainImageView.heightAnchor.constraint(equalTo: mainImageView.widthAnchor, multiplier: 0.75),
            
            nameLabel.topAnchor.constraint(equalTo: mainImageView.bottomAnchor, constant: 16),
            nameLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            nameLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
//            nameLabel.heightAnchor.constraint(equalToConstant: 54),
            
            bottomView.topAnchor.constraint(equalTo: nameLabel.bottomAnchor, constant: 16),
            bottomView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            bottomView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            bottomView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
            bottomView.heightAnchor.constraint(equalToConstant: 70),
            
            monitorImageView.topAnchor.constraint(equalTo: bottomView.topAnchor, constant: 16),
            monitorImageView.leadingAnchor.constraint(equalTo: bottomView.leadingAnchor, constant: 16),
            monitorImageView.bottomAnchor.constraint(equalTo: bottomView.bottomAnchor, constant: -16),
            monitorImageView.widthAnchor.constraint(equalTo: monitorImageView.heightAnchor),
            
            episodeLabel.leadingAnchor.constraint(equalTo: monitorImageView.trailingAnchor, constant: 10),
            episodeLabel.centerYAnchor.constraint(equalTo: monitorImageView.centerYAnchor),
            
            likeView.topAnchor.constraint(equalTo: bottomView.topAnchor, constant: 16),
            likeView.leadingAnchor.constraint(equalTo: episodeLabel.trailingAnchor, constant: 10),
            likeView.trailingAnchor.constraint(equalTo: bottomView.trailingAnchor, constant: -16),
            likeView.bottomAnchor.constraint(equalTo: bottomView.bottomAnchor, constant: -16),
            likeView.widthAnchor.constraint(equalTo: likeView.heightAnchor)
        ])
    }
    
    @objc private func didTapOnImage() {
        delegate?.didTapImage(inCell: self)
    }
    
    func configure(using episode: Episode) {
        mainImageView.image = episode.character?.image
        nameLabel.text = episode.character?.name
        let episodeText = episode.name + " | " + episode.episode
        episodeLabel.text = episodeText
        likeView.setInitialState(episode.isFavourite)
    }
}

extension EpisodeCell: LikeViewDelegate {
    func likeView(_ view: LikeView, switchedTo state: LikeView.State) {
        print(state)
    }
}
