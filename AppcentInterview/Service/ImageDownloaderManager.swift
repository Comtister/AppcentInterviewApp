//
//  ImageDownloader.swift
//  AppcentInterview
//
//  Created by Oguzhan Ozturk on 3.10.2021.
//

import Foundation
import Kingfisher

fileprivate class DefaultValues{
    static var defaultImageDownloader : ImageDownloader = {
        let imageDownloader = ImageDownloader(name: "default")
        imageDownloader.downloadTimeout = 20
        return imageDownloader
    }()
    static var defaultImageCache : ImageCache = {
        let imageCache = ImageCache(name: "default")
        imageCache.memoryStorage.config.totalCostLimit = 100 * 1024 * 1024
        imageCache.diskStorage.config.sizeLimit = 500 * 1024 * 1024
        return imageCache
    }()
}

class ImageDownloadManager{

    static let shared = ImageDownloadManager()
    
    private var imageDownloader : ImageDownloader
    private var imageCache : ImageCache
    
    private init() {
        self.imageDownloader = DefaultValues.defaultImageDownloader
        self.imageCache = DefaultValues.defaultImageCache
    }
    
    fileprivate init(imageDownloader : ImageDownloader?, imageCache : ImageCache?){
        self.imageDownloader = imageDownloader ?? DefaultValues.defaultImageDownloader
        self.imageCache = imageCache ?? DefaultValues.defaultImageCache
    }

    func downloadImage(url : URL , completion : @escaping (Result<Data,Error>) -> Void){
        
        let source = Source.network(ImageResource(downloadURL: url))
    
        let _ = KingfisherManager(downloader: imageDownloader, cache: imageCache).retrieveImage(with: source) { (result) in
           
            switch result{
                case .success(let result) :
                    guard let imageData = result.image.jpegData(compressionQuality: 0) else {completion(Result.failure(ImageDownloadError.DataError)) ; return}
                    completion(Result.success(imageData))
                case .failure(let error) :
                    completion(Result.failure(error))
            }
            
        }
        
    }
    
    class Builder{
        
        private var imageDownloader : ImageDownloader?
        private var imageCache : ImageCache?
        
        func setImageDownloader(imageDownloader : ImageDownloader) -> Builder{
            self.imageDownloader = imageDownloader
            return self
        }
        
        func setImageCache(imageCache : ImageCache) -> Builder{
            self.imageCache = imageCache
            return self
        }
        
        func build() -> ImageDownloadManager{
            return ImageDownloadManager(imageDownloader: imageDownloader , imageCache: imageCache)
        }
        
    }
    
}
