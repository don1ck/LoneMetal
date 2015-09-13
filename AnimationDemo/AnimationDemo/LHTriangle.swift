//
//  LHTriangle.swift
//  AnimationDemo
//
//  Created by Victor on 9/13/15.
//  Copyright © 2015 LoneHouse. All rights reserved.
//

import Foundation
import Metal


class LHTriangle: LHNode {
    
    init(device: MTLDevice){
        
        let V0 = LHVertex(x:  0.0, y:   1.0, z:   0.0, r:  1.0, g:  0.0, b:  0.0, a:  1.0)
        let V1 = LHVertex(x: -1.0, y:  -1.0, z:   0.0, r:  0.0, g:  1.0, b:  0.0, a:  1.0)
        let V2 = LHVertex(x:  1.0, y:  -1.0, z:   0.0, r:  0.0, g:  0.0, b:  1.0, a:  1.0)
        
        let verticesArray = [V0,V1,V2]
        super.init(name: "Triangle", vertices: verticesArray, device: device)
    }
    
}