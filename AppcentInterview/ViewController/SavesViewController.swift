//
//  SavesViewController.swift
//  AppcentInterview
//
//  Created by Oguzhan Ozturk on 7.10.2021.
//

import UIKit
import RxSwift
import Kingfisher

class SavesViewController: UIViewController {

    @IBOutlet var gamesCollectionView : UICollectionView!
    @IBOutlet var indicator : UIActivityIndicatorView!
    
    private let viewModel : SavesViewModel = SavesViewModel()
    
    private let disposebag : DisposeBag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        setupCollectionView()
        observeValues()
        viewModel.getDatas()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        viewModel.getDatas()
        
    }
    
    private func observeValues(){
        
        viewModel.gamesState.subscribe(onNext:{ [weak self] state in
            self?.gamesCollectionView.reloadData()
        },onError: { error in
            print("error")
        }).disposed(by: disposebag)
        
        viewModel.loadingState.subscribe(onNext:{ [weak self] state in
            state == true ? self?.indicator.startAnimating() : self?.indicator.stopAnimating()
        }).disposed(by: disposebag)
        
        
    }
    
    private func setupCollectionView(){
        gamesCollectionView.delegate = self
        gamesCollectionView.dataSource = self
        gamesCollectionView.collectionViewLayout = setupCollectionLayout()
        let nib = UINib(nibName: "GameCollectionViewCell", bundle: Bundle.main)
        gamesCollectionView.register(nib, forCellWithReuseIdentifier: "GameCell")
    }
    
    private func setupCollectionLayout() -> UICollectionViewLayout{
        
        let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .absolute(80))
        let item = NSCollectionLayoutItem(layoutSize: itemSize)
        
        let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .absolute(80))
        let group = NSCollectionLayoutGroup.vertical(layoutSize: groupSize, subitems: [item])
        
        let section = NSCollectionLayoutSection(group: group)
        
        return UICollectionViewCompositionalLayout(section: section)
        
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if let destinationVC = segue.destination as? DetailViewController{
            let gameID = sender as? Int
            destinationVC.gameID = gameID
        }
        
    }
   

}

extension SavesViewController : UICollectionViewDelegate , UICollectionViewDataSource{
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return viewModel.currentData.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "GameCell", for: indexPath) as? GameCollectionViewCell{
            
            let game = viewModel.currentData[indexPath.row]
            
            cell.nameLbl.text = game.name
            cell.ratingLbl.text = String("Score : \(game.metacritic ?? 0)")
            cell.releasedDateLbl.text = String("Release : \(game.released)")
            
            let source = Source.network(ImageResource(downloadURL: URL(string: game.imageUrl)!))
            let retryStrategy = DelayRetryStrategy(maxRetryCount: 3, retryInterval: .seconds(3))
            
            cell.imageView.kf.setImage(with: source,options: [.processor(DownsamplingImageProcessor(size: CGSize(width: 120, height: 80))),.scaleFactor(UIScreen.main.scale),.cacheOriginalImage,.retryStrategy(retryStrategy)])
    
            return cell
        }
        return UICollectionViewCell()
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        self.performSegue(withIdentifier: "DetailSegueTwo", sender: viewModel.currentData[indexPath.row].id)
        
    }
    
    
}
