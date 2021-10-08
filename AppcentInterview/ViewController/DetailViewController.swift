//
//  DetailViewController.swift
//  AppcentInterview
//
//  Created by Oguzhan Ozturk on 6.10.2021.
//

import UIKit
import Kingfisher
import RxSwift

class DetailViewController: UIViewController {

    @IBOutlet var imageContainer : UIView!
    @IBOutlet var stackView : UIStackView!
    @IBOutlet var gameImageView : UIImageView!
    @IBOutlet var gameLikeImageView : UIImageView!
    @IBOutlet var gameNameLbl : UILabel!
    @IBOutlet var gameDateLbl : UILabel!
    @IBOutlet var gameScoreLbl : UILabel!
    @IBOutlet var gameDetailLbl : UITextView!
    
    @IBOutlet var saveTapGesture : UITapGestureRecognizer!
    
    var gameID : Int?
    var game : Game?
    
    let viewModel : DetailViewModel = DetailViewModel()
    //let viewModel : DetailViewModel
    let disposeBag : DisposeBag = DisposeBag()
    
   
   
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        saveTapGesture.addTarget(self, action: #selector(saveAction(_:)))
        observeValues()
        getData()
        
    }
    
    private func getData(){
        if let gameID = gameID{
            viewModel.getGameDetail(id: gameID).subscribe(onSuccess:{ [weak self] gameDetail in
                self?.game = gameDetail
                self?.setData(gameData: gameDetail)
            },onFailure:{ [weak self] error in
                self?.showAlertDialog(message: error.localizedDescription)
            }).disposed(by: disposeBag)
        }
        
    }
    
    private func observeValues(){
       
        viewModel.networkState.subscribe(onNext:{ [weak self] state in
                    //Test Real Device
            self?.showAlertDialog(message: Constant.NoNetworkDescription)
        }).disposed(by: disposeBag)
        
    }
    
    private func setData(gameData : Game){
        imageContainer.isHidden = false
        stackView.isHidden = false
        gameNameLbl.text = gameData.name
        gameDateLbl.text = String("Release Date : \(gameData.released)")
        gameScoreLbl.text = String("Metacritic Score : \(gameData.metacritic ?? 0)")
        gameDetailLbl.text = gameData.desc?.removeSpecChars()
        gameLikeImageView.image = viewModel.isFavorite(id: gameData.id) ? UIImage(named: "saveicon") : UIImage(named: "nonsaveicon")
        if let imageUrl = URL(string: gameData.imageUrl){
            gameImageView.kf.setImage(with: Source.network(ImageResource(downloadURL: imageUrl)))
        }
    }
    
    @objc func saveAction(_ sender : Any){
       
        guard let game = game else {return}
       
        viewModel.changeSaveState(game: game).subscribe(onSuccess:{ [weak self] state in
            
            switch state{
            case .saved :
                self?.gameLikeImageView.image = UIImage(named: "saveicon")
            case .deleted :
                self?.gameLikeImageView.image = UIImage(named: "nonsaveicon")
            }
            
        },onFailure:{ [weak self] error in
            self?.showAlertDialog(message: Constant.DatabaseSaveDescription)
        }).disposed(by: disposeBag)
        
    }
    
    private func showAlertDialog(message : String){
            let alertController = UIAlertController(title: "Oops", message: message, preferredStyle: .alert)
            alertController.addAction(UIAlertAction(title: "Close", style: .default, handler: { [weak self] _ in
                if message == Constant.DatabaseSaveDescription {
                    return
                }
                self?.getData()
            }))
            self.present(alertController, animated: true, completion: nil)
        }

}
