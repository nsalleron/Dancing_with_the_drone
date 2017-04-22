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
#import "BebopVideoView.h"
#import "DroneDiscoverer.h"
#import <WatchConnectivity/WatchConnectivity.h>

@interface ViewControllerAccueil : UIViewController

@property (readonly,nonatomic,retain) UIButton *btnDrone;
@property (readonly,nonatomic,retain) UIButton *btnOptions;
@property (readonly,nonatomic,retain) UIButton *btnAide;
@property (assign, nonatomic) NSInteger index;
@property (nonatomic, strong) ARService *service;
@property (nonatomic) int *batteryDrone;
@property (nonatomic, strong) BebopDrone *bebopDrone;
@property (nonatomic, strong) NSArray *dataSource;
@property (nonatomic, strong) DroneDiscoverer *droneDiscoverer;
@property (nonatomic) dispatch_semaphore_t stateSem;
@property (nonatomic, strong) WCSession* session;
@property (atomic, strong) NSDate *dateOldCommand;
@property (nonatomic) bool bExterieur;
@property (readwrite, nonatomic) Boolean homeActivate;

/**
 * @brief push to DroneControl
 */
- (void) goToDroneControl:(UIButton*)send;
/**
 * @brief push to Options
 */
- (void) goToDroneOptions:(UIButton*)send;
/**
 * @brief push to Help
 */
- (void) goToDroneHelp:(UIButton*)send;
/**
 * @brief Check the level of the battery in order to prevent user from low battery
 */
- (void) checkBattery;
@end

