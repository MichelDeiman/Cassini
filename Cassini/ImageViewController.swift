//
//  ViewController.swift
//  Cassini
//
//  Created by Michel Deiman on 27/05/16.
//  Copyright © 2016 Michel Deiman. All rights reserved.
//

import UIKit

class ImageViewController: UIViewController, UIScrollViewDelegate {

//	model
	var imageURL: NSURL? {
		didSet {
			image = nil
			let viewIsOnScreen = view.window
			if viewIsOnScreen != nil {
				fetchImage()
			}
		}
	}
	
	@IBOutlet weak private var spinner: UIActivityIndicatorView!
	
	@IBOutlet weak private var scrollView: UIScrollView! {
		didSet {
			scrollView.contentSize = imageView.frame.size
			scrollView.delegate = self
			scrollView.maximumZoomScale = 1
			scrollView.minimumZoomScale = 0.03
		}
	}
	
	private func fetchImage() {
		if let url = imageURL {
			spinner?.startAnimating()	// ?: spinner might not be set -> optional chaining
			dispatch_async(dispatch_get_global_queue(QOS_CLASS_USER_INITIATED, 0)) {
				let contentsOfURL = NSData(contentsOfURL: url)
				dispatch_async(dispatch_get_main_queue()) {  // implement [weak meSelf = self]
					if url == self.imageURL
					{	if let imageData = contentsOfURL {
							self.image = UIImage(data: imageData)
						} else {
							self.spinner?.stopAnimating()
						}
					} else {
						print("ignored data retruned from url \(url)")
					}
				}
			}
		}
	}
	
	private var imageView = UIImageView()
	
	private var image: UIImage?
	{	get {
			return imageView.image
		}
		set {
			imageView.image = newValue
			imageView.sizeToFit()
			scrollView?.contentSize = imageView.frame.size	// scrollView might not be there -> ?
			spinner?.stopAnimating()
		}
	}
	
	func viewForZoomingInScrollView(scrollView: UIScrollView) -> UIView? {
		return imageView
	}
	
	override func viewWillAppear(animated: Bool) {
		super.viewWillAppear(animated)
		if image == nil {
			fetchImage()
		}
	}
	
	override func viewDidLoad()
	{	super.viewDidLoad()
		scrollView.addSubview(imageView)
	}
	
	
	
	
	
}

