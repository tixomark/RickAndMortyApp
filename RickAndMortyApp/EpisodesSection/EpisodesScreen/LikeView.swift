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
    enum State { case selected, normal }
    
    private var isSelected: Bool = false {
        willSet {
            updateAccordingToState(newValue)
        }
    }
    weak var delegate: LikeViewDelegate?
    
    convenience init() {
        self.init(frame: .zero)
        self.backgroundColor = .green
        let tapGesture = UITapGestureRecognizer(target: self, 
                                                action: #selector(didTap))
        self.addGestureRecognizer(tapGesture)
    }
    
    override func updateConstraints() {
        super.updateConstraints()
    }
    
    private func updateAccordingToState(_ isSelected: Bool) {
        switch isSelected {
        case true:
            self.backgroundColor = .green
        case false:
            self.backgroundColor = .red
        }
    }
    
    @objc private func didTap() {
        isSelected.toggle()
        let state: State = isSelected ? .selected : .normal
        delegate?.likeView(self, switchedTo: state)
    }
    
    func setInitialState(_ isSelected: Bool) {
        self.isSelected = isSelected
    }
    
}
