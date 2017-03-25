//
//  ChildViewController.m
//  Jack Sparrot
//
//  Created by Nicolas Salleron on 07/02/2017.
//
//

#import "ViewControllerManuel.h"
#import "ViewDimensionViewController.h"
#import "ViewManuel.h"
#import "BebopDrone.h"
#import "DroneDiscoverer.h"
#import <CoreMotion/CoreMotion.h>
#import <libARDiscovery/ARDiscovery.h>
@interface ViewControllerManuel ()<BebopDroneDelegate,DroneDiscovererDelegate,ViewDimensionViewControllerDelegate,UIAccelerometerDelegate>
@property (nonatomic, strong) UIAlertView *connectionAlertView;
@property (nonatomic, strong) BebopDrone *bebopDrone;
@property (nonatomic, strong) NSArray *dataSource;
@property (nonatomic, strong) DroneDiscoverer *droneDiscoverer;
@property (nonatomic) dispatch_semaphore_t stateSem;

@end


ViewManuel *ecran;
BOOL firstTime = TRUE;

double accX;
double accY;
double accZ;
double rotX;
double rotY;
double rotZ;

double xPlus;
double xMoins;
double xEgal;
boolean bFinMouvementX = false;
boolean firstTimeX = false;
int sample = 50;
double sampleX = 0;
double velocityX;
double positionX;

//  some behavior and view constants.
const static float GRAVITY_SCALE    = 9.81f;
const static float FRAME_RATE       = 60.0f;
const static float tiltSensitivity  = 0.02f;
const static float nearlyVertical   = 0.9;

@implementation ViewControllerManuel


- (void)viewDidLoad {
    [super viewDidLoad];
    
    /*DRONE*/
    if(_bebopDrone == nil) {
        _dataSource = [NSArray array];
        _droneDiscoverer = [[DroneDiscoverer alloc] init];
        [_droneDiscoverer setDelegate:self];
    }
    
    
    /* Acceleration + Gyroscope */
    _currentMaxAccelX = 0;
    _currentMaxAccelY = 0;
    _currentMaxAccelZ = 0;
    
    _currentMaxRotX = 0;
    _currentMaxRotY = 0;
    _currentMaxRotZ = 0;
    
    self.motionManager = [[CMMotionManager alloc] init];
    
    if(self.motionManager.isDeviceMotionAvailable){
        
        //self.motionManager.deviceMotionUpdateInterval = .1;
        self.motionManager.accelerometerUpdateInterval = 0.1;
        self.motionManager.gyroUpdateInterval = 0.5;
        [self.motionManager startGyroUpdatesToQueue:[NSOperationQueue currentQueue] withHandler:^(CMGyroData *gyroData, NSError *error) {
            dispatch_async(dispatch_get_main_queue(), ^{
                NSString *strYaw = [NSString stringWithFormat:@"Yaw: %.02f",gyroData.rotationRate.z];
                //[self.lblYaw setText:strYaw];
                //NSLog(strYaw);
                
                NSString *strPitch = [NSString stringWithFormat:@"Pitch: %.02f",gyroData.rotationRate.x];
                //[self.lblPitch setText:strPitch];
                //NSLog(strPitch);
                NSString *strRoll = [NSString stringWithFormat:@"Roll: %.02f",gyroData.rotationRate.y];
                //[self.lblRoll setText:strRoll];
                //NSLog(strRoll);
            });
            
        }];
        
        [self.motionManager startAccelerometerUpdatesToQueue:[NSOperationQueue currentQueue] withHandler:^(CMAccelerometerData *data, NSError *error){
            [self movement:data.acceleration];
            
            if (error) {
                NSLog(@"%@", error);
            }
        }];
        /*
        [self.motionManager startDeviceMotionUpdatesToQueue:[NSOperationQueue currentQueue]
                                                withHandler:^(CMDeviceMotion *deviceData, NSError *error){
                                                    [self outputDeviceMotionData:deviceData.userAcceleration];
                                                    
                                                    if (error) {
                                                        NSLog(@"%@", error);
                                                    }
                                                }];
        */
    }
    /* Fin acceleration */
    
    
    _enStatio = FALSE;
    _enVol = FALSE;
    _axeX = TRUE;
    
    ecran = [[ViewManuel alloc ] initWithFrame:[[UIScreen mainScreen] bounds]];
    [ecran setBackgroundColor:[UIColor colorWithRed:250.0/255 green:246.0/255 blue:244.0/255 alpha:1.0]];
    [ecran setViewController:self];
    [ecran updateBtnStatioDecoAttr:@"Décollage"];
    [ecran updateBtnDimensions:@"1D"];
    [ecran updateBtnChangementMode:@"Axe X"];
    [self setView: ecran];
    [self setTitle:@"Manuel"];
    
    

    //Swipe UP DOWN
    UISwipeGestureRecognizer * swipeUp=[[UISwipeGestureRecognizer alloc]initWithTarget:self action:@selector(swipeUp:)];
    swipeUp.direction=UISwipeGestureRecognizerDirectionUp;
    [self.view addGestureRecognizer:swipeUp];
    
    UISwipeGestureRecognizer * swipeDown=[[UISwipeGestureRecognizer alloc]initWithTarget:self action:@selector(swipeDown:)];
    swipeDown.direction=UISwipeGestureRecognizerDirectionDown;
    [self.view addGestureRecognizer:swipeDown];
    
    //Swipe Right et Left
    UISwipeGestureRecognizer * swipeRight=[[UISwipeGestureRecognizer alloc]initWithTarget:self action:@selector(changeAxe:)];
    swipeRight.direction=UISwipeGestureRecognizerDirectionRight;
    [self.view addGestureRecognizer:swipeRight];
    UISwipeGestureRecognizer * swipeLeft=[[UISwipeGestureRecognizer alloc]initWithTarget:self action:@selector(changeAxe:)];
    swipeRight.direction=UISwipeGestureRecognizerDirectionLeft;
    [self.view addGestureRecognizer:swipeLeft];
    
    [NSTimer scheduledTimerWithTimeInterval:0.1
                                     target:self
                                   selector:@selector(sendToDrone)
                                   userInfo:nil
                                    repeats:YES];
    

    
}

