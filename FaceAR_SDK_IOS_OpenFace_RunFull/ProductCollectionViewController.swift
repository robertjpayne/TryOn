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
    
    override func viewDidLoad() {
        super.viewDidLoad()
       pageControl.numberOfPages = 4
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 4
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAtIndexPath indexPath: IndexPath) -> UICollectionViewCell {
       
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as! ProductCollectionViewCell
        cell.loadData()
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        sizeForItemAtIndexPath indexPath: IndexPath) -> CGSize {
        
        return view.frame.size
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

}
