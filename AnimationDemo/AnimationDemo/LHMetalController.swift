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

class LHMetalController: UIViewController {
	// MARK: - Class Properties

	var device = MTLCreateSystemDefaultDevice()!
	var metalLayer = CAMetalLayer()
	
	var pipelineState : MTLRenderPipelineState! = nil
	var commandQueue : MTLCommandQueue! = nil
	
	var timer :CADisplayLink! = nil
	
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
        nodeToDraw.render(commandQueue, pipelineState: pipelineState, drawable: drawable, clearColor: nil)
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
