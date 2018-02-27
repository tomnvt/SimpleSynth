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

class ViewController: UIViewController, UIPickerViewDelegate, UIPickerViewDataSource {

    @IBOutlet weak var pianoView: PianoView!
    @IBOutlet weak var noteLabel: UILabel!
    @IBOutlet weak var wave1Picker: UIPickerView!
    
    var currentMIDINote: MIDINoteNumber = 0
    
    var oscillator : AKOscillator?
    
    let notes = ["C", "C#", "D", "D#", "E", "F", "F#", "G", "G#", "A", "A#", "B", "C", "C#", "D", "D#", "E", "F", "F#", "G", "G#", "A", "A#", "B", "C"]
    
    let waveforms = [AKTable(.square, count: 256), AKTable(.triangle, count: 256), AKTable(.sine, count: 256), AKTable(.sawtooth, count: 256)]
    let waveformNames = ["square", "triangle", "sine", "sawtooth"]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setOscillator(waveformIndex: 0)
        
        AudioKit.start()

        wave1Picker.dataSource = self
        wave1Picker.delegate = self
    }
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return waveformNames.count;
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return waveformNames[row]
    }
    
    func pickerView(_ pickerView: UIPickerView, attributedTitleForRow row: Int, forComponent component: Int) -> NSAttributedString? {
        let attributedString = NSAttributedString(string: waveformNames[row], attributes: [NSAttributedStringKey.foregroundColor : UIColor.white])
        return attributedString
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        setOscillator(waveformIndex: row)
    }
    
    func setOscillator(waveformIndex: Int) {
        oscillator = AKOscillator(waveform: waveforms[waveformIndex])
        AudioKit.output = oscillator
        oscillator?.rampTime = 0.2
        oscillator?.amplitude = 0.05
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

