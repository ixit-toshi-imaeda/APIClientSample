//
//  LoginViewController.swift
//  APIClientSample
//
//  Created by 今枝 稔晴 on 2019/09/23.
//  Copyright © 2019 iXIT Corporation. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON

class LoginViewController: UIViewController {

    let mail = "*********"
    let password = "*********"
    let deviceID = "*********"

    override func viewDidLoad() {
        super.viewDidLoad()

        // ログインしていたらパスポート一覧画面へ
        if AppDelegate.isLoggedIn {
            let vcName = String(describing: PassportListViewController.self)
            guard let passportVC = UIStoryboard(name: vcName, bundle: nil).instantiateInitialViewController() else {
                fatalError()
            }
            self.navigationController?.pushViewController(passportVC, animated: false)
        }
    }

    /// ログインボタンが押されたとき
    @IBAction func didTapLoginButton(_ sender: Any) {
        login(completion: { [weak self] in
            // ログイン成功
            // パスポート一覧へ
            let vcName = String(describing: PassportListViewController.self)
            guard let passportVC = UIStoryboard(name: vcName, bundle: nil).instantiateInitialViewController() else {
                fatalError()
            }
            self?.navigationController?.pushViewController(passportVC, animated: true)

        }, failed: { error in
            // ログイン失敗
            // TODO: 失敗アラート表示
        })
    }

}

fileprivate extension LoginViewController {

    /// ログイン試行処理
    func login(completion: @escaping ()->Void, failed: @escaping (Error)->Void) {
        let parameters: [String: Any] = [
            "mail": mail,
            "password": password,
            "device_id": deviceID
        ]
        let request = Router.login(parameters: parameters)
        let completion = completion
        let failed = failed
        Alamofire.request(request).responseJSON { response in
            switch response.result {
            case .success(let value):
                let json = JSON(value)
                dump(json)
                completion()

                guard let dataObject = LoginInfo.map(json: value, type: LoginInfo.self) else {
                    fatalError()
                }

                // ログイン情報を UserDefaults に保存
                UserDefaults.standard.set(dataObject.userId, forKey: Constants.UserDefaultsKey.userId)
                UserDefaults.standard.set(dataObject.sessionToken, forKey: Constants.UserDefaultsKey.sessionToken)
                UserDefaults.standard.set(dataObject.refreshToken, forKey: Constants.UserDefaultsKey.refreshToken)

            case .failure(let error):
                print(error)
                failed(error)

                print("Error localizedDescription: \(error.localizedDescription)")
            }
        }.responseString { response in
            print(response)
        }
    }
}
