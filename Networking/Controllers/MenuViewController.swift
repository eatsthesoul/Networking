//
//  ViewController.swift
//  Networking
//
//  Created by Evgeniy Petlitskiy on 10.03.21.
//

import UIKit
import UserNotifications
import Alamofire

enum Actions: String, CaseIterable {
    case downloadImage = "Download Image"
    case get = "GET"
    case post = "POST"
    case uploadImage = "Upload Image"
    case backgroundDownload = "Background download"
    case getAlamofire = "GET Alamofire"
    case getImageWithAlamofire = "Get Image Alamofire"
    case postAlamofire = "POST Alamofire"
    case putAlamofire = "PUT Alamofire"
    case uploadImageAlamofire = "Upload Image Alamofire"
}


class MenuViewController: UIViewController {
    
    private let menuCollectionView: UICollectionView = {
        let flowLayout = UICollectionViewFlowLayout()
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: flowLayout)
        collectionView.backgroundColor = .clear
        collectionView.contentInset = UIEdgeInsets(top: 25, left: 0, bottom: 25, right: 0)
        return collectionView
    }()
    
    
    private let actions = Actions.allCases
    
    //Background download properties
    private var downloadAlert: UIAlertController!
    private var backgroundDownloadService = BackgroundDownloadService()
    private var downloadedFilePath: URL?

    private let filmsData = ["1": "Shawshank Redemption", "2": "Green Mile", "3": "Lord of the Rings: The Return of the King", "4": "Interstellar"]
    
    let downloadImageUrl = "https://sun2.velcom-by-minsk.userapi.com/impg/OhE4P5PB9-FDQutwCdQL9Z0WRmbfNJ5ze5F6SA/BGs3w6-LSn0.jpg?size=1080x1351&quality=96&sign=c7469ba406ae95044527aed01c78bc9f&type=album"
    let getRequestUrl = "https://jsonplaceholder.typicode.com/posts/1/comments"
    let postRequestUrl = "https://jsonplaceholder.typicode.com/posts"
    let putRequestUrl = "https://jsonplaceholder.typicode.com/posts/1"
    let uploadImageUrl = "https://api.imgur.com/3/image"
    let backgroundDownloadUrl = "https://speed.hetzner.de/100MB.bin"
    
    //MARK: - VC Lifecycle methods
    
    override func viewDidLoad() {
        
        menuCollectionView.dataSource = self
        menuCollectionView.delegate = self
        menuCollectionView.register(MenuCollectionViewCell.self, forCellWithReuseIdentifier: MenuCollectionViewCell.identifier)
        
        setupViews()
        setupLayout()
        
        //that stuff will be open when app reload in the background after background tasks will be completed
        backgroundDownloadService.fileLocation = { (location) in
            self.downloadedFilePath = location
            self.downloadAlert.dismiss(animated: false, completion: nil)
            self.postNotification()
        }
        
        //background notification
        registerForNotification()
    }
    
    
    //MARK: - Setup methods
    
    private func setupViews() {
        view.addSubview(menuCollectionView)
    }
    
    private func setupLayout() {
        
        menuCollectionView.anchor(top: view.safeAreaLayoutGuide.topAnchor,
                          leading: view.safeAreaLayoutGuide.leadingAnchor,
                          bottom: view.safeAreaLayoutGuide.bottomAnchor,
                          trailing: view.safeAreaLayoutGuide.trailingAnchor,
                          padding: .init(top: 0, left: 0, bottom: 0, right: 0))

    }
    
    
    
