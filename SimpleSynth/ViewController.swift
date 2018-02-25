//
//  ViewController.swift
//  SimpleSynth
//
//  Created by NVT on 24.02.18.
//  Copyright © 2018 NVA. All rights reserved.
//

import UIKit
import PianoView

class ViewController: UIViewController {

    @IBOutlet weak var pianoView: PianoView!
    @IBOutlet weak var noteLabel: UILabel!
    
    let notes = ["C", "C#", "D", "D#", "E", "F", "F#", "G", "G#", "A", "A#", "B", "C", "C#", "D", "D#", "E", "F", "F#", "G", "G#", "A", "A#", "B", "C"]
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }

    @IBAction func keyButtonPressed(_ sender: UIButton) {
        noteLabel.text = "\(notes[sender.tag]) pressed"
    }
    
    
    @IBAction func keyButtonReleased(_ sender: UIButton) {
        noteLabel.text = "\(notes[sender.tag]) released"
    }
    
}

