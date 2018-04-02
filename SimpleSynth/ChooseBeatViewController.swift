//
//  ChooseBeatViewController.swift
//  SimpleSynth
//
//  Created by NVT on 20.03.18.
//  Copyright © 2018 NVA. All rights reserved.
//

import UIKit
import AudioKit

protocol ChangeBeatDelegate {
    func changeBeat()
}

class ChooseBeatViewController: UIViewController {

    var backButton: UIButton = {
        let button = UIButton()
        button.setTitle("Back", for: .normal)
        button.backgroundColor = UIColor.cyan
        button.setTitleColor(UIColor.black, for: .normal)
        button.frame = CGRect(x: 160, y: 100, width: 50, height: 50)
        button.layer.cornerRadius = 0.5 * button.bounds.size.width
        button.clipsToBounds = true
        return button
    }()
    
    var defaultBeatButton: UIButton = {
        let button = UIButton()
        button.setTitle("Default beat", for: .normal)
        button.backgroundColor = UIColor.cyan
        button.setTitleColor(UIColor.black, for: .normal)
        button.tag = 0
        button.frame = CGRect(x: 160, y: 100, width: 50, height: 50)
        button.layer.cornerRadius = 0.5 * button.bounds.size.width
        button.clipsToBounds = true
        return button
    }()
    
    var houserBeat1Button: UIButton = {
        let button = UIButton()
        button.setTitle("House 1", for: .normal)
        button.backgroundColor = UIColor.cyan
        button.setTitleColor(UIColor.black, for: .normal)
        button.tag = 1
        button.frame = CGRect(x: 160, y: 100, width: 50, height: 50)
        button.layer.cornerRadius = 0.5 * button.bounds.size.width
        button.clipsToBounds = true
        return button
    }()
    
    var houserBeat2Button: UIButton = {
        let button = UIButton()
        button.setTitle("House 2", for: .normal)
        button.backgroundColor = UIColor.cyan
        button.setTitleColor(UIColor.black, for: .normal)
        button.tag = 2
        button.frame = CGRect(x: 160, y: 100, width: 50, height: 50)
        button.layer.cornerRadius = 0.5 * button.bounds.size.width
        button.clipsToBounds = true
        return button
    }()
    
    var hiphopBeat1Button: UIButton = {
        let button = UIButton()
        button.setTitle("Hip Hop 1", for: .normal)
        button.backgroundColor = UIColor.cyan
        button.setTitleColor(UIColor.black, for: .normal)
        button.tag = 3
        button.frame = CGRect(x: 160, y: 100, width: 50, height: 50)
        button.layer.cornerRadius = 0.5 * button.bounds.size.width
        button.clipsToBounds = true
        return button
    }()
    
    var hiphopBeat2Button: UIButton = {
        let button = UIButton()
        button.setTitle("Hip Hop 2", for: .normal)
        button.backgroundColor = UIColor.cyan
        button.setTitleColor(UIColor.black, for: .normal)
        button.tag = 4
        button.frame = CGRect(x: 160, y: 100, width: 50, height: 50)
        button.layer.cornerRadius = 0.5 * button.bounds.size.width
        button.clipsToBounds = true
        return button
    }()
    
    var dnbBeat1Button: UIButton = {
        let button = UIButton()
        button.setTitle("Drum and Bass 1", for: .normal)
        button.backgroundColor = UIColor.cyan
        button.setTitleColor(UIColor.black, for: .normal)
        button.tag = 5
        button.frame = CGRect(x: 160, y: 100, width: 50, height: 50)
        button.layer.cornerRadius = 0.5 * button.bounds.size.width
        button.clipsToBounds = true
        return button
    }()
    
    var dnbBeat2Button: UIButton = {
        let button = UIButton()
        button.setTitle("Drum and Bass 2", for: .normal)
        button.backgroundColor = UIColor.cyan
        button.setTitleColor(UIColor.black, for: .normal)
        button.tag = 6
        button.frame = CGRect(x: 160, y: 100, width: 50, height: 50)
        button.layer.cornerRadius = 0.5 * button.bounds.size.width
        button.clipsToBounds = true
        return button
    }()
    
    let synth = Synth()
    let beat = Beat()
    
    let defaults = UserDefaults.standard
    
