//
//  OnboardingFinishedViewController.swift
//  Trable
//
//  Created by nc on 19.09.20.
//

import UIKit

class OnboardingFinishedViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    
    @IBAction func startTrable() {
        UserDefaults.standard.setValue(true, forKey: "finishedOnboarding")
    
        // Load the main App UI
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        self.view.window?.rootViewController = storyboard.instantiateInitialViewController()!
        
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
