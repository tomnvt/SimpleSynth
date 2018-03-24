//
//  Beat.swift
//  SimpleSynth
//
//  Created by NVT on 23.03.18.
//  Copyright © 2018 NVA. All rights reserved.
//

import AudioKit

class Beat {
    
    let beatFiles = ["default.wav", "house1.wav", "house2.wav", "hiphop1.wav", "hiphop2.wav", "dnb1.wav", "dnb2.wav"]
    
    var drums : AKAudioPlayer?
    
    func getDrums(file: String) -> AKAudioPlayer? {
        do {
            let drumFile = try AKAudioFile(readFileName: file)
            let drums = try AKAudioPlayer(file: drumFile)
            return drums
        } catch {
            print("No audio file")
        }
        return nil
    }
    
}
