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
	var lastFrameTimestamp : CFTimeInterval = 0.0
	
	var nodeToDraw: LHNode! = nil
	
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
	func render(time:CFTimeInterval) {
		let drawable = metalLayer.nextDrawable()!
		nodeToDraw.positionZ = -2.0
		nodeToDraw.scale = 1
		nodeToDraw.updateWithDelta(time)
		
		var worldModelMatrix = GLKMatrix4Identity
		worldModelMatrix = GLKMatrix4Translate(worldModelMatrix, 0, 0, -7)
		worldModelMatrix = GLKMatrix4RotateX(worldModelMatrix, GLKMathDegreesToRadians(25))
		nodeToDraw.render(commandQueue, pipelineState: pipelineState, drawable: drawable, parentModelMatrix: worldModelMatrix, projectionMatrix: projectionMatrix, clearColor: nil)
	}
 
	func newFrame(displayLink: CADisplayLink) {
		
		if lastFrameTimestamp == 0.0 {
			lastFrameTimestamp = displayLink.timestamp
		}
		
		let elapsed:CFTimeInterval = displayLink.timestamp - lastFrameTimestamp
		lastFrameTimestamp = displayLink.timestamp
		
		gameloop(timeSinceLastUpdate: elapsed)
		
	}
 
	func gameloop(timeSinceLastUpdate timeSinceLastUpdate: CFTimeInterval) {
		autoreleasepool {
			self.render(timeSinceLastUpdate)
		}
	}
	
	
	// MARK: - Custom methods
	
	func setupTimer() {
		timer = CADisplayLink(target: self, selector: Selector("newFrame:"))
		timer.addToRunLoop(NSRunLoop.mainRunLoop(), forMode: NSDefaultRunLoopMode)
	}
	
	func setupMetal() {
		nodeToDraw = LHCube(device: device)
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
