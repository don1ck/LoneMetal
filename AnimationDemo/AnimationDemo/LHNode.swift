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
import GLKit


extension GLKMatrix4  {
    static let elementsCount = 16
}



class LHNode: NSObject {
	
	let name:String
	var vertexCount:Int
	var vertexBuffer:MTLBuffer
    var uniformBuffer: MTLBuffer?
	var device: MTLDevice
    var modelMatrix: GLKMatrix4 {
        get {
            var model = GLKMatrix4()
            model = GLKMatrix4Translate(model, positionX, positionY, positionZ)
            model = GLKMatrix4Scale(model, scale, scale, scale)
            model = GLKMatrix4RotateX(model, rotationX)
            model = GLKMatrix4RotateY(model, rotationY)
            model = GLKMatrix4RotateZ(model, rotationZ)
            return model
        }
    }
    
    //MARK: Transforms
    var positionX:Float = 0.0
    var positionY:Float = 0.0
    var positionZ:Float = 0.0
    
    var rotationX:Float = 0.0
    var rotationY:Float = 0.0
    var rotationZ:Float = 0.0
    var scale:Float     = 1.0
    //
	
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
        // 1
        var nodeModelMatrix = self.modelMatrix
        // 2
        uniformBuffer = device.newBufferWithLength(sizeof(Float) *  GLKMatrix4.elementsCount, options: MTLResourceOptions.CPUCacheModeDefaultCache)
        // 3
        var bufferPointer = uniformBuffer?.contents()
        // 4
        memccpy(bufferPointer!, nodeModelMatrix, sizeof(Float)*GLKMatrix4.elementsCount, 1)
        // 5
        renderEncoder.setVertexBuffer(self.uniformBuffer, offset: 0, atIndex: 1)
        
            renderEncoder.drawPrimitives(.Triangle, vertexStart: 0, vertexCount: vertexCount, instanceCount: vertexCount/3)
            renderEncoder.endEncoding()
        
        commandBuffer.presentDrawable(drawable)
        commandBuffer.commit()
    }
	
}





