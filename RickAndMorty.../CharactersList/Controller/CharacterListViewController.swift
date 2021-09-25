//
//  CharactersListViewController.swift
//  RickAndMorty...
//
//  Created by Андрей on 22.06.2021.
//

import UIKit

class CharacterListViewController: UIViewController {
    
    // MARK: Outlets
    
    @IBOutlet weak var collectionView: UICollectionView!
    // MARK: Properties
    
    static let storyboardId = String(describing: CharacterListViewController.self)
    private var dataSource: [Character] = []
    private var nextRequest: String?
    private var nowLoading: Bool = false
    
    // MARK: Life Cycle

    override func viewDidLoad() {
        super.viewDidLoad()
        initialSetup()
    }
    
    // MARK: Private Methods
    
    private func initialSetup() {
        navigationItem.title = "Characters"
        setupCollectionView()
        fetchCharacters()
    }
    
    private func setupCollectionView() {
        collectionView.delegate = self
        collectionView.dataSource = self
        let nib = UINib(nibName: CharacterItemCell.reuseId, bundle: nil)
        collectionView.register(nib, forCellWithReuseIdentifier: CharacterItemCell.reuseId)
    }
    
    private func fetchCharacters() {
        APIManager().getCharacterList { [weak self] result in
            DispatchQueue.main.async {
                switch result {
                case .success(let characterList):
                    self?.dataSource = characterList.results
                    self?.nextRequest = characterList.info.next
                    self?.collectionView.reloadData()
                case .failure(let error):
                    print(error)
                    return
                }
            }
        }
    }
    
    private func loadingMoreCharacters() {
        guard let next = nextRequest else {
            return
        }
        APIManager().getCharacterList(nextRequestString: next) { [weak self] result in
            DispatchQueue.main.async {
                self?.nowLoading = false
                switch result {
                case .success(let characterList):
                    self?.dataSource.append(contentsOf: characterList.results)
                    self?.nextRequest = characterList.info.next
                    self?.collectionView.reloadData()
                case .failure(let error):
                    print(error)
                    return
                }
            }
        }
    }
}

// MARK: - UIScrollViewDelegate

extension CharacterListViewController: UIScrollViewDelegate {
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let currentOffset = scrollView.contentOffset.y
        let maxOffset = scrollView.contentSize.height - scrollView.frame.size.height
        let deltaOffset = maxOffset - currentOffset
        if deltaOffset < 30 && !nowLoading && dataSource.count > 0 && nextRequest != nil {
            nowLoading = true
            loadingMoreCharacters()
        }
    }
}

// MARK: - UICollectionView Delegate

extension CharacterListViewController: UICollectionViewDelegate {

    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let identifier = CharacterDetailsViewController.storyboardId
        if let controller = storyboard.instantiateViewController(withIdentifier: identifier)
            as? CharacterDetailsViewController {
            controller.character = dataSource[indexPath.item]
            navigationController?.pushViewController(controller, animated: true)
        }
    }
}

// MARK: - UICollectionView DataSource

extension CharacterListViewController: UICollectionViewDataSource {
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        numberOfItemsInSection section: Int) -> Int {
        return dataSource.count
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if let cell = collectionView.dequeueReusableCell(withReuseIdentifier: CharacterItemCell.reuseId,
                                                         for: indexPath) as? CharacterItemCell {
            let model = dataSource[indexPath.item]
            cell.configureCell(name: model.name, imageUrl: model.imageUrl)
            return cell
        }
        return UICollectionViewCell()
    }
}


//MARK: - UICollectionViewDelegate FlowLayout

extension CharacterListViewController: UICollectionViewDelegateFlowLayout {
    
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
