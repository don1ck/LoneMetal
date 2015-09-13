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
		vertexBuffer = device.newBufferWithBytes(vertexData, length: dataSize, options: MTLResourceOptions.CPUCacheModeDefaultCache)
		
		self.name = name
		self.device = device
		self.vertexCount = vertices.count
	}
    
    /**
    Renders Node
    
    - parameter commandQueue:  commandQueue
    - parameter pipelineState: pipelineState
    - parameter drawable:      drawable
    - parameter clearColor:   
    clearColor
    */
    func render(commandQueue: MTLCommandQueue, pipelineState: MTLRenderPipelineState, drawable: CAMetalDrawable, clearColor: MTLClearColor?) {
        let renderPassDescriptor = MTLRenderPassDescriptor()
        renderPassDescriptor.colorAttachments[0].texture = drawable.texture
        renderPassDescriptor.colorAttachments[0].loadAction = .Clear
        renderPassDescriptor.colorAttachments[0].clearColor = MTLClearColor(red: 0.0, green: 104.0/255.0, blue: 5.0/255.0, alpha: 1.0)
        renderPassDescriptor.colorAttachments[0].storeAction = .Store

        let commandBuffer = commandQueue.commandBuffer()
        let renderEncoder = commandBuffer.renderCommandEncoderWithDescriptor(renderPassDescriptor)
            renderEncoder.setRenderPipelineState(pipelineState)
            renderEncoder.setVertexBuffer(vertexBuffer, offset: 0, atIndex: 0)
            renderEncoder.drawPrimitives(.Triangle, vertexStart: 0, vertexCount: vertexCount, instanceCount: vertexCount/3)
            renderEncoder.endEncoding()
        
        commandBuffer.presentDrawable(drawable)
        commandBuffer.commit()
    }
	
}





