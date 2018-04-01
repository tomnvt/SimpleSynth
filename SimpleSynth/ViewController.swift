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


class ViewController: UIViewController, AKKeyboardDelegate, PassFirstRowDelegate, PassSecondRowDelegate, ChangeBeatDelegate {

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
    
    let chooseBeatButton: UIButton = {
        let button = UIButton()
        button.backgroundColor = UIColor.cyan
        button.setTitle("Choose beat", for: .normal)
        button.setTitleColor(UIColor.black, for: .normal)
        return button
    }()

    let oscLabel1: DropdownButton = {
        let button = DropdownButton()
        button.tag = 1
        return button
    }()
    
    let oscLabel2: DropdownButton = {
        let button = DropdownButton()
        button.tag = 2
        return button
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
    let beat = Beat()
    
    let defaults = UserDefaults.standard
    
    override func viewDidLoad() {
        
        self.navigationController?.setNavigationBarHidden(true, animated: false)
        
        super.viewDidLoad()
        
        self.view.backgroundColor = UIColor.black
        
        self.view.addSubview(beatOnOff)
        
        self.view.addSubview(chooseBeatButton)
        
        self.view.addSubview(oscLabel1)
        
        self.view.addSubview(oscLabel2)
        
        UIApplication.shared.statusBarStyle = .lightContent
        
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
        
    
        oscLabel1.snp.makeConstraints( { (make) -> Void in
            make.top.equalTo(0).offset(self.view.frame.height / 20)
            make.left.equalTo(0)
            make.right.equalTo(view).dividedBy(4)
            make.bottom.equalTo(view).dividedBy(5)
        })
        
        
        oscLabel2.snp.makeConstraints( { (make) -> Void in
            make.top.equalTo(0).offset(self.view.frame.height / 20)
            make.left.equalTo(oscLabel1.snp.right)
            make.right.equalTo(view).dividedBy(2).inset(self.view.frame.size.width / 100)
            make.bottom.equalTo(view).dividedBy(5)
        })
        
        oscLabel1.setTitle("OSC 1", for: .normal)
        oscLabel2.setTitle("OSC 2", for: .normal)
        
        oscLabel1.dropView.dropDownOptions = synth.waveformNames
        oscLabel2.dropView.dropDownOptions = synth.waveformNames
        
        oscLabel1.delegate1 = self
        oscLabel2.delegate2 = self
        
        
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
            make.bottom.equalTo(octaveDown.snp.top)
            make.width.equalTo(oscLabel1.snp.width)
        })
        beatOnOff.addTarget(self, action: #selector(beatOnOff(sender:)), for: .touchDown)
        
        chooseBeatButton.snp.makeConstraints( { (make) -> Void in
            make.top.equalTo(beatOnOff.snp.bottom)
            make.left.equalTo(polyphonicButton.snp.right)
            make.bottom.equalTo(synth.keyboard.snp.top)
            make.width.equalTo(oscLabel1.snp.width)
        })
        chooseBeatButton.addTarget(self, action: #selector(chooseBeatButtonPressed(sender:)), for: .touchDown)
        
        if defaults.bool(forKey: "beatIsPlaying") {
            beatOnOff.setTitle("Beat: ON", for: .normal)
        } else {
            beatOnOff.setTitle("Beat: OFF", for: .normal)
        }
        
        beat.drums = beat.getDrums(file: beat.beatFiles[defaults.integer(forKey: "beatFileNumber")])
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
//        beat.drums = beat.getDrums(file: beat.beatFiles[defaults.integer(forKey: "beatFileNumber")])
        routeAudio(synth: synth, beat: beat)
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
        routeAudio(synth: synth, beat: beat)
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
        if defaults.bool(forKey: "beatIsPlaying") == false {
            beatOnOff.setTitle("Beat: ON", for: .normal)
            beat.drums?.looping = true
            beat.drums?.play()
            defaults.set(true, forKey: "beatIsPlaying")
        } else if  defaults.bool(forKey: "beatIsPlaying") == true {
            stopDaBeat()
        }
    }
    
    
    @objc fileprivate func chooseBeatButtonPressed(sender: UIButton) {
        let vc = storyboard?.instantiateViewController(withIdentifier: "ChooseBeatViewController") as! ChooseBeatViewController
        vc.delegate = self
        navigationController?.pushViewController(vc, animated: true)
    }
    
    
    override func motionEnded(_ motion: UIEventSubtype, with event: UIEvent?) {
        AudioKit.stop()
        AudioKit.start()
    }
    
    
    func stopDaBeat() {
        beat.drums?.stop()
        beatOnOff.setTitle("Beat: OFF", for: .normal)
        defaults.set(false, forKey: "beatIsPlaying")
    }
    
    
    func passFirst(row: Int) {
        if row == 0 {
            synth.bank1.disconnectOutput()
            oscLabel1.titleLabel?.textColor = UIColor.gray
        } else {
            setWaveform(forBank: 1, waveformIndex: row)
            oscLabel1.titleLabel?.textColor = UIColor.black
        }
        defaults.set(row, forKey: "osc1wave")
        oscLabel2.titleLabel?.textColor = UIColor.black
    }
    
    
    func passSecond(row: Int) {
        if row == 0 {
            synth.bank2.disconnectOutput()
            oscLabel2.titleLabel?.textColor = UIColor.gray
        } else {
            setWaveform(forBank: 2, waveformIndex: row)
            oscLabel2.titleLabel?.textColor = UIColor.black
        }
        defaults.set(row, forKey: "osc2wave")
    }
    
    func changeBeat() {
        beat.drums = beat.getDrums(file: beat.beatFiles[defaults.integer(forKey: "beatFileNumber")])
        routeAudio(synth: synth, beat: beat)
        beat.drums?.play()
    }
    
}

extension UIViewController {
    
    func routeAudio(synth: Synth, beat: Beat) {
        synth.mixer = AKMixer(synth.bank1, synth.bank2)
        synth.filter = AKKorgLowPassFilter(synth.mixer)
        synth.filter.play()
        synth.reverb = AKReverb(synth.filter)
        synth.reverb.dryWetMix = synth.reverbSlider.value
        synth.delay = AKDelay(synth.reverb)
        synth.delay.dryWetMix = synth.delaySlider.value
        synth.postFxMixer = AKMixer(synth.delay, beat.drums)
        AudioKit.output = synth.postFxMixer
        AudioKit.start()
    }
    
}
