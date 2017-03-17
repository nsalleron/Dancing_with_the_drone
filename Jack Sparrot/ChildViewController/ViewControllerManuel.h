//
//  ChildViewController.h
//  Jack Sparrot
//
//  Created by Nicolas Salleron on 07/02/2017.
//
//

#import <UIKit/UIKit.h>
#import <CoreMotion/CoreMotion.h>
#import "ViewDimensionViewController.h"
#import "BebopDrone.h"

@interface ViewControllerManuel : UIViewController <ViewDimensionViewControllerDelegate,UIAccelerometerDelegate>

- (void) goToDimensionChoice:(UILongPressGestureRecognizer*)gesture;
- (void) changeSatio:(UIButton*)send;
- (void) homeFunction:(UILongPressGestureRecognizer*)gesture;
- (void) changeDecoAttr:(UILongPressGestureRecognizer*)gesture;
- (void) quitView:(UILongPressGestureRecognizer*)gesture;
- (void) changeAxe:(UIButton*)send;
- (void) setDrone:(BebopDrone *) drone;

@property (assign, nonatomic) NSInteger index;
@property (readwrite, nonatomic) Boolean enVol;
@property (readwrite, nonatomic) Boolean enStatio;
@property (readwrite, nonatomic) Boolean axeX;


@property (readwrite, nonatomic) double currentMaxAccelX;
@property (readwrite, nonatomic) double currentMaxAccelY;
@property (readwrite, nonatomic) double currentMaxAccelZ;
@property (readwrite, nonatomic) double currentMaxRotX;
@property (readwrite, nonatomic) double currentMaxRotY;
@property (readwrite, nonatomic) double currentMaxRotZ;

@property (strong, nonatomic) CMMotionManager *motionManager;


@end
