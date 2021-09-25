//
//  ViewController.swift
//  RickAndMorty...
//
//  Created by Андрей on 14.06.2021.
//

import UIKit

class MainViewController: UIViewController {

    // MARK: Outlets
    
    @IBOutlet var tableView: UITableView!
    
    // MARK: Properties
    
    private var dataSource: [MainModel] = []
    
    // MARK: Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        initialSetup()
    }
    
    // MARK: Private Methods
    
    private func initialSetup() {
        setupNavigationBar()
        setupTableView()
        setupDataSource()
        tableView.reloadData()
    }
    
    private func setupTableView() {
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(UINib(nibName: MainTableViewCell.reuseId, bundle: nil),
                           forCellReuseIdentifier: MainTableViewCell.reuseId)
    }
    
    private func setupDataSource() {
        dataSource = [MainModel(image: #imageLiteral(resourceName: "img_characters"), type: .characters),
                      MainModel(image: #imageLiteral(resourceName: "img_locations"), type: .locations),
                      MainModel(image: #imageLiteral(resourceName: "img_episodes"), type: .episodes)]
    }
    
    private func setupNavigationBar() {
        navigationController?.navigationBar.setBackgroundImage(UIImage(), for:.default)
        navigationController?.navigationBar.shadowImage = UIImage()
        navigationController?.navigationBar.tintColor = #colorLiteral(red: 0.7125723958, green: 0.8523507118, blue: 0.2493328154, alpha: 1)
        navigationItem.title = "Choose section"
    }
}

// MARK: - UITableView Delegate

extension MainViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let type = dataSource[indexPath.row].type
        switch type {
        case .characters:
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            let identifier = CharacterListViewController.storyboardId
            if let controller = storyboard.instantiateViewController(withIdentifier: identifier)
                as? CharacterListViewController {
                navigationController?.pushViewController(controller, animated: true)
            }
        case .locations:
            break
        case .episodes:
            break
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        let mainHeight = UIScreen.main.bounds.height
        return mainHeight / 4
    }
}

// MARK: - UITableView DataSource

extension MainViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView,
                   numberOfRowsInSection section: Int) -> Int {
        return 1//dataSource.count
    }
    
    func tableView(_ tableView: UITableView,
                   cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let cell = tableView.dequeueReusableCell(withIdentifier: MainTableViewCell.reuseId,
                                                    for: indexPath) as? MainTableViewCell {
            cell.model = dataSource[indexPath.row]
            return cell
        } else {
            return UITableViewCell()
        }
    }
}
