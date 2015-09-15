//
//  LHMetalController.swift
//  AnimationDemo
//
//  Created by Victor on 9/9/15.
//  Copyright (c) 2015 LoneHouse. All rights reserved.
//

import UIKit
import QuartzCore
import Metal
import GLKit

class LHMetalController: UIViewController {
	// MARK: - Class Properties

	var device = MTLCreateSystemDefaultDevice()!
	var metalLayer = CAMetalLayer()
	var projectionMatrix :GLKMatrix4!
	
	var pipelineState : MTLRenderPipelineState! = nil
	var commandQueue : MTLCommandQueue! = nil
	
	var timer :CADisplayLink! = nil
	
	@IBOutlet weak var metalView: UIView!
	// MARK: - UIView life circle
	
    override func viewDidLoad() {
        super.viewDidLoad()
		setupMetal()
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
	
	
	// MARK: - timer logic
	
	func render() {
		let drawable = metalLayer.nextDrawable()!
		let nodeToDraw = LHCube(device: device)
		nodeToDraw.positionZ = -2.0
		nodeToDraw.scale = 1
		
		var worldModelMatrix = GLKMatrix4Identity
		worldModelMatrix = GLKMatrix4Translate(worldModelMatrix, 0, 0, -7)
		worldModelMatrix = GLKMatrix4RotateX(<#T##matrix: GLKMatrix4##GLKMatrix4#>, <#T##radians: Float##Float#>)
		
		nodeToDraw.render(commandQueue, pipelineState: pipelineState, drawable: drawable, parentModelMatrix: worldModelMatrix, projectionMatrix: projectionMatrix, clearColor: nil)
	}
 
	func gameloop() {
		autoreleasepool {
			self.render()
		}
	}
	
	
	// MARK: - Custom methods
	
	func setupTimer() {
		timer = CADisplayLink(target: self, selector: Selector("gameloop"))
		timer.addToRunLoop(NSRunLoop.mainRunLoop(), forMode: NSDefaultRunLoopMode)
	}
	
	func setupMetal() {
		
		metalLayer.device = device
		metalLayer.pixelFormat = .BGRA8Unorm
		metalLayer.framebufferOnly = true
		metalLayer.frame = view.layer.bounds
		view.layer.addSublayer(metalLayer)

		projectionMatrix = GLKMatrix4MakePerspective(GLKMathDegreesToRadians(85), Float(self.view.bounds.size.width / self.view.bounds.size.height), 0.01, 100.0)
		
		createRenderPipeline()
		commandQueue = device.newCommandQueue()
		setupTimer()
	}
	
	func createRenderPipeline() {
		let defaultLibrary = device.newDefaultLibrary()
		let fragmentProgram = defaultLibrary!.newFunctionWithName("basic_fragment")
		let vertexProgram   = defaultLibrary!.newFunctionWithName("basic_vertex")
		
		let pipelineStateDescriptor = MTLRenderPipelineDescriptor()
		pipelineStateDescriptor.vertexFunction = vertexProgram;
		pipelineStateDescriptor.fragmentFunction = fragmentProgram;
		pipelineStateDescriptor.colorAttachments[0].pixelFormat = .BGRA8Unorm
		
		pipelineState = try! device.newRenderPipelineStateWithDescriptor(pipelineStateDescriptor)
	}
	
}
