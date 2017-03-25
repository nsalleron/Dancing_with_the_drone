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


@interface ViewControllerAccueil()<BebopDroneDelegate,DroneDiscovererDelegate>
@property (nonatomic, strong) UIAlertView *connectionAlertView;
@property (nonatomic, strong) BebopDrone *bebopDrone;
@property (nonatomic, strong) NSArray *dataSource;
@property (nonatomic, strong) DroneDiscoverer *droneDiscoverer;
@property (nonatomic) dispatch_semaphore_t stateSem;

@end

ViewEcranAccueil *ecranAccueil;
boolean droneViewActif;
ViewControllerManuel *controllerDrone;

@implementation ViewControllerAccueil

- (void)viewDidLoad {
    
    [super viewDidLoad];

    if(_bebopDrone == nil) {
        _dataSource = [NSArray array];
        _droneDiscoverer = [[DroneDiscoverer alloc] init];
        [_droneDiscoverer setDelegate:self];
    }
   
    ecranAccueil = [[ViewEcranAccueil alloc ] initWithFrame:[[UIScreen mainScreen] bounds]];
    [ecranAccueil setBackgroundColor:[UIColor colorWithRed:250.0/255 green:246.0/255 blue:244.0/255 alpha:1.0]];
    [self setView: ecranAccueil];
    [self setTitle:@"Accueil"];
    
}

- (void)viewDidAppear:(BOOL)animated {
    
    if(_bebopDrone == nil) {
        NSLog(@"DRONE = NULL");
        //_dataSource = [NSArray array];
        //_droneDiscoverer = [[DroneDiscoverer alloc] init];
        
        [self registerNotifications];
        [_droneDiscoverer startDiscovering];
   
        if ([_bebopDrone connectionState] != ARCONTROLLER_DEVICE_STATE_RUNNING) {
            NSLog(@"NULL SHOW");
            [_connectionAlertView show];
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
        
        _connectionAlertView = [[UIAlertView alloc] initWithTitle:[_service name] message:@"Connexion ..."
                                                         delegate:self cancelButtonTitle:@"Annulation" otherButtonTitles:nil, nil];
        if ([_bebopDrone connectionState] != ARCONTROLLER_DEVICE_STATE_RUNNING) {
            NSLog(@"CONNEXION SHOW");
            [_connectionAlertView show];
        }
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

- (void) viewDidDisappear:(BOOL)animated
{

}

- (void) deconnexionDrone{
    
    if(_service != nil){
        if (_connectionAlertView && !_connectionAlertView.isHidden) {
            [_connectionAlertView dismissWithClickedButtonIndex:0 animated:NO];
        }
        _connectionAlertView = [[UIAlertView alloc] initWithTitle:[_service name] message:@"Disconnecting ..."
                                                         delegate:self cancelButtonTitle:nil otherButtonTitles:nil, nil];
        [_connectionAlertView show];
        NSLog(@"DECONNEXION SHOW");
        
        // in background, disconnect from the drone
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
            [_bebopDrone disconnect];
            // wait for the disconnection to appear
            dispatch_semaphore_wait(_stateSem, DISPATCH_TIME_FOREVER);
            _bebopDrone = nil;
        
            // dismiss the alert view in main thread
            dispatch_async(dispatch_get_main_queue(), ^{
                NSLog(@"FIN CONNEXION ALERT VIEW");
                [_connectionAlertView dismissWithClickedButtonIndex:0 animated:YES];
                if(droneViewActif){
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
    
    
    NSLog(@"CHANGEMENT ETAT");
    switch (state) {
        case ARCONTROLLER_DEVICE_STATE_RUNNING:
            NSLog(@"STATE RUNNING");
            
            [_connectionAlertView dismissWithClickedButtonIndex:0 animated:YES];
            
            break;
        case ARCONTROLLER_DEVICE_STATE_STOPPED:
            NSLog(@"STATE STOPPED");
            dispatch_semaphore_signal(_stateSem);
            break;
            
        default:
            [_connectionAlertView dismissWithClickedButtonIndex:0 animated:YES];
            break;
    }
}

- (void)bebopDrone:(BebopDrone*)bebopDrone batteryDidChange:(int)batteryPercentage {
    [ecranAccueil setBattery:[NSString stringWithFormat:@"Drone %d%%", batteryPercentage]];
   
}

- (void)bebopDrone:(BebopDrone*)bebopDrone flyingStateDidChange:(eARCOMMANDS_ARDRONE3_PILOTINGSTATE_FLYINGSTATECHANGED_STATE)state {
    switch (state) {
        case ARCOMMANDS_ARDRONE3_PILOTINGSTATE_FLYINGSTATECHANGED_STATE_LANDED:
            NSLog(@"Take Off");
            break;
        case ARCOMMANDS_ARDRONE3_PILOTINGSTATE_FLYINGSTATECHANGED_STATE_FLYING:
            
            [controllerDrone finCommande];
            break;
        case ARCOMMANDS_ARDRONE3_PILOTINGSTATE_FLYINGSTATECHANGED_STATE_HOVERING:
            NSLog(@"Land");
            break;
        default:
            NSLog(@"Default");
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
