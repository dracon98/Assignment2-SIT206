//
//  GameScene.swift
//  SpaceWar
//
//  Created by RICHARDO WIJAYA on 16/05/2017.
//  Copyright © 2017 RICHARDO WIJAYA. All rights reserved.
//

import SpriteKit
import GameplayKit
import CoreMotion

class GameScene: SKScene, SKPhysicsContactDelegate {
    
    var starfield:SKEmitterNode!
    var player:SKSpriteNode!
    
    var scoreLabel:SKLabelNode!
    var score:Int = 0 {
    didSet {
    scoreLabel.text = "Score: \(score)"
    }
    }
    
    var gameTimer:Timer!
    var shootBullet:Timer!
    
    var possibleAliens = ["BMeteorite", "SMeteorite","Enemy"]
    
    let alienCategory:UInt32 = 0x1 << 1
    let photonTorpedoCategory:UInt32 = 0x1 << 0
    
    
    let motionManger = CMMotionManager()
    var xAcceleration:CGFloat = 0
    
    override func didMove(to view: SKView) {
    
    /*starfield = SKEmitterNode(fileNamed: "Starfield")
    starfield.position = CGPoint(x: 0, y: 1472)
    starfield.advanceSimulationTime(10)
    self.addChild(starfield)
    
    starfield.zPosition = -10*/
    
    player = SKSpriteNode(imageNamed: "PlayerShip")
    
    player.position = CGPoint(x: self.frame.size.width / 2, y: player.size.height / 2 + 20)
    
    self.addChild(player)
    
    self.physicsWorld.gravity = CGVector(dx: 0, dy: 0)
    self.physicsWorld.contactDelegate = self
    
    scoreLabel = SKLabelNode(text: "Score: 0")
    scoreLabel.position = CGPoint(x: 10, y: 10)
    scoreLabel.fontName = "AmericanTypewriter-Bold"
    scoreLabel.fontSize = 36
    scoreLabel.fontColor = UIColor.white
    score = 0
    
    self.addChild(scoreLabel)
    
    
    gameTimer = Timer.scheduledTimer(timeInterval: 0.75, target: self, selector: #selector(addAlien), userInfo: nil, repeats: true)
    
    shootBullet = Timer.scheduledTimer(timeInterval: 0.75, target: self, selector: #selector(fireBullet), userInfo: nil, repeats: true)
    
    motionManger.accelerometerUpdateInterval = 0.2
    motionManger.startAccelerometerUpdates(to: OperationQueue.current!) { (data:CMAccelerometerData?, error:Error?) in
    if let accelerometerData = data {
    let acceleration = accelerometerData.acceleration
    self.xAcceleration = CGFloat(acceleration.x) * 0.75 + self.xAcceleration * 0.25
    }
    }
    
    
    
    }
    func addAlien () {
        possibleAliens = GKRandomSource.sharedRandom().arrayByShufflingObjects(in: possibleAliens) as! [String]
        
        let alien = SKSpriteNode(imageNamed: possibleAliens[0])
        
        let randomAlienPosition = GKRandomDistribution(lowestValue: 0, highestValue: Int(self.frame.size.width))
        let position = CGFloat(randomAlienPosition.nextInt())
        
        alien.position = CGPoint(x: position, y: self.frame.size.height + alien.size.height)
        
        alien.physicsBody = SKPhysicsBody(rectangleOf: alien.size)
        alien.physicsBody?.isDynamic = true
        
        alien.physicsBody?.categoryBitMask = alienCategory
        alien.physicsBody?.contactTestBitMask = photonTorpedoCategory
        alien.physicsBody?.collisionBitMask = 0
        
        self.addChild(alien)
        
        let animationDuration:TimeInterval = 6
        
        var actionArray = [SKAction]()
        
        
        actionArray.append(SKAction.move(to: CGPoint(x: position, y: -alien.size.height), duration: animationDuration))
        actionArray.append(SKAction.removeFromParent())
        
        alien.run(SKAction.sequence(actionArray))
        
        
    }
    
    
    func fireBullet() {
        self.run(SKAction.playSoundFileNamed("torpedo.mp3", waitForCompletion: false))
        
        let bulletNode = SKSpriteNode(imageNamed: "Player_bullet")
        bulletNode.position = player.position
        bulletNode.position.y += 5
        bulletNode.physicsBody = SKPhysicsBody(circleOfRadius: bulletNode.size.width / 2)
        bulletNode.physicsBody?.isDynamic = true
        
        bulletNode.physicsBody?.categoryBitMask = photonTorpedoCategory
        bulletNode.physicsBody?.contactTestBitMask = alienCategory
        bulletNode.physicsBody?.collisionBitMask = 0
        bulletNode.physicsBody?.usesPreciseCollisionDetection = true
        
        self.addChild(bulletNode)
        
        let animationDuration:TimeInterval = 0.3
        
        
        var actionArray = [SKAction]()
        
        actionArray.append(SKAction.move(to: CGPoint(x: player.position.x, y: self.frame.size.height + 10), duration: animationDuration))
        actionArray.append(SKAction.removeFromParent())
        
        bulletNode.run(SKAction.sequence(actionArray))
        
        
        
    }
    
    
    func didBegin(_ contact: SKPhysicsContact) {
        var firstBody:SKPhysicsBody
        var secondBody:SKPhysicsBody
        
        if contact.bodyA.categoryBitMask < contact.bodyB.categoryBitMask {
            firstBody = contact.bodyA
            secondBody = contact.bodyB
        }else{
            firstBody = contact.bodyB
            secondBody = contact.bodyA
        }
        
        if (firstBody.categoryBitMask & photonTorpedoCategory) != 0 && (secondBody.categoryBitMask & alienCategory) != 0 {
            bulletDidCollideWithAlien(bulletNode: firstBody.node as! SKSpriteNode, alienNode: secondBody.node as! SKSpriteNode)
        }
        
    }
    
    
    func bulletDidCollideWithAlien (bulletNode:SKSpriteNode, alienNode:SKSpriteNode) {
        
        /*let explosion = SKEmitterNode(fileNamed: "Explosion")!
        explosion.position = alienNode.position
        self.addChild(explosion)*/
        
        self.run(SKAction.playSoundFileNamed("explosion.mp3", waitForCompletion: false))
        
        bulletNode.removeFromParent()
        alienNode.removeFromParent()
        
        
        /*self.run(SKAction.wait(forDuration: 2)) {
            explosion.removeFromParent()
        }*/
        
        score += 5
        
        
    }
    
    var touched:Bool = false
    var location = CGPoint.zero

    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        touched = true
        for touch in touches {
            location = touch.location(in:self)
        }
    }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        for touch in touches {
            location = touch.location(in: self)
        }
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        // Stop node from moving to touch
        touched = false
    }
    
    override func update(_ currentTime: TimeInterval) {
        // Called before each frame is rendered
        if (touched) {
            moveNodeToLocation()
        }
    }
    
    // Move the node to the location of the touch
    func moveNodeToLocation() {
        // Compute vector components in direction of the touch
        var dx = location.x - player.position.x
        var dy = location.y - player.position.y
        // How fast to move the node. Adjust this as needed
        let speed:CGFloat = 0.25
        // Scale vector
        dx = dx * speed
        dy = dy * speed
        player.position = CGPoint(x:player.position.x+dx, y:player.position.y+dy)
    }

}
