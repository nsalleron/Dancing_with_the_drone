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
@property (readwrite, nonatomic) Boolean homeActivate;
@property (nonatomic, strong) ARService *service;







@property (strong, nonatomic) CMMotionManager *motionManager;

@property (nonatomic) dispatch_semaphore_t stateSem;
@property (atomic, strong) NSMutableArray *arrayFloat;
@property (nonatomic) bool bExterieur;
@property (readonly, nonatomic) double incX;
@property (readonly, nonatomic) double incY;
@property (readonly, nonatomic) double incZ;
@property (readonly, nonatomic) int incStabX;
@property (readonly, nonatomic) int incStabY;
@property (readonly, nonatomic) int incStabZ;
@property (readonly, nonatomic) double absX;
@property (readonly, nonatomic) double absY;
@property (readonly, nonatomic) double absZ;
@property (readonly, nonatomic) bool stabX;
@property (readonly, nonatomic) bool stabY;
@property (readonly, nonatomic) bool stabZ;
@property (readonly, nonatomic) int lastMoveX;
@property (readonly, nonatomic) int lastMoveY;
@property (readonly, nonatomic) int lastMoveZ;


/*  0 = STABLE
 1 = LEFT
 2 = RIGHT
 3 = UP
 4 = DOWN
 5 = FOWARD
 6 = BACKWARD
 */
@property (readonly, nonatomic) int MOUVEMENT;



@end
