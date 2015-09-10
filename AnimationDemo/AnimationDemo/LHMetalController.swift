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
	
	var vertexBuffer : MTLBuffer! = nil
	
	// MARK: - UIView life circle
	
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
	
	// MARK: - Custom methods
	
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
	}
	
	func setVertexData(newVertexData: [Float]) {
	 let dataSize = newVertexData.count * sizeofValue(newVertexData[0]);
		vertexBuffer = device.newBufferWithBytes(newVertexData, length: dataSize, options: nil)
	}
	
}