- (BOOL)prefersStatusBarHidden {
    return YES;
}

- (void) changeDecoAttr:(UILongPressGestureRecognizer*)gesture{
    NSString *statio = @"Mode Stationnaire : ON";
    switch (_enVol) {
        case TRUE:
            //Atterrissage;
            NSLog(@"Atterrissage");
            _enVol = FALSE;
            _enStatio = FALSE;
            [_bebopDrone land];
            
            statio = @"Mode Stationnaire : OFF";
            break;
            
        case FALSE:
            //Decollage;
            NSLog(@"Decollage");
            _enVol = TRUE;
            _enStatio = TRUE;
            [_bebopDrone takeOff];
           
        default:
            break;
    }
    [ecran updateBtnStatioDecoAttr:statio];

    
}

- (void) changeAxe:(UIButton*)gesture{
    NSString *axe = @"Axe X";
    switch (_axeX) {
        case TRUE:
            //Axe Y
            NSLog(@"Axe Y");
            axe = @"Axe Y";
            _axeX = FALSE;
            break;
            
        case FALSE:
            //Axe X
            NSLog(@"Axe X");
            _axeX = TRUE;
        default:
            break;
    }
    [ecran updateBtnChangementMode:axe];
       
}

- (void) changeSatio:(UIButton*)send{
    if(firstTime){
        [self changeDecoAttr:NULL];
        firstTime = FALSE;
        return;
    }
        
    NSString *statio = @"Mode Stationnaire : ON";
    switch (_enStatio) {
        case TRUE:
            //Mode non stationnaire;
            NSLog(@"Mode stationnaire : OFF");
            _enStatio = FALSE;
            statio = @"Mode Stationnaire : OFF";
            break;
            
        case FALSE:
            //Mode stationnaire;
            NSLog(@"Mode Stationnaire : ON");
             _enStatio  = TRUE;
        default:
            break;
    }
    [ecran updateBtnStatioDecoAttr:statio];
}

-(void) goToDimensionChoice:(UILongPressGestureRecognizer*)gesture{
    
    ViewDimensionViewController *secondController = [[ViewDimensionViewController alloc] init];
    secondController.delegate = self;
    [self.navigationController pushViewController:secondController animated:YES];
    
}


- (void) viewDidDisappear:(BOOL)animated{
}

