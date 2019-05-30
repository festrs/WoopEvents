//
//  HomeViewController.swift
//  WoopEvents
//
//  Created by Felipe Dias Pereira on 2019-05-29.
//  Copyright © 2019 FelipeP. All rights reserved.
//
import UIKit
import Kingfisher

final class HomeViewController: UIViewController {
    @IBOutlet private weak var tableView: UITableView! {
        didSet {
            tableView.tableFooterView = UIView(frame: .zero)
            tableView.separatorInset = UIEdgeInsets.init(top: 0, left: 0, bottom: 0, right: 0)
            tableView.refreshControl = refreshControl
            tableView.register(UINib(nibName: HomeTableViewCell.identifier, bundle: nil),
                               forCellReuseIdentifier: HomeTableViewCell.identifier)

        }
    }
    private let refreshControl: UIRefreshControl = {
        let refreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action: #selector(refreshEventsData), for: .valueChanged)
        return refreshControl
    }()
    let viewModel: HomeViewModelProtocol

    // MARK: - Life Cycle
    init(viewModel: HomeViewModelProtocol = HomeViewModel()) {
        self.viewModel = viewModel
        super.init(nibName: "HomeViewController", bundle: Bundle.main)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        configBind()
        viewModel.fetchEvents()
    }

    // MARK: - Functions
    private func configBind() {
        viewModel.events.bind { [weak self] _ in
            guard let self = self else { return }
            self.tableView.reloadData()
        }

        viewModel.loading.bindAndFire { [weak self] isLoading in
            guard let self = self else { return }
            isLoading ? self.refreshControl.beginRefreshing() : self.refreshControl.endRefreshing()
        }

        viewModel.error.bind { [weak self] error in
            guard let self = self,
                let error = error else { return }
            
        }
    }

    // MARK: - Actions
    @objc private func refreshEventsData() {
        viewModel.fetchEvents()
    }
}

extension HomeViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        viewModel.didTapCell(at: indexPath)
        tableView.deselectRow(at: indexPath, animated: false)
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 160.0
    }
}

extension HomeViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.eventsCount()
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: HomeTableViewCell.identifier,
                                                       for: indexPath) as? HomeTableViewCell else { return UITableViewCell() }

        return cell
    }

    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        guard let cell = cell as? HomeTableViewCell else { return }
        if let cellViewModel = viewModel[indexPath.row] {
            cell.config(viewModel: cellViewModel)
        }
    }

    func tableView(_ tableView: UITableView, didEndDisplaying cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        if let cellViewModel = viewModel[indexPath.row] {
            cellViewModel.cancelImageDownload()
        }
    }
}

extension HomeViewController: UITableViewDataSourcePrefetching {
    func tableView(_ tableView: UITableView, prefetchRowsAt indexPaths: [IndexPath]) {
        let urls = viewModel.getImagesUrls(at: indexPaths)
        ImagePrefetcher(urls: urls).start()
    }
}
