//
//  BluetoothPermissionViewController.swift
//  Trable
//
//  Created by nc on 16.08.20.
//

import UIKit
import CoreBluetooth

class BluetoothPermissionViewController: UIViewController, CBPeripheralManagerDelegate {

    var bleManager: CBPeripheralManager?// = CBPeripheralManager.init()

    override func viewDidLoad() {
        super.viewDidLoad()
            
        // Do any additional setup after loading the view.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

    @IBAction func requestPermission() {
        // Initializing the CB Manager will trigger a permission request popup in iOS and will then update the state via the delegate
        bleManager = CBPeripheralManager.init()
        bleManager?.delegate = self
    }

    func peripheralManagerDidUpdateState(_ peripheral: CBPeripheralManager) {
        switch (peripheral.state) {
            // Proceed with onboarding
            case .poweredOff:
                fallthrough
            case .poweredOn:
                fallthrough
            case .resetting:
                performSegue(withIdentifier: "finishOnboarding", sender: nil)
                break
                
            // Tell user to go to settings and allow access
            case .unauthorized:
                performSegue(withIdentifier: "showOnboardingNoPerm", sender: nil)
                break
                
            // Some error occurred, show user error page
            case .unknown:
                fallthrough
            case .unsupported:
                fallthrough
            default:
                performSegue(withIdentifier: "showOnboardingBluetoothError", sender: nil)
                break
        }
    }
    

}
