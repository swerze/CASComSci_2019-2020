//
//  GameScene.swift
//  Mastermind
//
//  Created by Riley John Gibbs on 4/23/20.
//  Copyright © 2020 Riley John Gibbs. All rights reserved.
//

import SpriteKit
import GameplayKit

class GameScene: SKScene {
    
    var board: Board!
    var resetButton: SKLabelNode!
    
    override func didMove(to view: SKView) {
        board = Board()
        createBoard()
        generateButton()
    }
    
    private func restarting(){
        restart()
        board = Board()
        createBoard()
    }
    
    private func generateButton(){
        resetButton = SKLabelNode(fontNamed: "ArialRoundedMTBold")
        resetButton.zPosition = 1
        resetButton.position = CGPoint(x: 0, y: 0)
        resetButton.fontSize = 40
        resetButton.text = "Best Score: \(UserDefaults.standard.integer(forKey: "resetButton"))"
        resetButton.fontColor = SKColor.white
        self.addChild(resetButton)
    }
    
    private func restart(){
        for col in board.columns {
            if let dropper = col.dropper {
                dropper.removeFromParent()
            }
            for cell in col.cells {
                if let node = cell.node {
                    node.removeFromParent()
                }
            }
        }
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        for touch in touches {
            let location = touch.location(in: self)
            let touchedNodes = self.nodes(at: location)
            for touchedNode in touchedNodes {
                for column in self.board.columns {
                    if let dropper = column.dropper, dropper == touchedNode {
                        board.dropChip(in: column)
                        board.updateDisplay()
                    }
                }
            }
        }
    }
    
    override func update(_ currentTime: TimeInterval) {
        // Called before each frame is rendered
    }
    
    private func createBoard() {
        let width: CGFloat = frame.size.width * 7 / 9
        let cellWidth: CGFloat = width / CGFloat(board.NUM_COLUMNS)
        let height = cellWidth * CGFloat(board.NUM_ROWS)
        var x = width / -2 + cellWidth / 2
        var y = height / -2 + cellWidth / 2
        for col in board.columns {
            for cell in col.cells {
                let node = SKShapeNode(rectOf: CGSize(width: cellWidth, height: cellWidth))
                node.zPosition = 2
                node.position = CGPoint(x: x, y: y)
                node.strokeColor = SKColor.black
                cell.node = node
                cell.fill()
                addChild(node)
                y += cellWidth
            }
            let dropper = SKShapeNode()
            dropper.zPosition = 2
            dropper.position = CGPoint(x: x, y: y + cellWidth)
            dropper.fillColor = SKColor.cyan
            let path = CGMutablePath()
            path.addLines(between: [
                CGPoint(x: -cellWidth / 2 + 10, y: cellWidth / 2 - 10),
                CGPoint(x: cellWidth / 2 - 10, y: cellWidth / 2 - 10),
                CGPoint(x: 0, y: -cellWidth / 2 + 10)
            ])
            dropper.path = path
            addChild(dropper)
            col.dropper = dropper
            x += cellWidth
            y = height / -2 + cellWidth / 2
        }
    }
}
