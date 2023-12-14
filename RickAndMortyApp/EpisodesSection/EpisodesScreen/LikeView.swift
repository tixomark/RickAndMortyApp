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
    
    private var isSelected: Bool = false
    
    weak var delegate: LikeViewDelegate?
    
//    override var intrinsicContentSize: CGSize {
//        CGSize(width: 40, height: 40)
//    }
    
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
    
    private func updateAccordingToState(_ state: State) {
        switch state {
        case .normal:
            self.backgroundColor = .green
        case .selected:
            self.backgroundColor = .red
        }
    }
    
    @objc private func didTap() {
        isSelected.toggle()
        let state: State = isSelected ? .selected : .normal
        updateAccordingToState(state)
        delegate?.likeView(self, switchedTo: state)
    }
    
}
