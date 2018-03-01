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

    @IBOutlet weak var wave1Picker: UIPickerView!
    @IBOutlet weak var keyboardView: UIView!
    @IBOutlet weak var monophonicButton: UIButton!
    @IBOutlet weak var polyphonicButton: UIButton!
    
    var currentMIDINote: MIDINoteNumber = 0
    
    var keyboard = AKKeyboardView()
    
    var bank = AKOscillatorBank(waveform: AKTable(.square),
                                attackDuration: 0.1,
                                releaseDuration: 0.1)
    
    var currentAmplitude = 0.1
    var currentRampTime = 0.0
    
    let waveforms = [AKTable(.square), AKTable(.triangle), AKTable(.sine), AKTable(.sawtooth)]
    let waveformNames = ["square", "triangle", "sine", "sawtooth"]
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        AudioKit.output = bank

        AudioKit.start()
        
        wave1Picker.dataSource = self
        wave1Picker.delegate = self
        
        keyboard = AKKeyboardView(width: Int(keyboardView.frame.size.width), height: Int(keyboardView.frame.size.height), firstOctave: 3, octaveCount: 2)
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
        setWaveform(waveformIndex: row)
    }
    
    func noteOn(note: MIDINoteNumber) {
        bank.play(noteNumber: note, velocity: 80)
    }
    
    func noteOff(note: MIDINoteNumber) {
        bank.stop(noteNumber: note)
    }
    
    func setWaveform(waveformIndex: Int) {
        bank = AKOscillatorBank(waveform: waveforms[waveformIndex])
        AudioKit.output = bank

        AudioKit.start()
    }
    
    @IBAction func monophonicButtonPressed(_ sender: UIButton) {
        keyboard.polyphonicMode = false
    }
    @IBAction func polyphonicButtonPressed(_ sender: UIButton) {
        keyboard.polyphonicMode = true
    }
    
}

