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

- (void) goToDimensionChoice:(UIButton*)send;
- (void) changeSatio:(UIButton*)send;
- (void) changeDecoAttr:(UILongPressGestureRecognizer*)gesture;
- (void) changeAxe:(UIButton*)send;

@property (assign, nonatomic) NSInteger index;
@property (readwrite, nonatomic) Boolean enVol;
@property (readwrite, nonatomic) Boolean enStatio;
@property (readwrite, nonatomic) Boolean axeX;
@end
