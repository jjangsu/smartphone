//
//  ArcheryScene.swift
//  SpriteKitDemo
//
//  Created by Neil Smyth on 10/7/16.
//  Copyright © 2016 eBookFrenzy. All rights reserved.
//

import UIKit
import SpriteKit

class ArcheryScene: SKScene, SKPhysicsContactDelegate {

    let arrowCategory: UInt32 = 0x1 << 0
    let ballCategory: UInt32 = 0x1 << 1

    var score = 0
    var ballCount = 20

    override func didMove(to view: SKView) {
        let archerNode = self.childNode(withName: "archerNode")
        archerNode?.position.y = 0
        archerNode?.position.x = -self.size.width/2 + 40
        self.physicsWorld.gravity = CGVector(dx: 0, dy: -1.0)
        self.physicsWorld.contactDelegate = self
        self.initArcheryScene()
    }

    func initArcheryScene() {
        let releaseBalls = SKAction.sequence([SKAction.run({
        self.createBallNode() }),
        SKAction.wait(forDuration: 1)])

        self.run(SKAction.repeat(releaseBalls,
                            count: ballCount), completion: {
            let sequence =
                       SKAction.sequence([SKAction.wait(forDuration: 5.0),
                            SKAction.run({ self.gameOver() })])
            self.run(sequence)
        })

    }

    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {

        if let archerNode = self.childNode(withName: "archerNode") {
           let animate = SKAction(named: "animateArcher")
        let shootArrow = SKAction.run({
            let arrowNode = self.createArrowNode()
            self.addChild(arrowNode)
            arrowNode.physicsBody?.applyImpulse(CGVector(dx: 60, dy: 0))
        })

        let sequence = SKAction.sequence([animate!, shootArrow])

            archerNode.run(sequence)
        }
    }

    func createArrowNode() -> SKSpriteNode {
        let archerNode = self.childNode(withName: "archerNode")
        let archerPosition = archerNode?.position
        let archerWidth = archerNode?.frame.size.width

        let arrow = SKSpriteNode(imageNamed: "ArrowTexture.png")

        arrow.position = CGPoint(x: archerPosition!.x + archerWidth!,
                                 y: archerPosition!.y)
        arrow.name = "arrowNode"

        arrow.physicsBody = SKPhysicsBody(rectangleOf:
                    arrow.frame.size)

        arrow.physicsBody?.usesPreciseCollisionDetection = true
        arrow.physicsBody?.categoryBitMask = arrowCategory
        arrow.physicsBody?.collisionBitMask = arrowCategory | ballCategory
        arrow.physicsBody?.contactTestBitMask =
                                arrowCategory | ballCategory

        return arrow
    }

    func createBallNode() {
        let ball = SKSpriteNode(imageNamed: "BallTexture.png")

        let screenWidth = self.size.width

        ball.position = CGPoint(x: randomBetween(-screenWidth/2, max:
            screenWidth/2-200), y: self.size.height-50)

        ball.name = "ballNode"
        ball.physicsBody = SKPhysicsBody(circleOfRadius:
                            (ball.size.width/2))

        ball.physicsBody?.usesPreciseCollisionDetection = true
        ball.physicsBody?.categoryBitMask = ballCategory
        self.addChild(ball)
    }

    func randomBetween(_ min: CGFloat, max: CGFloat) -> CGFloat {
        return CGFloat(Float(arc4random()) / Float(UINT32_MAX)) * 
            (max - min) + min
    }

    func createScoreNode() -> SKLabelNode {
        let scoreNode = SKLabelNode(fontNamed: "Bradley Hand")
        scoreNode.name = "scoreNode"

        let newScore = "Score \(score)"

        scoreNode.text = newScore
        scoreNode.fontSize = 60
        scoreNode.fontColor = SKColor.red
        scoreNode.position = CGPoint(x: self.frame.midX,
                                     y: self.frame.midY)
        return scoreNode
    }

    func gameOver() {
        let scoreNode = self.createScoreNode()
        self.addChild(scoreNode)
        let fadeOut = SKAction.sequence([SKAction.wait(forDuration: 3.0),
                    SKAction.fadeOut(withDuration: 3.0)])

        let welcomeReturn =  SKAction.run({
            let transition = SKTransition.reveal(
                with: SKTransitionDirection.down, duration: 1.0)
            let welcomeScene = GameScene(fileNamed: "GameScene")
            self.scene!.view?.presentScene(welcomeScene!,
                                    transition: transition)
        })

        let sequence = SKAction.sequence([fadeOut, welcomeReturn])
        self.run(sequence)
    }


    func didBegin(_ contact: SKPhysicsContact) {
        let secondNode = contact.bodyB.node as! SKSpriteNode

        if (contact.bodyA.categoryBitMask == arrowCategory) &&
            (contact.bodyB.categoryBitMask == ballCategory) {

            let contactPoint = contact.contactPoint
            let contact_y = contactPoint.y
            let target_y = secondNode.position.y
            let target_x = secondNode.position.x
            let margin = secondNode.frame.size.height/2 - 25

            if (contact_y > (target_y - margin)) &&
                (contact_y < (target_y + margin)) {
                let burstPath = Bundle.main.path(
                    forResource: "BurstParticle", ofType: "sks")

                 if burstPath != nil {
                    let burstNode =
                      NSKeyedUnarchiver.unarchiveObject(withFile: burstPath!)
                            as! SKEmitterNode
                    burstNode.position = CGPoint(x: target_x, y: target_y)
                    secondNode.removeFromParent()
                    self.addChild(burstNode)
                    let audioAction = SKAction(named: "audioAction")
                    burstNode.run(audioAction!)

                 }

                score += 1
            }
        }
    }

}
