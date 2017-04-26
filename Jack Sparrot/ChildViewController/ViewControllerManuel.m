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
#define ARRIERE 4
#define AVANT 5
#define STATIONNAIRE 6
#define THRESH 0.5
#define THRESHSTABILITE 30


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
UIAlertView *alertControl;

NSTimer * timerDrone;
ViewManuel *ecran;
@implementation ViewControllerManuel


- (void)viewDidLoad {
    [super viewDidLoad];
    
    /*Récupération mode intérieur extérieur */
    _bInterieurManuel = [[NSUserDefaults standardUserDefaults] boolForKey:@"InOut"];
    NSLog(@"INTERIEUR MANUEL %d",_bInterieurManuel);
    /* Récupération des options et mise en place des settings par defaut */
    hauteurMax = [[NSUserDefaults standardUserDefaults] doubleForKey:@"Hauteur"];
    accelerationSetting = [[NSUserDefaults standardUserDefaults] doubleForKey:@"Acceleration"];
    
    /*DRONE*/
    if(_bebopDrone == nil) {
        _dataSource = [NSArray array];
        _droneDiscoverer = [[DroneDiscoverer alloc] init];
        [_droneDiscoverer setDelegate:self];
    }
    _bebopDrone = [[BebopDrone alloc ] init];
    
    /* Fin accélération */
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
    [ecran updateBtnDimensions:@"1D"];
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

- (void) mouvementDeviceMotion:(CMDeviceMotion *)motion{
    
    /* Le mouvement est-il autorisé */
    /*if(_bebopDrone == nil || !_enVol || _enStatio || _homeActivate){
        [_bebopDrone setFlag:0];
        [_bebopDrone setRoll:0];
        [_bebopDrone setPitch:0];
        [_bebopDrone setGaz:0];
        [_bebopDrone setYaw:0];
        return;
    }*/
    
    boolean MVTX = false,
            MVTY = false,
            MVTZ = false;
     
    /* Récupération de l'userAcceleration */
    _incX = motion.userAcceleration.x;
    _incY = motion.userAcceleration.y;
    _incZ = motion.userAcceleration.z;
    
    /* Vérification si acceleration ou déceleration  */
    _absX = fabs(_incX);
    _absY = fabs(_incY);
    _absZ = fabs(_incZ);
    
    if(_absX > THRESH){
        MVTX = true;
    }else{
        if(_iStabX < THRESHSTABILITE){
            _iStabX++;
        }else{
            if(_lastMoveX != STATIONNAIRE){
                NSLog(@"STATIONNAIRE X");
                [_bebopDrone setFlag:0];
                [_bebopDrone setPitch:0];
            }
            _stabX = YES;
            _lastMoveX = STATIONNAIRE;
            _iStabX = 0;
        }
    }
    
    if(_absY > THRESH){
        MVTY = true;
    }else{
        if(_iStabY < THRESHSTABILITE){
            _iStabY++;
        }else{
            if(_lastMoveY != STATIONNAIRE){
                NSLog(@"STATIONNAIRE Y");
                [ecran updateBtnDimensions:@"STATIONNAIRE"];
                [_bebopDrone setFlag:0];
                [_bebopDrone setRoll:0];
            }
            _stabY = YES;
            _lastMoveY = STATIONNAIRE;
            _iStabY = 0;
        }
    }
    
    if(_absZ > THRESH){
        MVTZ = true;
    }else{
        if(_iStabZ < THRESHSTABILITE){
            _iStabZ++;
        }else{
            if(_lastMoveZ != STATIONNAIRE){
                NSLog(@"STATIONNAIRE Z");
                [_bebopDrone setGaz:0];
            }
            _stabZ = YES;
            _lastMoveZ = STATIONNAIRE;
            _iStabZ = 0;
        }
    }
    
    if(MVTX == false && MVTY == false && MVTZ == false) return; /* Pas besoin d'en faire plus */
    
    /* Si mouvement en X ou Y ou Z alors on applique suivant le sens*/
    if(MVTX){
        if(_incX < -THRESH && _stabX){
            NSLog(@"AVANT");
            if(_axeX && currentDimensions == 1){
                [_bebopDrone setFlag:1];
                [_bebopDrone setPitch:100];
            }else if(currentDimensions == 2 || currentDimensions == 3){
                [_bebopDrone setFlag:1];
                [_bebopDrone setPitch:100];
            }
            _lastMoveX = AVANT;
            _stabX = NO;
        }else if(_incX > THRESH && _stabX){
            NSLog(@"ARRIERE");
            if(_axeX && currentDimensions == 1){
                [_bebopDrone setFlag:1];
                [_bebopDrone setPitch:-100];
            }else if(currentDimensions == 2 || currentDimensions == 3){
                [_bebopDrone setFlag:1];
                [_bebopDrone setPitch:-100];
            }
            _lastMoveX = ARRIERE;
            _stabX = NO;
        }
        _incX = 0;
    }
    
    
    if(MVTY){
        if(_incY < -THRESH && _stabY){
                NSLog(@"DROITE");
                if(!_axeX && currentDimensions == 1){
                    [_bebopDrone setFlag:1];
                    [_bebopDrone setRoll:-100];
                }else if(currentDimensions == 2 || currentDimensions == 3){
                    [_bebopDrone setFlag:1];
                    [_bebopDrone setRoll:-100];
                }
                _lastMoveY = DROITE;
                _stabY = NO;
        }else if(_incY > THRESH && _stabY){
                NSLog(@"GAUCHE");
                if(!_axeX && currentDimensions == 1){
                    [_bebopDrone setFlag:1];
                    [_bebopDrone setRoll:100];
                }else if(currentDimensions == 2 || currentDimensions == 3){
                    [_bebopDrone setFlag:1];
                    [_bebopDrone setRoll:100];
                }
                _lastMoveY = GAUCHE;
                _stabY = NO;
            
        }
        _incY = 0;
    }
    
    if(MVTZ){
        if(_incZ < -THRESH && _stabZ){
                NSLog(@"HAUT");
                if(currentDimensions == 3){
                    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
                        [_bebopDrone setGaz:50];
                        NSLog(@"GAZ UP");
                        [NSThread sleepForTimeInterval:0.5f];
                        NSLog(@"GAZ END");
                        [_bebopDrone setGaz:0];
                    });
                }
                _lastMoveZ = HAUT;
                _stabZ = NO;
            
        }else if(_incZ > THRESH && _stabZ){
                NSLog(@"BAS");
                if(currentDimensions == 3){
                    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
                        [_bebopDrone setGaz:-50];
                        NSLog(@"GAZ UP");
                        [NSThread sleepForTimeInterval:0.5f];
                        NSLog(@"GAZ END");
                        [_bebopDrone setGaz:0];
                    });
                }
                _lastMoveZ = BAS;
                _stabZ = NO;
            
        }
        _incZ = 0;
    }
}


