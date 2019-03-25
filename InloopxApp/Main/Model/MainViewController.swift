//
//  MainViewController.swift
//  InloopxApp
//
//  Created by MacBook Pro on 28/02/2019.
//  Copyright © 2019 MacBook Pro. All rights reserved.
//

import UIKit

protocol MainViewControllerFlowDelegate {
    func createNewPhoto(albums: [Album])
}

class MainViewController: BaseViewController {
    
    // OUTLETS //
    
    @IBOutlet weak var photoTableView: UITableView! {
        didSet {
            let cellNib  = UINib(nibName: PhotoCell.nameOfClass, bundle: nil)
            photoTableView.register(cellNib, forCellReuseIdentifier: PhotoCell.nameOfClass)
        }
    }
    
    // PROPERTIES //
    
    var flowDelegate: MainViewControllerFlowDelegate?

    var viewModel: MainViewModel?
    
    var photos: [Photo] = [] {
        didSet {
            photos = photos.sorted(by: {$0.title.count > $1.title.count})
            self.photoTableView?.reloadData()
        }
    }
    var albums: [Album] = []
    
    // OVERRIDE METHODS //
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Photos"
        navigationController?.navigationBar.tintColor = UIColor.white
        
        photoTableView.delegate = self
        photoTableView.dataSource = self
        
        setUpAddPhotoButton()
    }
    
    
    override func setupViewModel() {
        super.setupViewModel()
        
        let input = MainViewModel.Input()
        
        let output = self.viewModel?.transform(input: input)
        
        output?.photoRequest.drive(onNext: { (event) in
            self.view.startActivityIndicator()
            if event.isLoading {
                self.view.startActivityIndicator()
            } else if let er = event.error {
                self.view.stopActivityIndicator()
                AlertHandler.showWhisper(message: "\(er.message)", type: .error, shouldHide: true)
            } else if let photos = event.data {
                self.view.stopActivityIndicator()
                self.photos = photos
            }
        }).disposed(by: self.disposeBag)
        
        output?.albumRequest.drive(onNext: { (event) in
            self.view.startActivityIndicator()
            if event.isLoading {
                self.view.startActivityIndicator()
            } else if let er = event.error {
                self.view.stopActivityIndicator()
                AlertHandler.showWhisper(message: "\(er.message)", type: .error, shouldHide: true)
            } else if let albums = event.data {
                self.view.stopActivityIndicator()
                self.albums = albums
            }
        }).disposed(by: self.disposeBag)
    }

    // METHODS //
    
    private func setUpAddPhotoButton() {
        let addButton = UIButton.init(type: .custom)
        addButton.setImage(UIImage(named: "plus"), for: UIControl.State.normal)
        addButton.addTarget(self, action: #selector(tappedAdd), for: UIControl.Event.touchUpInside)
        addButton.frame = CGRect(x: 0, y: 0, width: 24, height: 24)
        navigationItem.rightBarButtonItem = UIBarButtonItem(customView: addButton)
    }
    
    @objc func tappedAdd() {
        flowDelegate?.createNewPhoto(albums: self.albums)
    }
}

// EXTENSIONS //

extension MainViewController : UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return photos.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = photoTableView.dequeueReusableCell(withIdentifier: PhotoCell.nameOfClass, for: indexPath) as! PhotoCell
        cell.titleOfPhotoLabel.text = photos[indexPath.row].title
        
        let url = photos[indexPath.row].thumbnailUrl
        let id = photos[indexPath.row].id
        cell.photoImageView.cacheImage(urlString: url, id: id)
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        photoTableView.deselectRow(at: indexPath, animated: true)
    }
    
    
}
