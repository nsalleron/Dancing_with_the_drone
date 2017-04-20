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
#import <AudioToolbox/AudioToolbox.h>
#import <AVFoundation/AVFoundation.h>

#define GAUCHE 0
#define DROITE 1
#define HAUT 2
#define BAS 3
#define AVANT 4
#define ARRIERE 5
#define STABLE 6
#define SURPLACE 7
#define THRESH 0.5


@interface ViewControllerManuel ()<BebopDroneDelegate,
                                    DroneDiscovererDelegate,
                                    ViewDimensionViewControllerDelegate,
                                    UIAlertViewDelegate>

@property (nonatomic, strong) UIAlertView *connectionAlertView;
@property (nonatomic, strong) BebopDrone *bebopDrone;
@property (nonatomic, strong) NSArray *dataSource;
@property (nonatomic, strong) DroneDiscoverer *droneDiscoverer;

@end



BOOL firstTime = TRUE;
int currentDimensions = 0;
double accelerationSetting;
double hauteurMax;
UIAlertView *alertManuel;

NSTimer * timerDrone;
ViewManuel *ecran;
@implementation ViewControllerManuel


- (void)viewDidLoad {
    [super viewDidLoad];
    
    /*Récupération mode intérieur extérieur */
    _bExterieur = ![[NSUserDefaults standardUserDefaults] objectForKey:@"InOut"];
    
    /* Récupération des options et mise en place des settings par defaut */
    hauteurMax = [[NSUserDefaults standardUserDefaults] doubleForKey:@"Hauteur"];
    accelerationSetting = [[NSUserDefaults standardUserDefaults] doubleForKey:@"Acceleration"];
    
    /*DRONE*/
    if(_bebopDrone == nil) {
        _dataSource = [NSArray array];
        _droneDiscoverer = [[DroneDiscoverer alloc] init];
        [_droneDiscoverer setDelegate:self];
    }
    
    //_bebopDrone = [[BebopDrone alloc] init];
    
    /* Acceleration + Gyroscope */
    self.motionManager = [[CMMotionManager alloc] init];
    
    
    if (self.motionManager.deviceMotionAvailable) {
        
        _motionManager.deviceMotionUpdateInterval = 1.0/10.0F;
        [_motionManager startDeviceMotionUpdatesUsingReferenceFrame:CMAttitudeReferenceFrameXArbitraryCorrectedZVertical];
        [_motionManager startDeviceMotionUpdatesToQueue:[NSOperationQueue currentQueue] withHandler:^(CMDeviceMotion *motion, NSError *error) {
                [self mouvementDeviceMotion:motion];
        }];
        
    
    }
    
    /* DEBUG
    [self.motionManager setAccelerometerUpdateInterval:1.0/10];
    [self.motionManager startAccelerometerUpdatesToQueue:[NSOperationQueue currentQueue] withHandler:^(CMAccelerometerData *data, NSError *error){
            [self movement:data.acceleration];
    }];
     */
    
    /* Fin acceleration */
    _enStatio = FALSE;
    _enVol = FALSE;
    _axeX = TRUE;
    _homeActivate = false;
    
    ecran = [[ViewManuel alloc ] initWithFrame:[[UIScreen mainScreen] bounds]];
    [ecran setBackgroundColor:[UIColor colorWithRed:250.0/255 green:246.0/255 blue:244.0/255 alpha:1.0]];
    [ecran setViewController:self];
    [ecran updateBtnStatioDecoAttr:@"        Décollage"];
    UIImage *btnImage = [UIImage imageNamed:@"ic_flight_takeoff.png"];
    [[ecran btnStatioDecoAttr] setImage:btnImage forState:UIControlStateNormal];
    [ecran updateBtnDimensions:@"      1D"];
    currentDimensions = 1;
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
    
    timerDrone = [NSTimer scheduledTimerWithTimeInterval:10.0
                                     target:self
                                   selector:@selector(checkBattery)
                                   userInfo:nil
                                    repeats:YES];
}

/**
 * @brief interprétation des mouvements via CoreMotion
 * @param motion Object CMDeviceMotion possédant les données CoreMotion
 */
