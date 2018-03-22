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
    
    override func viewDidLoad() {
        super.viewDidLoad()

        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        
    }
    
    func changeDrums(newFile: String) {
        synth.drumsFile = newFile
        synth.drums = synth.getDrums(file: synth.drumsFile)
    }
    
}
