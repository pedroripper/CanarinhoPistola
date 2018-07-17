//
//  ViewController.swift
//  CanarinhoRussia
//
//  Created by Pedro Ripper on 10/07/2018.
//

import UIKit

class ViewController: UIViewController {
    
    @IBAction func action(_ sender: UIButton) {
        // quando aperta o botao jogar, passa para a segunda viewcontroller
        performSegue(withIdentifier: "segue", sender: self)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
       
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }


}

