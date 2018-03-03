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
import SnapKit


class ViewController: UIViewController, UIPickerViewDelegate, UIPickerViewDataSource, AKKeyboardDelegate {

    @IBOutlet weak var wave1Picker: UIPickerView!
    @IBOutlet weak var monophonicButton: UIButton!
    @IBOutlet weak var polyphonicButton: UIButton!
    
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
        
        UIApplication.shared.statusBarStyle = .lightContent
        
        wave1Picker.dataSource = self
        wave1Picker.delegate = self
        
        keyboard = AKKeyboardView(width: Int(self.view.frame.size.width), height: Int(self.view.frame.size.height)/3, firstOctave: 3, octaveCount: 2)
        keyboard.delegate = self
        self.view.addSubview(keyboard)
        keyboard.snp.makeConstraints( { (make) -> Void in
            make.left.bottom.right.equalToSuperview()
            make.height.equalTo(self.view.frame.size.height/3)
            
        })
        
        filter = AKKorgLowPassFilter(bank)
        
        AudioKit.output = filter
        
        AudioKit.start()
        
        filterSlider = AKSlider(property: "Low Pass Cutoff",
                                value: filter.cutoffFrequency,
                                range: 20 ... 20000,
                                taper: 5,
                                format: "%0.1f Hz",
                                frame: CGRect(x: self.view.frame.size.width/2,
                                              y: ((self.view.frame.size.height / 10) * 0 + self.view.frame.size.height / 20),
                                              width: (self.view.frame.size.width / 2) - 10,
                                              height: 50))
        { sliderValue in self.filter.cutoffFrequency = sliderValue }

        self.view.addSubview(filterSlider)
        
        monophonicButton.backgroundColor = UIColor.cyan
        monophonicButton.setTitleColor(UIColor.black, for: .normal)
        monophonicButton.titleLabel?.font = UIFont.boldSystemFont(ofSize: self.view.frame.size.width / 52)
        
        polyphonicButton.backgroundColor = UIColor.cyan
        polyphonicButton.setTitleColor(UIColor.black, for: .normal)
        polyphonicButton.titleLabel?.font = UIFont.boldSystemFont(ofSize: self.view.frame.size.width / 52)
        
        
        monophonicButton.snp.makeConstraints( { (make) -> Void in
            make.topMargin.equalTo((self.view.frame.size.height / 10) * 0 + self.view.frame.size.height / 20)
            make.height.equalTo(self.view.frame.size.height / 10)
            make.width.equalTo(self.view.frame.size.width / 6)
        })
        
        polyphonicButton.snp.makeConstraints( { (make) -> Void in
            make.topMargin.equalTo((self.view.frame.size.height / 10) * 1 + self.view.frame.size.height / 20)
            make.height.equalTo(self.view.frame.size.height / 10)
            make.width.equalTo(self.view.frame.size.width / 6)
        })

        wave1Picker.snp.makeConstraints( { (make) -> Void in
            make.topMargin.equalTo((self.view.frame.size.height / 10) * 2 + self.view.frame.size.height / 20)
            make.height.equalTo((self.view.frame.size.height / 10)*3)
            make.width.equalTo(self.view.frame.size.width / 6)
        })
        
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
    
    func pickerView(_ pickerView: UIPickerView, viewForRow row: Int, forComponent component: Int, reusing view: UIView?) -> UIView {
        var label = view as! UILabel!
        if label == nil {
            label = UILabel()
        }
        
        label?.font = UIFont.systemFont(ofSize: self.view.frame.size.width / 45)
        label?.text =  waveformNames[row]
        label?.textColor = UIColor.white
        label?.textAlignment = .center
        return label!
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

