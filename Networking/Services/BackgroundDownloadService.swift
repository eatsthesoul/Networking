//
//  BackgroundDownloadService.swift
//  Networking
//
//  Created by Evgeniy Petlitskiy on 30.03.21.
//

import UIKit

class BackgroundDownloadService: NSObject {
    
    private var downloadTask: URLSessionDownloadTask!
    
    var fileLocation: ((URL) -> ())?
    var onProgress: ((Double) -> ())?
    
    private lazy var backgroundSession: URLSession = {
        let config = URLSessionConfiguration.background(withIdentifier: "eatsthesoul.Networking")
        config.isDiscretionary = true
        config.sessionSendsLaunchEvents = true
        return URLSession(configuration: config, delegate: self, delegateQueue: nil)
    }()
    
    func startDownload(from url: URL) {
        let backgroundTask = backgroundSession.downloadTask(with: url)
        backgroundTask.countOfBytesClientExpectsToSend = 512
        backgroundTask.countOfBytesClientExpectsToReceive = 100 * 1024 * 1024
        backgroundTask.resume()
    }
    
    func startDownload(with url: String) {
        guard let url = URL(string: url) else { return }
        startDownload(from: url)
    }
    
    func stopDownload() {
        downloadTask.cancel()
    }
}

extension BackgroundDownloadService: URLSessionDelegate {
    
    func urlSessionDidFinishEvents(forBackgroundURLSession session: URLSession) {
        DispatchQueue.main.async {
            guard
                let appDelegate = UIApplication.shared.delegate as? AppDelegate,
                let backgroundCompletionHandler = appDelegate.backgroundCompletionHandler
            else { return }
            
            appDelegate.backgroundCompletionHandler = nil
            backgroundCompletionHandler()
        }
    }
}

extension BackgroundDownloadService: URLSessionDownloadDelegate {
     
//    func urlSession(_ session: URLSession, task: URLSessionTask, didCompleteWithError error: Error?) {
//        guard let error = error else { return }
//        print(error.localizedDescription)
//    }
     
    func urlSession(_ session: URLSession, downloadTask: URLSessionDownloadTask, didFinishDownloadingTo location: URL) {
        print("Did finish downloading: \(location.absoluteString)")
        DispatchQueue.main.async {
            self.fileLocation?(location)
        }
    }
    
    func urlSession(_ session: URLSession, downloadTask: URLSessionDownloadTask, didWriteData bytesWritten: Int64, totalBytesWritten: Int64, totalBytesExpectedToWrite: Int64) {
        
        guard totalBytesWritten != NSURLSessionTransferSizeUnknown else { return }
        
        let progress = Double(totalBytesWritten) / Double(totalBytesExpectedToWrite)
        print("\(progress * 100)% was downloaded")
        
        DispatchQueue.main.async {
            self.onProgress?(progress)
        }
    }
    
    
    
}
