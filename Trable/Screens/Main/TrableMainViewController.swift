//
//  TrableMainViewController.swift
//  Trable
//
//  Created by nc on 19.09.20.
//

import UIKit
import CoreBluetooth
import WebKit

@IBDesignable
class TrableMainViewController: UIViewController {

    @IBOutlet
    private var webView: WKWebView!
        
    @IBInspectable
    private var startUrl: String = "index"
        
    override func viewDidLoad() {
        super.viewDidLoad()
        setupWebView()
        setupBluetoothManager()
    }
    
    func setupWebView() {
        webView.navigationDelegate = self
        
        webView.isOpaque = false
        webView.backgroundColor = UIColor.clear
        
        if let url = Bundle.main.url(forResource: startUrl, withExtension: "html") {
            webView.load(URLRequest(url: url))
        }
    }
    
    func setupBluetoothManager() {
        BluetoothManager.shared.initializeBluetoothManager(withDelegate: self)
    }
    
    
    private func startMapView(mapConfig: MapConfig) {
        let mapConfigJson = String(data: try! JSONEncoder().encode(mapConfig), encoding: .utf8)!
        
        let socketUrl = TrableServerManager.shared.baseUrl
        let apiKey = TrableServerManager.shared.apiKey
    
        let js = "app.initializeMap(\(mapConfigJson)); app.setupSocketConnection('\(socketUrl)', '\(apiKey)')"

        webView.evaluateJavaScript(js) { result, error in
            // TODO: Potential error handling
            print(result, error)
        }
    }
    
    
    
}

extension TrableMainViewController: WKNavigationDelegate {
    
    func webView(_ webView: WKWebView, decidePolicyFor navigationAction: WKNavigationAction, decisionHandler: @escaping (WKNavigationActionPolicy) -> Void) {
        
        // We only care about linkAcivated
        if (navigationAction.navigationType != .linkActivated) {
            decisionHandler(.allow)
            return;
        }
        
        guard let url = navigationAction.request.url else {
            decisionHandler(.allow)
            return
        }
        
        // Open external URLs within Safari
        if (!url.isFileURL) {
            UIApplication.shared.open(url, options: [:], completionHandler: nil)
            decisionHandler(.cancel)
            return
        }
        
            let vc = TrableMainViewController()
            vc.startUrl = url.lastPathComponent.replacingOccurrences(of: ".html", with: "")
            self.navigationController?.pushViewController(vc, animated: true)
            decisionHandler(.cancel)
            return;
    }
    
    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        
        guard webView.url == Bundle.main.url(forResource: startUrl, withExtension: "html") else {
            return
        }
        
        TrableServerManager.shared.fetchMapConfig() { (mapConfig, error) in
            guard let mapConfig = mapConfig else {
                print("An error occurred \(error!)")
                return
            }
            
            DispatchQueue.main.sync {
                self.startMapView(mapConfig: mapConfig)
            }
        }
    }

}

extension TrableMainViewController: CBPeripheralManagerDelegate {
    func peripheralManagerDidUpdateState(_ peripheral: CBPeripheralManager) {
        if (peripheral.state == .poweredOn) {
            // Start Advertising
            BluetoothManager.shared.startAdvertising()
        }
    }
}
