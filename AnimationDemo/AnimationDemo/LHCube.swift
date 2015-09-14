//
//  LHCube.swift
//  AnimationDemo
//
//  Created by Victor on 9/14/15.
//  Copyright © 2015 LoneHouse. All rights reserved.
//

import Foundation
import Metal

class LHCube: LHNode {
	
	init(device: MTLDevice){
		
		let A = LHVertex(x: -0.3, y:   0.3, z:   0.3, r:  1.0, g:  0.0, b:  0.0, a:  1.0)
		let B = LHVertex(x: -0.3, y:  -0.3, z:   0.3, r:  0.0, g:  1.0, b:  0.0, a:  1.0)
		let C = LHVertex(x:  0.3, y:  -0.3, z:   0.3, r:  0.0, g:  0.0, b:  1.0, a:  1.0)
		let D = LHVertex(x:  0.3, y:   0.3, z:   0.3, r:  0.1, g:  0.6, b:  0.4, a:  1.0)
		
		let Q = LHVertex(x: -0.3, y:   0.3, z:  -0.3, r:  1.0, g:  0.0, b:  0.0, a:  1.0)
		let R = LHVertex(x:  0.3, y:   0.3, z:  -0.3, r:  0.0, g:  1.0, b:  0.0, a:  1.0)
		let S = LHVertex(x: -0.3, y:  -0.3, z:  -0.3, r:  0.0, g:  0.0, b:  1.0, a:  1.0)
		let T = LHVertex(x:  0.3, y:  -0.3, z:  -0.3, r:  0.1, g:  0.6, b:  0.4, a:  1.0)
		
		let verticesArray:Array<LHVertex> = [
			A,B,C ,A,C,D,   //Front
			R,T,S ,Q,R,S,   //Back
			
			Q,S,B ,Q,B,A,   //Left
			D,C,T ,D,T,R,   //Right
			
			Q,A,D ,Q,D,R,   //Top
			B,S,T ,B,T,C    //Bot
		]
		
		super.init(name: "Cube", vertices: verticesArray, device: device)
	}

}
