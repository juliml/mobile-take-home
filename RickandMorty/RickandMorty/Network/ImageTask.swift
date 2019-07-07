//
//  ImageTask.swift
//  RickandMorty
//
//  Created by Juliana Lacerda on 2019-07-07.
//  Copyright © 2019 Juliana Lacerda. All rights reserved.
//

import UIKit

protocol ImageTaskDownloadedDelegate {
    func imageDownloaded(index: Int, section: Int)
}

class ImageTask {
    
    let index, section: Int
    let url: URL
    let delegate: ImageTaskDownloadedDelegate
    
    var image: UIImage?
    
    private var task: URLSessionDownloadTask?
    private var resumeData: Data?
    
    private var isDownloading = false
    private var isFinishedDownloading = false
    
    init(index: Int, section: Int, url: URL, delegate: ImageTaskDownloadedDelegate) {
        self.index = index
        self.section = section
        self.url = url
        self.delegate = delegate
    }
    
    func resume() {
        if !isDownloading && !isFinishedDownloading {
            isDownloading = true
            
            let session = URLSession(configuration: URLSessionConfiguration.default)
            if let resumeData = resumeData {
                task = session.downloadTask(withResumeData: resumeData, completionHandler: downloadTaskCompletionHandler)
            } else {
                task = session.downloadTask(with: url, completionHandler: downloadTaskCompletionHandler)
            }
            
            task?.resume()
        }
    }
    
    func pause() {
        if isDownloading && !isFinishedDownloading {
            task?.cancel(byProducingResumeData: { (data) in
                self.resumeData = data
            })
            self.isDownloading = false
        }
    }
    
    private func downloadTaskCompletionHandler(url: URL?, response: URLResponse?, error: Error?) {
        if let error = error {
            print("Error downloading: ", error)
            return
        }
        
        guard let url = url else { return }
        guard let data = FileManager.default.contents(atPath: url.path) else { return }
        guard let image = UIImage(data: data) else { return }
        
        DispatchQueue.main.async {
            self.image = image
            self.delegate.imageDownloaded(index: self.index, section: self.section)
        }
        
        self.isFinishedDownloading = true
    }
}


