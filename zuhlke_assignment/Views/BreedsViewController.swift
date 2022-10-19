//
//  BreedsViewController.swift
//  zuhlke_assignment
//

//

import UIKit

protocol BreedsDisplayBusinessLogic: AnyObject {
    func displayFetchedBreeds(viewModel: Breeds.FetchBreeds.ViewModel)
    func displayFetchedDogs(viewModel: Breeds.FetchDogs.ViewModel)
}

class BreedsViewController: UIViewController {
    
    var interactor: BreedsBusinessLogic?
    @IBOutlet weak var breedsCollectionView: UICollectionView!
    @IBOutlet weak var dogsTableView: UITableView!
    let refreshControl = UIRefreshControl()
    var activityIndicator: LoadMoreActivityIndicator?
    
    var displayedBreeds = [Breeds.FetchBreeds.ViewModel.DisplayedBreeds]()
    var displayedDogs = [Breeds.FetchDogs.ViewModel.DisplayedDogs]()
    var selectedBreed: Breeds.FetchBreeds.ViewModel.DisplayedBreeds?
    var dogPage = 0
    
    
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
        prepareVIP()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        prepareVIP()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configCollectionView()
        configTableView()
        fetchBreeds()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        
    }

    private func prepareVIP() {
        let interactor = BreedsInteractor()
        let presenter = BreedPresentation()
        self.interactor = interactor
        interactor.presenter = presenter
        presenter.viewController = self
    }
    
    private func configCollectionView() {
        breedsCollectionView.register(UINib(nibName: "BreedsCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "BreedsCollectionViewCell")
        breedsCollectionView.delegate = self
        breedsCollectionView.dataSource = self
        let collectionLayout = UICollectionViewFlowLayout()
        collectionLayout.estimatedItemSize = UICollectionViewFlowLayout.automaticSize
        collectionLayout.sectionInset = UIEdgeInsets(top: 0, left: 10, bottom: 0, right: 0)
        collectionLayout.scrollDirection = .horizontal
        breedsCollectionView.collectionViewLayout = collectionLayout
        breedsCollectionView.allowsSelection = true
    }
    
    private func configTableView() {
        dogsTableView.register(UINib(nibName: "DogTableViewCell", bundle: nil), forCellReuseIdentifier: "DogTableViewCell")
        dogsTableView.dataSource = self
        dogsTableView.delegate = self
        dogsTableView.rowHeight = UITableView.automaticDimension
        dogsTableView.estimatedRowHeight = 300
        
        //add pull to refresh
        refreshControl.attributedTitle = NSAttributedString(string: "Pull to refresh")
        refreshControl.addTarget(self, action: #selector(self.refresh(_:)), for: .valueChanged)
        dogsTableView.addSubview(refreshControl)
        
        //loadmore
        activityIndicator = LoadMoreActivityIndicator(scrollView: dogsTableView, spacingFromLastCell: 10, spacingFromLastCellWhenLoadMoreActionStart: 60)

    }
    
    @objc func refresh(_ sender: AnyObject) {
        if let name = selectedBreed?.name {
            fetchDogs(breed: name, page: 0)
        }
    }
    
    private func fetchBreeds() {
        interactor?.fetchBreeds(request: Breeds.FetchBreeds.Request())
    }
    
    private func fetchDogs(breed: String, page: Int) {
        interactor?.fetchDogs(request: Breeds.FetchDogs.Request(breed: breed), page: page)
    }
    
    private func clearDisplayedDogs() {
        dogPage = 0
        displayedDogs = [Breeds.FetchDogs.ViewModel.DisplayedDogs]()
    }

}

extension BreedsViewController: BreedsDisplayBusinessLogic {
    func displayFetchedDogs(viewModel: Breeds.FetchDogs.ViewModel) {
        refreshControl.endRefreshing()
        displayedDogs.append(contentsOf: viewModel.displayDogs)
        dogsTableView.reloadData()
        if (dogPage > 0) {
            DispatchQueue.main.async { [weak self] in
                self?.activityIndicator?.stop()
            }
        }
    }
    
    func displayFetchedBreeds(viewModel: Breeds.FetchBreeds.ViewModel) {
        displayedBreeds = viewModel.displayBreeds
        breedsCollectionView.reloadData()
    }
}

extension BreedsViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        clearDisplayedDogs()
        fetchDogs(breed: displayedBreeds[indexPath.row].name, page: 0)
        selectedBreed = displayedBreeds[indexPath.row]
        collectionView.reloadData()
    }
}

extension BreedsViewController: UICollectionViewDataSource {
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return displayedBreeds.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "BreedsCollectionViewCell", for: indexPath) as? BreedsCollectionViewCell {
            cell.updateView(name: displayedBreeds[indexPath.row].name, isSelected: selectedBreed?.name == displayedBreeds[indexPath.row].name)
            return cell
        }
        return UICollectionViewCell()
    }
}

extension BreedsViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let cell = tableView.dequeueReusableCell(withIdentifier: "DogTableViewCell", for: indexPath)as? DogTableViewCell {
            cell.setImage(url: displayedDogs[indexPath.row].imageURL)
            cell.onLayoutNeedChange = {
                tableView.beginUpdates()
                tableView.endUpdates()
            }
            return cell
        }
        return UITableViewCell()
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return displayedDogs.count
    }

}

extension BreedsViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        activityIndicator?.start {
            DispatchQueue.global(qos: .utility).async {
                if let name = self.selectedBreed?.name {
                    self.dogPage += 1
                    self.fetchDogs(breed: name, page: self.dogPage)
                } else {
                    DispatchQueue.main.async { [weak self] in
                        self?.activityIndicator?.stop()
                    }
                }
            }
        }
    }
}
