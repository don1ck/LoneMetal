//
//  ViewController.swift
//  AnimationDemo
//
//  Created by Victor on 9/8/15.
//  Copyright (c) 2015 LoneHouse. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

	override func viewDidLoad() {
		super.viewDidLoad()
		// Do any additional setup after loading the view, typically from a nib.
	}

	override func didReceiveMemoryWarning() {
		super.didReceiveMemoryWarning()
		// Dispose of any resources that can be recreated.
	}

	@IBAction func beMetalAction(sender: AnyObject) {
		performSegueWithIdentifier("goToMetal", sender: self)
	}

}

