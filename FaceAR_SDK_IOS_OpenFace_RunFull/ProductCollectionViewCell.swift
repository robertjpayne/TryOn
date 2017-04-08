//
//  ProductCollectionViewCell.swift
//  TryOn
//
//  Created by Chris Dunaetz on 4/7/17.
//  Copyright © 2017 Chris Dunaetz. All rights reserved.
//

import UIKit
import SceneKit

class ProductCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var detailScnView: SCNView!
    @IBOutlet weak var detailContainer: UIView!
    @IBOutlet weak var starsStackView: UIStackView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var reviewCountLabel: UILabel!
    @IBOutlet weak var buyButton: UIButton!
    
    var detailNode = SCNNode()

    enum Glasses {
        case purple
        case classyRims
        case topanga
    }
    var currentGlasses:Glasses = .classyRims
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    func loadData() {
        
        setupDetail()

    }
    
    //MARK: Detail
    //(box at bottom of the screen providing additional info about product)
    
    func setupDetail(){
        detailContainer.layer.cornerRadius = 10
        detailContainer.layer.masksToBounds = true
        
        buyButton.layer.borderColor = UIColor.white.cgColor
        buyButton.layer.borderWidth = 1.5
        buyButton.layer.cornerRadius = 3
        buyButton.layer.masksToBounds = true
        
        setupStars()
        setupDetailScene()
    }
    
    func setupStars(){
//        let numberOfStars = 4
//        //Clears old value
//        for view in starsStackView.arrangedSubviews {
//            view.removeFromSuperview()
//        }
//        //Updates new value
//        for _ in 0...numberOfStars+1 {
//            let imageView = UIImageView(image: #imageLiteral(resourceName: "star-reviews"))
//            imageView.heightAnchor.constraint(equalToConstant: 22).isActive = true
//            imageView.widthAnchor.constraint(equalToConstant: 22).isActive = true
//            starsStackView.addArrangedSubview(imageView)
//        }

    }

    func setupDetailScene(){
        let fileName = "littleGlasses"
        let scene = SCNScene(named: "art.scnassets/\(fileName).scn")!
        
        // create and add a camera to the scene
        let cameraNode = SCNNode()
        cameraNode.camera = SCNCamera()
        scene.rootNode.addChildNode(cameraNode)
        
        // place the camera
        cameraNode.position = SCNVector3(x: 0, y: 0, z: 15)

        // retrieve the ship node
        detailNode = scene.rootNode.childNodes.first ??  SCNNode()
        
        // animate the 3d object
        detailNode.runAction(SCNAction.repeatForever(SCNAction.rotateBy(x: 0, y: 2, z: 0, duration: 10)))
        
        // set the scene to the view
        detailScnView.scene = scene
        
        // configure the view
        detailScnView.backgroundColor = UIColor.clear
        
        
        let s = 2
        self.detailNode.scale = SCNVector3(s,s,s)
        detailNode.pivot = SCNMatrix4MakeRotation(Float(M_PI_2), 1, 0, 0)
        
    }
    
}
