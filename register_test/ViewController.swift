//
//  ViewController.swift
//  register_test
//
//  Created by NAKAYAMA KEITO on 2019/05/30.
//  Copyright © 2019 NAKAYAMA KEITO. All rights reserved.
//

import UIKit
import Photos

class ViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    @IBOutlet weak var profileImage: UIImageView!
    
    //写真を撮る場合またはアルバムから取得かどうかのフラグ
    var isTakePhoto = false
    
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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.

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


}