- (void) mouvementDeviceMotion:(CMDeviceMotion *)motion{
    
    /* Le mouvement est-il autorisé */
    if(_bebopDrone == nil || !_enVol || _enStatio || _homeActivate){
        [_bebopDrone setFlag:0];
        [_bebopDrone setRoll:0];
        [_bebopDrone setPitch:0];
        [_bebopDrone setGaz:0];
        [_bebopDrone setYaw:0];
        return;
    }
    
    
    
    /* Récupération de l'userAcceleration */
    _incX = motion.userAcceleration.x;
    _incY = motion.userAcceleration.y;
    _incZ = motion.userAcceleration.z;
    
    
    
    /* Vérification si mouvement */
    _absX = fabs(_incX);
    _absY = fabs(_incY);
    _absZ = fabs(_incZ);
    
    
    /* Mouvement de d'avant et d'arrière */
    if(_absX > THRESH){
        if(_incX < -THRESH){
            if(_stabX){
                NSLog(@"ARRIERE");
                if(_axeX && currentDimensions == 1){
                    [_bebopDrone setFlag:1];
                    [_bebopDrone setPitch:100];
                }else if(currentDimensions == 2 || currentDimensions == 3){
                    [_bebopDrone setFlag:1];
                    [_bebopDrone setPitch:100];
                }
                _lastMoveX = ARRIERE;
                _stabX = NO;
            }
        }else if(_incX > 0.2){
            if(_stabX){
                NSLog(@"AVANT");
                if(_axeX && currentDimensions == 1){
                    [_bebopDrone setFlag:1];
                    [_bebopDrone setPitch:-100];
                }else if(currentDimensions == 2 || currentDimensions == 3){
                    [_bebopDrone setFlag:1];
                    [_bebopDrone setPitch:-100];
                    
                }
                _lastMoveX = AVANT;
                _stabX = NO;
            }
        }
        _incX = 0;
    }else{
        if(_incStabX < 6){
            _incStabX++;
        }else{
            if(_lastMoveX != STABLE){
                NSLog(@"STABLE X");
                [_bebopDrone setFlag:0];
                [_bebopDrone setPitch:0];
            }
            _stabX = YES;
            _lastMoveX = STABLE;
            _incStabX = 0;
        }
    }
    
    /* Mouvement de gauche et droite */
    if(_absY > THRESH){
        if(_incY < -THRESH){
            if(_stabY){
                NSLog(@"DROITE");
                if(!_axeX && currentDimensions == 1){
                    [_bebopDrone setFlag:1];
                    [_bebopDrone setRoll:100];
                }else if(currentDimensions == 2 || currentDimensions == 3){
                    [_bebopDrone setFlag:1];
                    [_bebopDrone setRoll:100];
                }
                _lastMoveY = DROITE;
                _stabY = NO;
            }
        }else if(_incY > THRESH){
            if(_stabY){
                NSLog(@"GAUCHE");
                if(!_axeX && currentDimensions == 1){
                    [_bebopDrone setFlag:1];
                    [_bebopDrone setRoll:-100];
                }else if(currentDimensions == 2 || currentDimensions == 3){
                    [_bebopDrone setFlag:1];
                    [_bebopDrone setRoll:-100];
                }
                _lastMoveY = GAUCHE;
                _stabY = NO;
            }
        }
        _incY = 0;
    }else{
        if(_incStabY < 6){
            _incStabY++;
        }else{
            if(_lastMoveY != STABLE){
                NSLog(@"STABLE Y");
                [_bebopDrone setFlag:0];
                [_bebopDrone setRoll:0];
            }
            _stabY = YES;
            _lastMoveY = STABLE;
            _incStabY = 0;
        }
    }
    
    /* Mouvement de haut et bas */
    if(_absZ > THRESH){
        if(_incZ < -THRESH){
            if(_stabZ){
                NSLog(@"HAUT");
                if(currentDimensions == 3){
                    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
                        [_bebopDrone setGaz:100];
                        NSLog(@"GAZ UP");
                        [NSThread sleepForTimeInterval:0.2f];
                        NSLog(@"GAZ END");
                        [_bebopDrone setGaz:0];
                    });
                }
                _lastMoveZ = HAUT;
                _stabZ = NO;
            }
        }else if(_incZ > THRESH){
            if(_stabZ){
                NSLog(@"BAS");
                if(currentDimensions == 3){
                    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
                        [_bebopDrone setGaz:-100];
                        NSLog(@"GAZ UP");
                        [NSThread sleepForTimeInterval:0.2f];
                        NSLog(@"GAZ END");
                        [_bebopDrone setGaz:0];
                    });
                }
                _lastMoveZ = BAS;
                _stabZ = NO;
            }
        }
        _incZ = 0;
    }else{
        if(_incStabZ < 6){
            _incStabZ++;
        }else{
            if(_lastMoveZ != STABLE){
                NSLog(@"STABLE Z");
                [_bebopDrone setGaz:0];
            }
            _stabZ = YES;
            _lastMoveZ = STABLE;
            _incStabZ = 0;
        }
    }
    
}