/* Gestion des toucher long par le viewController */
- (void) quitView:(UILongPressGestureRecognizer*)gesture{

    [self unregisterNotifications];
    [_droneDiscoverer stopDiscovering];
    
    [self deconnexionDrone];
    
    if(_service == nil){
         [self.navigationController popViewControllerAnimated:YES];
    }
    
}


- (void) homeFunction:(UILongPressGestureRecognizer*)gesture{
    if ( gesture.state == UIGestureRecognizerStateBegan) {
        NSLog(@"Fonction Home activée!");
    }
}



-(void) changeStatio:(UIButton*)send{
    switch (_enStatio) {
        case TRUE:
            //Atterrissage;
            NSLog(@"Atterrissage");
            _enStatio = FALSE;
            break;
            
        case FALSE:
            //Decollage;
            NSLog(@"Decollage");
            _enStatio = TRUE;
        default:
            break;
    }
}


- (void)addItemViewController:(ViewDimensionViewController *)controller didFinishEnteringItem:(NSString *)item
{
    
    [ecran updateBtnDimensions:item];
    if([item  isEqual: @"1D"])
        [ecran updateView:[[UIScreen mainScreen] bounds].size];
    else
        [ecran update2D3D:[[UIScreen mainScreen] bounds].size];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)swipeUp:(UISwipeGestureRecognizer*)gestureRecognizer
{
    NSLog(@"Up");
}

-(void)swipeDown:(UISwipeGestureRecognizer*)gestureRecognizer
{
    NSLog(@"Down");
}

/* Rotation de l'écran */

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationLandscapeRight);
}
- (BOOL)shouldAutorotate{
    return YES;
}
- (UIInterfaceOrientationMask)supportedInterfaceOrientations // iOS 6 autorotation fix
{
    if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone) {
        return UIInterfaceOrientationMaskLandscapeRight;
    } else {
        return UIInterfaceOrientationMaskAll;
    }
}
- (UIInterfaceOrientation)preferredInterfaceOrientationForPresentation // iOS 6 autorotation fix
{
    return UIInterfaceOrientationLandscapeRight;
}
-(void)viewWillTransitionToSize:(CGSize)size withTransitionCoordinator:(id<UIViewControllerTransitionCoordinator>)coordinator{
    [ecran updateView:size];
}

/*
 *  @param acceleration : Acceleration en m/s^2 retourné par le téléphone.
 *
 */

-(void)movement:(CMAcceleration)data {
    //  get current frame location:
    float x = data.x;
    float y = data.y;
    float z = data.z;
    
    float newY = 0;
    float newX = 0;
    float newZ = 0;
    
    //left and right tilt
    if (ABS(x) >= tiltSensitivity) {
        newX = x * GRAVITY_SCALE;
    }
    
    //up and down tilt
    if (ABS(y) >= tiltSensitivity) {
        newY = y * -GRAVITY_SCALE;
    }
    
    if (ABS(z) >= tiltSensitivity) {
        newZ = (z * GRAVITY_SCALE) + GRAVITY_SCALE;
    }
    
    
    
    [ecran updateBtnDimensions:[[NSString alloc] initWithFormat:@" X : %.2f, Y : %.2f, Z : %.2f",newX,newY,newZ]];
    
        if(newX < -1){
            
            if(_bebopDrone != nil && _enVol && !_enStatio){
                [ecran updateBtnStatioDecoAttr:@"GAUCHE"];
                
                [_bebopDrone setFlag:1];
                [_bebopDrone setPitch:10];
                bFinMouvementX = false;
            }
            NSLog(@"GAUCHE \t %.2f",newX);
        }
        if(newX > 1 ){
            
            NSLog(@"DROITE \t %.2f",newX);
            if(_bebopDrone != nil && _enVol && !_enStatio){
                [ecran updateBtnStatioDecoAttr:@"DROITE"];
                [_bebopDrone setFlag:1];
                [_bebopDrone setPitch:-10];
                bFinMouvementX = false;
            }
        }
        
        
        if (newY > 1) {
            
            if(_bebopDrone != nil && _enVol && !_enStatio){
                [ecran updateBtnStatioDecoAttr:@"BAS"];
                [_bebopDrone setFlag:1];
                [_bebopDrone setRoll:-10];
                bFinMouvementX = false;
            }
            NSLog(@"BAS\t %.2f",newY);
        }
        if( newY < -1 ){
            if(_bebopDrone != nil && _enVol && !_enStatio){
                [ecran updateBtnStatioDecoAttr:@"HAUT"];
                [_bebopDrone setFlag:1];
                [_bebopDrone setRoll:10];
                bFinMouvementX = false;
            }
            NSLog(@"HAUT\t %.2f",newY);
        }
        
        if(-1 < newX  && newX < 1){
            if(_bebopDrone != nil && _enVol && !_enStatio){
                [ecran updateBtnStatioDecoAttr:@"X OK"];
                [_bebopDrone setFlag:1];
                [_bebopDrone setPitch:0];
                [_bebopDrone setRoll:0];
                bFinMouvementX = false;
            }
            
        }
}

