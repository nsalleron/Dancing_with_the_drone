//
//  ViewController.m
//  Jack Sparrot
//
//  Created by Nicolas Salleron on 31/01/2017.
//
//

#import "ViewControllerAcceuil.h"
#import "ViewControllerManuel.h"
#import "ViewDimensionViewController.h"
#import "ViewEcranAccueil.h"
#import "ViewControllerOptions.h"
#import "ViewControllerAide.h"
#import "BebopDrone.h"
#import "BebopVideoView.h"
#import "DroneDiscoverer.h"
#import <libARDiscovery/ARDiscovery.h>
#import <AVFoundation/AVFoundation.h>
#import <AVKit/AVKit.h>
#import <WatchConnectivity/WatchConnectivity.h>


@interface ViewControllerAccueil()<BebopDroneDelegate,DroneDiscovererDelegate,WCSessionDelegate>

@property (nonatomic, strong) BebopDrone *bebopDrone;
@property (nonatomic, strong) NSArray *dataSource;
@property (nonatomic, strong) DroneDiscoverer *droneDiscoverer;
@property (nonatomic) dispatch_semaphore_t stateSem;
@property (nonatomic, strong) WCSession* session;
@property (atomic, strong) NSDate *dateOldCommand;
@property (nonatomic) bool bExterieur;
@property (readwrite, nonatomic) Boolean homeActivate;

@end

ViewEcranAccueil *ecranAccueil;
boolean droneViewActif;
ViewControllerManuel *controllerDrone;

@implementation ViewControllerAccueil

- (void)viewDidLoad {
    
    [super viewDidLoad];
    
    NSLog(@"ACCUEIL ACCUEIL");
    
    ecranAccueil = [[ViewEcranAccueil alloc ] initWithFrame:[[UIScreen mainScreen] bounds]];
    [ecranAccueil setBackgroundColor:[UIColor colorWithRed:250.0/255 green:246.0/255 blue:244.0/255 alpha:1.0]];
    [self setView: ecranAccueil];
    [self setTitle:@"Accueil"];
    
    _bExterieur = ![[NSUserDefaults standardUserDefaults] objectForKey:@"InOut"];
    
    if ([WCSession isSupported]) {
        _session = [WCSession defaultSession];
        _session.delegate = self;
        [_session activateSession];
    }
    
}

/*!
 *  Il faut absoluement arrêter le drone quand la session est sur le point d'être désactivée.
 *
 */
- (void) sessionDidBecomeInactive:(WCSession *)session{
    [_bebopDrone setFlag:0];
    [_bebopDrone setPitch:0];
    [_bebopDrone setRoll:0];
    [_bebopDrone setGaz:0];
    [_bebopDrone setYaw:0];
}




//A FAIRE INTERPRETATION DES DONN2ES

