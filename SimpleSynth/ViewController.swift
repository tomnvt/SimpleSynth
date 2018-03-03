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
    @IBOutlet weak var monophonicButton: UIButton!
    @IBOutlet weak var polyphonicButton: UIButton!
    @IBOutlet weak var topView: UIView!
    @IBOutlet weak var filterView: UIView!
    @IBOutlet var mainView: UIView!
    
    var currentMIDINote: MIDINoteNumber = 0
    
    var keyboard = AKKeyboardView()
    
    var bank = AKOscillatorBank(waveform: AKTable(.square),
                                attackDuration: 0.1,
                                releaseDuration: 0.1)
    
    var filter = AKKorgLowPassFilter()
    var filterSlider = AKSlider(property: "Cutoff Frequency")
    
    var currentAmplitude = 0.1
    var currentRampTime = 0.0
    
    let waveforms = [AKTable(.square), AKTable(.triangle), AKTable(.sine), AKTable(.sawtooth)]
    let waveformNames = ["square", "triangle", "sine", "sawtooth"]
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        wave1Picker.dataSource = self
        wave1Picker.delegate = self
        
        keyboard = AKKeyboardView(width: Int(mainView.frame.size.width), height: Int(mainView.frame.size.height)/3, firstOctave: 3, octaveCount: 2)
        keyboard.delegate = self
        mainView.addSubview(keyboard)
        keyboard.frame = CGRect(x: 0, y: mainView.frame.size.height - mainView.frame.size.height/3, width: mainView.frame.size.width, height: mainView.frame.size.height/3)
        
        filter = AKKorgLowPassFilter(bank)
        
        AudioKit.output = filter
        
        AudioKit.start()
        
        filterSlider = AKSlider(property: "Cutoff Frequency", value: filter.cutoffFrequency, range: 20 ... 20000, taper: 5, format: "%0.1f Hz", frame: CGRect(x: 10, y: 10, width: mainView.frame.size.width / 2, height: 50))  { sliderValue in self.filter.cutoffFrequency = sliderValue }
        
        topView.addSubview(filterSlider)
        
        filter.play()
        
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
        filter = AKKorgLowPassFilter(bank)
        filter.play()
        AudioKit.output = filter
        AudioKit.start()
    }
    
    @IBAction func monophonicButtonPressed(_ sender: UIButton) {
        keyboard.polyphonicMode = false
    }
    @IBAction func polyphonicButtonPressed(_ sender: UIButton) {
        keyboard.polyphonicMode = true
    }
    
}

