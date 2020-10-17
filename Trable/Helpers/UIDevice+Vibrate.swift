//
//  UIDevice+Vibrate.swift
//  Trable
//
//  Created by nc on 19.09.20.
//

import UIKit
import AVFoundation

import AudioToolbox

extension UIDevice {
    static func vibrate() {
        AudioServicesPlaySystemSound(kSystemSoundID_Vibrate)
    }
    
    static func playFailureVibration() {
        AudioServicesPlaySystemSound(1521)
    }
}