/*

-(void) outputDeviceMotionData:(CMAcceleration) acceleration{
    
    
    double const kThreshold = 0.2 ;
    double const nbMouvement = 1;
    
    NSLog(@"Acceleration : %.2f",acceleration.x);
    
    if ([[[[ecran btnChangementMode] titleLabel]text] isEqualToString:@"Axe X"]) {
        
        if(acceleration.x < kThreshold * -1){ // x < -0.2
            _currentMaxAccelX = acceleration.x;
            xMoins++;
            //NSLog(@"%.2f",acceleration.x);
        }else if(acceleration.x > kThreshold){ // x > 0.2
            _currentMaxAccelX = acceleration.x;
            xPlus++;
            //NSLog(@"%.2f",acceleration.x);
        }else{
            _currentMaxAccelX = 0;
            //NSLog(@"FIN MOUVEMENT");
            xPlus = 0;
            xMoins = 0;
        }
        if(xPlus > nbMouvement){
            NSLog(@"DROITE");
            xPlus = 0; // ACTION
            bFinMouvementX = true;
            
        }else if(xMoins > nbMouvement){
            NSLog(@"GAUCHE");
            xMoins = 0;
            bFinMouvementX = true;
        }
    }
    
    
    
    if(acceleration.y < kThreshold * -1){ // -0.3 < -0.2
        _currentMaxAccelY = acceleration.y;
    }else if(acceleration.y > kThreshold){ // 0.3 > 0.2
        _currentMaxAccelY = acceleration.y;
    }else{
        _currentMaxAccelY = 0;
    }
    
    if(acceleration.z < kThreshold * -1){ // -0.3 < -0.2
        _currentMaxAccelZ = acceleration.z;
    }else if(acceleration.z > kThreshold){ // 0.3 > 0.2
        _currentMaxAccelZ = acceleration.z;
    }else{
        _currentMaxAccelZ = 0;
    }
}
//-(void)outputRotationData:(CMRotationRate)rotation
-(void)outputRotationData:(CMAcceleration)rotation
{
    double rotationXY = atan2(rotation.x, rotation.y) - M_PI;
    double rotationYZ = atan2(rotation.y, rotation.z) - M_PI;
    double rotationZX = atan2(rotation.z, rotation.x) - M_PI;
    //NSLog(@"X : %.2f\tY : %.2f\tZ : %.2f",rotationXY,rotationYZ,rotationZX);
    //[ecran updateBtnStatioDecoAttr:[[NSString alloc] initWithFormat:@"X : %.2f\tY : %.2f\tZ : %.2f",rotationXY,rotationYZ,rotationZX
    //                                ]];
    //[ecran updateBtnStatioDecoAttr:[[NSString alloc] initWithFormat:@"X : %.2f\t Y : %.2f\t Z : %.2f",
                                //    rotation.x,rotation.y,rotation.z]];
    rotX = rotation.x;
    rotY = rotation.y;
    rotZ = rotation.z;
    
}

 */

