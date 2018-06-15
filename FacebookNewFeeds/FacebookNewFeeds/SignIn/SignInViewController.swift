//
//  SignInViewController.swift
//  FacebookNewFeeds
//
//  Created by ha.thi.hoan on 5/28/18.
//  Copyright © 2018 ha.thi.hoan. All rights reserved.
//

import UIKit

private struct Constants {
    public static let buttonCornerRadius: CGFloat = 5
    public static let registerViewControllerIdentifier = "RegisterViewController"
    public static let goToMainSegue = "goToMain"
    public static let goToRegisterSegue = "goToRegister"
}

class SignInViewController: UIViewController {

    @IBOutlet weak var accountNameTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var signInButton: UIButton!
    @IBOutlet weak var createAccLabel: UILabel!

    override func viewDidLoad() {
        super.viewDidLoad()
        signInButton.layer.cornerRadius = Constants.buttonCornerRadius
        let tapToCreateAccLabel = UITapGestureRecognizer(target: self, action: #selector(registerAction))
        createAccLabel.addGestureRecognizer(tapToCreateAccLabel)
    }

    @IBAction func signInAction(_ sender: Any) {
       // if accountNameTextField.text == "hoanht" && passwordTextField.text == "123" {
            performSegue(withIdentifier: Constants.goToMainSegue, sender: nil)
       // }
    }

    @objc func registerAction() {
        performSegue(withIdentifier: Constants.goToRegisterSegue, sender: nil)
    }

}
