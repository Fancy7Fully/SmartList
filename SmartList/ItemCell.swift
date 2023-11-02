//
//  ItemCell.swift
//  SmartList
//
//  Created by Zhiyuan Zhou on 10/1/23.
//

import Foundation
import UIKit

class ItemCell: UITableViewCell {
    var image: UIImageView = UIImageView()
    lazy var titleLabel = {
        let label = UITextView(frame: .zero)
        label.font = .systemFont(ofSize: 18)
        return label
    }()
    
    var subtitle: UILabel = UILabel()
    var indexPath: IndexPath!
    var isFlagged: Bool = false
    
    lazy var flagImageView = {
        let flagImageView = UIImageView()
        flagImageView.image = .init(systemName: "flag.fill")?.withTintColor(.orange)
        flagImageView.isHidden = true
        return flagImageView
    }()
    weak var controller: UITableViewController?
    
    var delegate: ItemCellDelegate?
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: .default, reuseIdentifier: "c")
        setupView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func updateConstraints() {
        
        NSLayoutConstraint.activate([
            image.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            image.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 8),
            image.widthAnchor.constraint(equalToConstant: 24),
            image.heightAnchor.constraint(equalToConstant: 24),
            flagImageView.heightAnchor.constraint(equalToConstant: 24),
            flagImageView.widthAnchor.constraint(equalToConstant: 24),
            flagImageView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 8),
            flagImageView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            titleLabel.leadingAnchor.constraint(equalTo: image.trailingAnchor, constant: 8),
            titleLabel.topAnchor.constraint(equalTo: image.topAnchor),
            titleLabel.trailingAnchor.constraint(equalTo: flagImageView.leadingAnchor, constant: -16),
            subtitle.leadingAnchor.constraint(equalTo: titleLabel.leadingAnchor),
            subtitle.topAnchor.constraint(equalTo: titleLabel.bottomAnchor),
            subtitle.bottomAnchor.constraint(equalTo: contentView.bottomAnchor)
        ])
        
        super.updateConstraints()
    }
    
    private func setupView() {
        titleLabel.textColor = .black
        subtitle.textColor = .gray
        titleLabel.textContainer.lineBreakMode = .byWordWrapping
        titleLabel.isScrollEnabled = false
        titleLabel.backgroundColor = .green
        titleLabel.delegate = self
        subtitle.numberOfLines = 1
        image.translatesAutoresizingMaskIntoConstraints = false
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        subtitle.translatesAutoresizingMaskIntoConstraints = false
        flagImageView.translatesAutoresizingMaskIntoConstraints = false
        
        contentView.addSubview(image)
        contentView.addSubview(titleLabel)
        contentView.addSubview(subtitle)
        contentView.addSubview(flagImageView)
        
        updateConstraints()
        image.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(didTapOnImage)))
        image.isUserInteractionEnabled = true
    }
    
    @objc private func didTapOnImage() {
        UIView.transition(with: self.image, duration: 0.2, options: .transitionCrossDissolve) {
            [weak self] in
                guard let self = self else { return }
                self.image.image = .init(systemName: "checkmark.square.fill")
        } completion: { [weak self] _ in
            guard let self = self else { return }
            delegate?.didSelectChecker(self, indexPath: self.indexPath)
        }
    }
    
    func updateWithItem(item: Item, indexPath: IndexPath) {
        self.indexPath = indexPath
        titleLabel.text = item.name
        subtitle.text = "subtitle is here"
        switch item.state {
            case .checked:
                image.image = .init(systemName: "checkmark.square.fill")
            case .unchecked:
                image.image = .init(systemName: "square")
        }
        
        self.setNeedsUpdateConstraints()
        self.updateConstraintsIfNeeded()
    }
}

extension ItemCell: UITextViewDelegate {
    func textViewDidBeginEditing(_ textView: UITextView) {
        delegate?.cellWillUpdateText(self, indexPath: indexPath)
    }
    
    func textViewDidChange(_ textView: UITextView) {
        self.setNeedsUpdateConstraints()
        self.updateConstraintsIfNeeded()
        delegate?.cellDidUpdateText(self, text: textView.text, indexPath: indexPath)
    }
    
    func textViewDidEndEditing(_ textView: UITextView) {
        delegate?.cellDidEndUpdatingText(self, indexPath: indexPath, text: textView.text)
    }
}

protocol ItemCellDelegate {
    func cellDidUpdateText(_ cell: ItemCell, text: String, indexPath: IndexPath)
    func cellWillUpdateText(_ cell: ItemCell, indexPath: IndexPath)
    func didSelectChecker(_ cell: ItemCell, indexPath: IndexPath)
    func cellDidEndUpdatingText(_ cell: ItemCell, indexPath: IndexPath, text: String)
}
