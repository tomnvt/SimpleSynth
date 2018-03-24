//
//  ChooseBeatViewController.swift
//  SimpleSynth
//
//  Created by NVT on 20.03.18.
//  Copyright © 2018 NVA. All rights reserved.
//

import UIKit

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
        return button
    }()
    
    var houserBeat1Button: UIButton = {
        let button = UIButton()
        button.setTitle("House 1", for: .normal)
        button.backgroundColor = UIColor.cyan
        button.setTitleColor(UIColor.black, for: .normal)
        return button
    }()
    
    var houserBeat2Button: UIButton = {
        let button = UIButton()
        button.setTitle("House 2", for: .normal)
        button.backgroundColor = UIColor.cyan
        button.setTitleColor(UIColor.black, for: .normal)
        return button
    }()
    
    var hiphopBeat1Button: UIButton = {
        let button = UIButton()
        button.setTitle("Hip Hop 1", for: .normal)
        button.backgroundColor = UIColor.cyan
        button.setTitleColor(UIColor.black, for: .normal)
        return button
    }()
    
    var hiphopBeat2Button: UIButton = {
        let button = UIButton()
        button.setTitle("Hip Hop 2", for: .normal)
        button.backgroundColor = UIColor.cyan
        button.setTitleColor(UIColor.black, for: .normal)
        return button
    }()
    
    var dnbBeat1Button: UIButton = {
        let button = UIButton()
        button.setTitle("Drum and Bass 1", for: .normal)
        button.backgroundColor = UIColor.cyan
        button.setTitleColor(UIColor.black, for: .normal)
        return button
    }()
    
    var dnbBeat2Button: UIButton = {
        let button = UIButton()
        button.setTitle("Drum and Bass 2", for: .normal)
        button.backgroundColor = UIColor.cyan
        button.setTitleColor(UIColor.black, for: .normal)
        return button
    }()
    
    
    let synth = Synth()
    let beat = Beat()
    
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
        
    }
    
    func changeDrums(newFile: String) {
        beat.drumsFile = newFile
        beat.drums = beat.getDrums(file: beat.drumsFile)
    }
    
    @objc fileprivate func backButtonPressed(sender: UIButton) {
        let vc = ViewController()
        vc.modalTransitionStyle = .crossDissolve
        present(vc, animated: true, completion: nil)
    }
    
}
