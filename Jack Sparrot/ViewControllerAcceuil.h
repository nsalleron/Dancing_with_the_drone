//
//  ViewController.h
//  Jack Sparrot
//
//  Created by Nicolas Salleron on 31/01/2017.
//
//

#import <UIKit/UIKit.h>
#import <libARDiscovery/ARDISCOVERY_BonjourDiscovery.h>
#import "BebopDrone.h"
//#import "BebopVideoView.h"
#import "DroneDiscoverer.h"
#import <WatchConnectivity/WatchConnectivity.h>
/// \brief Cette classe est le view controller de l'écran d'accueil
/// \code
/// Cette classe est également un handler des commandes de la montre.
/// C'est elle qui se charge d'interpréter et de transmettre les commandes reçu par la montre au drone.
/// Elle se charge également de récupérer la batterie du drone afin de mettre à jour l'interface de l'utilisateur.
/// \endcode
///
@interface ViewControllerAccueil : UIViewController

@property (assign, nonatomic) NSInteger index;
@property (nonatomic, strong) ARService *service;
@property (nonatomic) int *batteryDrone;
@property (nonatomic, strong) BebopDrone *bebopDrone;
@property (nonatomic, strong) NSArray *dataSource;
@property (nonatomic, strong) DroneDiscoverer *droneDiscoverer;
@property (nonatomic) dispatch_semaphore_t stateSem;
@property (nonatomic, strong) WCSession* session;
@property (atomic, strong) NSDate *dateOldCommand;
@property (nonatomic) bool bInterieurAccueil;
@property (nonatomic) bool bWatchActive;
@property (readwrite, nonatomic) Boolean homeActivate;

/**
 * @brief Ouverture de la fenêtre de contrôle du drone
 */
- (void) goToDroneControl:(UIButton*)send;
/**
 * @brief Ouverture de la fenêtre des options
 */
- (void) goToDroneOptions:(UIButton*)send;
/**
 * @brief Ouverture de la fenêtre d'aide
 */
- (void) goToDroneHelp:(UIButton*)send;
/**
 * @brief Verification du niveau de batterie pour prévenir l'utilisateur d'une batterie faible.
 */
- (void) checkBattery;
/**
 *  @brief Il faut absoluement arrêter le drone quand la session est sur le point d'être désactivée.
 */
- (void) sessionDidBecomeInactive:(WCSession *)session;
/**
 * @brief Interprétation des données de la montre quand elle est disponible.
 * Agit directement sur le drone avec un timer au cas ou la connexion n'est plus active.
 */
- (void) session:(WCSession *)session didReceiveMessage:(NSDictionary<NSString *,id> *)message replyHandler:(void (^)(NSDictionary<NSString *,id> * _Nonnull))replyHandler;
/**
 * @brief Deconnexion propre du drone
 */
- (void) deconnexionDrone;
@end

