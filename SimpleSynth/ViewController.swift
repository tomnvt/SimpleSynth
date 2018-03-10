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
    @IBOutlet weak var polyphonicButton: UIButton!
    @IBOutlet weak var octaveDown: UIButton!
    @IBOutlet weak var octaveUp: UIButton!
    
    var currentMIDINote: MIDINoteNumber = 0
    
    var keyboard = AKKeyboardView()
    
    var bank1 = AKOscillatorBank(waveform: AKTable(.square),
                                 attackDuration: 0.1,
                                 releaseDuration: 0.1)
    
    var bank2 = AKOscillatorBank(waveform: AKTable(.triangle),
                                 attackDuration: 0.1,
                                 releaseDuration: 0.1)
    
    var octave = 3
    
    let octaveLabel: UILabel = {
        let label = UILabel()
        label.backgroundColor = .cyan
        return label
    }()
    
    var filter = AKKorgLowPassFilter()
    var filterSlider = AKSlider(property: "Cutoff Frequency")
    
    var reverb = AKReverb()
    var reverbSlider = AKSlider(property: "Reverb Amount")
    
    var delay = AKDelay()
    var delaySlider = AKSlider(property: "Delay Amount")
    
    var currentAmplitude = 0.1
    var currentRampTime = 0.0
    
    let waveforms = [AKTable(.square), AKTable(.triangle), AKTable(.sine), AKTable(.sawtooth)]
    let waveformNames = ["off", "square", "triangle", "sine", "sawtooth"]
    
    var wave2Picker = UIPickerView()
    
    let waveforms2 = [AKTable(.square), AKTable(.triangle), AKTable(.sine), AKTable(.sawtooth)]
    let waveform2Names = ["off2", "square", "triangle", "sine", "sawtooth"]
    
    var mixer = AKMixer()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        UIApplication.shared.statusBarStyle = .lightContent
        
        wave1Picker.dataSource = self
        wave1Picker.delegate = self
        wave2Picker.dataSource = self
        wave2Picker.delegate = self
        
        keyboard = AKKeyboardView(width: Int(self.view.frame.size.width),
                                  height: Int(self.view.frame.size.height)/3,
                                  firstOctave: octave,
                                  octaveCount: 2)
        keyboard.delegate = self
        self.view.addSubview(keyboard)
        keyboard.snp.makeConstraints( { (make) -> Void in
            make.left.bottom.right.equalToSuperview()
            make.height.equalTo(self.view.frame.size.height/3)
            
        })
        
        filter = AKKorgLowPassFilter(mixer)
        
        reverb = AKReverb(filter)
        reverb.dryWetMix = 0.5
        
        delay = AKDelay(reverb)
        delay.time = 0.3
        delay.feedback = 0.5
        delay.dryWetMix = 0.0
        
        AudioKit.output = delay
        
        AudioKit.start()
        
        filterSlider = AKSlider(property: "Low Pass Cutoff",
                                value: filter.cutoffFrequency,
                                range: 20 ... 20000,
                                taper: 5,
                                format: "%0.1f Hz",
                                frame: CGRect(x: self.view.frame.size.width/2,
                                              y: ((self.view.frame.size.height / 10) * 0 + self.view.frame.size.height / 20),
                                              width: (self.view.frame.size.width / 2) - 10,
                                              height: (self.view.frame.size.height / 9)))
        { sliderValue in self.filter.cutoffFrequency = sliderValue }

        self.view.addSubview(filterSlider)
        
        let adsrView = AKADSRView { att, dec, sus, rel in
            self.bank1.attackDuration = att
            self.bank1.decayDuration = dec
            self.bank1.sustainLevel = sus
            self.bank1.releaseDuration = rel
        }
        
        adsrView.attackDuration = bank1.attackDuration
        adsrView.decayDuration = bank1.decayDuration
        adsrView.releaseDuration = bank1.releaseDuration
        adsrView.sustainLevel = bank1.sustainLevel
        
        adsrView.frame = CGRect(x: self.view.frame.size.width/2,
                                y: ((self.view.frame.size.height / 9) * 1 + self.view.frame.size.height / 20),
                                width: (self.view.frame.size.width / 2) - 10,
                                height: (self.view.frame.size.height / 9) * 2 )
        
        self.view.addSubview(adsrView)
        
        reverbSlider = AKSlider(property: "Reverb Amount",
                                value: reverb.dryWetMix,
                                frame: CGRect(x: self.view.frame.size.width/2,
                                              y: (filterSlider.frame.size.height * 1.55 + adsrView.frame.size.height),
                                              width: (self.view.frame.size.width / 2) - 10,
                                              height: (self.view.frame.size.height / 9)))
        { sliderValue in self.reverb.dryWetMix = sliderValue }
        
        self.view.addSubview(reverbSlider)
        
        delaySlider = AKSlider(property: "Delay Amount",
                               value: delay.dryWetMix,
                               frame: CGRect(x: self.view.frame.size.width/2,
                                             y: (filterSlider.frame.size.height * 2.65 + adsrView.frame.size.height),
                                             width: (self.view.frame.size.width / 2) - 10,
                                             height: (self.view.frame.size.height / 9)))
        { sliderValue in self.delay.dryWetMix = sliderValue }
        
        self.view.addSubview(delaySlider)
        
        polyphonicButton.backgroundColor = UIColor.cyan
        polyphonicButton.setTitleColor(UIColor.black, for: .normal)
        polyphonicButton.titleLabel?.font = UIFont.boldSystemFont(ofSize: self.view.frame.size.width / 52)
        
        polyphonicButton.snp.makeConstraints( { (make) -> Void in
            make.bottom.equalTo(octaveUp.snp.top)
            make.height.equalTo(self.view.frame.size.height / 10)
            make.width.equalTo(self.view.frame.size.width / 4)
        })

        wave1Picker.tag = 1
        
        wave1Picker.snp.makeConstraints( { (make) -> Void in
            make.top.equalTo(self.view.snp.top).offset(self.view.frame.size.height / 10)
            make.height.equalTo((self.view.frame.size.height / 10)*3)
            make.width.equalTo(self.view.frame.size.width / 4)
        })
        
        self.view.addSubview(wave2Picker)
        
        wave2Picker.tag = 2
        
        wave2Picker.snp.makeConstraints( { (make) -> Void in
            make.top.equalTo(self.view.snp.top).offset(self.view.frame.size.height / 10)
            make.height.equalTo((self.view.frame.size.height / 10)*3)
            make.width.equalTo(self.view.frame.size.width / 4)
            make.right.equalTo(delaySlider.snp.left)
        })
    
        octaveDown.backgroundColor = UIColor.cyan
        octaveDown.setTitleColor(UIColor.black, for: .normal)
        octaveDown.titleLabel?.font = UIFont.boldSystemFont(ofSize: self.view.frame.size.width / 52)
        
        octaveDown.snp.makeConstraints( { (make) -> Void in
            make.bottom.equalTo(keyboard.snp.top)
            make.height.equalTo((self.view.frame.size.height / 10) * 1 + self.view.frame.size.height / 200)
            make.width.equalTo((self.view.frame.size.width / 4) / 3)
        })
        
        octaveUp.backgroundColor = UIColor.cyan
        octaveUp.setTitleColor(UIColor.black, for: .normal)
        octaveUp.titleLabel?.font = UIFont.boldSystemFont(ofSize: self.view.frame.size.width / 52)
        
        octaveUp.snp.makeConstraints( { (make) -> Void in
            make.bottom.equalTo(keyboard.snp.top)
            make.rightMargin.equalTo(polyphonicButton)
            make.height.equalTo((self.view.frame.size.height / 10) * 1 + self.view.frame.size.height / 200)
            make.width.equalTo((self.view.frame.size.width / 4) / 3)
        })
        
        self.view.addSubview(octaveLabel)
        octaveLabel.text = String(octave + 1)
        octaveLabel.textAlignment = .center
        octaveLabel.textColor = UIColor.black
        octaveLabel.font = UIFont.boldSystemFont(ofSize: self.view.frame.size.width / 52)
        
        octaveLabel.snp.makeConstraints( { make in
            make.top.equalTo(polyphonicButton.snp.bottom)
            make.left.equalTo(octaveDown.snp.right)
            make.right.equalTo(octaveUp.snp.left)
            make.bottom.equalTo(keyboard.snp.top)
            make.height.equalTo((self.view.frame.size.height / 10) * 1 + self.view.frame.size.height / 200)
            make.width.equalTo(self.view.frame.size.width / 15)
        })
        
        mixer = AKMixer(bank1, bank2)
        
        filter.play()
        
    }
    
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        if pickerView.tag == 1 {
            return waveformNames.count
        } else if pickerView.tag == 2 {
            return waveform2Names.count
        }
        return 0
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        if pickerView.tag == 1 {
            return waveformNames[row]
        } else if pickerView.tag == 2 {
            return waveform2Names[row]
        }
        return nil
    }
    
    func pickerView(_ pickerView: UIPickerView, attributedTitleForRow row: Int, forComponent component: Int) -> NSAttributedString? {
        let attributedString = NSAttributedString(string: waveformNames[row], attributes: [NSAttributedStringKey.foregroundColor : UIColor.white])
        return attributedString
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        if pickerView.tag == 1 {
            if row == 0 {
                bank1.disconnectOutput()
            } else {
                setWaveform(forBank: 1, waveformIndex: row - 1)
            }
        }
        if pickerView.tag == 2 {
            if row == 0 {
                bank2.disconnectOutput()
            } else {
                setWaveform(forBank: 2, waveformIndex: row - 1)
            }
        }
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
        bank1.play(noteNumber: note, velocity: 80)
        bank2.play(noteNumber: note, velocity: 80)
    }
    
    func noteOff(note: MIDINoteNumber) {
        bank1.stop(noteNumber: note)
        bank2.stop(noteNumber: note)
    }
    
    func setWaveform(forBank: Int, waveformIndex: Int) {
        switch forBank {
        case 1:
            bank1 = AKOscillatorBank(waveform: waveforms[waveformIndex])
            break
        case 2:
            bank2 = AKOscillatorBank(waveform: waveforms[waveformIndex])
            break
        default:
            break
        }
        mixer = AKMixer(bank1, bank2)
        filter = AKKorgLowPassFilter(mixer)
        filter.play()
        reverb = AKReverb(filter)
        reverb.dryWetMix = reverbSlider.value
        delay = AKDelay(reverb)
        delay.dryWetMix = delaySlider.value
        AudioKit.output = delay
        AudioKit.start()
    }

    @IBAction func polyphonicButtonPressed(_ sender: UIButton) {
        keyboard.polyphonicMode = !keyboard.polyphonicMode
        if keyboard.polyphonicMode {
            polyphonicButton.setTitle("Polyphonic mode", for: .normal)
        } else if !keyboard.polyphonicMode {
            polyphonicButton.setTitle("Monophonic mode", for: .normal)
        }
    }
    
    @IBAction func octaveDownPressed(_ sender: UIButton) {
        if octave >= 0 {
            octave -= 1
            keyboard.firstOctave = octave
            octaveLabel.text = String(octave + 1)
        }
    }
    
    
    @IBAction func octaveUpPressed(_ sender: UIButton) {
        if octave <= 5 {
            octave += 1
            keyboard.firstOctave = octave
            octaveLabel.text = String(octave + 1)
        }
    }
}

