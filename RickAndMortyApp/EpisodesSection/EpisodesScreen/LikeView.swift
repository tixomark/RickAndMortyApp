//
//  LikeView.swift
//  RickAndMortyApp
//
//  Created by Tixon Markin on 13.12.2023.
//

import Foundation
import UIKit

protocol LikeViewDelegate: AnyObject {
    func likeView(_ view: LikeView, switchedTo state: LikeView.State)
}

class LikeView: UIView {
    private var imageView: UIImageView = {
        let view = UIImageView()
        view.contentMode = .scaleAspectFit
        view.clipsToBounds = true
        view.isUserInteractionEnabled = true
        return view
    }()
    
    enum State {
        case selected, normal
    }
    
    private var isSelected: Bool = false
    weak var delegate: LikeViewDelegate?
    
    convenience init() {
        self.init(frame: .zero)
        self.backgroundColor = .clear
        let tapGesture = UITapGestureRecognizer(target: self,
                                                action: #selector(didTap))
        self.addGestureRecognizer(tapGesture)
        
        self.addSubviews(imageView)
        imageView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            imageView.topAnchor.constraint(equalTo: self.topAnchor),
            imageView.leadingAnchor.constraint(equalTo: self.leadingAnchor),
            imageView.trailingAnchor.constraint(equalTo: self.trailingAnchor),
            imageView.bottomAnchor.constraint(equalTo: self.bottomAnchor)
        ])
    }
 
    override func hitTest(_ point: CGPoint, with event: UIEvent?) -> UIView? {
        var rect = self.bounds.insetBy(dx: -40, dy: -40)
        if rect.contains(point) {
            return imageView
        }
        return nil
    }
    
    private func animateAccordingToState() {
        switch isSelected {
        case true:
            UIView.animate(withDuration: 0.2, delay: 0, options: .curveEaseIn) {
                self.imageView.transform = CGAffineTransformMakeScale(0.7, 0.7)
                self.imageView.alpha = 0
            } completion: { _ in
                UIView.animate(withDuration: 0.1, delay: 0, options: .curveEaseOut) {
                    self.imageView.image = UIImage(.likedIcon)
                    self.imageView.transform = .identity
                    self.imageView.alpha = 1
                }
            }
        case false:
            UIView.animate(withDuration: 0.2, delay: 0, options: .curveEaseOut) {
                self.imageView.transform = CGAffineTransformMakeScale(1.5, 1.5)
                self.imageView.alpha = 0
            } completion: { _ in
                UIView.animate(withDuration: 0.1, delay: 0, options: .curveEaseOut) {
                    self.imageView.image = UIImage(.unlikedIcon)
                    self.imageView.transform = .identity
                    self.imageView.alpha = 1
                }
            }
        }
    }
    
    @objc private func didTap() {
        isSelected.toggle()
        let state: State = isSelected ? .selected : .normal
        animateAccordingToState()
        delegate?.likeView(self, switchedTo: state)
    }
    
    func setInitialState(_ isSelected: Bool) {
        self.isSelected = isSelected
        let newImage = UIImage(isSelected ? .likedIcon : .unlikedIcon)
        imageView.image = newImage
    }
    
}
