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
	func raw() -> Array<Float> {
		return [m00,m01,m02,m03,m10,m11,m12,m13,m20,m21,m22,m23,m30,m31,m32,m33]
	}
}

class LHNode: NSObject {
	
	let name:String
	var vertexCount:Int
	var vertexBuffer:MTLBuffer
    var uniformBuffer: MTLBuffer?
	var device: MTLDevice
    var modelMatrix: GLKMatrix4 {
        get {
            var model = GLKMatrix4Identity
            model = GLKMatrix4Translate(model, positionX, positionY, positionZ)
            model = GLKMatrix4Scale(model, scale, scale, scale)
            model = GLKMatrix4RotateX(model, rotationX)
            model = GLKMatrix4RotateY(model, rotationY)
            model = GLKMatrix4RotateZ(model, rotationZ)
            return model
        }
    }
	
	var time: CFTimeInterval = 0.0
    
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
	
	func updateWithDelta(delta: CFTimeInterval){
		time += delta
	}
    
    /**
    Renders Node
    
    - parameter commandQueue:  commandQueue
    - parameter pipelineState: pipelineState
    - parameter drawable:      drawable
    - parameter clearColor:   
    clearColor
    */
	func render(commandQueue: MTLCommandQueue, pipelineState: MTLRenderPipelineState, drawable: CAMetalDrawable, parentModelMatrix:GLKMatrix4, projectionMatrix:GLKMatrix4, clearColor: MTLClearColor?) {
        let renderPassDescriptor = MTLRenderPassDescriptor()
        renderPassDescriptor.colorAttachments[0].texture = drawable.texture
        renderPassDescriptor.colorAttachments[0].loadAction = .Clear
        renderPassDescriptor.colorAttachments[0].clearColor = MTLClearColor(red: 0.0, green: 104.0/255.0, blue: 5.0/255.0, alpha: 1.0)
        renderPassDescriptor.colorAttachments[0].storeAction = .Store

        let commandBuffer = commandQueue.commandBuffer()
        let renderEncoder = commandBuffer.renderCommandEncoderWithDescriptor(renderPassDescriptor)
			renderEncoder.setCullMode(MTLCullMode.Front)
            renderEncoder.setRenderPipelineState(pipelineState)
            renderEncoder.setVertexBuffer(vertexBuffer, offset: 0, atIndex: 0)

        var nodeModelMatrix = self.modelMatrix
		nodeModelMatrix = GLKMatrix4Multiply(parentModelMatrix, nodeModelMatrix)
        uniformBuffer = device.newBufferWithBytes(nodeModelMatrix.raw()+projectionMatrix.raw(), length: sizeof(Float)*GLKMatrix4.elementsCount*2, options: MTLResourceOptions.CPUCacheModeDefaultCache)
        renderEncoder.setVertexBuffer(self.uniformBuffer, offset: 0, atIndex: 1)
        
            renderEncoder.drawPrimitives(.Triangle, vertexStart: 0, vertexCount: vertexCount, instanceCount: 1)
            renderEncoder.endEncoding()
        
        commandBuffer.presentDrawable(drawable)
        commandBuffer.commit()
    }
	
}





