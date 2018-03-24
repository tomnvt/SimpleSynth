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
    
    let synth = Synth()
    let beat = Beat()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = UIColor.black
        
        view.addSubview(backButton)
        backButton.snp.makeConstraints( { (make) -> Void in
            make.top.left.right.equalToSuperview()
            make.bottom.equalTo(self.view.snp.bottom).dividedBy(5)
        })
        backButton.addTarget(self, action: #selector(backButtonPressed(sender:)), for: .touchUpInside)
        
    }
    
    func changeDrums(newFile: String) {
        beat.drumsFile = newFile
        beat.drums = beat.getDrums(file: beat.drumsFile)
    }
    
    @objc fileprivate func backButtonPressed(sender: UIButton) {
        present(ViewController(), animated: true, completion: nil)
    }
    
}
