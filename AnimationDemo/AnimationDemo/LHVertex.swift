//
//  LHVertex.swift
//  AnimationDemo
//
//  Created by Victor on 9/11/15.
//  Copyright (c) 2015 LoneHouse. All rights reserved.
//

import Foundation

struct LHVertex {
	var x, y, z: Float
	var r, g, b, a: Float
	
	func floatBuffer() -> [Float] {
		return [x,y,z,r,g,b,a]
	}
	
}
