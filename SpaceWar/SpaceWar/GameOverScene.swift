//
//  GameOver.swift
//  SpacegameReloaded
//
//  Created by Brian Advent on 03/11/2016.
//  Copyright © 2016 Training. All rights reserved.
//

import UIKit
import SpriteKit


class GameOverScene: SKScene {

    var score:Int!
    var highscore : Int!
    var hsDefault : Int = 0
    var scoreLabel:SKLabelNode!
    var newGameButtonNode:SKSpriteNode!
    var hsLabel:SKLabelNode!
       
    override func didMove(to view: SKView) {
        
        
        
        newGameButtonNode = self.childNode(withName: "newGameButton") as! SKSpriteNode
        newGameButtonNode.texture = SKTexture(imageNamed: "newGameButton")
        let scoreDefault = UserDefaults.standard
        score = scoreDefault.value(forKey: "Score") as! NSInteger
        let hsDefault = UserDefaults.standard
        highscore = hsDefault.value(forKey: "Highscore") as! NSInteger
        
        scoreLabel = self.childNode(withName: "scoreLabel") as! SKLabelNode
        scoreLabel.text = "\(score!)"
        NSLog("\(highscore)")
        hsLabel = self.childNode(withName: "hsLabel") as! SKLabelNode
        hsLabel.text = "\(highscore!)"
    }
 
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        let touch = touches.first
        if let location = touch?.location(in: self) {
            let node = self.nodes(at: location)
            
            if node[0].name == "newGameButton" {
                let transition = SKTransition.flipHorizontal(withDuration: 0.5)
                let gameScene = GameScene(size: self.size)
                self.view!.presentScene(gameScene, transition: transition)
            }
        }

    }
    
}
