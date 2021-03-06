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
    
    @IBOutlet weak var scnView: SCNView!
    @IBOutlet weak var detailScnView: SCNView!
    @IBOutlet weak var detailContainer: UIView!
    @IBOutlet weak var starsStackView: UIStackView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var reviewCountLabel: UILabel!
    @IBOutlet weak var buyButton: UIButton!
    @IBOutlet weak var distanceWarningLabel: UILabel!
    
    var productNode = SCNNode()
    var detailNode = SCNNode()

    var animationInterval = 0.05
    var animationTimer: Timer?
    var product: Product!
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    func loadProduct(_ product:Product) {
        
        self.product = product
        setupDetailUI()
        setupDetailScene()
        self.setupMainScene()
    }
    
    //MARK: Setup
    
    func setupMainScene(){
        // create a new scene
        
        guard let scene = product.scene else {return}
        
        // create and add a camera to the scene
        let cameraNode = SCNNode()
        cameraNode.camera = SCNCamera()
        scene.rootNode.addChildNode(cameraNode)
        
        // place the camera
        cameraNode.position = SCNVector3(x: 0, y: 0, z: 15)
        
        // create and add a light to the scene
        let lightNode = SCNNode()
        lightNode.light = SCNLight()
        lightNode.light!.type = .omni
        lightNode.position = SCNVector3(x: 0, y: 10, z: 10)
        scene.rootNode.addChildNode(lightNode)
        
        // create and add an ambient light to the scene
        let ambientLightNode = SCNNode()
        ambientLightNode.light = SCNLight()
        ambientLightNode.light!.type = .ambient
        ambientLightNode.light!.color = UIColor.darkGray
        scene.rootNode.addChildNode(ambientLightNode)
        
        // retrieve the productNode node
        if let first = scene.rootNode.childNodes.first {
            productNode = first
        }

        // set the scene to the view
        scnView.scene = scene
        scnView.backgroundColor = UIColor.clear

        let _ = Timer.scheduledTimer(timeInterval: animationInterval, target: self, selector: #selector(animateOnInterval), userInfo: nil, repeats: true)
        
        //misc ui
        distanceWarningLabel.layer.shadowColor = UIColor.black.cgColor
        distanceWarningLabel.layer.shadowRadius = 3
        distanceWarningLabel.layer.shadowOpacity = 0.7
        distanceWarningLabel.layer.shadowOffset = CGSize(width: 0, height: 0)
        
        //This can be placed in animateOnInterval() for testing with a slider:
        self.updateScale()
    }
    
    
    
    
    //MARK: Detail
    //(box at bottom of the screen providing additional info about product)
    
    func setupDetailUI(){
        
        detailContainer.layer.cornerRadius = 10
        detailContainer.layer.masksToBounds = true
        
        //Buy Button
        buyButton.layer.borderColor = UIColor.white.cgColor
        buyButton.layer.borderWidth = 1.5
        buyButton.layer.cornerRadius = 3
        buyButton.layer.masksToBounds = true
        let string = "  $"+String(product.price)+"  "
        buyButton.setTitle(string, for: .normal)
        
        //Title
        titleLabel.adjustsFontSizeToFitWidth = true
        titleLabel.text = product.title
    }

    func setupDetailScene(){
        guard let scene = product.detailScene else {return}
        
        // create and add a camera to the scene
        let cameraNode = SCNNode()
        cameraNode.camera = SCNCamera()
        scene.rootNode.addChildNode(cameraNode)
        
        // place the camera
        cameraNode.position = SCNVector3(x: -5, y: 0, z: 20)

        // retrieve the ship node
        if let first = scene.rootNode.childNodes.first {
            detailNode = first
        }
        
        // animate the 3d object
        detailNode.runAction(SCNAction.repeatForever(SCNAction.rotateBy(x: 0, y: 2, z: 0, duration: 10)))
        
        // set the scene to the view
        detailScnView.scene = scene
        
        // configure the view
        detailScnView.backgroundColor = UIColor.clear
        
        
        let s = 2
        self.detailNode.scale = SCNVector3(s,s,s)
        detailNode.pivot = SCNMatrix4MakeRotation(.pi/2, 1, 0, 0)
        
    }
    
    
    
    //MARK: Animation
    
    func animateOnInterval(){
        UIView.animate(withDuration: animationInterval, animations: {
            self.updateEuler()
            self.pinGlassesToNose()
        })
    }
    
    func updateScale() {
        var s:Double = 0
        s = 6.6
        productNode.scale = SCNVector3(s,s,s)
    }
    
    func updateEuler(){
        if let pitch = UserDefaults.standard.object(forKey: "pitch") as? NSNumber,
            let yaw = UserDefaults.standard.object(forKey: "yaw") as? NSNumber,
            let roll = UserDefaults.standard.object(forKey: "roll") as? NSNumber {
            var _pitch = Float(pitch)//Float(pitch)/57
            var _yaw = -Float(yaw)
            var _roll = -Float(roll)
            _pitch += 300

            productNode.eulerAngles = SCNVector3(_pitch, _yaw, _roll)
        }
    }
    
    func pinGlassesToNose(){
        let i = 27 //Point on Nose
        guard let pointX = UserDefaults.standard.object(forKey: "\(i)x") as? NSNumber,
            let pointY = UserDefaults.standard.object(forKey: "\(i)y") as? NSNumber,
            let zPos = UserDefaults.standard.object(forKey: "zPos") as? NSNumber else {return}
        var _x = pointX.doubleValue
        var _y = pointY.doubleValue
        var _z = zPos.doubleValue
        let screenWidth = Double(480)
        let screenHeight = Double(640)
        
        //Show error if face is too far away.
        let tooFar = _z < 450
        distanceWarningLabel.isHidden = tooFar
        
        _x -= screenWidth/2
        _y -= screenHeight/2

        _y += 38
        _z += 200
        
        //Adjustments
        _x /= 8
        _y /= -8
        _z /= -8
        
        productNode.position = SCNVector3(_x, _y, _z)
    }
}
