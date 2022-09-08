//
//  ViewController.swift
//  NewsApp
//
//  Created by Admin on 06/09/22.
//

import UIKit
import SafariServices

class ViewController: UIViewController {
    
    // MARK: - Properties
    
    private var articles = [Article]()
    private var viewModel = [NewsTableViewCellViewModel]()
    
    private let searchVC = UISearchController(searchResultsController: nil)
    
    private let NewsTableView: UITableView = {
        let tableView = UITableView()
        tableView.register(NewsTableViewCell.self, forCellReuseIdentifier: NewsTableViewCell.identifier)
        return tableView
    }()
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureUI()
        configureTableView()
        fetchNews()
        configureSearchBar()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        NewsTableView.frame = view.bounds
    }
    
    // MARK: - Helpers
    
    private func configureSearchBar() {
        navigationItem.searchController = searchVC
        searchVC.searchBar.delegate = self
    }
    
    private func fetchNews() {
        APICaller.shared.getTopStories { [weak self] result in
            switch result {
            case .success(let articles):
                self?.articles = articles
                self?.viewModel = articles.compactMap({ article in
                    NewsTableViewCellViewModel(title: article.title, subTitle: article.description ?? "No Data Found", imageURL: URL(string: article.urlToImage ?? ""))
                })
                
                DispatchQueue.main.async {
                    self?.NewsTableView.reloadData()
                }
                
            case .failure(let error):
                print(error)
            }
        }
    }
    
    private func configureUI() {
        title = "News"
        view.backgroundColor = .systemBackground
    }
    
    private func configureTableView() {
        view.addSubview(NewsTableView)
        NewsTableView.dataSource = self
        NewsTableView.delegate = self
    }
}

// MARK: - UITableViewDataSource

extension ViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        guard let cell = tableView.dequeueReusableCell(withIdentifier: NewsTableViewCell.identifier, for: indexPath) as?
                NewsTableViewCell else { return UITableViewCell()}
        
        cell.configure(with: viewModel[indexPath.row])
        
        return cell
    }
}

// MARK: - UITableViewDelegate

extension ViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let article = articles[indexPath.row]
        guard let url = URL(string: article.url ?? "") else { return}
        
        let articleVC = SFSafariViewController(url: url)
        present(articleVC, animated: true)
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 150
    }
}

extension ViewController: UISearchBarDelegate {
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        guard let text = searchBar.text, !text.isEmpty else { return}
        
        APICaller.shared.search(with: text) { [weak self] result in
            switch result {
            case .success(let articles):
                self?.articles = articles
                self?.viewModel = articles.compactMap({ article in
                    NewsTableViewCellViewModel(title: article.title, subTitle: article.description ?? "No Data Found", imageURL: URL(string: article.urlToImage ?? ""))
                })
                
                DispatchQueue.main.async {
                    self?.NewsTableView.reloadData()
                    self?.searchVC.dismiss(animated: true, completion: nil)
                }
            case .failure(let error):
                print(error)
            }
        }
    }
}