/**
 * @brief Surveillance de la batterie du drone et mobile
 */
- (void) checkBattery{
    
    //Battery of the terminal
    UIDevice *myDevice = [UIDevice currentDevice];
    [myDevice setBatteryMonitoringEnabled:YES];
    
    int state = [myDevice batteryState];
    double batTermin = (float)[myDevice batteryLevel] * 100;
    
    //Battery of the drone
    
    if([_bebopDrone isFlying]){
        NSString *soundPath = [[NSBundle mainBundle] pathForResource:@"alert" ofType:@"mp3"];
        SystemSoundID soundID;
        AudioServicesCreateSystemSoundID((__bridge CFURLRef)[NSURL fileURLWithPath:soundPath], &soundID);
        AudioServicesPlaySystemSound(soundID);
        
        if(alertManuel == nil){
            alertManuel = [[UIAlertView alloc] initWithTitle:@"Attention !"
                                                      message:@"La batterie du terminal ou du drone est faible."
                                                     delegate:self
                                            cancelButtonTitle:@"Arrêter le drone"
                                            otherButtonTitles:@"Continuer",nil];
            [alertManuel show];
            
        }
        
    }
    
    
}

/**
 * @brief handler pour quand la batterie est faible
 */
- (void)alertView:(UIAlertView *)alertView didDismissWithButtonIndex:(NSInteger)buttonIndex {
    if (buttonIndex == 0) {
        [_bebopDrone land];
    }
}

/**
 * @brief Méthodes pour la rotation
 */
- (BOOL)prefersStatusBarHidden {
    return YES;
}

/**
 * @brief Passage du décollage à l'atterrissage
 */
- (void) changeDecoAttr:(UILongPressGestureRecognizer*)gesture{
    NSString *statio = @"    ON";
    UIImage *btnImage;
    switch (_enVol) {
        case TRUE:
            //Atterrissage;
            NSLog(@"Atterrissage");
            _enVol = FALSE;
            _enStatio = FALSE;
            [_bebopDrone land];
            btnImage = [UIImage imageNamed:@"ic_flight_takeoff.png"];
            [[ecran btnStatioDecoAttr] setImage:btnImage forState:UIControlStateNormal];
            statio = @"        Decollage";
            break;
            
        case FALSE:
            //Decollage;
            NSLog(@"        Decollage");
            _enVol = TRUE;
            _enStatio = TRUE;
            [_bebopDrone takeOff];
        default:
            break;
    }
    [ecran updateBtnStatioDecoAttr:statio];

    
}
/**
 * @brief Changement de l'axe X / Y / Z
 */
- (void) changeAxe:(UIButton*)gesture{
    NSString *axe = @"Axe X";
    switch (_axeX) {
        case TRUE:
            //Axe Y
            NSLog(@"Axe Y");
            axe = @"Axe Y";
            [_bebopDrone setFlag:0];
            [_bebopDrone setPitch:0];
            _axeX = FALSE;
            break;
            
        case FALSE:
            //Axe X
            NSLog(@"Axe X");
            [_bebopDrone setFlag:0];
            [_bebopDrone setRoll:0];
            _axeX = TRUE;
        default:
            break;
    }
    [ecran updateBtnChangementMode:axe];
       
}
/**
 * @brief Activation mode stationnaire ou non
 */
