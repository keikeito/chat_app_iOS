//
//  ViewController.swift
//  register_test
//
//  Created by NAKAYAMA KEITO on 2019/05/30.
//  Copyright © 2019 NAKAYAMA KEITO. All rights reserved.
//

import UIKit
import Photos

class ViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate,UIPickerViewDelegate, UIPickerViewDataSource{
    
    @IBOutlet weak var profileImage: UIImageView!
    
    @IBOutlet weak var seibetsuKame: UIButton!
    @IBOutlet weak var seibetsuUsagi: UIButton!
    @IBOutlet weak var seibetsuHuman: UIButton!
    @IBOutlet weak var ageTextFeild: UITextField!
    
    var pickerView: UIPickerView = UIPickerView()
    let ageList = ["設定しない", "18", "19", "20", "21", "22", "23", "24", "25", "26", "27", "28", "29", "30", "31", "32", "33", "34", "35", "36", "37", "38", "39", "40", "41", "42", "43", "44", "45", "46", "47", "48", "49", "50", "51", "52", "53", "54", "55", "56", "57", "58", "59", "60", "61", "62", "63", "64", "65", "66", "67", "68", "69", "70", "71", "72", "73", "74", "75", "76", "77", "78", "79", "80", "81", "82", "83", "84", "85", "86", "87", "88", "89"]

    //写真を撮る場合またはアルバムから取得かどうかのフラグ
    var isTakePhoto = false
    
    enum buttonTag: Int {
        case kameButton = 0
        case usagiButton = 1
        case humanButton = 2
    }
    
    @IBAction func profileTap(_ sender: Any) {
//        let usagiImage = UIImage(named: "usagi")
//
//        profileImage.image = usagiImage
        //self.profileImage.layer.cornerRadius = 300 * 0.5
        self.profileImage.clipsToBounds = true
        
        let actionSheet = UIAlertController(title: "画像選択時の注意",message: "", preferredStyle: .actionSheet)
        
        actionSheet.addAction(UIAlertAction(title: "写真を撮影", style: .default, handler: {(action) -> Void in self.takePhoto(action.title!)}))
        
        actionSheet.addAction(UIAlertAction(title: "アルバムから選択", style: .default, handler: {(action) -> Void in self.selectFromAlbum(action.title!)}))
        
        actionSheet.addAction(UIAlertAction(title: "キャンセル", style: .cancel, handler: nil))
        
        self.present(actionSheet, animated: true, completion: {
            print("正常")
        })
        
        
    }
    
    @IBAction func seibetsuTap(_ sender: Any) {

        if let button = sender as? UIButton {
            actionBorderColor(button: self.seibetsuKame, color: UIColor.gray)
            actionBorderColor(button: self.seibetsuUsagi, color: UIColor.gray)
            actionBorderColor(button: self.seibetsuHuman, color: UIColor.gray)
            
            if let tag = buttonTag(rawValue: button.tag) {
                switch tag {
                case .kameButton:actionBorderColor(button:self.seibetsuKame, color: UIColor.blue)
                case .usagiButton:actionBorderColor(button: self.seibetsuUsagi, color: UIColor.blue)
                    
                case .humanButton:
                    actionBorderColor(button: self.seibetsuHuman, color: UIColor.blue)
                }
            }
    
        }
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        self.seibetsuKame.layer.cornerRadius = self.seibetsuKame.frame.size.height/2
        self.seibetsuKame.clipsToBounds = true
        self.seibetsuKame.layer.masksToBounds = true
        actionBorderColor(button: self.seibetsuKame, color: UIColor.gray)
        
        self.seibetsuUsagi.layer.cornerRadius = self.seibetsuUsagi.frame.size.height/2
        self.seibetsuUsagi.clipsToBounds = true
        self.seibetsuUsagi.layer.masksToBounds = true
        actionBorderColor(button: self.seibetsuUsagi, color: UIColor.gray)
        
        self.seibetsuHuman.layer.cornerRadius = self.seibetsuHuman.frame.size.height/2
        self.seibetsuHuman.clipsToBounds = true
        self.seibetsuHuman.layer.masksToBounds = true
        actionBorderColor(button: self.seibetsuHuman, color: UIColor.gray)
        
        
        //ageTextFeildのUIPickerView処理
        pickerView.delegate = self
        pickerView.dataSource = self
        pickerView.showsSelectionIndicator = true
        
        let toolbar = UIToolbar(frame: CGRectMake(0, 0, 0, 35))
        let doneItem = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(ViewController.done))
        let cancelItem = UIBarButtonItem(barButtonSystemItem: .cancel, target: self, action: #selector(ViewController.cancel))
        toolbar.setItems([cancelItem, doneItem], animated: true)
        
        self.ageTextFeild.inputView = pickerView
        self.ageTextFeild.inputAccessoryView = toolbar
        
    }
    
