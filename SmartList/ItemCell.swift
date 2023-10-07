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
  var titleLabel = UITextView(frame: .zero)
  var subtitle: UILabel = UILabel()
  var index: Int!
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
      titleLabel.leadingAnchor.constraint(equalTo: image.trailingAnchor, constant: 8),
      titleLabel.topAnchor.constraint(equalTo: image.topAnchor),
      titleLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
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
//    titleLabel.numberOfLines = 0
    subtitle.numberOfLines = 1
    image.translatesAutoresizingMaskIntoConstraints = false
    titleLabel.translatesAutoresizingMaskIntoConstraints = false
    subtitle.translatesAutoresizingMaskIntoConstraints = false
    
    self.contentView.addSubview(image)
    self.contentView.addSubview(titleLabel)
    self.contentView.addSubview(subtitle)
    
    updateConstraints()
  }
  
  func updateWithItem(item: Item, index: Int) {
    self.index = index
    titleLabel.text = item.name
    subtitle.text = "subtitle is here"
    image.image = .init(systemName: "square")
    
    self.setNeedsUpdateConstraints()
    self.updateConstraintsIfNeeded()
  }
}

extension ItemCell: UITextViewDelegate {
  func textViewDidChange(_ textView: UITextView) {
    self.setNeedsUpdateConstraints()
    self.updateConstraintsIfNeeded()
    delegate?.cellDidUpdateText(text: textView.text, index: index)
  }
}

protocol ItemCellDelegate {
  func cellDidUpdateText(text: String, index: Int)
}
