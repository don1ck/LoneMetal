//
//  Node.swift
//  AnimationDemo
//
//  Created by Victor on 9/11/15.
//  Copyright (c) 2015 LoneHouse. All rights reserved.
//

import Foundation
import Metal
import QuartzCore

class LHNode: NSObject {
	
	let name:String
	var vertexCount:Int
	var vertexBuffer:MTLBuffer
	var device: MTLDevice
	
	init(name:String, vertices: Array<LHVertex>, device:MTLDevice) {
		
		var vertexData = Array<Float>()
		for vertex in vertices {
			vertexData += vertex.floatBuffer()
		}
		
		let dataSize = vertexData.count * sizeofValue(vertexData[0])
		vertexBuffer = device.newBufferWithBytes(vertexData, length: dataSize, options: nil)
		
		self.name = name
		self.device = device
		self.vertexCount = vertices.count
	}
	
}