    func selectFromAlbum(_ msg:String) {
        print(msg)
        self.isTakePhoto = false
        if UIImagePickerController.isSourceTypeAvailable(UIImagePickerController.SourceType.photoLibrary) {
            // 写真を選ぶビュー
            let pickerView = UIImagePickerController()
            // 写真の選択元をカメラロールにする
            // 「.camera」にすればカメラを起動できる
            pickerView.sourceType = .photoLibrary
            pickerView.delegate = self
            
            pickerView.allowsEditing = true
            // ビューに表示
            self.present(pickerView, animated: true)
        }
    }
    
    //写真選択完了後に呼ばれる標準メソッド
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info:[UIImagePickerController.InfoKey : Any]) {
        if let pickedImage = info[.originalImage] as? UIImage {
            self.profileImage.image = pickedImage
        }
        
        if isTakePhoto {
            if UIImagePickerController.isSourceTypeAvailable(UIImagePickerController.SourceType.savedPhotosAlbum) {
                print(isTakePhoto)
                UIImageWriteToSavedPhotosAlbum(
                    self.profileImage.image!,
                    self,
                    #selector(ViewController.image(_:didFinishSavingWithError:contextInfo:)),
                    nil)
            }

        }
        self.profileImage.layer.cornerRadius = self.profileImage.frame.size.height/2
        self.profileImage.clipsToBounds = true
        self.profileImage.layer.masksToBounds = true
        dismiss(animated: true, completion: nil)
        
    }
    
    /// キャンセル時
    func imagePickerControllerDidCancel(picker: UIImagePickerController) {
        // ImagePickerを終了
        dismiss(animated: true, completion: nil)
    }
    
    func  takePhoto(_ msg:String) {
        let sourceType:UIImagePickerController.SourceType =
            UIImagePickerController.SourceType.camera
        // カメラが利用可能かチェック
        if UIImagePickerController.isSourceTypeAvailable(
            UIImagePickerController.SourceType.camera){
            // インスタンスの作成
            let cameraPicker = UIImagePickerController()
            cameraPicker.sourceType = sourceType
            cameraPicker.delegate = self
            cameraPicker.allowsEditing = true
            self.isTakePhoto = true
            self.present(cameraPicker, animated: true, completion: nil)
            
        }
    }
    // 書き込み完了結果の受け取り
    @objc func image(_ image: UIImage,
                     didFinishSavingWithError error: NSError!,
                     contextInfo: UnsafeMutableRawPointer) {
    
    }
    
    //選択された性別のボタンの枠線を色付けする
    func actionBorderColor(button: UIButton,color:UIColor){
        button.layer.borderColor = color.cgColor
        button.layer.borderWidth = 2
        
    }
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return ageList.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return ageList[row]
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        self.ageTextFeild.text = ageList[row]
    }
    
    @objc func cancel() {
        self.ageTextFeild.text = ""
        self.ageTextFeild.endEditing(true)
    }
    
    @objc func done() {
        self.ageTextFeild.endEditing(true)
    }
    
    func CGRectMake(_ x: CGFloat, _ y: CGFloat, _ width: CGFloat, _ height: CGFloat) -> CGRect {
        return CGRect(x: x, y: y, width: width, height: height)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

