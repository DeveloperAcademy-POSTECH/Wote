//
//  CelebrateScean.swift
//  TwoHoSun
//
//  Created by HyunwooPark on 11/9/23.
//

import SpriteKit

class CelebrateScene: SKScene {
    override func didMove(to view: SKView) {
        backgroundColor = UIColor.background
        scaleMode = .resizeFill
        
        // 각 이미지에 대한 파티클 노드를 생성합니다.
        for node in 0...10 {
            if let particleEmitter = SKEmitterNode(fileNamed: "sprite") {
                particleEmitter.position = CGPoint(x: size.width / 2, y: size.height)
                particleEmitter.particleTexture = SKTexture(imageNamed: "sprite\(node)")
                particleEmitter.particleBirthRate = 1 // 각 파티클 에미터의 생성 비율을 조정합니다.
                addChild(particleEmitter)
            }
        }
    }
}
