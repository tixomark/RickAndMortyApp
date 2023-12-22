//
//  FilterView.swift
//  RickAndMortyApp
//
//  Created by Tixon Markin on 22.12.2023.
//

import Foundation
import UIKit

final class FilterView: UIView {
    private var filterIcon: UIImageView = {
        let view = UIImageView()
        view.image = UIImage(.filterIcon)
        view.backgroundColor = .clear
        view.contentMode = .scaleAspectFit
        view.clipsToBounds = true
        return view
    }()
    
    private var filterLabel: UILabel = {
        let label = UILabel()
        label.text = "ADVANCED FILTERS"
        label.font = UIFont(name: "Roboto-Medium", size: 14)
        label.textColor = .RMfilterTextColor
        label.textAlignment = .center
        return label
    }()
    
    convenience init() {
        self.init(frame: .zero)
        
        setUI()
        setConstraints()
    }
    
    private func setUI() {
        self.backgroundColor = .RMfilterBackgroundColor
        
        layer.cornerRadius = 4
        layer.shadowColor = UIColor.black.cgColor
        layer.shadowRadius = 2
        layer.shadowOpacity = 0.12
        layer.shadowOffset = CGSize(width: 0, height: 2)
        
        self.addSubviews(filterIcon, filterLabel)
    }
    
    private func setConstraints() {
        UIView.doNotTranslateAutoLayoutIntoConstraints(for: filterIcon, filterLabel)
        NSLayoutConstraint.activate([
            filterIcon.topAnchor.constraint(equalTo: self.topAnchor, constant: 21),
            filterIcon.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 21),
            filterIcon.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: -21),
            filterIcon.heightAnchor.constraint(equalToConstant: 12),
            filterIcon.widthAnchor.constraint(equalToConstant: 18),
            
            filterLabel.topAnchor.constraint(equalTo: self.topAnchor, constant: 16),
            filterLabel.centerXAnchor.constraint(equalTo: self.centerXAnchor),
            filterLabel.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: -16)
        ])
    }
}
