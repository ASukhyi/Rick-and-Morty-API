//
//  CharactersItemCell.swift
//  RickAndMorty...
//
//  Created by Андрей on 22.06.2021.
//

import UIKit

class CharacterItemCell: UICollectionViewCell {
    
    // MARK: Outlets

    @IBOutlet private weak var imageView: UIImageView!
   
    @IBOutlet private weak var nameLabel: UILabel!
    @IBOutlet private weak var loader: UIActivityIndicatorView!
    @IBOutlet private weak var bottomView: UIView!

    // MARK: Properties
    
    static let reuseId = String(describing: CharacterItemCell.self)
    private var name: String?
    private var imageUrl: String?
    private var task: URLSessionDataTask?
    
    // MARK: Life Cycle
    
    override func awakeFromNib() {
        super.awakeFromNib()
        backgroundColor = .clear
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        imageView.layer.cornerRadius = 8
        imageView.clipsToBounds = true
        bottomView.roundCorners([.bottomRight, .bottomLeft], radius: 8)
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        cleanCell()
    }
    
    // MARK: Public Methods
    
    public func configureCell(name: String?, imageUrl: String?) {
        self.name = name
        self.imageUrl = imageUrl
        fillCell()
    }
    
    // MARK: Private Methods
    
    private func fillCell() {
        nameLabel.text = name
        if task == nil, let urlString = imageUrl {
            loading(is: true)
            task = downloadImage(from: urlString)
        }
    }
    
    private func cleanCell() {
        imageView.image = nil
        nameLabel.text = nil
        task?.cancel()
        task = nil
    }
    
    private func loading(is loading: Bool) {
        DispatchQueue.main.async {
            self.loader.isHidden = !loading
            loading ? self.loader.startAnimating() : self.loader.stopAnimating()
        }
    }
    
    private func downloadImage(from urlString: String) -> URLSessionDataTask? {
        guard let url = URL(string: urlString) else { return nil }
        imageView.image = nil
        if let imageToCache = imageCache.object(forKey: urlString as NSString) {
            loading(is: false)
            imageView.image = imageToCache
            return nil
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
        return task
    }

}

extension UIView {

    func roundCorners(_ corners: UIRectCorner, radius: CGFloat) {
         let path = UIBezierPath(roundedRect: self.bounds,
                                 byRoundingCorners: corners,
                                 cornerRadii: CGSize(width: radius, height: radius))
         let mask = CAShapeLayer()
         mask.path = path.cgPath
         self.layer.mask = mask
    }
}
