//
//  GameViewController.swift
//  SpaceWar
//
//  Created by RICHARDO WIJAYA on 16/05/2017.
//  Copyright © 2017 RICHARDO WIJAYA. All rights reserved.
//

import UIKit
import SpriteKit
import GameplayKit

class GameViewController: UIViewController {

    @IBOutlet weak var layer: UIImageView!
    @IBOutlet weak var paused: UILabel!
    @IBOutlet weak var Continue: UIButton!
    override func viewDidLoad() {
        super.viewDidLoad()
        Continue.layer.borderWidth = 2
        Continue.layer.cornerRadius = 15
        Continue.layer.borderColor = UIColor.white.cgColor
        // Load 'GameScene.sks' as a GKScene. This provides gameplay related content
        // including entities and graphs.
        if let view = self.view as! SKView? {
            // Load the SKScene from 'GameScene.sks'
            if let scene = SKScene(fileNamed: "GameScene") {
                // Set the scale mode to scale to fit the window
                scene.scaleMode = .aspectFill
                
                // Present the scene
                view.presentScene(scene)
            }
            
            view.ignoresSiblingOrder = true
            
            view.showsFPS = true
            view.showsNodeCount = true
        }
    }
    
    @IBAction func Pause(_ sender: UIButton) {
        //let skView = self.view as! SKView
        let skView = self.view as! SKView
        skView.scene?.isPaused = true
        //skView.isPaused = true
        paused.isHidden = false
        layer.isHidden = false
        Continue.isHidden = false
    }
    override var shouldAutorotate: Bool {
        return true
    }

    @IBAction func continueGame(_ sender: UIButton) {
        //let skView = self.view as! SKView
        let skView = self.view as! SKView
        skView.scene?.isPaused = false
        //skView.isPaused = false
        paused.isHidden = true
        layer.isHidden = true
        Continue.isHidden = true
    }
    override var supportedInterfaceOrientations: UIInterfaceOrientationMask {
        if UIDevice.current.userInterfaceIdiom == .phone {
            return .allButUpsideDown
        } else {
            return .all
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Release any cached data, images, etc that aren't in use.
    }

    override var prefersStatusBarHidden: Bool {
        return true
    }
}
