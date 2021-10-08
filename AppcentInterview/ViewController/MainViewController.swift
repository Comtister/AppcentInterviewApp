//
//  MainViewController.swift
//  AppcentInterview
//
//  Created by Oguzhan Ozturk on 2.10.2021.
//

import UIKit
import RxSwift
import Kingfisher

class MainViewController: UIViewController {

    @IBOutlet var searchBar : UISearchBar!
    @IBOutlet var scrollView : UIScrollView!
    @IBOutlet var pageControl : UIPageControl!
    @IBOutlet var scrollContainer : UIView!
    @IBOutlet var gameCollectionView : UICollectionView!
    @IBOutlet var collectionIndicator : UIActivityIndicatorView!
    @IBOutlet var topGamesIndicator : UIActivityIndicatorView!
    @IBOutlet var scrollViewTapGesture : UITapGestureRecognizer!
    @IBOutlet var nullSearchTextLbl : UILabel!
    
    @IBOutlet var gameCollectionNormalTopConstraint : NSLayoutConstraint!
    @IBOutlet var gameCollectionViewSearchTopConstraint : NSLayoutConstraint!
    
    
    private let viewModel : MainViewModel = MainViewModel()
    private let disposeBag : DisposeBag = DisposeBag()
    
    var topGamesViews : [TopGamesView] = []
    
    let retryStrategy = DelayRetryStrategy(maxRetryCount: 3, retryInterval: .seconds(3))
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        scrollViewTapGesture.addTarget(self, action: #selector(scrollViewTapAction))
        topGamesViews = createTopGamesView()
        setupCollectionView()
        setupPageControl()
        setupSearchBar()
        observeValues()
        viewModel.getGames()
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        setupScrollView(topGames: topGamesViews)
    }
    
    private func observeValues(){
        
        viewModel.gamesChanges.subscribe(onNext:{ [weak self] state in
           
            switch state{
            case .Fetch:
                self?.gameCollectionView.reloadData()
            case .Search :
                self?.gameCollectionView.reloadData()
                self?.setNullSearchLayout(state: false)
            case .NullSearch :
                self?.setNullSearchLayout(state: true)
            }
        },onError: { [weak self] error in
            //Handle error
            self?.showAlertDialog(message: error.localizedDescription)
        }).disposed(by: disposeBag)
        
        viewModel.tableLoadingState.subscribe(onNext: { [weak self] state in
            state == true ? self?.collectionIndicator.startAnimating() : self?.collectionIndicator.stopAnimating()
        }).disposed(by: disposeBag)
        
        viewModel.topGamesLoadingState.subscribe(onNext:{ [weak self] state in
            if state{
                self?.topGamesIndicator.startAnimating()
            }else{
                self?.topGamesViews.enumerated().forEach({ index , topGameView in
                    guard let viewModel = self?.viewModel else {return}
                    
                    topGameView.gameNameLbl.text = self?.viewModel.topGames[index].name
                    
                    let source = Source.network(ImageResource(downloadURL: URL(string: viewModel.topGames[index].imageUrl)!))
                    guard let retryStrategy = self?.retryStrategy else {return}
                    self?.topGamesIndicator.startAnimating()
                    topGameView.image.kf.setImage(with: source,options: [.retryStrategy(retryStrategy)]) { (state) in
                        
                        switch state{
                        case .success(_) : self?.topGamesIndicator.stopAnimating()
                        case .failure(let error) : self?.showAlertDialog(message: error.localizedDescription)
                        }
                        
                    }
                })
            }
        }).disposed(by: disposeBag)
        
        viewModel.networkState.subscribe(onNext:{ [weak self] state in
                    //Test Real Device
            self?.showAlertDialog(message: Constant.NoNetworkDescription)
        }).disposed(by: disposeBag)
        
    }
    
    private func setupSearchBar(){
        searchBar.delegate = self
    }
    
    private func setupPageControl(){
        pageControl.numberOfPages = 3
        pageControl.currentPage = 0
        pageControl.isUserInteractionEnabled = false
        view.bringSubviewToFront(pageControl)
    }
    
    private func setupScrollView(topGames : [TopGamesView]){
        
        scrollView.frame = CGRect(x: 0, y: 0, width: scrollContainer.frame.width, height: scrollContainer.frame.height)
        scrollView.contentSize = CGSize(width: scrollView.frame.width * CGFloat(topGames.count), height: scrollView.frame.height)
        
        scrollView.delegate = self
        scrollView.isPagingEnabled = true
        scrollView.showsHorizontalScrollIndicator = false
        
        topGames.enumerated().forEach { (index,topgame) in
            topgame.frame = CGRect(x: scrollView.frame.width * CGFloat(index), y: 0, width: scrollView.frame.width, height: scrollView.frame.height)
            scrollView.addSubview(topgame)
        }
    }
    
