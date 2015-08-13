//
//  GameScene.swift
//  Flappy Bird
//
//  Created by Brad Gray on 8/11/15.
//  Copyright (c) 2015 Brad Gray. All rights reserved.
//

import SpriteKit

class GameScene: SKScene, SKPhysicsContactDelegate {
    
    var bird = SKSpriteNode()
    var bg = SKSpriteNode()
    var pipe1 = SKSpriteNode()
    var pipe2 = SKSpriteNode()
    enum ColliderType: UInt32 {
        
        case Bird = 1
        case Object = 2
        
    }
    var gameOver = false
    
    override func didMoveToView(view: SKView) {
        
        
        self.physicsWorld.contactDelegate = self
        
       let bgTexture = SKTexture(imageNamed: "bg.png")
        
        
        let movebg = SKAction.moveByX(-bgTexture.size().width, y: 0, duration: 9)
        let replacebg = SKAction.moveByX(bgTexture.size().width, y: 0, duration: 0)
        let movebgForever = SKAction.repeatActionForever(SKAction.sequence([movebg, replacebg]))
        
        bg.runAction(movebgForever)
       
        
        
        for var i: CGFloat=0; i < 3; i++ {
            bg = SKSpriteNode(texture: bgTexture)
            
            bg.position = CGPoint(x: bgTexture.size().width/2 + bgTexture.size().width * i, y: CGRectGetMidY(self.frame))
            
            bg.size.height = self.frame.height
            
            bg.runAction(movebgForever)
            bg.zPosition = -5
            
            self.addChild(bg)
        }

      
        let birdTexture = SKTexture(imageNamed: "flappy1.png")
        
        let birdTexture2 = SKTexture(imageNamed: "flappy2.png")
        
        let animation = SKAction.animateWithTextures([birdTexture, birdTexture2], timePerFrame: 0.1)
        
        let makeBirdFlap = SKAction.repeatActionForever(animation)
        
        bird = SKSpriteNode(texture: birdTexture)
        
       
        bird.position = CGPoint(x: CGRectGetMidX(self.frame), y: CGRectGetMidY(self.frame))
        
       bird.runAction(makeBirdFlap)
        
        bird.physicsBody = SKPhysicsBody(circleOfRadius: birdTexture.size().height/2)
        bird.physicsBody!.dynamic = true
        
        bird.physicsBody!.categoryBitMask = ColliderType.Bird.rawValue
        bird.physicsBody!.contactTestBitMask = ColliderType.Object.rawValue
        
        
        self.addChild(bird)
        
      
        
        _ = NSTimer.scheduledTimerWithTimeInterval(3, target: self, selector: Selector("makePipes"), userInfo: nil, repeats: true)

        
        
        
        
        
    var ground = SKNode()
        
    ground.position = CGPointMake(0, 0)
    
        ground.physicsBody = SKPhysicsBody(rectangleOfSize: CGSizeMake(self.frame.size.width, 1))
        
        ground.physicsBody!.dynamic = false
        
       ground.physicsBody!.categoryBitMask = ColliderType.Object.rawValue
        ground.physicsBody!.categoryBitMask = ColliderType.Object.rawValue
        
        self.addChild(ground)
        
        
    }
    
    func makePipes () {
        
        let randomPipes = arc4random() % UInt32(self.frame.height / 2)
        let pipeOffset = CGFloat(randomPipes) - self.frame.height / 4
        
        let gapHeigth = bird.size.height * 4
        
        
        
        let movePipes = SKAction.moveByX(-self.frame.size.width * 2, y: 0, duration: NSTimeInterval(self.frame.size.width / 100))
        let removePipes = SKAction.removeFromParent()
        let moveandRemovePipes = SKAction.sequence([movePipes, removePipes])
        
        let pipeTexture = SKTexture(imageNamed: "pipe1.png")
        pipe1 = SKSpriteNode(texture: pipeTexture)
        pipe1.position = CGPointMake(CGRectGetMidX(self.frame) + self.frame.size.width, CGRectGetMidY(self.frame) + pipeTexture.size().height/2 + gapHeigth / 2 + pipeOffset)
        pipe1.runAction(moveandRemovePipes)
        
        pipe1.physicsBody = SKPhysicsBody(rectangleOfSize: pipeTexture.size())
        pipe1.physicsBody!.categoryBitMask = ColliderType.Object.rawValue
        pipe1.physicsBody!.categoryBitMask = ColliderType.Object.rawValue
        pipe1.physicsBody!.dynamic = false
        
        self.addChild(pipe1)
        
        
        let pipTexture2 = SKTexture(imageNamed: "pipe2.png")
        pipe2 = SKSpriteNode(texture: pipTexture2)
        pipe2.position = CGPointMake(CGRectGetMidX(self.frame) + self.frame.size.width, CGRectGetMidY(self.frame) - pipTexture2.size().height/2 - gapHeigth / 2 + pipeOffset)
        pipe2.runAction(moveandRemovePipes)
        
        pipe2.physicsBody = SKPhysicsBody(rectangleOfSize: pipTexture2.size())
        pipe2.physicsBody!.categoryBitMask = ColliderType.Object.rawValue
        pipe2.physicsBody!.categoryBitMask = ColliderType.Object.rawValue
        pipe2.physicsBody!.dynamic = false
        

        
        self.addChild(pipe2)
        
        
        
        
    }

    func didBeginContact(contact: SKPhysicsContact) {
        print("we have contact")
        
        gameOver = true
        self.speed = 0
    }
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
      
        if gameOver == false {
        bird.physicsBody?.velocity = CGVectorMake(0, 0)
        bird.physicsBody?.applyImpulse(CGVectorMake(0, 50))
        }
           }
   
    override func update(currentTime: CFTimeInterval) {
        /* Called before each frame is rendered */
    }
}
