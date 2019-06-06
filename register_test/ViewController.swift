//
//  ViewController.swift
//  register_test
//
//  Created by NAKAYAMA KEITO on 2019/05/30.
//  Copyright © 2019 NAKAYAMA KEITO. All rights reserved.
//

import UIKit
import Photos

class ViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate,UITextViewDelegate{
    
    @IBOutlet weak var profileImage: UIImageView!
    
    @IBOutlet weak var seibetsuKame: UIButton!
    @IBOutlet weak var seibetsuUsagi: UIButton!
    @IBOutlet weak var seibetsuHuman: UIButton!
    @IBOutlet weak var ageTextFeild: UITextField!
    
    @IBOutlet weak var selfIntroTextView: UITextView!
    var editingField:UITextField?
    @IBOutlet weak var myScrolView: UIScrollView!
    
    @IBOutlet weak var contentView: UIView!
    @IBOutlet weak var selfIntroTextViewPlaceHolder: UILabel!
    //重なっている高さ
    var overlap:CGFloat = 0.0
    var lastOffsetY:CGFloat = 0.0

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
        //スクロール領域の設定
        self.myScrolView.contentSize = CGSize(width:0, height:1000)
        
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
        
        
        selfIntroTextView.delegate = self
        
        
        //通知センター
        let notification = NotificationCenter.default
        notification.addObserver(self, selector: #selector(ViewController.keyboradChangeFrame(_:)), name: UIResponder.keyboardDidChangeFrameNotification, object: nil)
        
        notification.addObserver(self, selector: #selector(ViewController.keyboardWillShow(_:)), name: UIResponder.keyboardWillShowNotification, object: nil)
        
        notification.addObserver(self, selector: #selector(ViewController.keyboardDidHide(_:)), name: UIResponder.keyboardDidHideNotification, object: nil)
        
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
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    
    func textViewDidBeginEditing(_ textView: UITextView){

    }
    
    
    func textViewDidEndEditing(_ textView: UITextView){

    }
    
    @objc func keyboradChangeFrame(_ notification: Notification) {
        selfIntroTextViewPlaceHolder.isHidden = true
        let userInfo = (notification as Notification).userInfo!
        let keybordFrame = (userInfo[UIResponder.keyboardFrameEndUserInfoKey] as! NSValue).cgRectValue

        print("selfIntroTextView.maxY")
        print(self.selfIntroTextView.frame.maxY)
        print("keybordFrame.minY")
        print(keybordFrame.minY)
        
        let fldFrame = view.convert(self.selfIntroTextView.frame,from: contentView)
        print("fldFrame.maxY")
        print(fldFrame.maxY)
        var overlap = fldFrame.maxY - keybordFrame.minY + 5
        print("overlap")
        print(overlap)
        print("--------------")
        if overlap>0 {
            overlap += myScrolView.contentOffset.y
            myScrolView.setContentOffset(CGPoint(x: 0, y:overlap), animated: true)
        }
        
        //TextViewが空だったらLabel表示
        if(self.selfIntroTextView.text.isEmpty){
            selfIntroTextViewPlaceHolder.isHidden = false
        }
    }
    
    @objc func keyboardWillShow(_ notification: Notification) {
        lastOffsetY = myScrolView.contentOffset.y
    }
    
    @objc func keyboardDidHide(_ notification: Notification) {
        myScrolView.setContentOffset(CGPoint(x: 0,y: lastOffsetY),animated: true)
    }

    @IBAction func tapView(_ sender: Any) {
        view.endEditing(true)
    }
    
}

