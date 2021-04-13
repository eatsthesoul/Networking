//
//  DownloadImageViewController.swift
//  Networking
//
//  Created by Evgeniy Petlitskiy on 11.03.21.
//

import UIKit


class DownloadImageViewController: UIViewController {
    
    private var url: String
    private let imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        return imageView
    }()

    private let spinner: UIActivityIndicatorView = {
        let spinner = UIActivityIndicatorView()
        spinner.startAnimating()
        return spinner
    }()
    
    private var completedLabel: UILabel = {
        let label = UILabel()
        label.isHidden = true
        return label
    }()
    
    private let progressView: UIProgressView = {
        let progress = UIProgressView()
        progress.isHidden = true
        return progress
    }()
    
    init(url: String) {
        self.url = url
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        setupViews()
        setupLayout()
        setupNavigationController()
    }
    
    private func setupViews() {
        view.addSubview(imageView)
        view.addSubview(spinner)
        view.addSubview(completedLabel)
        view.addSubview(progressView)
    }
    
    private func setupLayout() {
        imageView.anchor(top: view.topAnchor, leading: view.leadingAnchor, bottom: view.bottomAnchor, trailing: view.trailingAnchor)
        
        spinner.centerInSuperview()
        
        completedLabel.anchor(top: self.spinner.bottomAnchor,
                              leading: nil,
                              bottom: nil,
                              trailing: nil,
                              padding: .init(top: 20, left: 0, bottom: 0, right: 0))
        completedLabel.centerXAnchor.constraint(equalTo: self.view.centerXAnchor).isActive = true
        
        progressView.anchor(top: self.completedLabel.bottomAnchor,
                            leading: nil,
                            bottom: nil,
                            trailing: nil,
                            padding: .init(top: 20, left: 0, bottom: 0, right: 0))
        progressView.centerXAnchor.constraint(equalTo: self.view.centerXAnchor).isActive = true
    }
    
    private func setupNavigationController() {
        navigationItem.title = "Image"
    }
    
    //MARK: - Public API
    
    func fetchImage() {
        NetworkingService.downloadImage(with: url) { (image) in
            self.spinner.stopAnimating()
            self.imageView.image = image
        }
    }
    
    func fetchImageAlamofire() {
        completedLabel.isHidden = false
        progressView.isHidden = false
        
//        completedLabel.text = AlamofireNetworkingService.completed { completed in
//
//        }
        
        AlamofireNetworkingService.completed = { completed in
            self.completedLabel.text = completed
        }
        
        AlamofireNetworkingService.onProgress = { progress in
            self.progressView.progress = Float(progress)
        }
        
        AlamofireNetworkingService.getData(with: url) { (data) in
            guard let image = UIImage(data: data) else { return }
            self.spinner.stopAnimating()
            self.imageView.image = image
            self.completedLabel.isHidden = true
            self.progressView.isHidden = true
        }
    }

}

