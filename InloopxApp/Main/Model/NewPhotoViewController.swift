//
//  NewPhotoViewController.swift
//  InloopxApp
//
//  Created by MacBook Pro on 28/02/2019.
//  Copyright © 2019 MacBook Pro. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

protocol NewPhotoFlowDelegate {
    func back()
}

class NewPhotoViewController: BaseViewController {

    var flowDelegate: NewPhotoFlowDelegate?
    
    var currentAlbumId: Int?
    
    var timer: Timer?
    
    var viewModel: NewPhotoViewModel?
    
    var newPhotoRequest = PublishSubject<(title: String, albumId: Int)>()
    
    var grupedAlbumsByUseId: [[Album]] = []
    var albums: [Album] = [] {
        didSet {
            self.grupedAlbumsByUseId = albums.group(by: {$0.userId})
        }
    }
    
    var spaceOrEnterIsEnabled: Bool = true
    
    @IBOutlet weak var albumIdTextField: PickerViewTextField! {
        didSet {
            albumIdTextField.updateDelegate = self
        }
    }
    
    @IBOutlet weak var titleTextField: UITextField!
    @IBOutlet weak var submitButton: UIButton! {
        didSet {
            submitButton.layer.cornerRadius = 10
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = "Create new photo"
        navigationController?.navigationBar.tintColor = UIColor.black
        
        albumIdTextField.pickerView.delegate = self
        
    }
    
    override func setupViewModel() {
        super.setupViewModel()
        
        let input = NewPhotoViewModel.Input(nePhotoRequest: newPhotoRequest)
        
        let output = self.viewModel?.transform(input: input)
        
        output?.newPhotoResponse
            .subscribeOn(MainScheduler.instance)
            .subscribe(onNext: { [weak self] event in
                self?.view.startActivityIndicator()
                if event.isLoading {
                    self?.view.startActivityIndicator()
                } else if let error = event.error {
                    print(error.message)
                } else {
                    AlertHandler.showWhisper(message: "New photo was succesfully added.", type: .success, shouldHide: true)
                    self?.timer = Timer.scheduledTimer(timeInterval: 2, target: self , selector: #selector(self?.runBack), userInfo: nil, repeats: false)
                }
        }).disposed(by: disposeBag)
        
        
    }
    
    @objc func runBack() {
        if let timer = timer {
            timer.invalidate()
        }
        flowDelegate?.back()
    }
    
    private func isValidTitle(title: String) -> Bool {
        return title.count >= 8
    }
    
    private func isValidAlbum() -> Bool {
        return currentAlbumId != nil
    }
    
    @IBAction func submit(_ sender: Any) {
        if let text = titleTextField.text, text != "" {
            if isValidTitle(title: text) {
                if isValidAlbum() {
                    if let albumId = currentAlbumId {
                        newPhotoRequest.onNext((title: text, albumId: albumId))
                    }
                } else {
                    AlertHandler.showWhisper(message: "Please choose album!", type: .info, shouldHide: true)
                }
            } else {
                AlertHandler.showWhisper(message: "Minumum length of title must be 8 characters!", type: .error
                    , shouldHide: true)
            }
        } else {
            AlertHandler.showWhisper(message: "Please write a title of photo", type: .info, shouldHide: true)
        }
        
    }
}

extension NewPhotoViewController: UITextFieldDelegate {
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        if self.spaceOrEnterIsEnabled {
            if (string == " ") || (string == "\n") {
                AlertHandler.showWhisper(message: "Title can't start with whitespace or newline", type: .error, shouldHide: true)
                return false
            } else {
                self.spaceOrEnterIsEnabled = false
                return true
            }
        } else {
            return true
        }
    }
}

extension NewPhotoViewController: UIPickerViewDelegate, UIPickerViewDataSource {
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return albums.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        self.currentAlbumId = self.albums[0].id
        self.albumIdTextField.text = self.albums[0].title
        return albums[row].title
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        self.currentAlbumId = albums[row].id
    }
    
}

extension NewPhotoViewController: UpdateSettingsDelegate {
    func didTouchDone() {
        for album in albums {
            if album.id == self.currentAlbumId {
                albumIdTextField.text = album.title
            }
        }
    }
    
}
