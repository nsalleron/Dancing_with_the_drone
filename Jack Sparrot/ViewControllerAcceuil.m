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

#import "BebopDrone.h"
#import "DroneDiscoverer.h"
#import <libARDiscovery/ARDiscovery.h>


@interface ViewControllerAccueil()<DroneDiscovererDelegate,BebopDroneDelegate>
@property (nonatomic, strong) UIAlertView *connectionAlertView;
@property (nonatomic, strong) UIAlertController *downloadAlertController;
@property (nonatomic, strong) UIProgressView *downloadProgressView;
@property (nonatomic, strong) BebopDrone *bebopDrone;
@property (nonatomic) dispatch_semaphore_t stateSem;

@property (nonatomic, strong) NSArray *dataSource;

@property (nonatomic, strong) DroneDiscoverer *droneDiscoverer;
@property (nonatomic, strong) ARService *selectedService;

@end

ViewEcranAccueil *ecranAccueil;


@implementation ViewControllerAccueil

- (void)viewDidLoad {
    
    [super viewDidLoad];
    _connectionAlertView = [[UIAlertView alloc] initWithTitle:[_service name] message:@"Connecting ..."
                                                     delegate:self cancelButtonTitle:nil otherButtonTitles:nil, nil];
    
    
    
    
    
    
    
    
    
    
    
    
    _dataSource = [NSArray array];
    _droneDiscoverer = [[DroneDiscoverer alloc] init];
    [_droneDiscoverer setDelegate:self];
    
    _bebopDrone = [[BebopDrone alloc] initWithService:_service];
    [_bebopDrone setDelegate:self];
    
    
    // Do any additional setup after loading the view, typically from a nib.
    ecranAccueil = [[ViewEcranAccueil alloc ] initWithFrame:[[UIScreen mainScreen] bounds]];
    [ecranAccueil setBackgroundColor:[UIColor colorWithRed:250.0/255 green:246.0/255 blue:244.0/255 alpha:1.0]];
        //[[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent];
    [self setView: ecranAccueil];
    [self setTitle:@"Accueil"];
    
}

- (void)viewDidAppear:(BOOL)animated {
    [self registerNotifications];
    [_droneDiscoverer startDiscovering];
    
    
    if ([_bebopDrone connectionState] != ARCONTROLLER_DEVICE_STATE_RUNNING) {
       // [_connectionAlertView show];
    }

    
}


- (void) viewDidDisappear:(BOOL)animated
{
    [self unregisterNotifications];
    [_droneDiscoverer stopDiscovering];
    
    if (_connectionAlertView && !_connectionAlertView.isHidden) {
        [_connectionAlertView dismissWithClickedButtonIndex:0 animated:NO];
    }
    _connectionAlertView = [[UIAlertView alloc] initWithTitle:[_service name] message:@"Disconnecting ..."
                                                     delegate:self cancelButtonTitle:nil otherButtonTitles:nil, nil];
    /*[_connectionAlertView show];
    
    // in background, disconnect from the drone
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        [_bebopDrone disconnect];
        // wait for the disconnection to appear
        dispatch_semaphore_wait(_stateSem, DISPATCH_TIME_FOREVER);
        _bebopDrone = nil;
        
        // dismiss the alert view in main thread
        dispatch_async(dispatch_get_main_queue(), ^{
            [_connectionAlertView dismissWithClickedButtonIndex:0 animated:YES];
        });
    });*/
}

- (void) connectionToDrone{
    _stateSem = dispatch_semaphore_create(0);
    [_bebopDrone connect];
   
    
}

#pragma mark DroneDiscovererDelegate
- (void)droneDiscoverer:(DroneDiscoverer *)droneDiscoverer didUpdateDronesList:(NSArray *)dronesList {
    _dataSource = dronesList;
    
    if([_dataSource count] !=0){
        _selectedService = [_dataSource objectAtIndex:0];
        
        [self setService:_selectedService];
        [self connectionToDrone];
        [_connectionAlertView dismissWithClickedButtonIndex:0 animated:YES];
    }
   
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


#pragma mark BebopDroneDelegate
-(void)bebopDrone:(BebopDrone *)bebopDrone connectionDidChange:(eARCONTROLLER_DEVICE_STATE)state {
    NSLog(@"->connectionDidChange");
    switch (state) {
        case ARCONTROLLER_DEVICE_STATE_RUNNING:
            [_connectionAlertView dismissWithClickedButtonIndex:0 animated:YES];
            break;
        case ARCONTROLLER_DEVICE_STATE_STOPPED:
            dispatch_semaphore_signal(_stateSem);
            
            // Go back
            //[self.navigationController popViewControllerAnimated:YES];
            
            break;
            
        default:
            break;
    }
}

- (void)bebopDrone:(BebopDrone*)bebopDrone batteryDidChange:(int)batteryPercentage {
   
    NSLog(@"PAssage Batt");
    [ecranAccueil setBattery:[NSString stringWithFormat:@"%d%%", batteryPercentage]];
    
    
}

- (void)bebopDrone:(BebopDrone*)bebopDrone flyingStateDidChange:(eARCOMMANDS_ARDRONE3_PILOTINGSTATE_FLYINGSTATECHANGED_STATE)state {
    switch (state) {
        case ARCOMMANDS_ARDRONE3_PILOTINGSTATE_FLYINGSTATECHANGED_STATE_LANDED:
            //[_takeOffLandBt setTitle:@"Take off" forState:UIControlStateNormal];
            //[_takeOffLandBt setEnabled:YES];
            //[_downloadMediasBt setEnabled:YES];
            break;
        case ARCOMMANDS_ARDRONE3_PILOTINGSTATE_FLYINGSTATECHANGED_STATE_FLYING:
        case ARCOMMANDS_ARDRONE3_PILOTINGSTATE_FLYINGSTATECHANGED_STATE_HOVERING:
            //[_takeOffLandBt setTitle:@"Land" forState:UIControlStateNormal];
            //[_takeOffLandBt setEnabled:YES];
            //[_downloadMediasBt setEnabled:NO];
            break;
       // default:
           // [_takeOffLandBt setEnabled:NO];
            //[_downloadMediasBt setEnabled:NO];
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

    ViewControllerManuel *secondController = [[ViewControllerManuel alloc] init];
    [self.navigationController pushViewController:secondController animated:YES];
}

-(void) goToDroneOptions:(UIButton*)send{
    ViewControllerOptions *secondController = [[ViewControllerOptions alloc] init];
    [self.navigationController pushViewController:secondController animated:YES];
}


@end
