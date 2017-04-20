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



@property (assign, nonatomic) NSInteger index;
@property (readwrite, nonatomic) Boolean enVol;
@property (readwrite, nonatomic) Boolean enStatio;
@property (readwrite, nonatomic) Boolean axeX;
@property (readwrite, nonatomic) Boolean homeActivate;
@property (nonatomic, strong) ARService *service;
@property (nonatomic) int *batteryDroneManuel;
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
@property (readonly, nonatomic) int MOUVEMENT;

/**
 * @brief lancement de la view dimension
 */
- (void) goToDimensionChoice:(UILongPressGestureRecognizer*)gesture;
/**
 * @brief changement mode stationnaire ou non
 */
- (void) changeSatio:(UIButton*)send;
/**
 * @brief activation de la fonction home
 */
- (void) homeFunction:(UILongPressGestureRecognizer*)gesture;
/**
 * @brief changement mode decollage / Atterrissage
 */
- (void) changeDecoAttr:(UILongPressGestureRecognizer*)gesture;
/**
 * @brief sortir de la view
 */
- (void) quitView:(UILongPressGestureRecognizer*)gesture;
/**
 * @brief changer axe X/Y/Z
 */
- (void) changeAxe:(UIButton*)send;
/**
 * @brief fin commande du drone
 */
- (void) finCommande;



@end
