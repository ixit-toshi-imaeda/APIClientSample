//
//  PassportListViewController.swift
//  APIClientSample
//
//  Created by 今枝 稔晴 on 2019/09/23.
//  Copyright © 2019 iXIT Corporation. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON

class PassportListViewController: UIViewController {

    @IBOutlet weak var tableView: UITableView!

    override func viewDidLoad() {
        super.viewDidLoad()

        // 戻るナビゲーションボタンを機能させない（ログアウトなしでログイン画面に戻れなくする）
        navigationItem.setHidesBackButton(true, animated: false)

        refresh()
    }

    /// データ取得＆画面更新
    func refresh() {
        fetchPassports {
            // TODO: 画面の更新
        }
    }

    @IBAction func didTapLogoutButton(_ sender: Any) {
        logout()
    }
}

/// MARK: - Private
fileprivate extension PassportListViewController {

    /// 画面を更新する
    func fetchPassports(completion: @escaping ()->Void) {
        // パラメータ生成、リクエスト生成
        let parameters: [String: Any] = [
            "user_id": UserDefaults.standard.string(forKey: Constants.UserDefaultsKey.userId) ?? "",
            "coupon_name": "",
            "limit": "",
            "offset": ""
        ]
        let request = Router.getPassports(parameters: parameters)
        let completion = completion
        // リクエスト
        Alamofire.request(request).responseJSON { response in
            switch response.result {
            case .success(let value):
                let json = JSON(value)
                print("JSON: \(json)")
                completion()
            case .failure(let error):
                print(error)
            }
        }.responseString { response in
            print(response)
        }
    }

    /// ログアウト処理
    func logout() {

        let ac = UIAlertController(title: "ログアウト", message: "ログアウトしてもよろしいですか？", preferredStyle: .alert)
        ac.addAction(UIAlertAction(title: "OK", style: .default, handler: { _ in
            // UserDefaults からログイン情報削除
            UserDefaults.standard.removeObject(forKey: Constants.UserDefaultsKey.userId)
            UserDefaults.standard.removeObject(forKey: Constants.UserDefaultsKey.sessionToken)
            UserDefaults.standard.removeObject(forKey: Constants.UserDefaultsKey.refreshToken)
            // ログイン画面に戻す
            self.navigationController?.popToRootViewController(animated: true)
        }))
        ac.addAction(UIAlertAction(title: "キャンセル", style: .cancel, handler: nil))
        self.present(ac, animated: true, completion: nil)
    }
}
