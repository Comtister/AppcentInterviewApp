//
//  MainViewController.swift
//  AppcentInterview
//
//  Created by Oguzhan Ozturk on 2.10.2021.
//

import UIKit

class MainViewController: UIViewController {

    @IBOutlet var searchBar : UISearchBar!
    @IBOutlet var scrollView : UIScrollView!
    @IBOutlet var pageControl : UIPageControl!
    @IBOutlet var scrollContainer : UIView!
    @IBOutlet var gameCollectionView : UICollectionView!
    
    @IBOutlet var gameCollectionNormalTopConstraint : NSLayoutConstraint!
    var gameCollectionSearchTopConstraint : NSLayoutConstraint!
    
    
    var games : [TopGamesView] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()

        games = tryTopGames()
        setupCollectionView()
        setupPageControl()
        setSearchBar()
        
        gameCollectionSearchTopConstraint =  gameCollectionView.topAnchor.constraint(equalTo: searchBar.bottomAnchor)
        gameCollectionSearchTopConstraint.isActive = false
       
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        setupScrollView(topGames: games)
    }
    
    private func setSearchBar(){
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
    
    private func tryTopGames() -> [TopGamesView]{
       
        let v1 : TopGamesView = TopGamesView.loadFromNib(owner: self, options: nil)
        v1.image.image = UIImage(named: "topgamestestimage")
        
        let v2 : TopGamesView = TopGamesView.loadFromNib(owner: self, options: nil)
        v2.image.image = UIImage(named: "topgamestestimage")
        
        let v3 : TopGamesView = TopGamesView.loadFromNib(owner: self, options: nil)
        v3.image.image = UIImage(named: "topgamestestimage")
        
        return[v1,v2,v3]
    }
    
    private func changeLayoutState(isSearchActive state : Bool){
        scrollContainer.isHidden = state
        pageControl.isHidden = state
        gameCollectionNormalTopConstraint.isActive = !state
        gameCollectionSearchTopConstraint.isActive = state
        gameCollectionView.layoutIfNeeded()
    }
    
}

extension MainViewController : UIScrollViewDelegate{
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let pageIndex = round(scrollView.contentOffset.x/view.frame.width)
        pageControl.currentPage = Int(pageIndex)
    }
    
}

extension MainViewController : UICollectionViewDelegate , UICollectionViewDataSource{
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 5
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        if let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "GameCell", for: indexPath) as? GameCollectionViewCell{
            
            return cell
        }
        return UICollectionViewCell()
        
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
    }
    
}

extension MainViewController : UISearchBarDelegate{
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        
        if searchText.count > 3{
            //Handle layout
            changeLayoutState(isSearchActive: true)
        }else if searchText.count == 0{
            changeLayoutState(isSearchActive: false)
        }
        
        
        
    }
    
}