- (void) checkBattery{
    
    //Battery of the terminal
    UIDevice *myDevice = [UIDevice currentDevice];
    [myDevice setBatteryMonitoringEnabled:YES];
    
    int state = [myDevice batteryState];
    double batTermin = (float)[myDevice batteryLevel] * 100;
    
    //Battery of the drone
    if(batTermin < 10 || _batteryDroneManuel < 10){
        
        
        if([_bebopDrone isFlying]){
            NSString *soundPath = [[NSBundle mainBundle] pathForResource:@"alert" ofType:@"mp3"];
            SystemSoundID soundID;
            AudioServicesCreateSystemSoundID((__bridge CFURLRef)[NSURL fileURLWithPath:soundPath], &soundID);
            AudioServicesPlaySystemSound(soundID);
            
            if(alertControl == nil){
                alertControl = [[UIAlertView alloc] initWithTitle:@"Attention !"
                                                          message:@"La batterie du terminal ou du drone est faible."
                                                         delegate:self
                                                cancelButtonTitle:@"Arrêter le drone"
                                                otherButtonTitles:@"Continuer",nil];
                [alertControl show];
                
            }
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
            btnImage = [UIImage imageNamed:@"ic_play_arrow.png"];
            [[ecran btnStatioDecoAttr] setImage:btnImage forState:UIControlStateNormal];
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
    [_bebopDrone setGaz:0];
    
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
        NSLog(@"Fonction Home activée! bInteireur = %d",_bInterieurManuel);
        _homeActivate = true;
        [_bebopDrone setViewCall:self];
        if(_bInterieurManuel){
            [_bebopDrone returnHomeInterieur];

        }else{
            [_bebopDrone returnHomeExterieur];
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
    /* Acceleration + Gyroscope */
    self.motionManager = [[CMMotionManager alloc] init];
    
    
    if (self.motionManager.deviceMotionAvailable) {
        
        _motionManager.deviceMotionUpdateInterval = 1.0/60.0F;
        [_motionManager startDeviceMotionUpdatesUsingReferenceFrame:CMAttitudeReferenceFrameXArbitraryCorrectedZVertical];
        [_motionManager startDeviceMotionUpdatesToQueue:[NSOperationQueue currentQueue] withHandler:^(CMDeviceMotion *motion, NSError *error) {
            [self mouvementDeviceMotion:motion];
        }];
        
        
    }
}

- (void) viewDidDisappear:(BOOL)animated{
    [timerDrone invalidate];
    self.motionManager = nil;
}



@end
