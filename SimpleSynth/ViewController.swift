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

    // Numeric variables
    var octave = 3
    var currentAmplitude = 0.1
    var currentRampTime = 0.0
    
    // UI elements declaration
    var polyphonicButton: UIButton = {
        let button = UIButton()
        button.setTitle("Monophonic mode", for: .normal)
        button.backgroundColor = UIColor.cyan
        button.setTitleColor(UIColor.black, for: .normal)
        return button
    }()
    
    var octaveDown: UIButton = {
        let button = UIButton()
        button.setTitle("-1", for: .normal)
        button.backgroundColor = UIColor.cyan
        button.setTitleColor(UIColor.black, for: .normal)
        return button
    }()
    
    var octaveUp: UIButton = {
        let button = UIButton()
        button.setTitle("+1", for: .normal)
        button.backgroundColor = UIColor.cyan
        button.setTitleColor(UIColor.black, for: .normal)
        return button
    }()
    
    var beatOnOff: UIButton = {
        let button = UIButton()
        button.backgroundColor = UIColor.cyan
        button.setTitle("Beat: OFF", for: .normal)
        button.setTitleColor(UIColor.black, for: .normal)
        return button
    }()

    var wave1Picker: UIPickerView = {
       let picker = UIPickerView()
        picker.tag = 1
        return picker
    }()
    
    var wave2Picker: UIPickerView = {
        let picker = UIPickerView()
        picker.tag = 2
        return picker
    }()
    
    let oscLabel1: UILabel = {
        let label = UILabel()
        label.text = "OSC 1"
        label.textColor = UIColor.white
        label.textAlignment = .center
        return label
    }()
    
    let oscLabel2: UILabel = {
        let label = UILabel()
        label.text = "OSC 2"
        label.textColor = UIColor.white
        label.textAlignment = .center
        return label
    }()
    
    let octaveLabel: UILabel = {
        let label = UILabel()
        label.backgroundColor = .cyan
        label.text = "4"
        label.textAlignment = .center
        label.textColor = UIColor.black
        return label
    }()
    
    let synth = Synth()
    
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        self.view.backgroundColor = UIColor.black
        
        synth.drums = getAudioFile()
        
        self.view.addSubview(beatOnOff)
        
        self.view.addSubview(oscLabel1)
        
        self.view.addSubview(oscLabel2)
        
        UIApplication.shared.statusBarStyle = .lightContent
        
        wave1Picker.dataSource = self
        wave1Picker.delegate = self
        wave2Picker.dataSource = self
        wave2Picker.delegate = self
        
        synth.keyboard = AKKeyboardView(width: Int(self.view.frame.size.width),
                                        height: Int(self.view.frame.size.height)/3,
                                        firstOctave: octave,
                                        octaveCount: 2)
        synth.keyboard.delegate = self
        self.view.addSubview(synth.keyboard)
        synth.keyboard.snp.makeConstraints( { (make) -> Void in
            make.left.bottom.right.equalToSuperview()
            make.height.equalTo(self.view.frame.size.height/3)
            
        })
        
        synth.filterSlider = AKSlider(property: "Low Pass Cutoff",
                                      value: synth.filter.cutoffFrequency,
                                      range: 20 ... 20000,
                                      taper: 5,
                                      format: "%0.1f Hz",
                                      frame: CGRect(x: self.view.frame.size.width/2,
                                                    y: ((self.view.frame.size.height / 10) * 0 + self.view.frame.size.height / 20),
                                                    width: (self.view.frame.size.width / 2) - 10,
                                                    height: (self.view.frame.size.height / 9)))
        { sliderValue in self.synth.filter.cutoffFrequency = sliderValue }
        self.view.addSubview(synth.filterSlider)
        
        
        synth.adsrView.frame = CGRect(x: self.view.frame.size.width/2,
                                y: ((self.view.frame.size.height / 9) * 1 + self.view.frame.size.height / 20),
                                width: (self.view.frame.size.width / 2) - 10,
                                height: (self.view.frame.size.height / 9) * 2 )
        self.view.addSubview(synth.adsrView)
        
        
        synth.reverbSlider = AKSlider(property: "Reverb Amount",
                                value: synth.reverb.dryWetMix,
                                frame: CGRect(x: self.view.frame.size.width/2,
                                              y: (synth.filterSlider.frame.size.height * 1.55 + synth.adsrView.frame.size.height),
                                              width: (self.view.frame.size.width / 2) - 10,
                                              height: (self.view.frame.size.height / 9)))
        { sliderValue in self.synth.reverb.dryWetMix = sliderValue }
        self.view.addSubview(synth.reverbSlider)
        
        
        synth.delaySlider = AKSlider(property: "Delay Amount",
                               value: synth.delay.dryWetMix,
                               frame: CGRect(x: self.view.frame.size.width/2,
                                             y: (synth.filterSlider.frame.size.height * 2.65 + synth.adsrView.frame.size.height),
                                             width: (self.view.frame.size.width / 2) - 10,
                                             height: (self.view.frame.size.height / 9)))
        { sliderValue in self.synth.delay.dryWetMix = sliderValue }
        self.view.addSubview(synth.delaySlider)
        
        
        self.view.addSubview(wave1Picker)
        wave1Picker.snp.makeConstraints( { (make) -> Void in
            make.top.equalTo(self.view.snp.top).offset(self.view.frame.size.height / 10)
            make.height.equalTo((self.view.frame.size.height / 10)*3)
            make.width.equalTo(self.view.frame.size.width / 4)
        })
        
        
        self.view.addSubview(wave2Picker)
        wave2Picker.snp.makeConstraints( { (make) -> Void in
            make.top.equalTo(self.view.snp.top).offset(self.view.frame.size.height / 10)
            make.height.equalTo((self.view.frame.size.height / 10)*3)
            make.width.equalTo(self.view.frame.size.width / 4)
            make.right.equalTo(synth.delaySlider.snp.left)
        })
        
        
        oscLabel1.snp.makeConstraints( { (make) -> Void in
            make.top.equalTo(0).offset(self.view.frame.height / 20)
            make.left.equalTo(0)
            make.right.equalTo(wave2Picker.snp.left)
            make.bottom.equalTo(wave1Picker.snp.top)
        })
        
        oscLabel2.snp.makeConstraints( { (make) -> Void in
            make.top.equalTo(0).offset(self.view.frame.height / 20)
            make.left.equalTo(oscLabel1.snp.right)
            make.right.equalTo(wave2Picker.snp.right)
            make.bottom.equalTo(wave1Picker.snp.top)
        })
    
        
        self.view.addSubview(octaveDown)
        octaveDown.snp.makeConstraints( { (make) -> Void in
            make.bottom.equalTo(synth.keyboard.snp.top)
            make.left.equalTo(self.view.snp.left)
            make.height.equalTo((self.view.frame.size.height / 10) * 1 + self.view.frame.size.height / 200)
            make.width.equalTo((self.view.frame.size.width / 4) / 3)
        })
        octaveDown.titleLabel?.font = UIFont.boldSystemFont(ofSize: self.view.frame.size.width / 52)
        octaveDown.addTarget(self, action: #selector(octaveDownPressed(sender:)), for: .touchDown)
        
        
        self.view.addSubview(polyphonicButton)
        polyphonicButton.snp.makeConstraints( { (make) -> Void in
            make.bottom.equalTo(octaveDown.snp.top)
            make.height.equalTo(self.view.frame.size.height / 10)
            make.width.equalTo(self.view.frame.size.width / 4)
        })
        polyphonicButton.titleLabel?.font = UIFont.boldSystemFont(ofSize: self.view.frame.size.width / 52)
        polyphonicButton.addTarget(self, action: #selector(polyphonicButtonPressed(sender:)), for: .touchDown)
        
        
        self.view.addSubview(octaveUp)
        octaveUp.snp.makeConstraints( { (make) -> Void in
            make.bottom.equalTo(synth.keyboard.snp.top)
            make.rightMargin.equalTo(polyphonicButton)
            make.height.equalTo((self.view.frame.size.height / 10) * 1 + self.view.frame.size.height / 200)
            make.width.equalTo((self.view.frame.size.width / 4) / 3)
        })
        octaveUp.titleLabel?.font = UIFont.boldSystemFont(ofSize: self.view.frame.size.width / 52)
        octaveUp.addTarget(self, action: #selector(octaveUpPressed(sender:)), for: .touchDown)
        
        
        self.view.addSubview(octaveLabel)
        octaveLabel.snp.makeConstraints( { make in
            make.top.equalTo(polyphonicButton.snp.bottom)
            make.left.equalTo(octaveDown.snp.right)
            make.right.equalTo(octaveUp.snp.left)
            make.bottom.equalTo(synth.keyboard.snp.top)
            make.height.equalTo((self.view.frame.size.height / 10) * 1 + self.view.frame.size.height / 200)
            make.width.equalTo(self.view.frame.size.width / 15)
        })
        octaveLabel.font = UIFont.boldSystemFont(ofSize: self.view.frame.size.width / 52)
        
        
        beatOnOff.snp.makeConstraints( { (make) -> Void in
            make.top.equalTo(polyphonicButton.snp.top)
            make.left.equalTo(polyphonicButton.snp.right)
            make.bottom.equalTo(synth.keyboard.snp.top)
            make.width.equalTo(wave2Picker.snp.width)
        })
        beatOnOff.addTarget(self, action: #selector(beatOnOff(sender:)), for: .touchDown)
        
        routeAudio()
        
    }
    
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        if pickerView.tag == 1 {
            return synth.waveformNames.count
        } else if pickerView.tag == 2 {
            return synth.waveformNames.count
        }
        return 0
    }
    
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        if pickerView.tag == 1 {
            return synth.waveformNames[row]
        } else if pickerView.tag == 2 {
            return synth.waveformNames[row]
        }
        return nil
    }
    
    
    func pickerView(_ pickerView: UIPickerView, attributedTitleForRow row: Int, forComponent component: Int) -> NSAttributedString? {
        let attributedString = NSAttributedString(string: synth.waveformNames[row], attributes: [NSAttributedStringKey.foregroundColor : UIColor.white])
        return attributedString
    }
    
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        if pickerView.tag == 1 {
            if row == 0 {
                synth.bank1.disconnectOutput()
            } else {
                setWaveform(forBank: 1, waveformIndex: row - 1)
            }
        }
        if pickerView.tag == 2 {
            if row == 0 {
                synth.bank2.disconnectOutput()
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
        label?.text =  synth.waveformNames[row]
        label?.textColor = UIColor.white
        label?.textAlignment = .center
        return label!
    }
    
    
    func noteOn(note: MIDINoteNumber) {
        synth.bank1.play(noteNumber: note, velocity: 80)
        synth.bank2.play(noteNumber: note, velocity: 80)
    }
    
    
    func noteOff(note: MIDINoteNumber) {
        synth.bank1.stop(noteNumber: note)
        synth.bank2.stop(noteNumber: note)
    }
    
    
    func setWaveform(forBank: Int, waveformIndex: Int) {
        switch forBank {
        case 1:
            synth.bank1 = AKOscillatorBank(waveform: synth.waveforms[waveformIndex])
            break
        case 2:
            synth.bank2 = AKOscillatorBank(waveform: synth.waveforms[waveformIndex])
            break
        default:
            break
        }
        routeAudio()
    }
    
    
    func getAudioFile() -> AKAudioPlayer? {
        do {
            let drumFile = try AKAudioFile(readFileName: "drumloop.wav")
            let drums = try AKAudioPlayer(file: drumFile)
            return drums
        } catch {
            print("No audio file")
        }
        return nil
    }
    
    
    func routeAudio() {
        synth.mixer = AKMixer(synth.bank1, synth.bank2)
        synth.filter = AKKorgLowPassFilter(synth.mixer)
        synth.filter.play()
        synth.reverb = AKReverb(synth.filter)
        synth.reverb.dryWetMix = synth.reverbSlider.value
        synth.delay = AKDelay(synth.reverb)
        synth.delay.dryWetMix = synth.delaySlider.value
        synth.postFxMixer = AKMixer(synth.delay, synth.drums)
        AudioKit.output = synth.postFxMixer
        AudioKit.start()
    }

    
    @objc fileprivate func polyphonicButtonPressed(sender: UIButton) {
        synth.keyboard.polyphonicMode = !synth.keyboard.polyphonicMode
        if synth.keyboard.polyphonicMode {
            polyphonicButton.setTitle("Polyphonic mode", for: .normal)
        } else if !synth.keyboard.polyphonicMode {
            polyphonicButton.setTitle("Monophonic mode", for: .normal)
        }
    }
    
    
     @objc fileprivate func octaveDownPressed(sender: UIButton) {
        if octave >= 0 {
            octave -= 1
            synth.keyboard.firstOctave = octave
            octaveLabel.text = String(octave + 1)
        }
    }
    
    
     @objc fileprivate func octaveUpPressed(sender: UIButton) {
        if octave <= 5 {
            octave += 1
            synth.keyboard.firstOctave = octave
            octaveLabel.text = String(octave + 1)
        }
    }
    
    
    @objc fileprivate func beatOnOff(sender: UIButton) {
        if beatOnOff.currentTitle == "Beat: OFF" {
            beatOnOff.setTitle("Beat: ON", for: .normal)
            synth.drums?.looping = true
            synth.drums?.play()
        } else {
            beatOnOff.setTitle("Beat: OFF", for: .normal)
            synth.drums?.stop()
        }
    }
    
    override func motionEnded(_ motion: UIEventSubtype, with event: UIEvent?) {
        AudioKit.stop()
        beatOnOff.setTitle("Beat: OFF", for: .normal)
        AudioKit.start()
    }
    
}
