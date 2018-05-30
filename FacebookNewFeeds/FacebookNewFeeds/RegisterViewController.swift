//
//  RegisterViewController.swift
//  FacebookNewFeeds
//
//  Created by ha.thi.hoan on 5/28/18.
//  Copyright © 2018 ha.thi.hoan. All rights reserved.
//

import UIKit

private struct Constants {
    public static let goToMainSegue = "goToMain"
}

class RegisterViewController: UIViewController {

    @IBOutlet weak var accountNameTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var repasswordTextField: UITextField!
    @IBOutlet weak var registerButton: UIButton!

    override func viewDidLoad() {
        super.viewDidLoad()
    }

    @IBAction func registerAction(_ sender: Any) {
        if accountNameTextField.text != "" && passwordTextField.text != "" && repasswordTextField.text != "" {
            performSegue(withIdentifier: Constants.goToMainSegue, sender: nil)
        }
    }

}
