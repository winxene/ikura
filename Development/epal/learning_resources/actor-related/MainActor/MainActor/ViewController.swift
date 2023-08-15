//
//  ViewController.swift
//  MainActor
//
//  Created by Winxen Ryandiharvin on 07/08/23.
//

import UIKit

class ViewController: UIViewController {

    //this one is for creating the view by code
    override func loadView() {
        super.loadView()
        view.backgroundColor = .white
        view.addSubview(mainTextLabel)
        view.addSubview(secondaryTextLabel)
        
        mainTextLabel.topAnchor.constraint(equalTo: view.topAnchor, constant: 0).isActive = true
        mainTextLabel.topAnchor.constraint(equalTo: view.topAnchor, constant: 0).isActive = true
        secondaryTextLabel.topAnchor.constraint(equalTo: mainTextLabel.topAnchor, constant: 130).isActive = true
        secondaryTextLabel.leftAnchor.constraint(equalTo: mainTextLabel.leftAnchor, constant: 10).isActive = true
    }
    
    lazy var mainTextLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = UIColor(red: 130/255, green: 131/255, blue: 134/255, alpha: 1)
        label.font = .systemFont(ofSize: 52, weight: .regular)
        label.text = "Test 12345"
        return label
    }()
    
    lazy var secondaryTextLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = UIColor(red: 130/255, green: 131/255, blue: 134/255, alpha: 1)
        label.font = .systemFont(ofSize: 52, weight: .regular)
        label.text = "234"
        return label
    }()
    override func viewDidLoad() {
        super.viewDidLoad()

    }
}