    private func setupCollectionView(){
        gameCollectionView.delegate = self
        gameCollectionView.dataSource = self
        gameCollectionView.prefetchDataSource = self
        gameCollectionView.collectionViewLayout = setupCollectionLayout()
        let nib = UINib(nibName: "GameCollectionViewCell", bundle: Bundle.main)
        gameCollectionView.register(nib, forCellWithReuseIdentifier: "GameCell")
    }
    
    private func setupCollectionLayout() -> UICollectionViewLayout{
        
        let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .absolute(80))
        let item = NSCollectionLayoutItem(layoutSize: itemSize)
        
        let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .absolute(80))
        let group = NSCollectionLayoutGroup.vertical(layoutSize: groupSize, subitems: [item])
        
        let section = NSCollectionLayoutSection(group: group)
        return UICollectionViewCompositionalLayout(section: section)
    }
    
    private func createTopGamesView() -> [TopGamesView]{
       
        let gameView1 : TopGamesView = TopGamesView.loadFromNib(owner: self, options: nil)
        let gameView2 : TopGamesView = TopGamesView.loadFromNib(owner: self, options: nil)
        let gameView3 : TopGamesView = TopGamesView.loadFromNib(owner: self, options: nil)
       
        return [gameView1,gameView2,gameView3]
    }
    
    private func changeLayoutState(isSearchActive state : Bool){
        scrollContainer.isHidden = state
        pageControl.isHidden = state
        gameCollectionNormalTopConstraint.isActive = !state
        gameCollectionViewSearchTopConstraint.isActive = state
        gameCollectionView.layoutIfNeeded()
    }
    
    private func setNullSearchLayout(state : Bool){
        gameCollectionView.isHidden = state
        nullSearchTextLbl.isHidden = !state
        
    }
    
    @objc func scrollViewTapAction(){
        let gameID = viewModel.topGames[pageControl.currentPage].id
        self.performSegue(withIdentifier: "DetailSegue", sender: gameID)
    }
    
    private func showAlertDialog(message : String){
            let alertController = UIAlertController(title: "Oops", message: message, preferredStyle: .alert)
            alertController.addAction(UIAlertAction(title: "Close", style: .default, handler: { [weak self] _ in
                self?.viewModel.getGames()
            }))
            self.present(alertController, animated: true, completion: nil)
        }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if let destinationVC = segue.destination as? DetailViewController{
            let gameID = sender as? Int
            destinationVC.gameID = gameID
        }
        
    }
    
}

extension MainViewController : UIScrollViewDelegate{
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let pageIndex = round(scrollView.contentOffset.x/view.frame.width)
        pageControl.currentPage = Int(pageIndex)
    }
    
}

extension MainViewController : UICollectionViewDelegate , UICollectionViewDataSource , UICollectionViewDataSourcePrefetching{
    
    func collectionView(_ collectionView: UICollectionView, prefetchItemsAt indexPaths: [IndexPath]) {
        if indexPaths.contains(where: isLoaded(indexPath:)) && viewModel.searchState == false{
            viewModel.getGames()
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return viewModel.currentData.games.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        if let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "GameCell", for: indexPath) as? GameCollectionViewCell{
            
            let game = viewModel.currentData.games[indexPath.row]
            
            cell.nameLbl.text = game.name
            cell.ratingLbl.text = String("Score : \(game.metacritic ?? 0)")
            cell.releasedDateLbl.text = String("Release : \(game.released)")
            
            let source = Source.network(ImageResource(downloadURL: URL(string: game.imageUrl)!))
        
            cell.imageView.kf.setImage(with: source,options: [.processor(DownsamplingImageProcessor(size: CGSize(width: 120, height: 80))),.scaleFactor(UIScreen.main.scale),.cacheOriginalImage,.retryStrategy(retryStrategy)])
    
            return cell
        }
        return UICollectionViewCell()
        
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        self.performSegue(withIdentifier: "DetailSegue", sender: viewModel.currentData.games[indexPath.row].id)
        
    }
    
    private func isLoaded(indexPath : IndexPath) -> Bool{
        let count = viewModel.currentData.games.count
        return indexPath.row >= count - 1
    }
    
}

extension MainViewController : UISearchBarDelegate{
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if searchText.count > 3{
            changeLayoutState(isSearchActive: true)
            viewModel.searchGame(searchText: searchText)
        }else if searchText.isEmpty{
            changeLayoutState(isSearchActive: false)
            viewModel.searchGame(searchText: searchText)
        }
    }
    
}
