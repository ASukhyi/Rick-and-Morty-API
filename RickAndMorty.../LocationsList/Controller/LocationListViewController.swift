//
//  LocationListViewController.swift
//  RickAndMorty...
//
//  Created by Андрей on 24.06.2021.
//

import UIKit

class LocationListViewController: UIViewController {

    // MARK: Outlets
    
    @IBOutlet private weak var collectionView: UICollectionView!
    
    // MARK: Properties
    
    static let storyboardId = String(describing: LocationListViewController.self)
    private var dataSource: [Location] = []
    private var nextRequest: String?
    private var nowLoading: Bool = false
    
    // MARK: Life Cycle

    override func viewDidLoad() {
        super.viewDidLoad()
        initialSetup()
    }
    
    // MARK: Private Methods
    
    private func initialSetup() {
        navigationItem.title = "Locations"
        setupCollectionView()
        fetchLocations()
    }
    
    private func setupCollectionView() {
        collectionView.delegate = self
        collectionView.dataSource = self
        let nib = UINib(nibName: LocationItemCell.reuseId, bundle: nil)
        collectionView.register(nib, forCellWithReuseIdentifier: LocationItemCell.reuseId)
    }
    
    private func fetchLocations() {
//        APIManager().getLocationList { [weak self] result in
//            DispatchQueue.main.async {
//                switch result {
//                case .success(let locationList):
//                    self?.dataSource = locationList.results
//                    self?.nextRequest = locationList.info.next
//                    self?.collectionView.reloadData()
//                case .failure(let error):
//                    print(error)
//                    return
//                }
//            }
//        }
    }
    
    private func loadingMoreLocations() {
        guard let next = nextRequest else {
            return
        }
//        APIManager().getLocationList(nextRequestString: next) { [weak self] result in
//            DispatchQueue.main.async {
//                self?.nowLoading = false
//                switch result {
//                case .success(let locationList):
//                    self?.dataSource.append(contentsOf: locationList.results)
//                    self?.nextRequest = locationList.info.next
//                    self?.collectionView.reloadData()
//                case .failure(let error):
//                    print(error)
//                    return
//                }
//            }
//        }
    }
}

// MARK: - UIScrollViewDelegate

extension LocationListViewController: UIScrollViewDelegate {
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let currentOffset = scrollView.contentOffset.y
        let maxOffset = scrollView.contentSize.height - scrollView.frame.size.height
        let deltaOffset = maxOffset - currentOffset
        if deltaOffset < 30 && !nowLoading && dataSource.count > 0 && nextRequest != nil {
            nowLoading = true
            loadingMoreLocations()
        }
    }
}

// MARK: - UICollectionView Delegate

extension LocationListViewController: UICollectionViewDelegate {

    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let identifier = CharacterDetailsViewController.storyboardId
        if let controller = storyboard.instantiateViewController(withIdentifier: identifier)
            as? CharacterDetailsViewController {
//            controller.character = dataSource[indexPath.item]
//            navigationController?.pushViewController(controller, animated: true)
        }
    }
}

// MARK: - UICollectionView DataSource

extension LocationListViewController: UICollectionViewDataSource {
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        numberOfItemsInSection section: Int) -> Int {
        return dataSource.count
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if let cell = collectionView.dequeueReusableCell(withReuseIdentifier: LocationItemCell.reuseId,
            for: indexPath) as? LocationItemCell {
            let model = dataSource[indexPath.item]
            cell.configureCell(name: model.name)
            return cell
        }
        return UICollectionViewCell()
    }
}


//MARK: - UICollectionViewDelegate FlowLayout

extension LocationListViewController: UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = collectionView.bounds.width / 2
        return CGSize(width: width, height: width * 1.3)
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
}


