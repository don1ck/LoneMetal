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

	var device = MTLCreateSystemDefaultDevice()
	var metalLayer = CAMetalLayer()
	
	var pipelineState : MTLRenderPipelineState! = nil
	var commandQueue : MTLCommandQueue! = nil
	var vertexBuffer : MTLBuffer! = nil
	
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
		//
		setVertexData([0.0, 1.0, 0.0,
					-1.0, -1.0, 0.0,
					1.0, -1.0, 0.0])
		//
		
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
		
		var pipelineError : NSError?
		
		pipelineState = device.newRenderPipelineStateWithDescriptor(pipelineStateDescriptor, error: &pipelineError)
		
		if pipelineState == nil {
			println("Pipeline creation error \(pipelineError)")
		}
		
	}
	
	
	func setVertexData(newVertexData: [Float]) {
	 let dataSize = newVertexData.count * sizeofValue(newVertexData[0]);
		vertexBuffer = device.newBufferWithBytes(newVertexData, length: dataSize, options: nil)
	}
	
}