    var delegate : ChangeBeatDelegate?
    
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
            make.top.equalTo(view.snp.top).offset(16)
            make.left.equalToSuperview().offset(16)
            make.right.equalToSuperview().dividedBy(2).inset(8)
            make.height.equalToSuperview().dividedBy(5)
        })
        
        defaultBeatButton.snp.makeConstraints( { (make) in
            make.top.equalToSuperview().offset(16)
            make.right.equalToSuperview().inset(16)
            make.left.equalTo(backButton.snp.right).offset(16)
            make.height.equalToSuperview().dividedBy(5)
        })
        
        houserBeat1Button.snp.makeConstraints( { (make) in
            make.top.equalTo(backButton.snp.bottom).offset(16)
            make.left.equalToSuperview().offset(16)
            make.right.equalToSuperview().dividedBy(2).inset(8)
            make.height.equalToSuperview().dividedBy(5)
        })
        
        houserBeat2Button.snp.makeConstraints( { (make) in
            make.top.equalTo(backButton.snp.bottom).offset(16)
            make.left.equalTo(backButton.snp.right).offset(16)
            make.right.equalToSuperview().inset(16)
            make.height.equalToSuperview().dividedBy(5)
        })
        
        hiphopBeat1Button.snp.makeConstraints( { (make) in
            make.top.equalTo(houserBeat1Button.snp.bottom).offset(16)
            make.left.equalToSuperview().offset(16)
            make.right.equalToSuperview().dividedBy(2).inset(8)
            make.height.equalToSuperview().dividedBy(5)
        })
        
        hiphopBeat2Button.snp.makeConstraints( { (make) in
            make.top.equalTo(houserBeat1Button.snp.bottom).offset(16)
            make.left.equalTo(backButton.snp.right).offset(16)
            make.right.equalToSuperview().inset(16)
            make.height.equalToSuperview().dividedBy(5)
        })
        
        dnbBeat1Button.snp.makeConstraints( { (make) in
            make.top.equalTo(hiphopBeat2Button.snp.bottom).offset(16)
            make.left.equalToSuperview().offset(16)
            make.right.equalToSuperview().dividedBy(2).inset(8)
            make.height.equalToSuperview().dividedBy(5)
        })
        
        dnbBeat2Button.snp.makeConstraints( { (make) in
            make.top.equalTo(hiphopBeat2Button.snp.bottom).offset(16)
            make.left.equalTo(backButton.snp.right).offset(16)
            make.right.equalToSuperview().inset(16)
            make.height.equalToSuperview().dividedBy(5)
        })
        
        backButton.layer.cornerRadius = 0.5 * backButton.bounds.size.width
        backButton.clipsToBounds = true
        
        backButton.addTarget(self, action: #selector(backButtonPressed(sender:)), for: .touchUpInside)
        defaultBeatButton.addTarget(self, action: #selector(beatButtonPressed(sender:)), for: .touchDown)
        houserBeat1Button.addTarget(self, action: #selector(beatButtonPressed(sender:)), for: .touchDown)
        houserBeat2Button.addTarget(self, action: #selector(beatButtonPressed(sender:)), for: .touchDown)
        hiphopBeat1Button.addTarget(self, action: #selector(beatButtonPressed(sender:)), for: .touchDown)
        hiphopBeat2Button.addTarget(self, action: #selector(beatButtonPressed(sender:)), for: .touchDown)
        dnbBeat1Button.addTarget(self, action: #selector(beatButtonPressed(sender:)), for: .touchDown)
        dnbBeat2Button.addTarget(self, action: #selector(beatButtonPressed(sender:)), for: .touchDown)
        
        let button = [defaultBeatButton, houserBeat1Button, houserBeat2Button, hiphopBeat1Button, hiphopBeat2Button, dnbBeat1Button, dnbBeat2Button]
        
        button[defaults.integer(forKey: "beatFileNumber")].titleLabel?.font = UIFont.boldSystemFont(ofSize: 17.00)
        
    }
    
    func changeDrums(newFile: String) {
        AudioKit.stop()
        delegate?.changeBeat()
    }
    
    @objc fileprivate func backButtonPressed(sender: UIButton) {
        navigationController?.popViewController(animated: true)
        if !defaults.bool(forKey: "beatIsPlaying") {
            beat.drums?.stop()
        }
    }
    
    @objc fileprivate func beatButtonPressed(sender: UIButton) {
        let button = [defaultBeatButton, houserBeat1Button, houserBeat2Button, hiphopBeat1Button, hiphopBeat2Button, dnbBeat1Button, dnbBeat2Button]
        button[defaults.integer(forKey: "beatFileNumber")].titleLabel?.font = UIFont.systemFont(ofSize: 17.00)
        defaults.set(sender.tag, forKey: "beatFileNumber")
        changeDrums(newFile: beat.beatFiles[sender.tag])
        button[defaults.integer(forKey: "beatFileNumber")].titleLabel?.font = UIFont.boldSystemFont(ofSize: 17.00)
    }
    
}