- (void) changeSatio:(UIButton*)send{
    if(firstTime){
        [self changeDecoAttr:NULL];
        UIImage *btnImage = [UIImage imageNamed:@"ic_play_arrow.png"];
        [[ecran btnStatioDecoAttr] setImage:btnImage forState:UIControlStateNormal];
        firstTime = FALSE;
        return;
        
    }
    UIImage *btnImage;
    
    NSString *statio = @"    ON";
    switch (_enStatio) {
        case TRUE:
            //Mode non stationnaire;
            NSLog(@"    OFF");
            _enStatio = FALSE;
            statio = @"    OFF";
            btnImage = [UIImage imageNamed:@"ic_pause.png"];
            [[ecran btnStatioDecoAttr] setImage:btnImage forState:UIControlStateNormal];
            break;
            
        case FALSE:
            //Mode stationnaire;
            NSLog(@"    ON");
             _enStatio  = TRUE;
            [_bebopDrone setFlag:0];
            [_bebopDrone setRoll:0];
            [_bebopDrone setPitch:0];
            [_bebopDrone setGaz:0];
            btnImage = [UIImage imageNamed:@"ic_play_arrow.png"];
            [[ecran btnStatioDecoAttr] setImage:btnImage forState:UIControlStateNormal];
            break;
        default:
            break;
    }
    [ecran updateBtnStatioDecoAttr:statio];
}

/**
 * @brief Vers l'écran dimensions
 */
-(void) goToDimensionChoice:(UILongPressGestureRecognizer*)gesture{
    
    /* On met le drone en mode stationnaire */
    [_bebopDrone setFlag:0];
    [_bebopDrone setRoll:0];
    [_bebopDrone setPitch:0];
    
    ViewDimensionViewController *secondController = [[ViewDimensionViewController alloc] init];
    secondController.delegate = self;
    [self.navigationController pushViewController:secondController animated:YES];
    
}


/**
 * @brief Gestion des toucher long par le viewController 
 */
- (void) quitView:(UILongPressGestureRecognizer*)gesture{

    if(_service == nil){
        [self.navigationController popViewControllerAnimated:YES];
    }
    
    [self unregisterNotifications];
    [_droneDiscoverer stopDiscovering];
    
    [self deconnexionDrone];
    
    
    
}

/**
 * @brief Activation de la fonction home
 */
- (void) homeFunction:(UILongPressGestureRecognizer*)gesture{
    if ( gesture.state == UIGestureRecognizerStateBegan) {
        NSLog(@"Fonction Home activée! bExterieur = %d",_bExterieur);
        _homeActivate = true;
        [_bebopDrone setViewCall:self];
        if(_bExterieur){
            [_bebopDrone returnHomeExterieur];
        }else{
            [_bebopDrone returnHomeInterieur];
        }
        
    }
}


/**
 * @brief Activation mode stationnaire ou non
 */
-(void) changeStatio:(UIButton*)send{
    switch (_enStatio) {
        case TRUE:
            //Atterrissage;
            //NSLog(@"Atterrissage");
            _enStatio = FALSE;
            break;
            
        case FALSE:
            //Decollage;
            //NSLog(@"Decollage");
            _enStatio = TRUE;
        default:
            break;
    }
}

/*
 * @brief Changement de dimensions et redimensionnement des écrans 
 */

- (void)addItemViewController:(ViewDimensionViewController *)controller didFinishEnteringItem:(NSString *)item
{
    
    [ecran updateBtnDimensions:item];
    if([item  isEqual: @"1D"]){
        NSLog(@"1D OK");
        [ecran updateView:[[UIScreen mainScreen] bounds].size];
        currentDimensions = 1;
    }else if([item  isEqual: @"2D"]){
        currentDimensions = 2;
        NSLog(@"2D OK");
        [ecran update2D3D:[[UIScreen mainScreen] bounds].size];
    }else if([item  isEqual: @"3D"]){
        currentDimensions = 3;
        NSLog(@"3D OK");
        [ecran update2D3D:[[UIScreen mainScreen] bounds].size];
    }
    
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
/**
 * @brief gestion du swipe UP
 */
-(void)swipeUp:(UISwipeGestureRecognizer*)gestureRecognizer
{
   
    if(_bebopDrone == nil || !_enVol || _enStatio) return;
    
    // in background, gaz the drone
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        [_bebopDrone setGaz:100];
        NSLog(@"GAZ UP");
        [NSThread sleepForTimeInterval:0.5f];
        NSLog(@"GAZ END");
        [_bebopDrone setGaz:0];
    });
    
    
    
}
/**
 * @brief gestion du swipe DOWN
 */
