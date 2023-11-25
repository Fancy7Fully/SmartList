//
//  ViewController.swift
//  SmartList
//
//  Created by Zhiyuan Zhou on 10/1/23.
//

import UIKit
import Combine

class TodoListViewController: UITableViewController {
    
    let viewModel = ViewModel()
    var sub: Cancellable?
    var focusSub: Cancellable?
    
    enum Operation {
        case updateAll
        case update(rows: [IndexPath])
        case delete(rows: [IndexPath])
    }
    
    class ViewModel {
        var items = DataManager.shared.modelFromDatabase().items
        var data: CurrentValueSubject<Operation, Never> = CurrentValueSubject(.updateAll)
        var focusedIndexPath = PassthroughSubject<IndexPath, Never>()
        
        func deleteRowAt(_ index: Int) {
            items.remove(at: index)
            data.send(.delete(rows: [IndexPath(row: index, section: 0)]))
        }
        
        var rowNumber: Int {
            items.count
        }
        
        func flushData() {
            for item in items {
                DataManager.shared.updateRow(itemId: item.id, item: item)
                
            }
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
        
        focusSub = viewModel.focusedIndexPath.sink(receiveCompletion: { [weak self] completion in
            guard let self = self else { return }
            focusSub?.cancel()
        }, receiveValue: { [weak self] indexPath in
            guard let self = self else { return }
            self.tableView.scrollToRow(at: indexPath, at: .top, animated: true)
        })
        
        NotificationCenter.default.addObserver(self, selector: #selector(appWillBeTerminated), name: UIApplication.willTerminateNotification, object: nil)
        Task {
            let manager = OpenAIManager()
            let result = await manager.requestWithRequest(request: "what are the ingredients for caesar salad?")
            print(result)
        }
    }
    
    @objc private func appWillBeTerminated() {
        viewModel.flushData()
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
        let flagAction = UIContextualAction(style: .normal, title: "Flag") { action, view, completion in
            completion(true)
        }
        flagAction.backgroundColor = .orange
        
        let action2 = UIContextualAction(style: .destructive, title: "Destructive") { [weak self] action, view, completion in
            guard let self = self else { return }
            viewModel.deleteRowAt(indexPath.row)
            completion(true)
        }
        let configuration = UISwipeActionsConfiguration(actions: [action2, flagAction])
        return configuration
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.scrollToRow(at: indexPath, at: .top, animated: true)
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let cell = tableView.dequeueReusableCell(withIdentifier: "cell") as? ItemCell {
            cell.updateWithItem(item: viewModel.items[indexPath.row], indexPath: indexPath)
            cell.contentView.backgroundColor = .white
            cell.controller = self
            cell.delegate = viewModel
            cell.selectionStyle = .none
            
            return cell
        }
        
        let cell = ItemCell(style: .default, reuseIdentifier: "cell")
        cell.updateWithItem(item: viewModel.items[indexPath.row], indexPath: indexPath)
        cell.contentView.backgroundColor = .white
        cell.controller = self
        cell.delegate = viewModel
        cell.selectionStyle = .none
        
        return cell
    }
    
}

extension TodoListViewController.ViewModel: ItemCellDelegate {
    func cellDidUpdateText(_ cell: ItemCell, text: String, indexPath: IndexPath) {
        items[indexPath.row].name = text
        data.send(.update(rows: [indexPath]))
    }
    
    func cellWillUpdateText(_ cell: ItemCell, indexPath: IndexPath) {
        focusedIndexPath.send(indexPath)
    }
    
    func didSelectChecker(_ cell: ItemCell, indexPath: IndexPath) {
        items[indexPath.row].state.toggle()
        data.send(.update(rows: [indexPath]))
    }
    func cellDidEndUpdatingText(_ cell: ItemCell, indexPath: IndexPath, text: String) {
        items[indexPath.row].name = text
        DataManager.shared.updateRow(itemId: items[indexPath.row].id, item: items[indexPath.row])
    }
}

struct Model {
    var items: [Item]
}

struct Item {
    var id: Int = 0
    enum State: Int {
        case unchecked = 0
        case checked
        
        mutating func toggle() {
            switch self {
                case .unchecked:
                    self = .checked
                case .checked:
                    self = .unchecked
            }
        }
    }
    var name: String
    var state: State = .unchecked
}
