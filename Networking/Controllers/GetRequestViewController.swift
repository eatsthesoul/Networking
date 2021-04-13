//
//  GetRequestViewController.swift
//  Networking
//
//  Created by Evgeniy Petlitskiy on 14.03.21.
//

import UIKit

class GetRequestViewController: UIViewController {
    
    private let url: String
    private var data = [Comment]()
    
    let tableView: UITableView = {
        let tableView = UITableView()
        tableView.isHidden = true
        return tableView
    }()
    
    private let spinner: UIActivityIndicatorView = {
        let spinner = UIActivityIndicatorView()
        spinner.startAnimating()
        return spinner
    }()
    
    init(with url: String) {
        self.url = url
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK: - ViewController Lifecycle methods
    
    override func viewDidLoad() {
        
        tableView.dataSource = self
        tableView.delegate = self
        tableView.register(GetRequestTableViewCell.self, forCellReuseIdentifier: GetRequestTableViewCell.identifier)
        
        setupViews()
        setupLayout()
        setupNavigationController()
    }
    
    func setupViews() {
        view.addSubview(tableView)
        view.addSubview(spinner)
    }
    
    func setupLayout() {
        tableView.anchor(top: view.safeAreaLayoutGuide.topAnchor,
                         leading: view.leadingAnchor,
                         bottom: view.bottomAnchor,
                         trailing: view.trailingAnchor)
        spinner.centerInSuperview()
    }
    
    private func setupNavigationController() {
        navigationItem.title = "GET Request"
    }
    
    //MARK: - Public API
    
    func getRequest() {
        NetworkingService.getRequest(with: url) { (data) in
            do {
                let jsonData = try JSONDecoder().decode([Comment].self, from: data)
                self.data = jsonData
                self.tableView.reloadData()
                self.tableView.isHidden = false
                self.spinner.stopAnimating()
            }
            catch let error {
                print(error)
            }
        }
    }
    
    func getRequestWithAlamofire() {
        AlamofireNetworkingService.getRequest(with: url, of: [Comment].self) { (result) in
            self.data = result
            self.tableView.reloadData()
            self.tableView.isHidden = false
            self.spinner.stopAnimating()
        }
    }
}

// MARK: - Table View Data Source

extension GetRequestViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return data.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: GetRequestTableViewCell.identifier, for: indexPath) as! GetRequestTableViewCell
        cell.registerMessage(with: data[indexPath.row])
        
        return cell
    }
}

// MARK: - Table View Delegate

extension GetRequestViewController: UITableViewDelegate {
    
//    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
//        tableView.deselectRow(at: indexPath, animated: true)
//    }
}