-(void)swipeDown:(UISwipeGestureRecognizer*)gestureRecognizer
{
   
    if(_bebopDrone == nil || !_enVol || _enStatio) return;
    
    // in background, gaz the drone
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        [_bebopDrone setGaz:-100];
        NSLog(@"GAZ DOWN");
        [NSThread sleepForTimeInterval:0.5f];
          NSLog(@"GAZ END");
        [_bebopDrone setGaz:0];
    });
}

/**
 * @brief Méthodes pour la rotation
 */

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationLandscapeRight);
}
/**
 * @brief Méthodes pour la rotation
 */
- (BOOL)shouldAutorotate{
    return YES;
}
/**
 * @brief Méthodes pour la rotation
 */
- (UIInterfaceOrientationMask)supportedInterfaceOrientations
{
    if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone) {
        return UIInterfaceOrientationMaskLandscapeRight;
    } else {
        return UIInterfaceOrientationMaskAll;
    }
}
/**
 * @brief Méthodes pour la rotation
 */
- (UIInterfaceOrientation)preferredInterfaceOrientationForPresentation
{
    return UIInterfaceOrientationLandscapeRight;
}
-(void)viewWillTransitionToSize:(CGSize)size withTransitionCoordinator:(id<UIViewControllerTransitionCoordinator>)coordinator{
    [ecran updateView:size];
}


#pragma mark DroneDiscovererDelegate
- (void)droneDiscoverer:(DroneDiscoverer *)droneDiscoverer didUpdateDronesList:(NSArray *)dronesList {
    _dataSource = dronesList;
    
    if(_dataSource.count != 0 ){
        _service = [_dataSource objectAtIndex:0];
        
        _stateSem = dispatch_semaphore_create(0);
        
        _bebopDrone = [[BebopDrone alloc] initWithService:_service];
        [_bebopDrone setDelegate:self];
        [_bebopDrone setMaxHauteur:hauteurMax];
        [_bebopDrone setAcceleration:accelerationSetting];
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

- (void)bebopDrone:(BebopDrone*)bebopDrone batteryDidChange:(int)batteryPercentage {
    _batteryDroneManuel = batteryPercentage;
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
        
        
        NSLog(@"DECONNEXION SHOW MANUEL");
        
        // in background, disconnect from the drone
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
            [_bebopDrone disconnect];
            // wait for the disconnection to appear
            dispatch_semaphore_wait(_stateSem, DISPATCH_TIME_FOREVER);
            _bebopDrone = nil;
            
            // dismiss the alert view in main thread
            dispatch_async(dispatch_get_main_queue(), ^{
                [_connectionAlertView dismissWithClickedButtonIndex:0 animated:YES];
                 NSLog(@"FIN CONNEXION ALERT VIEW MANUEL");
                _service = nil;
                _bebopDrone = nil;
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

- (void)bebopDrone:(BebopDrone*)bebopDrone flyingStateDidChange:(eARCOMMANDS_ARDRONE3_PILOTINGSTATE_FLYINGSTATECHANGED_STATE)state {
    
    switch (state) {
        case ARCOMMANDS_ARDRONE3_PILOTINGSTATE_FLYINGSTATECHANGED_STATE_LANDED:
            
            break;
        case ARCOMMANDS_ARDRONE3_PILOTINGSTATE_FLYINGSTATECHANGED_STATE_FLYING:
            
            break;
        case ARCOMMANDS_ARDRONE3_PILOTINGSTATE_FLYINGSTATECHANGED_STATE_HOVERING:

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

- (void) viewDidDisappear:(BOOL)animated{
    [timerDrone invalidate];
}



@end