- (void) session:(WCSession *)session didReceiveMessage:(NSDictionary<NSString *,id> *)message replyHandler:(void (^)(NSDictionary<NSString *,id> * _Nonnull))replyHandler{
    NSArray * ArrayCommand = [[NSArray alloc] init];
    NSLog(@"MESSAGE : %@",[message objectForKey:@"CMD"]);
    NSString * string = [message objectForKey:@"CMD"];
    [[ecranAccueil btnDrone] setTitle:string forState:UIControlStateNormal];
    
    ArrayCommand = [string componentsSeparatedByString:@";"];
    
    
    [[ecranAccueil btnAide] setTitle:[ArrayCommand objectAtIndex:0] forState:UIControlStateNormal];
    [[ecranAccueil btnDrone] setTitle:[ArrayCommand objectAtIndex:1] forState:UIControlStateNormal];
    
    
    NSString *axe = [ArrayCommand objectAtIndex:0];
    NSString *valeur;
    if([ArrayCommand count]>1){
        valeur = [ArrayCommand objectAtIndex:1];
    }
    
    
    _dateOldCommand = [NSDate date];
    
    if ([axe isEqualToString:@"X"]) {
        [_bebopDrone setPitch:[valeur intValue]];
    }else if([axe isEqualToString:@"Y"]){
        [_bebopDrone setRoll:[valeur intValue]];
    }else if([axe isEqualToString:@"Z"]){
        // in background, gaz the drone
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
            [_bebopDrone setGaz:[valeur intValue]];
            NSLog(@"GAZ UP");
            [NSThread sleepForTimeInterval:0.5f];
            NSLog(@"GAZ DOWN");
            [_bebopDrone setGaz:0];
        });
    }else if([axe isEqualToString:@"D"]){
        [_bebopDrone takeOff];
    }else if([axe isEqualToString:@"A"]){
        [_bebopDrone land];
    }else if([axe isEqualToString:@"H"]){
        if(_homeActivate == false){
            _homeActivate = true;
            [_bebopDrone setViewCall:self];
            if(_bExterieur){
                [_bebopDrone returnHomeExterieur];
            }else{
                [_bebopDrone returnHomeInterieur];
            }
        }else{
            [_bebopDrone cancelReturnHome];
        }
    }

    //replyHandler = [[NSDictionary alloc] initWithObjectsAndKeys:@"DONE",@"reply", nil];
    
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        [NSThread sleepForTimeInterval:1.0f];
        if([[NSDate date] timeIntervalSinceDate:_dateOldCommand] > 1.0){
            [_bebopDrone setFlag:0];
            [_bebopDrone setPitch:0];
            [_bebopDrone setRoll:0];
            [_bebopDrone setGaz:0];
            [_bebopDrone setYaw:0];
        }
    });
    
}

- (void)viewDidAppear:(BOOL)animated {
    
    NSLog(@"VIEW DID APPEAR ACCUEIL");
    
    if(_bebopDrone == nil) {
        NSLog(@"DRONE = NULL ACCUEIL");
        _dataSource = [NSArray array];
        _droneDiscoverer = [[DroneDiscoverer alloc] init];
        [_droneDiscoverer setDelegate:self];
        
        [self registerNotifications];
        [_droneDiscoverer startDiscovering];
        
        if ([_bebopDrone connectionState] != ARCONTROLLER_DEVICE_STATE_RUNNING) {
            NSLog(@"NULL SHOW ACCUEIL");
        }
    }
    
    
}

#pragma mark DroneDiscovererDelegate
- (void)droneDiscoverer:(DroneDiscoverer *)droneDiscoverer didUpdateDronesList:(NSArray *)dronesList {
    _dataSource = dronesList;
    
    if(_dataSource.count != 0 ){
        _service = [_dataSource objectAtIndex:0];
        
        _stateSem = dispatch_semaphore_create(0);
        
        _bebopDrone = [[BebopDrone alloc] initWithService:_service];
        [_bebopDrone setDelegate:self];
        [_bebopDrone connect];
        
    }
    
}

- (BOOL)bebopDrone:(BebopDrone*)bebopDrone configureDecoder:(ARCONTROLLER_Stream_Codec_t)codec {
    return NO;
}

- (BOOL)bebopDrone:(BebopDrone*)bebopDrone didReceiveFrame:(ARCONTROLLER_Frame_t*)frame {
    return NO;
}

#pragma mark notification registration
- (void)registerNotifications {
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(enteredBackground:) name: UIApplicationDidEnterBackgroundNotification object: nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(enterForeground:) name: UIApplicationWillEnterForegroundNotification object: nil];
}

- (void)unregisterNotifications {
    [[NSNotificationCenter defaultCenter] removeObserver:self name: UIApplicationDidEnterBackgroundNotification object: nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name: UIApplicationWillEnterForegroundNotification object: nil];
}

#pragma mark - application notifications
- (void)enterForeground:(NSNotification*)notification {
    [_droneDiscoverer startDiscovering];
}

- (void)enteredBackground:(NSNotification*)notification {
    [_droneDiscoverer stopDiscovering];
}

- (void) viewDidDisappear:(BOOL)animated {
    
}

