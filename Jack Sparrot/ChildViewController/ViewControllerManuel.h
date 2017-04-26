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
/// \brief Cette classe est le view controller de l'écran ViewManuel.h
/// \code
/// Cette classe est également un handler des commandes du drone suivant l'acceleration
/// C'est elle qui se charge d'interpréter les commandes et de transmettre au drone les différentes instructions
/// Elle possède également un timer qui se charge de vérifier la batterie toute les dix secondes. 
/// \endcode
///
@interface ViewControllerManuel : UIViewController



@property (assign, nonatomic) NSInteger index;
@property (readwrite, nonatomic) Boolean enVol;
@property (readwrite, nonatomic) Boolean enStatio;
@property (readwrite, nonatomic) Boolean axeX;
@property (readwrite, nonatomic) Boolean homeActivate;
@property (nonatomic) int *batteryDrone;
@property (nonatomic, strong) ARService *service;
@property (nonatomic) int *batteryDroneManuel;
@property (strong, nonatomic) CMMotionManager *motionManager;
@property (nonatomic) dispatch_semaphore_t stateSem;
@property (atomic, strong) NSMutableArray *arrayFloat;
@property (nonatomic) bool bInterieurManuel;
@property (readonly, nonatomic) int lastMoveX;
@property (readonly, nonatomic) int lastMoveY;
@property (readonly, nonatomic) int lastMoveZ;
@property (readonly, nonatomic) double absX;
@property (readonly, nonatomic) double absY;
@property (readonly, nonatomic) double absZ;
@property (readonly, nonatomic) bool stabX;
@property (readonly, nonatomic) bool stabY;
@property (readonly, nonatomic) bool stabZ;
@property (readonly, nonatomic) double incX;
@property (readonly, nonatomic) double incY;
@property (readonly, nonatomic) double incZ;
@property (readonly, nonatomic) int iStabX;
@property (readonly, nonatomic) int iStabY;
@property (readonly, nonatomic) int iStabZ;
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
/**
 * @brief Méthode pour la surveillance de la batterie du terminal et du drone
 */
- (void) checkBattery;

/**
 * @brief interprétation des mouvements via CoreMotion
 * @param motion Object CMDeviceMotion possédant les données CoreMotion
 */
- (void) mouvementDeviceMotion:(CMDeviceMotion *)motion;
/**
 * @brief Deconnexion propre du drone
 */
- (void) deconnexionDrone;
/**
 * @brief gestion du swipe DOWN
 */
-(void)swipeDown:(UISwipeGestureRecognizer*)gestureRecognizer;

/**
 * @brief gestion du swipe UP
 */
-(void)swipeUp:(UISwipeGestureRecognizer*)gestureRecognizer;
@end
