//
//  CharcterDetailsViewController.swift
//  RickAndMorty...
//
//  Created by Андрей on 21.06.2021.
//

import UIKit

class CharacterDetailsViewController: UIViewController {
    
    // MARK: Outlets
    
 
    @IBOutlet private weak var loader: UIActivityIndicatorView!
    @IBOutlet private weak var imageView: UIImageView!
    @IBOutlet private weak var nameLabel: UILabel!
    @IBOutlet private weak var statusLabel: UILabel!
    @IBOutlet private weak var genderLabel: UILabel!
    @IBOutlet private weak var speciesLabel: UILabel!
    @IBOutlet private weak var originLabel: UILabel!
    @IBOutlet private weak var locationLabel: UILabel!
    @IBOutlet private weak var nameView: UIView!
    @IBOutlet private weak var statusView: UIView!
    @IBOutlet private weak var genderView: UIView!
    @IBOutlet private weak var speciesView: UIView!
    @IBOutlet private weak var originView: UIView!
    @IBOutlet private weak var locationView: UIView!
    
    
    // MARK: Properties
    
    static let storyboardId: String = String(describing: CharacterDetailsViewController.self)
    public var character: Character?
    
    // MARK: Life Cycle

    override func viewDidLoad() {
        super.viewDidLoad()
        fillUI()
    }
    
    // MARK: Private Methods
    
    private func fillUI() {
        guard let model = character else {
            return
        }
        downloadImage(from: model.imageUrl)
        navigationItem.title = model.name
        nameLabel.text = model.name
        statusLabel.text = model.status.rawValue
        genderLabel.text = model.gender.rawValue
        speciesLabel.text = model.species
        originLabel.text = model.origin.name
        locationLabel.text = model.location.name
        
        nameView.isHidden = model.name.isEmpty
        statusView.isHidden = model.status.rawValue.isEmpty
        genderView.isHidden = model.gender.rawValue.isEmpty
        speciesView.isHidden = model.species.isEmpty
        originView.isHidden = model.origin.name.isEmpty
        locationView.isHidden = model.location.name.isEmpty
    }
    
    private func downloadImage(from urlString: String) {
        guard let url = URL(string: urlString) else { return }
        loading(is: true)
        imageView.image = nil
        if let imageToCache = imageCache.object(forKey: urlString as NSString) {
            loading(is: false)
            imageView.image = imageToCache
            return
        }
        let task = URLSession.shared.dataTask(with: url) { (data, response, error) in
            if let err = error { print(err); return }
            DispatchQueue.main.async {
                let imageToCache = UIImage(data: data!)
                imageCache.setObject(imageToCache!, forKey: urlString as NSString)
                self.loading(is: false)
                self.imageView.image = imageToCache
            }
        }
        task.resume()
    }

    private func loading(is loading: Bool) {
        DispatchQueue.main.async {
            self.loader.isHidden = !loading
            loading ? self.loader.startAnimating() : self.loader.stopAnimating()
        }
    }
}