-(void)sendToDrone{
   
    /* Si le drone est en vol et n'est pas en mode stationnaire */
    if( _enVol && !_enStatio){
         //[ecran updateBtnDimensions:@"UPDATE"];
        //On balance les ordres
        if(![ecran.btnChangementMode isHidden]){
            if([[ecran.btnChangementMode.titleLabel text] isEqualToString:@"Axe X"]){   //Mode X ou Y
                if(_currentMaxAccelX != 0){
                    [ecran updateBtnDimensions:@"UPDATE DIFF"];
                    [_bebopDrone setFlag:1];
                    if(_currentMaxAccelX > 0){
                        [_bebopDrone setPitch:1];   //Le coefficient doit être appliqué
                    }else{
                        [ecran updateBtnDimensions:@"UPDATE"];
                        [_bebopDrone setPitch:-1];
                    }
                }else{
                    [_bebopDrone setFlag:1];
                    [_bebopDrone setPitch:0];
                }
            }else{
                if(_currentMaxAccelY != 0){
                    [_bebopDrone setFlag:1];
                    [_bebopDrone setRoll:10];   //Le coefficient doit être appliqué
                }
            }
            
        } else if(![[ecran.btnDimensions.titleLabel text] isEqualToString:@"2D"]){      //Mode X ET Y
            
        } else if(![[ecran.btnDimensions.titleLabel text] isEqualToString:@"3D"]){       //Mode X ET Y ET Z
           
        }
    }else{
        //Nothing?
    }
}

- (void) finCommande{
    bFinMouvementX = true;
    [ecran updateBtnChangementMode:@"FIN MOUVEMENT"];
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

- (void) deconnexionDrone{
    
    if(_service != nil){
        if (_connectionAlertView && !_connectionAlertView.isHidden) {
            [_connectionAlertView dismissWithClickedButtonIndex:0 animated:NO];
        }
        
        _connectionAlertView = [[UIAlertView alloc] initWithTitle:[_service name] message:@"Disconnecting ..."
                                                         delegate:self cancelButtonTitle:nil otherButtonTitles:nil, nil];
        [_connectionAlertView show];
        
        // in background, disconnect from the drone
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
            [_bebopDrone disconnect];
            // wait for the disconnection to appear
            dispatch_semaphore_wait(_stateSem, DISPATCH_TIME_FOREVER);
            _bebopDrone = nil;
            
            // dismiss the alert view in main thread
            dispatch_async(dispatch_get_main_queue(), ^{
                [_connectionAlertView dismissWithClickedButtonIndex:0 animated:YES];
                
                [self.navigationController popViewControllerAnimated:YES];
                
            });
        });
    }
    
}


-(void)bebopDrone:(BebopDrone *)bebopDrone connectionDidChange:(eARCONTROLLER_DEVICE_STATE)state {
    
    
    NSLog(@"CHANGEMENT ETAT MANUEL");
    switch (state) {
        case ARCONTROLLER_DEVICE_STATE_RUNNING:
            NSLog(@"STATE RUNNING");
            [_connectionAlertView dismissWithClickedButtonIndex:0 animated:YES];
            break;
        case ARCONTROLLER_DEVICE_STATE_STOPPED:
            NSLog(@"STATE STOPPED");
            dispatch_semaphore_signal(_stateSem);
            
            [self deconnexionDrone];
            
            break;
            
        default:
            break;
    }
}

- (void)bebopDrone:(BebopDrone*)bebopDrone batteryDidChange:(int)batteryPercentage {

}

- (void)bebopDrone:(BebopDrone*)bebopDrone flyingStateDidChange:(eARCOMMANDS_ARDRONE3_PILOTINGSTATE_FLYINGSTATECHANGED_STATE)state {
    
    switch (state) {
        case ARCOMMANDS_ARDRONE3_PILOTINGSTATE_FLYINGSTATECHANGED_STATE_LANDED:
            NSLog(@"Take Off");
            break;
        case ARCOMMANDS_ARDRONE3_PILOTINGSTATE_FLYINGSTATECHANGED_STATE_FLYING:
            [ecran updateBtnChangementMode:@"FIN CMD"];
            //bFinMouvementX = true;
            
            break;
        case ARCOMMANDS_ARDRONE3_PILOTINGSTATE_FLYINGSTATECHANGED_STATE_HOVERING:
            [ecran updateBtnChangementMode:@"HOVERING "];
            NSLog(@"Land");
            break;
        default:
            NSLog(@"Default");
            break;
    }
}

-(void)viewDidAppear:(BOOL)animated{
    if(_bebopDrone == nil) {
        [self registerNotifications];
        [_droneDiscoverer startDiscovering];
    
        if ([_bebopDrone connectionState] != ARCONTROLLER_DEVICE_STATE_RUNNING) {
            [_connectionAlertView show];
        }
    }
}



@end
