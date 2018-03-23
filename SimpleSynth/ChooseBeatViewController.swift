//
//  ChooseBeatViewController.swift
//  SimpleSynth
//
//  Created by NVT on 20.03.18.
//  Copyright © 2018 NVA. All rights reserved.
//

import UIKit

class ChooseBeatViewController: UIViewController {

    let synth = Synth()
    let beat = Beat()
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    func changeDrums(newFile: String) {
        beat.drumsFile = newFile
        beat.drums = beat.getDrums(file: beat.drumsFile)
    }
    
}
