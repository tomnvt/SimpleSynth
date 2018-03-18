//
//  Synth.swift
//  SimpleSynth
//
//  Created by NVT on 18.03.18.
//  Copyright © 2018 NVA. All rights reserved.
//

import AudioKit
import AudioKitUI

class Synth {
    var currentMIDINote: MIDINoteNumber = 0
    
    var drums : AKAudioPlayer?
    
    var keyboard = AKKeyboardView()
    
    let waveforms = [AKTable(.square), AKTable(.triangle), AKTable(.sine), AKTable(.sawtooth)]

    let waveformNames = ["off", "square", "triangle", "sine", "sawtooth"]

    var bank1 = AKOscillatorBank(waveform: AKTable(.square),
                                 attackDuration: 0.1,
                                 releaseDuration: 0.1)
    var bank2 = AKOscillatorBank(waveform: AKTable(.triangle),
                                 attackDuration: 0.1,
                                 releaseDuration: 0.1)

    
    var adsrView: AKADSRView = {
        let adsr = AKADSRView()
        return adsr
    }()
    
    var filter = AKKorgLowPassFilter()
    var filterSlider = AKSlider(property: "Cutoff Frequency")
    var reverb: AKReverb = {
        
        let reverb = AKReverb()
        reverb.dryWetMix = 0.5
        return reverb
    }()
    var reverbSlider = AKSlider(property: "Reverb Amount")
    
    var delay: AKDelay = {
        let delay = AKDelay()
        delay.time = 0.3
        delay.feedback = 0.5
        delay.dryWetMix = 0.0
        return delay
    }()
    var delaySlider = AKSlider(property: "Delay Amount")
    
    var mixer = AKMixer()
    var postFxMixer = AKMixer()
    
    init() {
        adsrView = AKADSRView { att, dec, sus, rel in
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
    }
    
    
}
