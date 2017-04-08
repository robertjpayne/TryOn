//
//  ProductCollectionViewController.swift
//  TryOn
//
//  Created by Chris Dunaetz on 4/7/17.
//  Copyright © 2017 Chris Dunaetz. All rights reserved.
//

import Foundation
import UIKit

class ProductCollectionViewController: UIViewController {
    
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var pageControl: UIPageControl!
    var productSceneViewController: ProductSceneViewController!
    
    var products = [0,0,0,0]
//    var products = [0]
    
    override func viewDidLoad() {
        super.viewDidLoad()
       pageControl.numberOfPages = products.count
        

    }
    
    //MARK: CollectionView Delegate Functions
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return products.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAtIndexPath indexPath: IndexPath) -> UICollectionViewCell {
       
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as! ProductCollectionViewCell
        cell.loadData()
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as! ProductCollectionViewCell
    }
    
    func collectionView(_ collectionView: UICollectionView, didEndDisplaying cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as! ProductCollectionViewCell
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        sizeForItemAtIndexPath indexPath: IndexPath) -> CGSize {
        
        return CGSize(width:self.view.bounds.width, height: 185)
    }

    func scrollViewDidScroll(_ scrollView: UICollectionView) {
        let middlePoint = CGPoint(x: scrollView.frame.width/2 + scrollView.contentOffset.x, y: scrollView.frame.height/2 + scrollView.contentOffset.y)
        if let centerRowIndex = scrollView.indexPathForItem(at: middlePoint) {
            for index in scrollView.indexPathsForVisibleItems {
                if index.row == centerRowIndex.row {
                    UIView.animate(withDuration: 0.4, animations: {
                        self.pageControl.currentPage = index.row
                    })
                }
            }
        }
    }

    //MARK: Navigation
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
       productSceneViewController = segue.destination as! ProductSceneViewController
    }
}
