//
//  GameOver.swift
//  SpaceWar
//
//  Created by RICHARDO WIJAYA on 21/05/2017.
//  Copyright © 2017 RICHARDO WIJAYA. All rights reserved.
//


import UIKit
import SpriteKit

class GameOverScene: SKScene {

    var score:Int!
    var highscore : Int!
    var hsDefault : Int = 0
    var scoreLabel:SKLabelNode!
    var newGameButtonNode:SKSpriteNode!
    var mainMenuNode:SKSpriteNode!
    var hsLabel:SKLabelNode!
    var history = String()
    
    override func didMove(to view: SKView) {
        
        mainMenuNode = self.childNode(withName: "mainMenu") as! SKSpriteNode
        mainMenuNode.texture = SKTexture(imageNamed: "mainMenu")
        
        newGameButtonNode = self.childNode(withName: "newGameButton") as! SKSpriteNode
        newGameButtonNode.texture = SKTexture(imageNamed: "newGameButton")
        let scoreDefault = UserDefaults.standard
        score = scoreDefault.value(forKey: "Score") as! NSInteger
        let hsDefault = UserDefaults.standard
        highscore = hsDefault.value(forKey: "Highscore") as! NSInteger
        
        scoreLabel = self.childNode(withName: "scoreLabel") as! SKLabelNode
        scoreLabel.text = "\(score!)"
        NSLog("highscore : \(highscore!)")
        hsLabel = self.childNode(withName: "hsLabel") as! SKLabelNode
        hsLabel.text = "\(highscore!)"
        
        history += "/n Score : \(score) "
    }

    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        let touch = touches.first
        if let location = touch?.location(in: self) {
            let node = self.nodes(at: location)
            NSLog("\(node)")
            if node[0].name == "newGameButton" {
                let transition = SKTransition.flipHorizontal(withDuration: 0.5)
                let gameScene = GameScene(size: self.size)
                self.view!.presentScene(gameScene, transition: transition)
            }
            if node[0].name == "mainMenu" {
                let transition = SKTransition.flipHorizontal(withDuration: 0.5)
                let gameScene = MenuScene(size: self.size)
                gameScene.hsMain = self.highscore
                self.view!.presentScene(gameScene, transition: transition)
            }
        }
    }
    
}
