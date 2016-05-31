//
//  CassiniViewController.swift
//  Cassini
//
//  Created by Michel Deiman on 27/05/16.
//  Copyright © 2016 Michel Deiman. All rights reserved.
//

import UIKit

class CassiniViewController: UIViewController, UISplitViewControllerDelegate {
	
	
	private struct StoryBoard {
		static let ShowImageSegue = "Show Image"
	}

	@IBAction private func onShowImage(sender: UIButton)
	{
		if let ivc = splitViewController?.viewControllers.last?.contentViewController as? ImageViewController
		{	let imageName = sender.currentTitle
			ivc.imageURL = DemoURL.NSAImageNamed(imageName)
			ivc.title = imageName
		} else {
			performSegueWithIdentifier(StoryBoard.ShowImageSegue, sender: sender)
		}
	}
	
     override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
		guard let identifier = segue.identifier where identifier == StoryBoard.ShowImageSegue
		else { return }
		let destinationVC = segue.destinationViewController
		if let contentVC = destinationVC.contentViewController as? ImageViewController {
			let imageName = (sender as? UIButton)?.currentTitle
			contentVC.imageURL = DemoURL.NSAImageNamed(imageName)
			contentVC.title = imageName
			title = imageName
		}
    }
	
	override func viewDidLoad() {
		super.viewDidLoad()
		splitViewController?.delegate = self
	}

	func splitViewController(splitViewController: UISplitViewController, collapseSecondaryViewController secondaryViewController: UIViewController, ontoPrimaryViewController primaryViewController: UIViewController) -> Bool
	{	if primaryViewController.contentViewController == self
		{	if let ivc = secondaryViewController.contentViewController as? ImageViewController where ivc.imageURL == nil {
				return true
			}
		}
		return false
	}
	

}


extension UIViewController
{
	var contentViewController: UIViewController? {
		if let navcon = self as? UINavigationController {
			return navcon.visibleViewController
		} else {
			return self
		}
	}
}
