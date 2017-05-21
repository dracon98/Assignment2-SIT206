//
//  MenuScene.swift
//  SpaceWar
//
//  Created by RICHARDO WIJAYA on 16/05/2017.
//  Copyright © 2017 RICHARDO WIJAYA. All rights reserved.
//


import UIKit
import SpriteKit

class MenuScene: SKScene {

    var starfield:SKEmitterNode!
    
    var playButtonNode:SKSpriteNode!
    var IconNode:SKSpriteNode!
    var SpaceWar:SKLabelNode!
    var hsMain = Int()
    var labelScore:SKLabelNode!
    
    override func didMove(to view: SKView) {
    
        playButtonNode = SKSpriteNode(imageNamed: "playButton")
        playButtonNode.position = CGPoint(x: self.frame.size.width / 2, y: self.frame.size.height / 3 * 2)
        playButtonNode.size = CGSize(width: 220, height: 55)
        addChild(playButtonNode)
        IconNode = SKSpriteNode(imageNamed: "Icon")
        IconNode.position = CGPoint(x: 200, y: 200)
        
        
        
        
        IconNode.size = CGSize(width: 360, height: 360)
        addChild(IconNode)
        SpaceWar = SKLabelNode(text: "SPACEWAR")
        SpaceWar.position = CGPoint(x: 200, y: 600)
        SpaceWar.fontName = "GillSans-Italic"
        SpaceWar.fontSize = 64
        SpaceWar.fontColor = UIColor.white
        addChild(SpaceWar)
        labelScore = SKLabelNode(text: "HighScore : \(hsMain)")
        labelScore.fontSize = 32
        labelScore.fontColor = UIColor.white
        labelScore.position = CGPoint(x: 200, y: 700)
        addChild(labelScore)
    }
 
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        var start = CGPoint.zero

            for area in touches{
                start = area.location(in: self)
            if (playButtonNode.contains(start)){
                let transition = SKTransition.flipHorizontal(withDuration: 0.5)
                let gameScene = GameScene(size: self.size)
                self.view!.presentScene(gameScene, transition: transition)
            }
        }
    }
}
