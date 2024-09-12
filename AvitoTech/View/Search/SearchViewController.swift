//
//  SearchView.swift
//  AvitoTech
//
//  Created by Владимир Иванов on 06.09.2024.
//

import UIKit

final class SearchViewController: UIViewController {
    private let viewModel = SearchViewModel(unsplashService: UnsplashService())
    private let searchView = SearchView()
    var coordinator: MainCoordinator?
    
    private var itemsPerRow: CGFloat = 2
    private let sectionInserts = UIEdgeInsets(top: 20, left: 20, bottom: 20, right: 20)
    private var timer: Timer?
    private let historyTableView = UITableView()
    private var isShowingHistory = false
    
    private let spinner: UIActivityIndicatorView = {
        let spinner = UIActivityIndicatorView()
        spinner.color = .customGrey
        spinner.translatesAutoresizingMaskIntoConstraints = false
        return spinner
    }()
    
    override func loadView() {
        self.view = searchView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupCollectionView()
        setupSearchBar()
        setupSpinner()
        setupHistoryTableView()
        setupChangeLayoutButton()
        setupSegmentedControl()
        
        viewModel.errorHandler = { [weak self] error in
            self?.showErrorAlert(error: error)
        }
    }
    
    private func showErrorAlert(error: AppError) {
        let alertController = UIAlertController(title: "Ошибка", message: error.localizedDescription, preferredStyle: .alert)
        alertController.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        present(alertController, animated: true, completion: nil)
    }
    
    private func setupCollectionView() {
        searchView.collectionView.dataSource = self
        searchView.collectionView.delegate = self
        searchView.collectionView.register(PhotoCell.self, forCellWithReuseIdentifier: "PhotoCell")
    }
    
    private func setupSearchBar() {
        navigationItem.titleView = searchView.searchBar
        searchView.searchBar.delegate = self
    }
    
    private func setupSpinner() {
        view.addSubview(spinner)
        spinner.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        spinner.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
    }
    
    private func setupHistoryTableView() {
        view.addSubview(historyTableView)
        historyTableView.translatesAutoresizingMaskIntoConstraints = false
        historyTableView.dataSource = self
        historyTableView.delegate = self
        historyTableView.register(UITableViewCell.self, forCellReuseIdentifier: "HistoryCell")
        
        
        NSLayoutConstraint.activate([
            historyTableView.topAnchor.constraint(equalTo: view.topAnchor),
            historyTableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            historyTableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            historyTableView.heightAnchor.constraint(equalToConstant: 350)
        ])
        
        historyTableView.isHidden = true
    }
    
    private func updateHistoryTableView() {
        historyTableView.reloadData()
    }
    
    private func setupChangeLayoutButton() {
        let layoutButton = UIBarButtonItem(title: nil, style: .plain, target: self, action: #selector(toggleLayout))
        layoutButton.image = UIImage(systemName: "tablecells.badge.ellipsis")
        navigationItem.rightBarButtonItem = layoutButton
    }
    
    @objc private func toggleLayout() {
        itemsPerRow = itemsPerRow == 2 ? 1 : 2
        navigationItem.rightBarButtonItem?.image = itemsPerRow == 2 ? UIImage(systemName: "tablecells.badge.ellipsis") : UIImage(systemName: "tablecells.fill.badge.ellipsis")
        
        UIView.animate(withDuration: 0.3) {
            self.searchView.collectionView.collectionViewLayout.invalidateLayout()
        }
    }
    
    private func setupSegmentedControl() {
        searchView.segmentedControl.addTarget(self, action: #selector(sortOptionChanged(_:)), for: .valueChanged)
    }
    
    @objc private func sortOptionChanged(_ sender: UISegmentedControl) {
        let selectedSortOption = sender.selectedSegmentIndex
        switch selectedSortOption {
        case 0:
            viewModel.sortResults(by: .popularity)
        case 1:
            viewModel.sortResults(by: .date)
        default:
            break
        }
        searchView.collectionView.reloadData()
    }
}

// MARK: - UICollectionViewDataSource
extension SearchViewController: UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return viewModel.searchResults.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "PhotoCell", for: indexPath) as! PhotoCell
        let photo = viewModel.searchResults[indexPath.item]
        cell.configure(with: photo, viewModel: viewModel)
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let photo = viewModel.searchResults[indexPath.item]
        coordinator?.showDetail(for: photo)
    }
}

// MARK: - UICollectionViewDelegateFlowLayout
extension SearchViewController: UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let paddingSpace = sectionInserts.left * (itemsPerRow + 1)
        let availableWidth = view.frame.width - paddingSpace
        let widthPerItem = availableWidth / itemsPerRow
        
        return CGSize(width: widthPerItem, height: widthPerItem + 10)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return sectionInserts
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return sectionInserts.left
    }
}

// MARK: - UISearchBarDelegate
extension SearchViewController: UISearchBarDelegate {
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if searchText.isEmpty {
            historyTableView.isHidden = true
        } else {
            isShowingHistory = true
            historyTableView.isHidden = false
            updateHistoryTableView()
        }
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        searchBar.resignFirstResponder() // Скрыть клавиатуру
        self.spinner.startAnimating()
        self.viewModel.search(query: searchBar.text ?? "") { [weak self] (searchResults) in
            self?.spinner.stopAnimating()
            self?.searchView.collectionView.reloadData()
            self?.updateHistoryTableView()
        }
        isShowingHistory = false
        historyTableView.isHidden = true
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        isShowingHistory = false
        historyTableView.isHidden = true
    }
}


extension SearchViewController: UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.getFilteredHistory(for: searchView.searchBar.text ?? "").count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "HistoryCell", for: indexPath)
        let historyItem = viewModel.getFilteredHistory(for: searchView.searchBar.text ?? "")[indexPath.row]
        cell.textLabel?.text = historyItem
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let historyItem = viewModel.getFilteredHistory(for: searchView.searchBar.text ?? "")[indexPath.row]
        searchView.searchBar.text = historyItem
        isShowingHistory = false
        historyTableView.isHidden = true
        searchBar(searchView.searchBar, textDidChange: historyItem)
    }
}

@available(iOS 17.0, *)
#Preview {
    SearchViewController()
}
