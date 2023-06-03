//
//  ViewController.swift
//  GifApp
//
//  Created by D on 27.05.2023.
//

import UIKit

final class GifListViewController: UIViewController, UISearchBarDelegate {
    //MARK: - UI objects
    private lazy var tableView:
    UITableView = {
        let tableView = UITableView(frame: .zero, style: .plain)
        tableView.register(GifListCell.self, forCellReuseIdentifier: GifListCell.reuseIdentifier)
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.backgroundColor = .black
        return tableView
    }()
    
    private lazy var searchController: UISearchController = {
        let sc = UISearchController(searchResultsController: nil)
        sc.searchBar.delegate = self
        return sc
    }()
    
    private lazy var containerView: UIView = {
        let view = UIView(frame: CGRect(x: 0, y: 0, width: view.frame.width, height: searchController.searchBar.bounds.height))
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    //MARK: - Private properties
    private var gifs: [String] = []
    private let gifListService = GifListService.shared
    private var gifListServiceObserver: NSObjectProtocol?
    
    private let mockWord = "coinbase"
    private let numberOfGifs = 12              //ограничение на запрос 25
    
    //MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
        gifListService.makeAPIcall(with: mockWord, number: numberOfGifs) { [weak self] success in
            guard let self = self else { return }
            if success {
                self.updateTableView()
            } else {
            }
        }
        gifListServiceObserver = NotificationCenter.default
            .addObserver(forName: GifListService.didChangeNotification,
                         object: nil,
                         queue: .main,
                         using: { [weak self] _ in
                guard let self = self else { return }
                self.updateTableView()
            })
    }
    //MARK: - Private methods
    private func setupView() {
        setupSearchController()
        containerView.addSubview(searchController.searchBar)
        view.addSubview(containerView)
        view.addSubview(tableView)
        tableView.delegate = self
        tableView.dataSource = self
        
        NSLayoutConstraint.activate([
            containerView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            containerView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            containerView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            containerView.heightAnchor.constraint(equalToConstant: searchController.searchBar.bounds.height ),
            
            tableView.topAnchor.constraint(equalTo: containerView.bottomAnchor),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            
        ])
    }
    
    
    private func setupSearchController() {
        searchController.searchBar.placeholder = "Поиск"
        searchController.searchBar.setValue("Отмена", forKey: "cancelButtonText")
        searchController.definesPresentationContext = true
        searchController.searchBar.backgroundColor = .white
    }
    
    private func updateTableView() {
        let oldGifsCount = gifs.count
         let newGifsCount = gifListService.gifs.count
         gifs = gifListService.gifs
         if oldGifsCount != newGifsCount {
             DispatchQueue.main.async {
                 self.tableView.reloadData()
             }
         }
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        guard let searchText = searchBar.text, !searchText.isEmpty else {
            return
        }

            gifListService.makeAPIcall(with: searchText, number: numberOfGifs) { [weak self] success in
                if success {
                    self?.updateTableView()
                } else {
                    assertionFailure("cannot download")
                }
            }
    }
    
    
}

//MARK: - UITableViewDataSource
extension GifListViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        gifs.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        gifs = gifListService.gifs
        let tableViewHeight = tableView.frame.height
        let gif = gifs[indexPath.row]
        let cell = tableView.dequeueReusableCell(withIdentifier: GifListCell.reuseIdentifier, for: indexPath)
        guard let gifListCell = cell as? GifListCell else { return UITableViewCell() }
        gifListCell.configCell(imageURL: gif, numberRow: indexPath.row, tableViewHeight: tableViewHeight)
        return gifListCell
    }
    
    
}
//MARK: - UITableViewDelegate
extension GifListViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        UITableView.automaticDimension
    }
}
