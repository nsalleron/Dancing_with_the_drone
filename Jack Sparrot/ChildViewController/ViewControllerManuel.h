//
//  ChildViewController.h
//  Jack Sparrot
//
//  Created by Nicolas Salleron on 07/02/2017.
//
//

#import <UIKit/UIKit.h>
#import "ViewDimensionViewController.h"

@interface ViewControllerManuel : UIViewController <ViewDimensionViewControllerDelegate>

-(void) goToDimensionChoice:(UIButton*)send;

@property (assign, nonatomic) NSInteger index;

@end
