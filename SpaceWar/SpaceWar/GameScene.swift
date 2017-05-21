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

struct CollisionCategory {
    static let Enemy : UInt32 = 1
    static let Bullet : UInt32 = 2
    static let Player : UInt32 = 3
    static let PowerUp : UInt32 = 4
}
class GameScene: SKScene, SKPhysicsContactDelegate {
    
    var starfield:SKEmitterNode!
    var player:SKSpriteNode!
    var spawnbullet = true
    var scoreLabel:SKLabelNode!
    var lifeLabel:SKLabelNode!
    var pause:SKSpriteNode!
    var Continue: SKLabelNode!
    var score:Int = 0 {
    didSet {
    scoreLabel.text = "Score: \(score)"
    
    }
    }
    var life:Int = 3{
        didSet{
            lifeLabel.text = "Life:\(life)"
        }
    }
    var gameTimer:Timer!
    var shootBullet:Timer!
    var powerup:Timer!
    var highscore = Int()
    
    var possibleAliens = ["BMeteorite", "SMeteorite","Enemy"]
    
    override func didMove(to view: SKView) {
    
    let hsDefault = UserDefaults.standard
        
        if(hsDefault.value(forKey: "Highscore") != nil){
            highscore = hsDefault.value(forKey: "Highscore") as! NSInteger
        }
        else{
            highscore = 0
        }
    /*starfield = SKEmitterNode(fileNamed: "Starfield")
    starfield.position = CGPoint(x: 0, y: 1472)
    starfield.advanceSimulationTime(10)
    self.addChild(starfield)
    
    starfield.zPosition = -10*/
    // player
    player = SKSpriteNode(imageNamed: "PlayerShip")
    
    player.position = CGPoint(x: self.frame.size.width / 2, y: player.size.height / 2 + 20)
    player.physicsBody?.affectedByGravity = false
    player.physicsBody = SKPhysicsBody(rectangleOf: player.size)
    player.physicsBody?.categoryBitMask = CollisionCategory.Player
    player.physicsBody?.contactTestBitMask = CollisionCategory.Enemy
    player.physicsBody?.contactTestBitMask = CollisionCategory.PowerUp
    player.physicsBody?.isDynamic = false
    player.zPosition = 100
    self.addChild(player)
    
    //worldPhysics
    self.physicsWorld.gravity = CGVector(dx: 0, dy: 0)
    self.physicsWorld.contactDelegate = self
    // score label
    scoreLabel = SKLabelNode(text: "Score: 0")
    scoreLabel.position = CGPoint(x: 40, y: frame.size.height - 30)
    scoreLabel.fontName = "AmericanTypewriter-Bold"
    scoreLabel.fontSize = 20
    scoreLabel.fontColor = UIColor.white
    score = 0
    
    self.addChild(scoreLabel)
    //life label
    lifeLabel = SKLabelNode(text: "Life: 3")
    
    lifeLabel.position = CGPoint(x: frame.size.width - 60, y: frame.size.height - 30)
    lifeLabel.fontName = "AmericanTypewriter-Bold"
    lifeLabel.fontSize = 20
    lifeLabel.fontColor = UIColor.white
    self.addChild(lifeLabel)
    // pause button
    pause = SKSpriteNode(imageNamed: "Pause")
    pause.position = CGPoint(x: self.frame.size.width - 60, y: player.size.height / 4 * 3 )
    pause.size = CGSize(width: 30, height: 30)
        pause.zPosition = -10;
    self.addChild(pause)
    // continue
    Continue = SKLabelNode(text: "Continue")
    Continue.isHidden = true
    Continue.position = CGPoint(x: frame.size.width / 2, y: frame.size.height / 2)
    Continue.fontName = "AmericanTypewriter-Bold"
    Continue.fontSize = 30
    Continue.fontColor = UIColor.white
        self.addChild(Continue)
    //spawning bullet and enemy
    gameTimer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(addAlien), userInfo: nil, repeats: true)
        
