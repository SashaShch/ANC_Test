//
//  ViewController.swift
//  ANC_Test
//
//  Created by SashaShch on 21.12.2020.
//

import UIKit
import AVFoundation

class ViewController: UIViewController, AVCaptureMetadataOutputObjectsDelegate {
    
    let cellCountPerRow = 2
    let cellMargin: CGFloat = 50
    var products = Products()
    var code = ""
    
    var video = AVCaptureVideoPreviewLayer()
    let session = AVCaptureSession()

    override func viewDidLoad() {
        super.viewDidLoad()
        setupVideo()
    }
    
    func setupVideo() {
        let captureDevice = AVCaptureDevice.default(for: AVMediaType.video)
        do {
            let input = try AVCaptureDeviceInput(device: captureDevice!)
            session.addInput(input)
        } catch {
            fatalError(error.localizedDescription)
        }
        let output = AVCaptureMetadataOutput()
        session.addOutput(output)

        output.setMetadataObjectsDelegate(self, queue: DispatchQueue.main)
        output.metadataObjectTypes = [AVMetadataObject.ObjectType.qr]

        video = AVCaptureVideoPreviewLayer(session: session)
        video.frame = view.layer.bounds
    }
    
    func startRunning() {
        view.layer.addSublayer(video)
        session.startRunning()
    }


    @IBAction func qrButtonPressed(_ sender: Any) {
        startRunning()
    }
    
    func metadataOutput(_ output: AVCaptureMetadataOutput, didOutput metadataObjects: [AVMetadataObject], from connection: AVCaptureConnection) {
        guard metadataObjects.count > 0 else { return }
        if let object = metadataObjects.first as? AVMetadataMachineReadableCodeObject {
            if object.type == AVMetadataObject.ObjectType.qr {
                let alert = UIAlertController(title: "Выберите товар", message: object.stringValue, preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "ОК", style: .default, handler: { (action) in
                    self.view.layer.sublayers?.removeLast()
                }))
                present(alert, animated: true, completion: nil)
                self.code = object.stringValue ?? ""
                self.session.stopRunning()
            }
        }
    }
}

extension ViewController: UICollectionViewDataSource {
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        numberOfItemsInSection section: Int) -> Int {
        return products.count()
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let item = products.products[indexPath.item]
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ProductCell", for: indexPath) as! ProductCell
        
        cell.productCode.text = item.code
        let image = UIImage(named: item.image)
            cell.productImage.image = image
        
        return cell
    }
    
}

extension ViewController: UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        insetForSectionAt section: Int) -> UIEdgeInsets
    {
        return UIEdgeInsets(top: cellMargin, left: cellMargin, bottom: cellMargin, right: cellMargin)
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        let width = floor((UIScreen.main.bounds.width - CGFloat(cellCountPerRow + 1) * cellMargin) / CGFloat(cellCountPerRow))
        return CGSize(width: width, height: width)
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        
        return cellMargin
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        
        return cellMargin
    }
    
}

extension ViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let item = products.products[indexPath.item]
        if code != "" {
            item.code = code
            collectionView.reloadData()
        }
    }
}