- (void) deconnexionDrone{
    
    if(_service != nil){
        NSLog(@"DECONNEXION SHOW ACCUEIL");
        
        // in background, disconnect from the drone
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
            [_bebopDrone disconnect];
            // wait for the disconnection to appear
            dispatch_semaphore_wait(_stateSem, DISPATCH_TIME_FOREVER);
            _bebopDrone = nil;
            
            // dismiss the alert view in main thread
            dispatch_async(dispatch_get_main_queue(), ^{
                NSLog(@"FIN CONNEXION ALERT VIEW ACCUEIL");
                if(droneViewActif){
                    _service = nil;
                    _bebopDrone = nil;
                    controllerDrone = [[ViewControllerManuel alloc] init];
                    [self.navigationController pushViewController:controllerDrone animated:YES];
                    
                }
            });
        });
    }else{
        controllerDrone = [[ViewControllerManuel alloc] init];
        [self.navigationController pushViewController:controllerDrone animated:YES];
    }
    
}


-(void)bebopDrone:(BebopDrone *)bebopDrone connectionDidChange:(eARCONTROLLER_DEVICE_STATE)state {
    
    
    NSLog(@"CHANGEMENT ETAT ACCUEIL");
    switch (state) {
        case ARCONTROLLER_DEVICE_STATE_RUNNING:
            NSLog(@"STATE RUNNING ACCUEIL");
            
            break;
        case ARCONTROLLER_DEVICE_STATE_STOPPED:
            NSLog(@"STATE STOPPEDACCUEIL");
            dispatch_semaphore_signal(_stateSem);
            break;
            
        default:
            
            break;
    }
}

- (void)bebopDrone:(BebopDrone*)bebopDrone batteryDidChange:(int)batteryPercentage {
    [ecranAccueil setBattery:[NSString stringWithFormat:@"Drone %d%%", batteryPercentage]];
    
}

- (void)bebopDrone:(BebopDrone*)bebopDrone flyingStateDidChange:(eARCOMMANDS_ARDRONE3_PILOTINGSTATE_FLYINGSTATECHANGED_STATE)state {
    switch (state) {
        case ARCOMMANDS_ARDRONE3_PILOTINGSTATE_FLYINGSTATECHANGED_STATE_LANDED:
            NSLog(@"Take Off ACCUEIL");
            break;
        case ARCOMMANDS_ARDRONE3_PILOTINGSTATE_FLYINGSTATECHANGED_STATE_FLYING:
            
            [controllerDrone finCommande];
            break;
        case ARCOMMANDS_ARDRONE3_PILOTINGSTATE_FLYINGSTATECHANGED_STATE_HOVERING:
            NSLog(@"Land ACCUEIL");
            break;
        default:
            NSLog(@"Default ACCUEIL");
            break;
    }
}


//ROTATION

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

- (BOOL)shouldAutorotate  // iOS 6 autorotation fix
{
    return YES;
}

- (UIInterfaceOrientationMask)supportedInterfaceOrientations // iOS 6 autorotation fix
{
    
    return UIInterfaceOrientationMaskAll;
}

- (UIInterfaceOrientation)preferredInterfaceOrientationForPresentation // iOS 6 autorotation fix
{
    return UIInterfaceOrientationPortrait;
}


- (BOOL)prefersStatusBarHidden {
    return YES;
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
-(UIStatusBarStyle)preferredStatusBarStyle {
    return UIStatusBarStyleDefault;
}

-(void)viewWillTransitionToSize:(CGSize)size withTransitionCoordinator:(id<UIViewControllerTransitionCoordinator>)coordinator{
    
    [ecranAccueil updateView:size];
}

- (void)viewWillAppear:(BOOL)animated {
    [self.navigationController setNavigationBarHidden:YES animated:animated];
    [super viewWillAppear:animated];
}

-(void) goToDroneControl:(UIButton*)send{
    droneViewActif = true;
    [self unregisterNotifications];
    [_droneDiscoverer stopDiscovering];
    [self deconnexionDrone];
    
    
}

-(void) goToDroneOptions:(UIButton*)send{
    
    ViewControllerOptions *secondController = [[ViewControllerOptions alloc] init];
    [self.navigationController pushViewController:secondController animated:YES];
    
}

-(void) goToDroneHelp:(UIButton*)send{
    
    ViewControllerOptions *secondController = [[ViewControllerAide alloc] init];
    [self.navigationController pushViewController:secondController animated:YES];
}

@end