    shootBullet = Timer.scheduledTimer(timeInterval: 0.75, target: self, selector: #selector(fireBullet), userInfo: nil, repeats: true)
    //powerup = Timer.scheduledTimer(timeInterval: 6, target: self, selector: #selector(PowerUpSpawn), userInfo: nil, repeats: true)
}
    
    
    func addAlien () {
        possibleAliens = GKRandomSource.sharedRandom().arrayByShufflingObjects(in: possibleAliens) as! [String]
        
        let enemy = SKSpriteNode(imageNamed: possibleAliens[0])
        
        let randomEnemyPosition = GKRandomDistribution(lowestValue: 0, highestValue: Int(self.frame.size.width))
        let position = CGFloat(randomEnemyPosition.nextInt())
        
        enemy.position = CGPoint(x: position, y: self.frame.size.height + enemy.size.height)
        
        enemy.physicsBody = SKPhysicsBody(rectangleOf: enemy.size)
        enemy.physicsBody?.isDynamic = true
        enemy.physicsBody?.affectedByGravity = false
        enemy.physicsBody?.categoryBitMask = CollisionCategory.Enemy
        enemy.physicsBody?.contactTestBitMask = CollisionCategory.Bullet
        enemy.physicsBody?.contactTestBitMask = CollisionCategory.Player
        self.addChild(enemy)
        
        let animationDuration:TimeInterval = 6
        
        let action = SKAction.move(to: CGPoint(x: position, y: -enemy.size.height), duration: animationDuration)
        let actionDone = SKAction.removeFromParent()
        enemy.run(SKAction.sequence([action,actionDone]))
        
    }
    func PowerUpSpawn() {
        let PowerUp = SKSpriteNode(imageNamed: "PowerUp_Icon")
        let randomPowerUpPosition = GKRandomDistribution(lowestValue: 0, highestValue: Int(self.frame.size.width))
        let position = CGFloat(randomPowerUpPosition.nextInt())
        PowerUp.zPosition = -10
        PowerUp.position = CGPoint(x: position, y: self.frame.size.height + PowerUp.size.height)
        PowerUp.physicsBody = SKPhysicsBody(rectangleOf: PowerUp.size)
        PowerUp.physicsBody?.isDynamic = true
        PowerUp.physicsBody?.affectedByGravity = false
        PowerUp.physicsBody?.categoryBitMask = CollisionCategory.PowerUp
        PowerUp.physicsBody?.contactTestBitMask = CollisionCategory.Player
        PowerUp.physicsBody?.collisionBitMask = 0
        self.addChild(PowerUp)
        let animationDuration:TimeInterval = 6
        
        let action = SKAction.move(to: CGPoint(x: position, y: -PowerUp.size.height), duration: animationDuration)
        let actionDone = SKAction.removeFromParent()
        PowerUp.run(SKAction.sequence([action,actionDone]))
        
    }
    
    func fireBullet() {
        self.run(SKAction.playSoundFileNamed("torpedo.mp3", waitForCompletion: false))
        
        let bulletNode = SKSpriteNode(imageNamed: "Player_bullet")
        bulletNode.zPosition = -5
        bulletNode.position = player.position
        bulletNode.physicsBody = SKPhysicsBody(rectangleOf: bulletNode.size)
        bulletNode.physicsBody?.affectedByGravity = false
        bulletNode.physicsBody?.categoryBitMask = CollisionCategory.Bullet
        bulletNode.physicsBody?.contactTestBitMask = CollisionCategory.Enemy
        bulletNode.physicsBody?.isDynamic = false
        self.addChild(bulletNode)
        
        let animationDuration:TimeInterval = 0.3
        
        //moving bullet to y value
        let action = SKAction.move(to: CGPoint(x: player.position.x, y: self.frame.size.height + 10), duration: animationDuration)
        let actionDone = SKAction.removeFromParent()
        bulletNode.run(SKAction.sequence([action,actionDone]))
        
    }
    
    
    func didBegin(_ contact: SKPhysicsContact) {
        let firstBody:SKPhysicsBody = contact.bodyA
        let secondBody:SKPhysicsBody = contact.bodyB
        
        if ((firstBody.categoryBitMask == CollisionCategory.Enemy) && (secondBody.categoryBitMask == CollisionCategory.Bullet) || (firstBody.categoryBitMask == CollisionCategory.Bullet) && (secondBody.categoryBitMask == CollisionCategory.Enemy)) {
            CollisionWithBullet(Enemy: firstBody.node as! SKSpriteNode, Bullet: secondBody.node as! SKSpriteNode)
        }
        if (firstBody.categoryBitMask == CollisionCategory.Enemy) && (secondBody.categoryBitMask == CollisionCategory.Player){
            CollisionWithPlayer(Enemy: firstBody.node as! SKSpriteNode, Player: secondBody.node as! SKSpriteNode)
        }
        if (firstBody.categoryBitMask == CollisionCategory.Player) && (secondBody.categoryBitMask == CollisionCategory.Enemy){
            CollisionWithPlayer(Enemy: secondBody.node as! SKSpriteNode, Player: firstBody.node as! SKSpriteNode)
        }
        if (firstBody.categoryBitMask == CollisionCategory.Player) && (secondBody.categoryBitMask == CollisionCategory.PowerUp){
            ShieldOn(PowerUp: secondBody.node as! SKSpriteNode, Player: firstBody.node as! SKSpriteNode)
            }
        if (firstBody.categoryBitMask == CollisionCategory.PowerUp) && (secondBody.categoryBitMask == CollisionCategory.Player){
            ShieldOn(PowerUp: firstBody.node as! SKSpriteNode, Player: secondBody.node as! SKSpriteNode)
        }
    }
    func CollisionWithBullet(Enemy: SKSpriteNode, Bullet: SKSpriteNode) {
        let explosion = SKEmitterNode(fileNamed: "Explosion.sks")!
        explosion.particleScale = 0.05
        explosion.position = Enemy.position
        self.addChild(explosion)
        
        self.run(SKAction.playSoundFileNamed("explosion.mp3", waitForCompletion: false))
        
        Enemy.removeFromParent()
        Bullet.removeFromParent()
        
        
        self.run(SKAction.wait(forDuration: 2)) {
            explosion.removeFromParent()
        }
        
        score += 5
    }
    
