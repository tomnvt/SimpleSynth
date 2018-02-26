//
//  ViewController.swift
//  SimpleSynth
//
//  Created by NVT on 24.02.18.
//  Copyright © 2018 NVA. All rights reserved.
//

import UIKit
import PianoView
import AudioKit

class ViewController: UIViewController {

    @IBOutlet weak var pianoView: PianoView!
    @IBOutlet weak var noteLabel: UILabel!
    
    let sine = AKTable(.sine, count: 256)
    
    var currentMIDINote: MIDINoteNumber = 0
    
    var oscillator : AKOscillator?
    
    let notes = ["C", "C#", "D", "D#", "E", "F", "F#", "G", "G#", "A", "A#", "B", "C", "C#", "D", "D#", "E", "F", "F#", "G", "G#", "A", "A#", "B", "C"]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        oscillator = AKOscillator(waveform: sine)

        AudioKit.output = oscillator

        AudioKit.start()

        let currentAmplitude = 0.2
        let currentRampTime = 0.05
        oscillator?.rampTime = currentRampTime
        oscillator?.amplitude = currentAmplitude

    }

    
    @IBAction func keyButtonPressed(_ sender: UIButton) {
        noteLabel.text = "\(notes[sender.tag]) pressed"
        oscillator?.frequency = ((sender.tag)+60).midiNoteToFrequency()
        oscillator?.play()
    }
    
    
    @IBAction func keyButtonReleased(_ sender: UIButton) {
        noteLabel.text = "\(notes[sender.tag]) released"
        oscillator?.stop()
    }
    
}

