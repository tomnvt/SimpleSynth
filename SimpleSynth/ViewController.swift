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

    var polyphonicButton = UIButton()
    var octaveDown = UIButton()
    var octaveUp = UIButton()
    var wave1Picker = UIPickerView()
    
    var currentMIDINote: MIDINoteNumber = 0
    
    let oscLabel1 = UILabel()
    let oscLabel2 = UILabel()
    
    var beatOnOff = UIButton()
    
    var drums : AKAudioPlayer?
    
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
    
    var mixer = AKMixer()
    var postFxMixer = AKMixer()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        beatOnOff.backgroundColor = UIColor.cyan
        beatOnOff.setTitle("Beat: OFF", for: .normal)
        beatOnOff.setTitleColor(UIColor.black, for: .normal)
        
        drums = getAudioFile()
        
        self.view.addSubview(beatOnOff)
        
        oscLabel1.text = "OSC 1"
        oscLabel1.textColor = UIColor.white
        oscLabel1.textAlignment = .center
        
        self.view.addSubview(oscLabel1)
        
        oscLabel2.text = "OSC 2"
        oscLabel2.textColor = UIColor.white
        oscLabel2.textAlignment = .center

        self.view.addSubview(oscLabel2)
        
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
        
        reverb.dryWetMix = 0.5
        
        delay.time = 0.3
        delay.feedback = 0.5
        delay.dryWetMix = 0.0
        
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
            self.bank2.attackDuration = att
            self.bank2.decayDuration = dec
            self.bank2.sustainLevel = sus
            self.bank2.releaseDuration = rel
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
        
        self.view.addSubview(polyphonicButton)
        self.view.addSubview(octaveUp)
        self.view.addSubview(octaveDown)
        
        polyphonicButton.snp.makeConstraints( { (make) -> Void in
            make.bottom.equalTo(octaveUp.snp.top)
            make.height.equalTo(self.view.frame.size.height / 10)
            make.width.equalTo(self.view.frame.size.width / 4)
        })

        self.view.addSubview(wave1Picker)
        
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
    
        octaveDown.setTitle("-1", for: .normal)
        octaveDown.backgroundColor = UIColor.cyan
        octaveDown.setTitleColor(UIColor.black, for: .normal)
        octaveDown.titleLabel?.font = UIFont.boldSystemFont(ofSize: self.view.frame.size.width / 52)
        octaveDown.addTarget(self, action: #selector(octaveDownPressed(sender:)), for: .touchDown)
        
        octaveDown.snp.makeConstraints( { (make) -> Void in
            make.bottom.equalTo(keyboard.snp.top)
            make.left.equalTo(self.view.snp.left)
            make.height.equalTo((self.view.frame.size.height / 10) * 1 + self.view.frame.size.height / 200)
            make.width.equalTo((self.view.frame.size.width / 4) / 3)
        })
        
        octaveUp.setTitle("+1", for: .normal)
        octaveUp.backgroundColor = UIColor.cyan
        octaveUp.setTitleColor(UIColor.black, for: .normal)
        octaveUp.titleLabel?.font = UIFont.boldSystemFont(ofSize: self.view.frame.size.width / 52)
        octaveUp.addTarget(self, action: #selector(octaveUpPressed(sender:)), for: .touchDown)
        
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
        
        beatOnOff.snp.makeConstraints( { (make) -> Void in
            make.top.equalTo(polyphonicButton.snp.top)
            make.left.equalTo(polyphonicButton.snp.right)
            make.bottom.equalTo(keyboard.snp.top)
            make.width.equalTo(wave2Picker.snp.width)
        })
        
        beatOnOff.addTarget(self, action: #selector(beatOnOff(sender:)), for: .touchDown)
        
        routeAudio()
        
        self.view.backgroundColor = UIColor.black
        
        polyphonicButton.setTitle("Monophonic mode", for: .normal)
        polyphonicButton.backgroundColor = UIColor.cyan
        polyphonicButton.setTitleColor(UIColor.black, for: .normal)
        polyphonicButton.titleLabel?.font = UIFont.boldSystemFont(ofSize: self.view.frame.size.width / 52)
        
        polyphonicButton.addTarget(self, action: #selector(polyphonicButtonPressed(sender:)), for: .touchDown)
        
    }
    
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        if pickerView.tag == 1 {
            return waveformNames.count
        } else if pickerView.tag == 2 {
            return waveformNames.count
        }
        return 0
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        if pickerView.tag == 1 {
            return waveformNames[row]
        } else if pickerView.tag == 2 {
            return waveformNames[row]
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
        mixer = AKMixer(bank1, bank2)
        filter = AKKorgLowPassFilter(mixer)
        filter.play()
        reverb = AKReverb(filter)
        reverb.dryWetMix = reverbSlider.value
        delay = AKDelay(reverb)
        delay.dryWetMix = delaySlider.value
        postFxMixer = AKMixer(delay, drums)
        AudioKit.output = postFxMixer
        AudioKit.start()
    }

    @objc fileprivate func polyphonicButtonPressed(sender: UIButton) {
        keyboard.polyphonicMode = !keyboard.polyphonicMode
        if keyboard.polyphonicMode {
            polyphonicButton.setTitle("Polyphonic mode", for: .normal)
        } else if !keyboard.polyphonicMode {
            polyphonicButton.setTitle("Monophonic mode", for: .normal)
        }
    }
    
     @objc fileprivate func octaveDownPressed(sender: UIButton) {
        if octave >= 0 {
            octave -= 1
            keyboard.firstOctave = octave
            octaveLabel.text = String(octave + 1)
        }
    }
    
    
     @objc fileprivate func octaveUpPressed(sender: UIButton) {
        if octave <= 5 {
            octave += 1
            keyboard.firstOctave = octave
            octaveLabel.text = String(octave + 1)
        }
    }
    
    @objc fileprivate func beatOnOff(sender: UIButton) {
        if beatOnOff.currentTitle == "Beat: OFF" {
            beatOnOff.setTitle("Beat: ON", for: .normal)
            drums?.looping = true
            drums?.play()
        } else {
            beatOnOff.setTitle("Beat: OFF", for: .normal)
            drums?.stop()
        }
    }
    
}

