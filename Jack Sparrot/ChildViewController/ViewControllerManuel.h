//
//  ChildViewController.h
//  Jack Sparrot
//
//  Created by Nicolas Salleron on 07/02/2017.
//
//

#import <UIKit/UIKit.h>
#import <CoreMotion/CoreMotion.h>
#import <libARDiscovery/ARDISCOVERY_BonjourDiscovery.h>

@interface ViewControllerManuel : UIViewController

- (void) goToDimensionChoice:(UILongPressGestureRecognizer*)gesture;
- (void) changeSatio:(UIButton*)send;
- (void) homeFunction:(UILongPressGestureRecognizer*)gesture;
- (void) changeDecoAttr:(UILongPressGestureRecognizer*)gesture;
- (void) quitView:(UILongPressGestureRecognizer*)gesture;
- (void) changeAxe:(UIButton*)send;
- (void) finCommande;

@property (assign, nonatomic) NSInteger index;
@property (readwrite, nonatomic) Boolean enVol;
@property (readwrite, nonatomic) Boolean enStatio;
@property (readwrite, nonatomic) Boolean axeX;

@property (nonatomic, strong) ARService *service;

@property (strong, nonatomic) CMMotionManager *motionManager;


@end
