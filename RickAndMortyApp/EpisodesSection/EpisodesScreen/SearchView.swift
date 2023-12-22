//
//  SearchView.swift
//  RickAndMortyApp
//
//  Created by Tixon Markin on 21.12.2023.
//

import Foundation
import UIKit

protocol SearchViewDelegate: AnyObject {
    func textDidChangeIn(_ searchView: SearchView, toValue text: String)
}

final class SearchView: UIView {
    private var searchIcon: UIImageView = {
        let view = UIImageView()
        view.image = UIImage(.searchIcon)
        view.backgroundColor = .clear
        view.contentMode = .scaleAspectFit
        view.clipsToBounds = true
        return view
    }()
    
    private var searchField: UITextField = {
        let field = UITextField()
        field.placeholder = "Name or episode (ex.S01E01)..."
        field.font = UIFont(name: "Roboto-Regular", size: 16)
        field.textColor = .gray
        field.returnKeyType = .done
        return field
    }()
    
    weak var delegate: SearchViewDelegate?
    
    convenience init() {
        self.init(frame: .zero)
        setUI()
        setConstraints()
        
        searchField.delegate = self
    }
    
    func refreshText() {
        searchField.text = nil
    }
    
    private func setUI() {
        layer.cornerRadius = 8
        layer.borderWidth = 1
        layer.borderColor = UIColor.gray.cgColor
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(didTapSearch))
        self.addGestureRecognizer(tapGesture)
        
        searchField.addTarget(self, action: #selector(editingChanged(_:)), for: .editingChanged)
        
        self.addSubviews(searchIcon, searchField)
    }
    
    private func setConstraints() {
        UIView.doNotTranslateAutoLayoutIntoConstraints(for: searchIcon, searchField)

        NSLayoutConstraint.activate([
            searchIcon.topAnchor.constraint(equalTo: self.topAnchor, constant: 16),
            searchIcon.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 16),
            searchIcon.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: -16),
            searchIcon.heightAnchor.constraint(equalToConstant: 24),
            searchIcon.widthAnchor.constraint(equalToConstant: 24),
            
            searchField.topAnchor.constraint(equalTo: self.topAnchor, constant: 16),
            searchField.leadingAnchor.constraint(equalTo: searchIcon.trailingAnchor, constant: 8),
            searchField.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -16),
            searchField.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: -16)
        ])
    }
    
    @objc private func didTapSearch() {
        searchField.becomeFirstResponder()
    }
    
    @objc private func editingChanged(_ sender: UITextField) {
        guard let text = sender.text
        else { return }
        
        delegate?.textDidChangeIn(self, toValue: text)
    }
    
}

extension SearchView: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
}
