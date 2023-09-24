//
//  WelcomeViewController.swift
//  Flash Chat iOS13
//
//  Created by Angela Yu on 21/10/2019.
//  Copyright © 2019 Angela Yu. All rights reserved.
//

import UIKit

class WelcomeViewController: UIViewController {

    @IBOutlet weak var titleLabel: UILabel!
    
    var characterTitle = "GaliChat..."
    var indexNumber = 0.0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        loopForCharacter()
    }
    
}


// MARK: - Animation

extension WelcomeViewController {
    
    private func loopForCharacter() {
        titleLabel.text = ""
        
        for character in characterTitle {
            appendCharacter(character)
        }
    }
    
    private func appendCharacter(_ character: Character) {
        indexNumber+=1
        
        Timer.scheduledTimer(withTimeInterval: 0.1*indexNumber, repeats: false) { [self] _ in
            titleLabel.text?.append(character)
        }
    }
    
}
