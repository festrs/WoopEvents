//
//  HomeTableViewController.swift
//  WoopEvents
//
//  Created by Felipe Dias Pereira on 2019-05-30.
//  Copyright © 2019 FelipeP. All rights reserved.
//

import UIKit
import Kingfisher

final class HomeTableViewController: UITableViewController {
    private enum Constants {
        static let tableViewCellHeight: CGFloat = 138.0
    }

    let viewModel: HomeViewModelProtocol
    private lazy var errorLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .center
        label.numberOfLines = 0
        label.isHidden = true
        label.text = viewModel.emptyMsg
        return label
    }()

    // MARK: - Life Cycle
    init(viewModel: HomeViewModelProtocol = HomeViewModel()) {
        self.viewModel = viewModel
        super.init(nibName: "HomeTableViewController", bundle: Bundle.main)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func loadView() {
        super.loadView()

        configTableView()
        title = viewModel.title
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        configBind()
        viewModel.fetchEvents()
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)

        refreshControl?.endRefreshing()
    }

    // MARK: - Functions
    private func configBind() {
        viewModel.updateHandler = tableView.reloadData

        viewModel.requestModel.addObservation(for: self) { (viewController, viewModel) in
            viewModel.loading ? viewController.refreshControl?.beginRefreshing() : viewController.refreshControl?.endRefreshing()

            guard let error = viewModel.error else { return }
            viewController.errorLabel.text = error
        }

        viewModel.errorIsHidden.bind(to: \.isHidden, on: errorLabel)
    }

    private func configTableView() {
        tableView.tableFooterView = UIView(frame: .zero)
        tableView.separatorInset = UIEdgeInsets.init(top: 0, left: 0, bottom: 0, right: 0)
        tableView.register(UINib(nibName: HomeTableViewCell.identifier, bundle: nil),
                           forCellReuseIdentifier: HomeTableViewCell.identifier)
        tableView.backgroundView = errorLabel

        let newRefreshControl = UIRefreshControl()
        newRefreshControl.addTarget(self, action: #selector(refreshEventsData), for: .valueChanged)

        refreshControl = newRefreshControl
        tableView.refreshControl = refreshControl
    }

    // MARK: - Actions
    @objc private func refreshEventsData() {
        viewModel.fetchEvents()
    }

    // MARK: - Table view data source
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.eventsCount()
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: HomeTableViewCell.identifier,
                                                       for: indexPath) as? HomeTableViewCell else { return UITableViewCell() }

        return cell
    }

    override func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        guard let cell = cell as? HomeTableViewCell else { return }
        if let cellViewModel = viewModel.getObject(at: indexPath.row) {
            cell.config(viewModel: cellViewModel)
        }
    }

    override func tableView(_ tableView: UITableView, didEndDisplaying cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        if let cellViewModel = viewModel.getObject(at: indexPath.row) {
            cellViewModel.cancelImageDownload()
        }
    }

    // MARK: - Table View Delegate
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        viewModel.didTapCell(at: indexPath)
        tableView.deselectRow(at: indexPath, animated: false)
    }

    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return Constants.tableViewCellHeight
    }

    // MARK: - Table view Prefetch Data
    func tableView(_ tableView: UITableView, prefetchRowsAt indexPaths: [IndexPath]) {
        let urls = viewModel.getImagesUrls(at: indexPaths)
        ImagePrefetcher(urls: urls).start()
    }
}
