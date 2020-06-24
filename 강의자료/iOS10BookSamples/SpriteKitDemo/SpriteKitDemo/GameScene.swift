//
//  GameScene.swift
//  SpriteKitDemo
//
//  Created by Neil Smyth on 10/7/16.
//  Copyright © 2016 eBookFrenzy. All rights reserved.
//

import SpriteKit
import GameplayKit

class GameScene: SKScene {
    
    override func didMove(to view: SKView) {
        
    }
    

    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        let welcomeNode = childNode(withName: "welcomeNode")
        if (welcomeNode != nil) {
            let fadeAway = SKAction.fadeOut(withDuration: 1.0)

            welcomeNode?.run(fadeAway, completion: {
                let doors = SKTransition.doorway(withDuration: 1.0)
                let archeryScene = ArcheryScene(fileNamed: "ArcheryScene")
                self.view?.presentScene(archeryScene!, transition: doors)
            })
        }

    }
    
        
    override func update(_ currentTime: TimeInterval) {
        // Called before each frame is rendered
    }
}
