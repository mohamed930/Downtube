//
//  DownloadVideoViewController.swift
//  Downtupe1
//
//  Created by Mohamed Ali on 5/2/20.
//  Copyright © 2020 Mohamed Ali. All rights reserved.
//

import UIKit
import GoogleMobileAds
import PhotosUI

class DownloadVideoViewController: UIViewController {
    
    var type:String?
    var url:String?
    var videoName:String?
    
    @IBOutlet weak var AD1: GADBannerView!
    @IBOutlet weak var AD2: GADBannerView!
    
    let shapelayer = CAShapeLayer()
    
    let precentageLabel: UILabel = {
        let label = UILabel()
        label.text = "0%"
        label.textAlignment = .center
        label.font = UIFont.boldSystemFont(ofSize: 32)
        return label
    }()
    
    // These Parts For Adding Audio File to Apple's File.
    let documentInteractionController = UIDocumentInteractionController()
    
    func share(url: URL) {
        documentInteractionController.url = url
        documentInteractionController.uti = url.typeIdentifier ?? "public.data, public.content"
        documentInteractionController.name = url.localizedName ?? url.lastPathComponent
        documentInteractionController.presentOptionsMenu(from: view.frame, in: view, animated: true)
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        if url == nil || type == nil{
            print("nil")
        }
        else {
            print(type!)
            print(url!)
            
            DrawCirlceProgress()
            downloadVideoFile()
        }
        
        Tools.SetInitialize(Banner: AD1, ob: self)
        Tools.SetInitialize(Banner: AD2, ob: self)
    }
    
    func DrawCirlceProgress() {
        
        view.addSubview(precentageLabel)
        precentageLabel.frame = CGRect(x: 0, y: 0, width: 100, height: 100)
        precentageLabel.center = view.center
        
        // Add Trak Layer.
        let trackLayer = CAShapeLayer()
        let path = UIBezierPath(arcCenter: .zero, radius: 100, startAngle: 0 , endAngle: 2 * CGFloat.pi, clockwise: true)
        
        trackLayer.path = path.cgPath
        trackLayer.strokeColor = UIColor.lightGray.cgColor
        trackLayer.lineCap = .round
        trackLayer.fillColor = UIColor.clear.cgColor
        trackLayer.lineWidth = 10
        trackLayer.position = view.center
        view.layer.addSublayer(trackLayer)
        
        
        shapelayer.path = path.cgPath
        shapelayer.strokeColor = UIColor.red.cgColor
        shapelayer.lineCap = .round
        shapelayer.fillColor = UIColor.clear.cgColor
        shapelayer.strokeEnd = 0
        shapelayer.lineWidth = 10
        shapelayer.position = view.center
        shapelayer.transform = CATransform3DMakeRotation(-CGFloat.pi / 2, 0, 0, 1)
        view.layer.addSublayer(shapelayer)
        
    }
    
    func downloadVideoFile() {
        
        let configration = URLSessionConfiguration.default
        let operationQueue = OperationQueue()
        let urlSeasion = URLSession(configuration: configration, delegate: self, delegateQueue: operationQueue)
        
        guard let url = URL(string: self.url!) else{return}
        let downloadTask = urlSeasion.downloadTask(with: url)
        downloadTask.resume()
    }
}

extension DownloadVideoViewController: GADBannerViewDelegate {
    
    internal func adViewDidReceiveAd(_ bannerView: GADBannerView) {
        AD1.isHidden = false
        AD2.isHidden = false
    }
    
    internal func adView(_ bannerView: GADBannerView, didFailToReceiveAdWithError error: GADRequestError) {
        AD1.isHidden = true
        AD2.isHidden = true
    }
    
}

extension URL {
    var typeIdentifier: String? {
        return (try? resourceValues(forKeys: [.typeIdentifierKey]))?.typeIdentifier
    }
    var localizedName: String? {
        return (try? resourceValues(forKeys: [.localizedNameKey]))?.localizedName
    }
}

extension DownloadVideoViewController: URLSessionDownloadDelegate {
    
    func urlSession(_ session: URLSession, downloadTask: URLSessionDownloadTask, didFinishDownloadingTo location: URL) {
        
        if type == "HD:" || type == "SD:" {
            
            print("Download Sucess!")
            print(videoName!)
            
            let urlData = NSData(contentsOf: location)
            let documentsPath = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)[0];
            let filePath="\(documentsPath)/\(videoName!).mp4"
            DispatchQueue.main.async {
                urlData?.write(toFile: filePath, atomically: true)
                PHPhotoLibrary.shared().performChanges({
                    PHAssetChangeRequest.creationRequestForAssetFromVideo(atFileURL: URL(fileURLWithPath: filePath))
                }) { completed, error in
                    if completed {
                        print("Video is saved!")
                        self.shapelayer.strokeColor = UIColor.green.cgColor
                    }
                }
            }
        }
        else if type == "m4a:" {
            saveAudio(fileName: "fileName.m4a")
        }
        else if type == "mp3:" {
            saveAudio(fileName: "fileName.mp3")
        }
        
    }
    
    func saveAudio (fileName:String) {
        // Add Audio File To Apple's File
        
        URLSession.shared.dataTask(with: URL(string: self.url!)!) { data, response, error in
            guard let data = data, error == nil else { return }
            let tmpURL = FileManager.default.temporaryDirectory
                .appendingPathComponent(response?.suggestedFilename ?? fileName)
            do {
                try data.write(to: tmpURL)
                DispatchQueue.main.async {
                    self.share(url: tmpURL)
                    print("File Saved Successfully!")
                    self.precentageLabel.text = "Saved"
                    self.shapelayer.strokeColor = UIColor.green.cgColor
                }
            } catch {
                print(error)
            }

        }.resume()
    }
    
    func urlSession(_ session: URLSession, downloadTask: URLSessionDownloadTask, didWriteData bytesWritten: Int64, totalBytesWritten: Int64, totalBytesExpectedToWrite: Int64) {
        
        let precentage = (CGFloat(totalBytesWritten) / CGFloat(totalBytesExpectedToWrite))
        
        DispatchQueue.main.async {
            self.precentageLabel.text = "\(Int(precentage * 100))%"
            
            self.shapelayer.strokeEnd = precentage
        }
    }
}
