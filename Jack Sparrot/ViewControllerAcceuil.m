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
    
    NSLog(@"ACCUEIL ACCUEIL");
    
    ecranAccueil = [[ViewEcranAccueil alloc ] initWithFrame:[[UIScreen mainScreen] bounds]];
    [ecranAccueil setBackgroundColor:[UIColor colorWithRed:250.0/255 green:246.0/255 blue:244.0/255 alpha:1.0]];
    [self setView: ecranAccueil];
    [self setTitle:@"Accueil"];
    
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

- (void) viewDidDisappear:(BOOL)animated
{

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
