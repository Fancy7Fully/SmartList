//
//  ViewController.swift
//  SmartList
//
//  Created by Zhiyuan Zhou on 10/1/23.
//

import UIKit
import Combine

class ViewController: UITableViewController {
  
  let viewModel = ViewModel()
  var sub: Cancellable?
  
  enum Operation {
    case updateAll
    case update(rows: [IndexPath])
    case delete(rows: [IndexPath])
  }
  
  class ViewModel {
    var items = MockModel().items
    var data: CurrentValueSubject<Operation, Never> = CurrentValueSubject(.updateAll)
    
    func deleteRowAt(_ index: Int) {
      items.remove(at: index)
      data.send(.delete(rows: [IndexPath(row: index, section: 0)]))
    }
    
    var rowNumber: Int {
      items.count
    }
  }
  
  override func viewDidLoad() {
    super.viewDidLoad()
    // Do any additional setup after loading the view.
    view.backgroundColor = .gray
    tableView.dataSource = self
    tableView.delegate = self
    tableView.backgroundColor = .white
    tableView.rowHeight = UITableView.automaticDimension
    tableView.estimatedRowHeight = 500
    
    self.title = "a title"
    self.tableView.register(ItemCell.self, forCellReuseIdentifier: "cell")
//    self.navigationItem.leftBarButtonItem = self.editButtonItem
    sub = viewModel.data.sink(receiveCompletion: { [weak self] completion in
      guard let self = self else { return }
      sub?.cancel()
    }, receiveValue: { [weak self]  operation in
      guard let self = self else { return }
      switch operation {
        case .update(let rows):
          tableView.reconfigureRows(at: rows)
        case .updateAll:
          tableView.reloadData()
        case .delete(let rows):
          tableView.deleteRows(at: rows, with: .automatic)
          tableView.reloadData()
      }
    })
    
    
    

  }
  
  override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return viewModel.rowNumber
  }
  
  override func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
    let label = UILabel(frame: .zero)
    label.backgroundColor = .red
    label.textColor = .blue
    label.text = "Title"
    return label
  }
  
  override func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
    let action = UIContextualAction(style: .normal, title: "Normal") { action, view, completion in
      completion(true)
    }
    let action2 = UIContextualAction(style: .destructive, title: "Destructive") { [weak self] action, view, completion in
      guard let self = self else { return }
      viewModel.deleteRowAt(indexPath.row)
      completion(true)
    }
    let configuration = UISwipeActionsConfiguration(actions: [action, action2])
    return configuration
  }
  
  override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    if let cell = tableView.dequeueReusableCell(withIdentifier: "cell") as? ItemCell {
      cell.updateWithItem(item: viewModel.items[indexPath.row], index: indexPath.row)
      cell.contentView.backgroundColor = .white
      cell.controller = self
      cell.delegate = viewModel
      
      return cell
    }
    
    let cell = ItemCell(style: .default, reuseIdentifier: "cell")
    cell.updateWithItem(item: viewModel.items[indexPath.row], index: indexPath.row)
    cell.contentView.backgroundColor = .white
    cell.controller = self
    cell.delegate = viewModel
    
    return cell
  }

}

extension ViewController.ViewModel: ItemCellDelegate {
  func cellDidUpdateText(text: String, index: Int) {
    items[index] = Item(name: text)
    data.send(.update(rows: [IndexPath(row: index, section: 0)]))
  }
}

struct MockModel {
  var items: [Item] = [
    Item(name: "HamburgerHamburgerHamburgerHamburgerHamburgerHamburgerHamburgerHamburgerHamburgerHamburgerHamburgerHamburgerHamburgerHamburgerHamburgerHamburgerHamburgerHamburgerHamburgerHamburgerHamburgerHamburgerHamburgerHamburgerHamburgerHamburgerHamburgerHamburgerHamburger"),
    Item(name: "Brocolli"),
    Item(name: "Cheese"),
    Item(name: "Iron"),
    Item(name: "Hamburger"),
    Item(name: "Brocolli"),
    Item(name: "Cheese"),
    Item(name: "Iron"),
    Item(name: "Hamburger"),
    Item(name: "Brocolli"),
    Item(name: "Cheese"),
    Item(name: "Iron"),
    Item(name: "Hamburger"),
    Item(name: "Brocolli"),
    Item(name: "Cheese"),
    Item(name: "Iron"),
    Item(name: "Hamburger"),
    Item(name: "Brocolli"),
    Item(name: "Cheese"),
    Item(name: "Iron"),
    Item(name: "Hamburger"),
    Item(name: "Brocolli"),
    Item(name: "Cheese"),
    Item(name: "Iron")
  ]
}

struct Item {
  var name: String
}
