//
//  TableViewModelDataSource.swift
//  Unicred
//
//  Created by Felipe Dias Pereira on 2020-03-27.
//  Copyright © 2020 Unicred. All rights reserved.
//

import UIKit

protocol SelfConstructedUITableViewCell {
  func makeCell(for tableView: UITableView, at indexPath: IndexPath) -> UITableViewCell?
}

final class TableViewModelDataSource<T: SelfConstructedUITableViewCell>: NSObject, UITableViewDataSource {
    private(set) var items: [[T]]

    init(items: [[T]]) {
        self.items = items
    }

    func update(with items: [[T]]) {
        self.items = items
    }

    private func numberOfRows(in section: Int) -> Int {
        guard items.indices.contains(section) else { return 0 }
        return items[section].count
    }

    private func numberOfSections() -> Int {
        return items.count
    }

    func getObject(at indexPath: IndexPath) -> T? {
        guard items.indices.contains(indexPath.section),
            items[indexPath.section].indices.contains(indexPath.row) else { return nil }
        return items[indexPath.section][indexPath.row]
    }

    func numberOfSections(in tableView: UITableView) -> Int {
        numberOfSections()
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        numberOfRows(in: section)
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let object = getObject(at: indexPath),
            let cell = object.makeCell(for: tableView, at: indexPath) {
            return cell
        }
        return UITableViewCell()
    }
}
