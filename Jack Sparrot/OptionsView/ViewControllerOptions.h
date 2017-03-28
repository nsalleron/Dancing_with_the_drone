//
//  ViewController.h
//  Jack Sparrot
//
//  Created by Gregoire Gasc on 07/03/2017.
//
//

#import <UIKit/UIKit.h>
#import "ViewDimensionViewController.h"
#import "ViewCouleurs.h"

@interface ViewControllerOptions : UIViewController <ViewCouleursControllerDelegate>

-(void) goToColorChoice:(UIButton*) send;

@end

