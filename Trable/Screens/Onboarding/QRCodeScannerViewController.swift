//
//  QRCodeScannerViewController.swift
//  Trable
//
//  Created by nc on 19.09.20.
//

import AVFoundation
import UIKit

// Base from: https://www.hackingwithswift.com/example-code/media/how-to-scan-a-qr-code
class QRCodeScannerViewController: UIViewController, AVCaptureMetadataOutputObjectsDelegate {
    var captureSession: AVCaptureSession!
    var previewLayer: AVCaptureVideoPreviewLayer!

    @IBOutlet var previewView: UIView!
    @IBOutlet var errorLabel: UILabel!
    
    @IBOutlet var activityIndicator: UIActivityIndicatorView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        captureSession = AVCaptureSession()

        guard let videoCaptureDevice = AVCaptureDevice.default(for: .video) else { return }
        let videoInput: AVCaptureDeviceInput

        do {
            videoInput = try AVCaptureDeviceInput(device: videoCaptureDevice)
        } catch {
            return
        }

        if (captureSession.canAddInput(videoInput)) {
            captureSession.addInput(videoInput)
        } else {
            failed()
            return
        }

        let metadataOutput = AVCaptureMetadataOutput()

        if (captureSession.canAddOutput(metadataOutput)) {
            captureSession.addOutput(metadataOutput)

            metadataOutput.setMetadataObjectsDelegate(self, queue: DispatchQueue.main)
            metadataOutput.metadataObjectTypes = [.qr]
        } else {
            failed()
            return
        }

        previewLayer = AVCaptureVideoPreviewLayer(session: captureSession)
        previewLayer.frame = view.layer.bounds
        previewLayer.videoGravity = .resizeAspectFill
        previewView.layer.addSublayer(previewLayer)

        captureSession.startRunning()
    }

    func failed() {
        let ac = UIAlertController(title: "Scanning not supported", message: "Your device does not support scanning a QR codes.", preferredStyle: .alert)
        ac.addAction(UIAlertAction(title: "OK", style: .default))
        present(ac, animated: true)
        captureSession = nil
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        if (captureSession?.isRunning == false) {
            captureSession.startRunning()
        }
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)

        if (captureSession?.isRunning == true) {
            captureSession.stopRunning()
        }
    }

    func metadataOutput(_ output: AVCaptureMetadataOutput, didOutput metadataObjects: [AVMetadataObject], from connection: AVCaptureConnection) {
        if let metadataObject = metadataObjects.first {
            guard let readableObject = metadataObject as? AVMetadataMachineReadableCodeObject else { return }
            guard let stringValue = readableObject.stringValue else { return }
            UIDevice.vibrate()
            found(code: stringValue)
        }
    }

    func found(code: String) {
        
        // Check if data is a valid url
        if let url = URL(string: code) {
            
            print("DEBUG: Passed URL check")
            
            
            // Check if it's a trable URL
            
            print("DEBUG: url.host?: " + (url.host ?? "nil"))

            if (url.host == "gettrable.app" || url.scheme == "trable") {
               
                print("DEBUG: > It's a Trable URL")

        
                let urlParams: [String: Any] = url.params()
                print("DEBUG: url.params() " +  String(describing: urlParams))

                // Check if it contains a manifest query parameter
                if (urlParams.contains() { (key, value) in key == "manifest" }) {
                    
                    if let manifestData = urlParams["manifest"] as? String {
                        
                        // Decode data from Base64URL
                        let manifestUrl = manifestData.fromBase64URL()
                        
                        // Stop scanning, save the data
                        captureSession.stopRunning()
                        
                        // Save manifest url
                        UserDefaults.standard.setValue(manifestUrl, forKey: "trable_manifest_url")

                        print("UserDefault for trable_manifest_url: " + (UserDefaults.standard.string(forKey: "trable_manifest_url") ?? "-not defined-" ))
                        
                        activityIndicator.isHidden = false
                        
                        // Load Manifest
                        TrableServerManager.shared.handleManifestChange(to: manifestUrl!) { error in
                            if (error == nil) {
                                TrableServerManager.shared.enrollClient(to: TrableServerManager.shared.manifest!) { enrollError in
                                    if (enrollError == nil) {
                                        self.handleManifestSuccess()
                                    } else {
                                        self.handleManifestFailure(error: enrollError!)
                                    }
                                }
                            } else {
                                self.handleManifestFailure(error: error!)
                            }
                        }
                        return
                    }
                    

                }
            
            }
        }
        
        invalidQR()
        print(code)
    }
    
    func handleManifestSuccess() {
        DispatchQueue.main.sync() {
            activityIndicator.isHidden = true
            self.presentingViewController!.performSegue(withIdentifier: "finishOnboarding", sender: nil)
            dismiss(animated: true)
        }

    }
    
    func handleManifestFailure(error: Error) {
        DispatchQueue.main.sync() {
            activityIndicator.isHidden = true
            
            var errorMessage = String(describing: error)
            if !(error is RequestError) {
                errorMessage = error.localizedDescription
            }
            
            let alert = UIAlertController(title: "Failed to fetch Manifest", message: "An error occurred: \(errorMessage)", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: { action in
                self.captureSession.startRunning()
            }))
            self.present(alert, animated: true, completion: nil)
        }
    }
    
    func invalidQR() {
        errorLabel.text = "Not a valid Trable QR Code"
        UIDevice.playFailureVibration()
    }
}

