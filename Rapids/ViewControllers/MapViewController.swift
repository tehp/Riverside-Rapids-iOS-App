//
//  MapViewController.swift
//  Rapids
//
//  Created by Programming 12 on 2016-04-08.
//  Copyright © 2016 Riverside Secondary School. All rights reserved.
//

import UIKit

class MapViewController: UIViewController {
   
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var imageViewBottomConstraint: NSLayoutConstraint!
    @IBOutlet weak var imageViewLeadingConstraint: NSLayoutConstraint!
    @IBOutlet weak var imageViewTopConstraint: NSLayoutConstraint!
    @IBOutlet weak var imageViewTrailingConstraint: NSLayoutConstraint!
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var toolbar: UIToolbar!
    
    //This is not working right now, but we'll leave it here in case we can get it working later
    let IMAGE_BORDER_SPACE: CGFloat = 0
    
    let MAX_ZOOM_SCALE: CGFloat = 1.5
    
    override func viewDidLoad() {
        super.viewDidLoad()
     
        // Do any additional setup after loading the view.
        scrollView.delegate = self
        
        toolbar.barTintColor = AppDelegate.navColor
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        updateMinZoomScaleForSize(view.bounds.size)
        updateConstraintsForSize(view.bounds.size)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func backButtonClicked(sender: UIBarButtonItem) {
        self.dismissViewControllerAnimated(true, completion: nil)
        
    }
    
    private func updateMinZoomScaleForSize(size: CGSize) {
        let navigationBarHeight: CGFloat = 0.0//self.navigationController!.navigationBar.frame.height
        let statusBarHeight: CGFloat = 0.0//UIApplication.sharedApplication().statusBarFrame.height
        let toolbarHeight: CGFloat = toolbar.frame.height
        let uiComponentsHeight = navigationBarHeight + statusBarHeight + toolbarHeight
        let borderAdjustedHeight = uiComponentsHeight + (IMAGE_BORDER_SPACE * 2)
        
        let widthScale = size.width / (imageView.image?.size.width)!
        let heightScale = (size.height - borderAdjustedHeight) / (imageView.image?.size.height)!
        let minScale = min(widthScale , heightScale)
        
        scrollView.minimumZoomScale = minScale
        scrollView.maximumZoomScale = MAX_ZOOM_SCALE
        
        scrollView.zoomScale = minScale
    }
    
    
    private func updateConstraintsForSize(size: CGSize) {
        
        let yOffset: CGFloat = IMAGE_BORDER_SPACE
        imageViewTopConstraint.constant = yOffset
        imageViewBottomConstraint.constant = yOffset
        
        let xOffset = max(0, (size.width - imageView.frame.width) / 2)
        imageViewLeadingConstraint.constant = xOffset
        imageViewTrailingConstraint.constant = xOffset
        
        view.layoutIfNeeded()
    }

    
    @IBAction func floorSelected(sender: UISegmentedControl) {
        switch sender.selectedSegmentIndex {
        case 0:
            // First floor clicked
            imageView.image = UIImage(named: "Floor1")
        case 1:
            // Second floor clicked
            imageView.image = UIImage(named: "Floor2")
        default: break
            // Do nothing
        }
        updateMinZoomScaleForSize(view.bounds.size)
        updateConstraintsForSize(view.bounds.size)
    }
    

    /*
    // MARK: - Navigation

    
    }
    */

}

extension MapViewController: UIScrollViewDelegate {
    
    func viewForZoomingInScrollView(scrollView: UIScrollView) -> UIView? {
        return imageView
    }
    
    func scrollViewDidZoom(scrollView: UIScrollView) {
        updateConstraintsForSize(view.bounds.size)
    }
    
}