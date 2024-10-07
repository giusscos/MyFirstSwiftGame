//
//  GameViewController.swift
//  MyFirstSwiftGame
//
//  Created by Giuseppe Cosenza on 07/10/24.
//

import UIKit
import QuartzCore
import SceneKit

class GameViewController: UIViewController {

    var sceneView: SCNView!
    var scene: SCNScene!
    
    var playerNode: SCNNode!
    var selfieStickNode: SCNNode!
    
    var motion = MotionHelper()
    var motionForce = SCNVector3(0, 0, 0)
    
    override func viewDidLoad() {
        setupScene()
        setuNodes()
    }
    
    func setupScene() {
        sceneView = self.view as? SCNView
        
        sceneView.delegate = self
        
//        sceneView.allowsCameraControl = true
        
        scene = SCNScene(named: "MainScene.scn")
        
        sceneView.scene = scene
        
        let tapRecognizer = UITapGestureRecognizer()
        tapRecognizer.numberOfTapsRequired = 1
        tapRecognizer.numberOfTouchesRequired = 1
        tapRecognizer.addTarget(self, action: #selector (GameViewController.sceneViewTapped(recognizer:)))
        
        sceneView.addGestureRecognizer(tapRecognizer)
    }
    
    func setuNodes() {
        playerNode = scene.rootNode.childNode(withName: "player", recursively: true)!
        selfieStickNode = scene.rootNode.childNode(withName: "selfieStick", recursively: true)!
    }
    
    @objc func sceneViewTapped(recognizer: UITapGestureRecognizer) {
        let location = recognizer.location(in: sceneView)
        
        let hitResults = sceneView.hitTest(location, options: nil)
        
        if hitResults.count > 0 {
            let result = hitResults.first
            
            if let node = result?.node {
                if node.name == "player" {
                    playerNode.physicsBody?.applyForce(SCNVector3(0, 4, -2), asImpulse: true)
                }
            }
        }
    }
    
    override var prefersStatusBarHidden: Bool {
        return false
    }

}

extension GameViewController: SCNSceneRendererDelegate {
    func renderer(_ renderer: any SCNSceneRenderer, updateAtTime time: TimeInterval) {
        let player = playerNode.presentation
        let playerPosition = player.position
        
        let targetPosition = SCNVector3(x: playerPosition.x, y: playerPosition.y + 5, z: playerPosition.z + 5)
        
        var cameraPosition = selfieStickNode.position
        
        let camDamping: Float = 0.3
        
        let xComponent = cameraPosition.x * (1 - camDamping) + targetPosition.x * camDamping
        let yComponent = cameraPosition.y * (1 - camDamping) + targetPosition.y * camDamping
        let zComponent = cameraPosition.z * (1 - camDamping) + targetPosition.z * camDamping
        
        cameraPosition = SCNVector3(x: xComponent, y: yComponent, z: zComponent)
        selfieStickNode.position = cameraPosition
        
        motion.getAccelerometerData { (x, y, z) in
            self.motionForce = SCNVector3(x: x * 0.05, y: 0, z: (y + 0.8) * -0.05)
        }
        
        playerNode.physicsBody?.velocity += motionForce
    }
}
