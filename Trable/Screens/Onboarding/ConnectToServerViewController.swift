//
//  ConnectToServerViewController.swift
//  Trable
//
//  Created by nc on 20.09.20.
//

import UIKit

class ConnectToServerViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        checkForManifestIntent()
    }
    
    func checkForManifestIntent() {
        if (UserDefaults.standard.bool(forKey: "intent:preloaded_manifest")) {
            guard let manifestUrl = UserDefaults.standard.string(forKey: "trable_manifest_url") else {
                return;
            }
            
            TrableServerManager.shared.handleManifestChange(to: manifestUrl) { error in
                if (error == nil) {
                    self.handleManifestSuccess()
                } else {
                    self.handleManifestFailure(error: error!)
                }
            }
        }
    }

    func handleManifestSuccess() {
        DispatchQueue.main.sync() {
            UserDefaults.standard.setValue(false, forKey: "intent:preloaded_manifest")
            self.navigationController?.performSegue(withIdentifier: "finishOnboarding", sender: nil)
            dismiss(animated: true)
        }

    }
    
    func handleManifestFailure(error: Error) {
        DispatchQueue.main.sync() {
            var errorMessage = String(describing: error)
            if !(error is RequestError) {
                errorMessage = error.localizedDescription
            }
            
            let alert = UIAlertController(title: "Failed to fetch Manifest", message: "An error occurred: \(errorMessage)", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.default))
            self.present(alert, animated: true, completion: nil)
        }
    }
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