    func ShieldOn(PowerUp: SKSpriteNode, Player: SKSpriteNode){
        
        let shield = SKSpriteNode(imageNamed: "Shield")
        shield.zPosition = -15
        shield.position = Player.position
        self.addChild(shield)
        PowerUp.removeFromParent()
        self.run(SKAction.wait(forDuration: 5)) {
            shield.removeFromParent()
        }
        
        
    }
 
    func CollisionWithPlayer(Enemy: SKSpriteNode, Player: SKSpriteNode){
        
        Enemy.removeFromParent()
        life -= 1
        Health(Player: life, Location: Player)
        
    }
    
    
    func Health(Player:Int, Location: SKSpriteNode){
        if Player == 0 {
            let explosion = SKEmitterNode(fileNamed: "PlayerExplosion.sks")!
            explosion.particleScale = 0.5
            explosion.position = Location.position
            self.addChild(explosion)
            Location.removeFromParent()
            shootBullet.invalidate()
            gameTimer.invalidate()
            let scoreDefault = UserDefaults.standard
            scoreDefault.setValue(score, forKey: "Score")
            if (score > highscore){
                let hsDefault = UserDefaults.standard
                hsDefault.setValue(score, forKey: "Highscore")
            }
            self.run(SKAction.playSoundFileNamed("explosion.mp3", waitForCompletion: false))
            self.run(SKAction.wait(forDuration: 2)) {
                explosion.removeFromParent()
                self.run(SKAction.wait(forDuration: 3)){
                    self.scoreLabel.removeFromParent()
                    self.Continue.removeFromParent()
                    self.pause.removeFromParent()
                    self.lifeLabel.removeFromParent()
                    let transition = SKTransition.flipHorizontal(withDuration: 0.5)
                    let gameOver = SKScene(fileNamed: "GameOverScene") as! GameOverScene
                    self.view?.presentScene(gameOver, transition: transition)
                }
            }
            
        }
        else{
            
            self.run(SKAction.playSoundFileNamed("LoseHealth.mp3", waitForCompletion: false))
            let explosion = SKEmitterNode(fileNamed: "Damage.sks")!
            explosion.particleScale = 0.5
            explosion.position = Location.position
            self.addChild(explosion)
            self.run(SKAction.playSoundFileNamed("explosion.mp3", waitForCompletion: false))
            self.run(SKAction.wait(forDuration: 2)) {
                explosion.removeFromParent()
            }
        }
        
    }
    
    
    var touched:Bool = false
    var location = CGPoint.zero
    var pause_button = CGPoint.zero
    var continue_button = CGPoint.zero
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        touched = true
        for playerlocation in touches {
            location = playerlocation.location(in:self)
            
            if player.contains(location){
                location = playerlocation.location(in: self)
            }
            else {
                location = player.position
            }
        }
        for touch in touches{
            pause_button = touch.location(in:self)
            
            if pause.contains(pause_button){
                Continue.isHidden =  false
                Continue.colorBlendFactor = 0.2
                self.isPaused = true
                shootBullet.invalidate()
                gameTimer.invalidate()
                
            
            }
        }
        for area in touches{
            continue_button = area.location(in: self)
            
            if Continue.contains(continue_button){
                self.isPaused = false
                gameTimer = Timer.scheduledTimer(timeInterval: 0.75, target: self, selector: #selector(addAlien), userInfo: nil, repeats: true)
                
                shootBullet = Timer.scheduledTimer(timeInterval: 0.75, target: self, selector: #selector(fireBullet), userInfo: nil, repeats: true)
                Continue.isHidden = true
            }
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
        for touch in touches{
            pause_button = touch.location(in:self)
            
            if pause.contains(pause_button){

                Continue.colorBlendFactor = 1
                
            }
        }
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
