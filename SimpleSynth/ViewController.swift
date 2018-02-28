//
//  ViewController.swift
//  SimpleSynth
//
//  Created by NVT on 24.02.18.
//  Copyright © 2018 NVA. All rights reserved.
//

import UIKit
import AudioKit
import AudioKitUI


class ViewController: UIViewController, UIPickerViewDelegate, UIPickerViewDataSource, AKKeyboardDelegate {

    @IBOutlet weak var noteLabel: UILabel!
    @IBOutlet weak var wave1Picker: UIPickerView!
    @IBOutlet weak var keyboardView: UIView!
    
    var currentMIDINote: MIDINoteNumber = 0
    
    var oscillator : AKOscillator?
    
    var currentAmplitude = 0.1
    var currentRampTime = 0.0
    
    let waveforms = [AKTable(.square, count: 256), AKTable(.triangle, count: 256), AKTable(.sine, count: 256), AKTable(.sawtooth, count: 256)]
    let waveformNames = ["square", "triangle", "sine", "sawtooth"]
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setOscillator(waveformIndex: 0)
        
        AudioKit.start()
        
        AudioKit.output = oscillator

        wave1Picker.dataSource = self
        wave1Picker.delegate = self
        
        let keyboard = AKKeyboardView(width: Int(keyboardView.frame.size.width), height: Int(keyboardView.frame.size.height), firstOctave: 3, octaveCount: 2)
        keyboard.delegate = self
        keyboardView.addSubview(keyboard)
        
    }
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return waveformNames.count
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
    func noteOn(note: MIDINoteNumber) {
        currentMIDINote = note
        if oscillator?.amplitude == 0 {
            oscillator?.rampTime = 0
        }
        oscillator?.frequency = note.midiNoteToFrequency()
        
        oscillator?.rampTime = currentRampTime
        oscillator?.amplitude = currentAmplitude
        oscillator?.play()
    }
    
    func noteOff(note: MIDINoteNumber) {
        if currentMIDINote == note {
            oscillator?.amplitude = 0
        }
    }
    
    func setOscillator(waveformIndex: Int) {
        oscillator = AKOscillator(waveform: waveforms[waveformIndex])
        AudioKit.output = oscillator
        oscillator?.rampTime = 0.2
        oscillator?.amplitude = 0.05
    }
    
    
}