//MARK: - Buttons handlers
    
    private func downloadImage() {
        let downloadImageVC = DownloadImageViewController(url: downloadImageUrl)
        downloadImageVC.fetchImage()
        navigationController?.pushViewController(downloadImageVC, animated: true)
    }
    
    private func getRequest() {
        let getRequestVC = GetRequestViewController(with: getRequestUrl)
        getRequestVC.getRequest()
        navigationController?.pushViewController(getRequestVC, animated: true)
    }
    
    private func postRequest() {
        
        guard let data = try? JSONSerialization.data(withJSONObject: filmsData, options: []) else { return }
        NetworkingService.postRequest(to: postRequestUrl, data: data, headers: ["Content-Type" : "application/json"]) { (data) in
            guard let data = data else { return }
            guard let jsonData = try? JSONSerialization.jsonObject(with: data, options: []) else { return }
            print(jsonData)
        }
    }
    
    private func uploadImage() {
        guard let image = UIImage(named: "image") else { return }
        guard let imageProperties = ImageProperties(withImage: image, forKey: "image") else { return }
        NetworkingService.postRequest(to: uploadImageUrl,
                                      data: imageProperties.data,
                                      headers: ["Authorization" : "Client-ID f02864b15a1aec9"]) { (data) in
            guard let data = data else { return }
            guard let jsonData = try? JSONSerialization.jsonObject(with: data, options: []) else { return }
            print(jsonData)
        }
    }
    
    private func backgroundDownload() {
        showDownloadAlert()
        backgroundDownloadService.startDownload(with: backgroundDownloadUrl)
        
    }
    
    private func getRequestAlamofire() {
        let getRequestVC = GetRequestViewController(with: getRequestUrl)
        getRequestVC.getRequestWithAlamofire()
        navigationController?.pushViewController(getRequestVC, animated: true)
    }
    
    private func getImageAlamofire() {
        let downloadImageVC = DownloadImageViewController(url: downloadImageUrl)
        downloadImageVC.fetchImageAlamofire()
        navigationController?.pushViewController(downloadImageVC, animated: true)
    }
    
    private func postRequestAlamofire() {
        AlamofireNetworkingService.postRequest(postRequestUrl, data: filmsData, headers: ["Content-Type" : "application/json"]) { (result) in
            guard let result = result else { return }
            print(result)
        }
    }
    
    private func putRequestAlamofire() {
        let data = ["1" : "Shawshank Redemption"]
        AlamofireNetworkingService.putRequest(putRequestUrl, data: data, headers: ["Content-Type" : "application/json"]) { (result) in
            guard let result = result else { return }
            print(result)
        }
    }
    
    private func uploadImageAlamofire() {
        guard let image = UIImage(named: "image") else { return }
        guard let imageProperties = ImageProperties(withImage: image, forKey: "image") else { return }
        let headers = ["Authorization" : "Client-ID f02864b15a1aec9"]
        AlamofireNetworkingService.uploadData(uploadImageUrl,
                                              data: [imageProperties.key : imageProperties.data],
                                              headers: headers) { (response) in
            guard let response = response else { return }
            print(response)
        }
    }
    
    //MARK: - UIAlertVC methods

    private func showDownloadAlert() {
        downloadAlert = UIAlertController(title: "Downloading...", message: "0%", preferredStyle: .alert)
        
        // custom height
        let heightAnchor = NSLayoutConstraint(item: downloadAlert.view!,
                                              attribute: .height,
                                              relatedBy: .equal,
                                              toItem: nil,
                                              attribute: .notAnAttribute,
                                              multiplier: 0,
                                              constant: 170)
        downloadAlert.view.addConstraint(heightAnchor)
        
        // cancel action
        let cancelAction = UIAlertAction(title: "Cancel", style: .destructive) { (action) in
            self.backgroundDownloadService.stopDownload()
        }
        downloadAlert.addAction(cancelAction)
        
        // activity indicator
        let activityIndicator = UIActivityIndicatorView()
        activityIndicator.startAnimating()
        self.downloadAlert.view.addSubview(activityIndicator)
        activityIndicator.centerInSuperview()
        
        // progress view
        let progressView = UIProgressView()
        progressView.tintColor = .blue
        downloadAlert.view.addSubview(progressView)
        progressView.anchor(top: nil,
                            leading: downloadAlert.view.leadingAnchor,
                            bottom: downloadAlert.view.bottomAnchor,
                            trailing: downloadAlert.view.trailingAnchor,
                            padding: .init(top: 0, left: 0, bottom: 44, right: 0),
                            size: .init(width: 0, height: 2))
        
        // dynamic info
        backgroundDownloadService.onProgress = { (progress) in
            progressView.progress = Float(progress)
            self.downloadAlert.message = "\(Int(progress * 100))%"
        }
        
        present(downloadAlert, animated: true)
    }

//    private func hideDownloadAlert() {
//        backgroundNetworkingService.stopDownload()
//    }
}




//MARK: - UICollectionViewDataSource

extension MenuViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return actions.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: MenuCollectionViewCell.identifier, for: indexPath) as! MenuCollectionViewCell
        cell.nameLabel.text = actions[indexPath.row].rawValue
        return cell
    }
    
}

//MARK: - UICollectionViewDelegate

extension MenuViewController: UICollectionViewDelegate {
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let action = actions[indexPath.row]
        switch action {
        case .downloadImage:
            downloadImage()
        case .get:
            getRequest()
        case .post:
            postRequest()
        case .uploadImage:
            uploadImage()
        case .backgroundDownload:
            backgroundDownload()
        case .getImageWithAlamofire:
            getImageAlamofire()
        case .getAlamofire:
            getRequestAlamofire()
        case .postAlamofire:
            postRequestAlamofire()
        case .putAlamofire:
            putRequestAlamofire()
        case .uploadImageAlamofire:
            uploadImageAlamofire()
        }
    }
}

//MARK: - UICollectionViewDelegateFlowLayout

extension MenuViewController: UICollectionViewDelegateFlowLayout {

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: view.bounds.width, height: 100)
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 30
    }
}

//MARK: - Notifications

extension MenuViewController {
    
    private func registerForNotification() {
        UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .sound]) { (_, _) in
            
        }
    }
    
    private func postNotification() {
        let content = UNMutableNotificationContent()
        content.title = "Download complete!"
        content.body = "Your background download has completed. FilePath: \(self.downloadedFilePath!.absoluteString)"
        
        let trigger = UNTimeIntervalNotificationTrigger(timeInterval: 3, repeats: false)
        
        let request = UNNotificationRequest(identifier: "DownloadComplete", content: content, trigger: trigger)
        
        UNUserNotificationCenter.current().add(request, withCompletionHandler: nil)
    }
}


