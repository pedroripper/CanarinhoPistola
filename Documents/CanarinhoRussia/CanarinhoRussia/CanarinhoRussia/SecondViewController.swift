//
//  SecondViewController.swift
//  CanarinhoRussia
//
//  Created by Pedro Ripper on 10/07/2018.
//

import UIKit
import SceneKit

class SecondViewController: UIViewController {
    @IBOutlet var gamescn: SCNView!// espaco da tela que passa o jogo
 

    @IBOutlet var scoreLabel: UILabel! // texto do score na tela

    
    var score = 0 {
        didSet{ // sempre que score muda, ativa essa funcao de mudar o texto de scoreLabel
            DispatchQueue.main.async() {
            self.scoreLabel.text = "Score: \(self.score)"
            }
            
        }
    }
   
   
    let russianDoll = 2 // contact bitmask da boneca russa
    
    var scene:SCNScene!
    
    // objetos do jogo
    var canarinhoNode:SCNNode!
    var cameraVisionNode:SCNNode!
    var dollNode:SCNNode!
    
    
    
    override func viewDidLoad() {
        // quando a tela e carregada, chama essas funcoes para criar a cena e carregar os objetos
        setupScene()
        setupNodes()
        
    }
    
    
    func setupScene(){

        gamescn.delegate = self
        
        
        scene = SCNScene(named: "gameScene.scn")
        gamescn.scene = scene
        
        scene.physicsWorld.contactDelegate = self
        
        let tapRecognizer = UITapGestureRecognizer()
        tapRecognizer.numberOfTapsRequired = 1
        tapRecognizer.numberOfTouchesRequired = 1
        
        tapRecognizer.addTarget(self, action: #selector(SecondViewController.sceneViewTapped(recognizer:)))
        gamescn.addGestureRecognizer(tapRecognizer)
        
    }
    
    func setupNodes() {
    
        canarinhoNode = scene.rootNode.childNode(withName: "Cube", recursively: true)!
        canarinhoNode.physicsBody?.contactTestBitMask = russianDoll
        cameraVisionNode = scene.rootNode.childNode(withName: "cameraVision", recursively: true)!
        dollNode = scene.rootNode.childNode(withName:"Sphere", recursively: true)!
       
        
        
    }
    func increaseScore(){
        score = score + 1
      
    }
    
    
  
        
        
    
    @objc func sceneViewTapped (recognizer:UITapGestureRecognizer) {
        let location = recognizer.location(in: gamescn)
        
        let hitResults = gamescn.hitTest(location, options: nil)
        let clicks = hitResults.count
        // pulo do canarinho
        if clicks == 1 {
            canarinhoNode.physicsBody?.applyForce(SCNVector3(x: 0, y:4, z: 0), asImpulse: true)
        }
    }
    
    
    override var shouldAutorotate: Bool {
        return false
    }
    
    override var prefersStatusBarHidden: Bool {
        return false
    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
}

extension SecondViewController : SCNSceneRendererDelegate {
    func renderer(_ renderer: SCNSceneRenderer, updateAtTime time: TimeInterval) {
        
        let canarinho = canarinhoNode.presentation
        let canarinhoPosition = canarinho.position
        var dollPosition = dollNode.position
        //fazendo a camera acompanhar o canarinho
        let targetPosition = SCNVector3(x: canarinhoPosition.x, y: canarinhoPosition.y , z:canarinhoPosition.z )
        var cameraPosition = cameraVisionNode.position

        let camDamping:Float = 0.3
       
        
        let xComponent = cameraPosition.x * (1 - camDamping) + targetPosition.x * camDamping
    
        let zComponent = cameraPosition.z * (1 - camDamping) + targetPosition.z * camDamping
        
        
        let correcao:Float = 10.0
    
        
        cameraPosition = SCNVector3(x: xComponent, y: cameraPosition.y, z: zComponent)
        cameraVisionNode.position = cameraPosition
        if canarinhoPosition.x < dollPosition.x{
            //sempre que o canarinho ultrapassa a boneca, ela muda de posicao
            let xdoll = canarinhoPosition.x - correcao
            let ydoll = dollPosition.y
            let zdoll = dollPosition.z
            dollPosition = SCNVector3(xdoll, ydoll, zdoll)
            dollNode.position = dollPosition
            increaseScore()
            
        }
     
        
    }
    
    
    
}

extension SecondViewController : SCNPhysicsContactDelegate {
    func physicsWorld(_ world: SCNPhysicsWorld, didBegin contact: SCNPhysicsContact) {
        // checando se o canarinho encostou na boneca
        var contactNode:SCNNode!
        
        if contact.nodeA.name == "canarinhoPistolcollada" {
            contactNode = contact.nodeB
        }else{
            contactNode = contact.nodeA
        }
        
        if contactNode.physicsBody?.categoryBitMask == russianDoll {
            score = 0
            self.dismiss(animated: false, completion: nil)
        }    }
    
    
}




