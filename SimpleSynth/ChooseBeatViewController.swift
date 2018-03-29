//
//  ChooseBeatViewController.swift
//  SimpleSynth
//
//  Created by NVT on 20.03.18.
//  Copyright © 2018 NVA. All rights reserved.
//

import UIKit
import AudioKit

class ChooseBeatViewController: UIViewController {

    var backButton: UIButton = {
        let button = UIButton()
        button.setTitle("Back", for: .normal)
        button.backgroundColor = UIColor.cyan
        button.setTitleColor(UIColor.black, for: .normal)
        return button
    }()
    
    var defaultBeatButton: UIButton = {
        let button = UIButton()
        button.setTitle("Default beat", for: .normal)
        button.backgroundColor = UIColor.cyan
        button.setTitleColor(UIColor.black, for: .normal)
        button.tag = 0
        return button
    }()
    
    var houserBeat1Button: UIButton = {
        let button = UIButton()
        button.setTitle("House 1", for: .normal)
        button.backgroundColor = UIColor.cyan
        button.setTitleColor(UIColor.black, for: .normal)
        button.tag = 1
        return button
    }()
    
    var houserBeat2Button: UIButton = {
        let button = UIButton()
        button.setTitle("House 2", for: .normal)
        button.backgroundColor = UIColor.cyan
        button.setTitleColor(UIColor.black, for: .normal)
        button.tag = 2
        return button
    }()
    
    var hiphopBeat1Button: UIButton = {
        let button = UIButton()
        button.setTitle("Hip Hop 1", for: .normal)
        button.backgroundColor = UIColor.cyan
        button.setTitleColor(UIColor.black, for: .normal)
        button.tag = 3
        return button
    }()
    
    var hiphopBeat2Button: UIButton = {
        let button = UIButton()
        button.setTitle("Hip Hop 2", for: .normal)
        button.backgroundColor = UIColor.cyan
        button.setTitleColor(UIColor.black, for: .normal)
        button.tag = 4
        return button
    }()
    
    var dnbBeat1Button: UIButton = {
        let button = UIButton()
        button.setTitle("Drum and Bass 1", for: .normal)
        button.backgroundColor = UIColor.cyan
        button.setTitleColor(UIColor.black, for: .normal)
        button.tag = 5
        return button
    }()
    
    var dnbBeat2Button: UIButton = {
        let button = UIButton()
        button.setTitle("Drum and Bass 2", for: .normal)
        button.backgroundColor = UIColor.cyan
        button.setTitleColor(UIColor.black, for: .normal)
        button.tag = 6
        return button
    }()
    
    let synth = Synth()
    let beat = Beat()
    
    let defaults = UserDefaults.standard
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = UIColor.black
        
        view.addSubview(backButton)
        view.addSubview(defaultBeatButton)
        view.addSubview(houserBeat1Button)
        view.addSubview(houserBeat2Button)
        view.addSubview(hiphopBeat1Button)
        view.addSubview(hiphopBeat2Button)
        view.addSubview(dnbBeat1Button)
        view.addSubview(dnbBeat2Button)
        
        backButton.snp.makeConstraints( { (make) in
            make.top.left.equalToSuperview()
            make.right.equalToSuperview().dividedBy(2)
            make.bottom.equalToSuperview().dividedBy(5)
        })
        
        defaultBeatButton.snp.makeConstraints( { (make) in
            make.top.right.equalToSuperview()
            make.left.equalTo(backButton.snp.right)
            make.bottom.equalToSuperview().dividedBy(5)
        })
        
        houserBeat1Button.snp.makeConstraints( { (make) in
            make.left.equalToSuperview()
            make.top.equalTo(backButton.snp.bottom).offset(1)
            make.right.equalToSuperview().dividedBy(2)
            make.height.equalToSuperview().dividedBy(5)
        })
        
        houserBeat2Button.snp.makeConstraints( { (make) in
            make.top.equalTo(backButton.snp.bottom).offset(1)
            make.left.equalTo(houserBeat1Button.snp.right)
            make.right.equalToSuperview()
            make.height.equalToSuperview().dividedBy(5)
        })
        
        hiphopBeat1Button.snp.makeConstraints( { (make) in
            make.left.equalToSuperview()
            make.top.equalTo(houserBeat1Button.snp.bottom)
            make.right.equalToSuperview().dividedBy(2)
            make.height.equalToSuperview().dividedBy(5)
        })
        
        hiphopBeat2Button.snp.makeConstraints( { (make) in
            make.left.equalTo(houserBeat1Button.snp.right)
            make.top.equalTo(houserBeat1Button.snp.bottom)
            make.right.equalToSuperview()
            make.height.equalToSuperview().dividedBy(5)
        })
        
        dnbBeat1Button.snp.makeConstraints( { (make) in
            make.left.equalToSuperview()
            make.top.equalTo(hiphopBeat2Button.snp.bottom)
            make.right.equalToSuperview().dividedBy(2)
            make.height.equalToSuperview().dividedBy(5)
        })
        
        dnbBeat2Button.snp.makeConstraints( { (make) in
            make.left.equalTo(houserBeat1Button.snp.right)
            make.top.equalTo(hiphopBeat2Button.snp.bottom)
            make.right.equalToSuperview()
            make.height.equalToSuperview().dividedBy(5)
        })
        
        backButton.addTarget(self, action: #selector(backButtonPressed(sender:)), for: .touchUpInside)
        defaultBeatButton.addTarget(self, action: #selector(beatButtonPressed(sender:)), for: .touchDown)
        houserBeat1Button.addTarget(self, action: #selector(beatButtonPressed(sender:)), for: .touchDown)
        houserBeat2Button.addTarget(self, action: #selector(beatButtonPressed(sender:)), for: .touchDown)
        hiphopBeat1Button.addTarget(self, action: #selector(beatButtonPressed(sender:)), for: .touchDown)
        hiphopBeat2Button.addTarget(self, action: #selector(beatButtonPressed(sender:)), for: .touchDown)
        dnbBeat1Button.addTarget(self, action: #selector(beatButtonPressed(sender:)), for: .touchDown)
        dnbBeat2Button.addTarget(self, action: #selector(beatButtonPressed(sender:)), for: .touchDown)
        
    }
    
    func changeDrums(newFile: String) {
        AudioKit.stop()
        beat.drums = beat.getDrums(file: beat.beatFiles[defaults.integer(forKey: "beatFileNumber")])
        routeAudio(synth: synth, beat: beat)
        if defaults.bool(forKey: "beatIsPlaying") {
            beat.drums?.looping = true
        }
        beat.drums?.play()
    }
    
    @objc fileprivate func backButtonPressed(sender: UIButton) {
        let vc = ViewController()
        vc.modalTransitionStyle = .crossDissolve
        present(vc, animated: true, completion: nil)
        if !defaults.bool(forKey: "beatIsPlaying") {
            beat.drums?.stop()
        }
    }
    
    @objc fileprivate func beatButtonPressed(sender: UIButton) {
        defaults.set(sender.tag, forKey: "beatFileNumber")
        changeDrums(newFile: beat.beatFiles[sender.tag])
    }
    
}
