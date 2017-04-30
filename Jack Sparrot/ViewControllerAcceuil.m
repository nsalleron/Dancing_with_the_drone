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
#import <libARDiscovery/ARDiscovery.h>
#import <AVFoundation/AVFoundation.h>
#import <AVKit/AVKit.h>
#import <AudioToolbox/AudioToolbox.h>
#import <AVFoundation/AVFoundation.h>


@interface ViewControllerAccueil()<BebopDroneDelegate,DroneDiscovererDelegate,WCSessionDelegate,UIAlertViewDelegate>
@end

ViewEcranAccueil *ecranAccueil;
boolean droneViewActif;
ViewControllerManuel *controllerDrone;
double accelerationSettingAccueil;
double hauteurMaxAccueil;
bool interieur;
NSTimer * timerAccueil;
NSTimer * timerWatch;
UIAlertView *alertAccueil;

@implementation ViewControllerAccueil


- (void)viewDidLoad {
    
    [super viewDidLoad];

    _bWatchActive = false;
    ecranAccueil = [[ViewEcranAccueil alloc ] initWithFrame:[[UIScreen mainScreen] bounds]];
    [ecranAccueil setBackgroundColor:[UIColor colorWithRed:250.0/255 green:246.0/255 blue:244.0/255 alpha:1.0]];
    [self setView: ecranAccueil];
    [self setTitle:@"Accueil"];
    
    if ([WCSession isSupported]) {
        _session = [WCSession defaultSession];
        _session.delegate = self;
        [_session activateSession];
    }

    
}

- (void) checkBattery{
    
    //Battery du terminal
    UIDevice *myDevice = [UIDevice currentDevice];
    [myDevice setBatteryMonitoringEnabled:YES];
    
    int state = [myDevice batteryState];
    double batTermin = (float)[myDevice batteryLevel] * 100;
    
    //Battery du drone
    if(batTermin < 10 || _batteryDrone < 10){
        
        
        if([_bebopDrone isFlying]){
            NSString *soundPath = [[NSBundle mainBundle] pathForResource:@"alert" ofType:@"mp3"];
            SystemSoundID soundID;
            AudioServicesCreateSystemSoundID((__bridge CFURLRef)[NSURL fileURLWithPath:soundPath], &soundID);
            AudioServicesPlaySystemSound(soundID);
        
            if(alertAccueil == nil){
                alertAccueil = [[UIAlertView alloc] initWithTitle:@"Attention !"
                                                          message:@"La batterie du terminal ou du drone est faible."
                                                         delegate:self
                                                cancelButtonTitle:@"Arrêter le drone"
                                                otherButtonTitles:@"Continuer",nil];
                [alertAccueil show];

            }
            
        }

        
    }
    
    
}

/**
 * @brief Réponse à l'alertView
 */
- (void)alertView:(UIAlertView *)alertView didDismissWithButtonIndex:(NSInteger)buttonIndex {
    if (buttonIndex == 0) {
        [_bebopDrone land];
    }
}


/**
 *  @brief Il faut absoluement arrêter le drone quand la session est sur le point d'être désactivée.
 */
- (void) sessionDidBecomeInactive:(WCSession *)session{
    [_bebopDrone setFlag:0];
    [_bebopDrone setPitch:0];
    [_bebopDrone setRoll:0];
    [_bebopDrone setGaz:0];
    [_bebopDrone setYaw:0];
    _bWatchActive = false;
    [ecranAccueil btnAide].enabled = YES;
    [ecranAccueil btnAide].alpha = 1;
    [ecranAccueil btnDrone].enabled = YES;
    [ecranAccueil btnDrone].alpha = 1;
    [ecranAccueil btnOptions].enabled = YES;
    [ecranAccueil btnOptions].alpha = 1;
    [[ecranAccueil labelMontre] setText:@""];
    [[ecranAccueil labelMontre] setTextColor:[UIColor redColor]];
    [ecranAccueil updateView:[[UIScreen mainScreen] bounds].size];

}



/**
 * @brief Interprétation des données de la montre quand elle est disponible.
 * Agit directement sur le drone avec un timer au cas ou la connexion n'est plus active.
 */
- (void) session:(WCSession *)session didReceiveMessage:(NSDictionary<NSString *,id> *)message replyHandler:(void (^)(NSDictionary<NSString *,id> * _Nonnull))replyHandler{
    
    
    NSArray * ArrayCommand = [[NSArray alloc] init];
    NSString * axe;
    NSString *valeur;
    float accel, hauteur;
    
    
    NSString * string = [message objectForKey:@"CMD"];
    ArrayCommand = [string componentsSeparatedByString:@";"];
    
    //DEBUG
    NSLog(@"MESSAGE : %@",[message objectForKey:@"CMD"]);
    //
    //[[ecranAccueil btnDrone] setTitle:string forState:UIControlStateNormal];
    //[[ecranAccueil btnAide] setTitle:[ArrayCommand objectAtIndex:0] forState:UIControlStateNormal];
    
    /* Détermination de l'axe */
    axe = [ArrayCommand objectAtIndex:0];
    if([ArrayCommand count]>1){
        valeur = [ArrayCommand objectAtIndex:1];
        //[[ecranAccueil btnDrone] setTitle:[ArrayCommand objectAtIndex:1] forState:UIControlStateNormal];
    }
    
    /*Récupération de la date courante */
    _dateOldCommand = [NSDate date];
    
    if([axe isEqualToString:@"MONTRE"]){
        NSLog(@"MONTRE");
        
        NSString* rep = [[NSString alloc] initWithFormat:@"%f;%f;%d;",accelerationSettingAccueil,hauteurMaxAccueil,_bInterieurAccueil];
        NSDictionary* response = @{@"response" : rep} ;
        if (replyHandler != nil) replyHandler(response);
        
        
        return;
        
    }
    
    if([axe isEqualToString:@"END"]){
        
        _bWatchActive = false;
        [_bebopDrone setFlag:0];
        [_bebopDrone setPitch:0];
        [_bebopDrone setRoll:0];
        [_bebopDrone setGaz:0];
        [_bebopDrone setYaw:0];
        
       
            NSDictionary* response = @{@"reply" : @"DONE"} ;
            if (replyHandler != nil) replyHandler(response);
        
        
        return;

    }
    
    
    /*Valeur vers drone*/
    if([axe isEqualToString:@"0"]){
        [_bebopDrone setFlag:0];
        [_bebopDrone setPitch:0];
        [_bebopDrone setRoll:0];
        [_bebopDrone setGaz:0];
        [_bebopDrone setYaw:0];
        
        NSString* rep = [[NSString alloc] initWithFormat:@"%f;%f;%d;",accelerationSettingAccueil,hauteurMaxAccueil,_bInterieurAccueil];
        NSLog(@"MESSAGE POUR 0 %@",rep);
        NSDictionary* response = @{@"reply" : rep} ;
        if (replyHandler != nil) replyHandler(response);
        
        _bWatchActive = true;
        
        
        
        dispatch_async(dispatch_get_main_queue(), ^{
           [ecranAccueil btnAide].enabled = NO;
           [ecranAccueil btnAide].alpha = 0.5;
           [ecranAccueil btnDrone].enabled = NO;
           [ecranAccueil btnDrone].alpha = 0.5;
           [ecranAccueil btnOptions].enabled = NO;
            [ecranAccueil btnOptions].alpha = 0.5;
            [[ecranAccueil labelMontre] setText:@"Montre active !"];
            [[ecranAccueil labelMontre] setTextColor:[UIColor redColor]];
            [ecranAccueil updateView:[[UIScreen mainScreen] bounds].size];
        });
        return;

        
    }else if([axe isEqualToString:@"X"]) {
        [_bebopDrone setPitch:[valeur intValue]];
        NSDictionary* response = @{@"reply" : @"DONE X"} ;
        if (replyHandler != nil) replyHandler(response);
    }else if([axe isEqualToString:@"Y"]){
        [_bebopDrone setRoll:[valeur intValue]];
        NSDictionary* response = @{@"reply" : @"DONE Y"} ;
        if (replyHandler != nil) replyHandler(response);
    }else if([axe isEqualToString:@"Z"]){
        // in background, gaz the drone
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
            [_bebopDrone setGaz:[valeur intValue]];
            NSLog(@"GAZ UP");
            [NSThread sleepForTimeInterval:0.5f];
            NSLog(@"GAZ END");
            [_bebopDrone setGaz:0];
        });
        NSDictionary* response = @{@"reply" : @"DONE Z"} ;
        if (replyHandler != nil) replyHandler(response);
    }else if([axe isEqualToString:@"D"]){
        [_bebopDrone takeOff];
        NSDictionary* response = @{@"reply" : @"DONE D"} ;
        if (replyHandler != nil) replyHandler(response);
    }else if([axe isEqualToString:@"A"]){
        [_bebopDrone land];
        NSDictionary* response = @{@"reply" : @"DONE A"} ;
        if (replyHandler != nil) replyHandler(response);
    }else if([axe isEqualToString:@"H"]){
        if(_homeActivate == false){
            _homeActivate = true;
            [_bebopDrone setViewCall:self];
            if(_bInterieurAccueil){
                [_bebopDrone returnHomeInterieur];
            }else{
                [_bebopDrone returnHomeExterieur];
            }
        }else{
            [_bebopDrone cancelReturnHome];
        }
        NSDictionary* response = @{@"reply" : @"DONE H"} ;
        if (replyHandler != nil) replyHandler(response);
    }else if([axe isEqualToString:@"P"]){ /*Paramètres depuis la montre */
        accel = [valeur floatValue];
        hauteur = [[ArrayCommand objectAtIndex:2] floatValue];
        interieur = [[ArrayCommand objectAtIndex:3] floatValue];
        
        [[ecranAccueil btnDrone] setTitle:[[NSString alloc]initWithFormat:@"%f,%f",accel,hauteur ] forState:UIControlStateNormal];
        [[ecranAccueil btnAide] setTitle:[[NSString alloc]initWithFormat:@"%d",interieur ] forState:UIControlStateNormal];
        
        [[NSUserDefaults standardUserDefaults] setDouble:accel forKey:@"Acceleration"];
        [[NSUserDefaults standardUserDefaults] setDouble:hauteur forKey:@"Hauteur"];

        [[NSUserDefaults standardUserDefaults] setDouble:hauteur forKey:@"InOut"];
        
        //Rechargement du drone pour application des paramètres
        _bebopDrone = nil;
        [self viewDidAppear:FALSE];
        NSDictionary* response = @{@"reply" : @"DONE P"} ;
        if (replyHandler != nil) replyHandler(response);
        
    }

    //replyHandler = [[NSDictionary alloc] initWithObjectsAndKeys:@"DONE",@"reply", nil];
    
}
/*Vérification s'il n'y a pas de déconnexion */
- (void) checkConnectivityWatch{
    
    if(_dateOldCommand == nil){
        [_bebopDrone setFlag:0];
        [_bebopDrone setPitch:0];
        [_bebopDrone setRoll:0];
        [_bebopDrone setGaz:0];
        [_bebopDrone setYaw:0];
        _bWatchActive = false;
        [ecranAccueil btnAide].enabled = YES;
        [ecranAccueil btnAide].alpha = 1;
        [ecranAccueil btnDrone].enabled = YES;
        [ecranAccueil btnDrone].alpha = 1;
        [ecranAccueil btnOptions].enabled = YES;
        [ecranAccueil btnOptions].alpha = 1;
        [[ecranAccueil labelMontre] setText:@""];
        [[ecranAccueil labelMontre] setTextColor:[UIColor redColor]];
        [ecranAccueil updateView:[[UIScreen mainScreen] bounds].size];

        return;
    }
    
        dispatch_async(dispatch_get_main_queue(), ^{
            NSLog(@"TIME : %f", [[NSDate date] timeIntervalSinceDate:_dateOldCommand] );
            if([[NSDate date] timeIntervalSinceDate:_dateOldCommand] > 1.0){
                [_bebopDrone setFlag:0];
                [_bebopDrone setPitch:0];
                [_bebopDrone setRoll:0];
                [_bebopDrone setGaz:0];
                [_bebopDrone setYaw:0];
                _bWatchActive = false;
                [ecranAccueil btnAide].enabled = YES;
                [ecranAccueil btnAide].alpha = 1;
                [ecranAccueil btnDrone].enabled = YES;
                [ecranAccueil btnDrone].alpha = 1;
                [ecranAccueil btnOptions].enabled = YES;
                [ecranAccueil btnOptions].alpha = 1;                [[ecranAccueil labelMontre] setText:@""];
                [[ecranAccueil labelMontre] setTextColor:[UIColor redColor]];
                [ecranAccueil updateView:[[UIScreen mainScreen] bounds].size];
            }else{
                [ecranAccueil btnAide].enabled = NO;
                [ecranAccueil btnAide].alpha = 0.5;
                [ecranAccueil btnDrone].enabled = NO;
                [ecranAccueil btnDrone].alpha = 0.5;
                [ecranAccueil btnOptions].enabled = NO;
                [ecranAccueil btnOptions].alpha = 0.5;
                [[ecranAccueil labelMontre] setText:@"Montre active !"];
                [[ecranAccueil labelMontre] setTextColor:[UIColor redColor]];
                [ecranAccueil updateView:[[UIScreen mainScreen] bounds].size];
            }
        });
   
    
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:YES];
    if(_bebopDrone == nil) {
        _dataSource = [NSArray array];
        _droneDiscoverer = [[DroneDiscoverer alloc] init];
        [_droneDiscoverer setDelegate:self];
        [self registerNotifications];
        [_droneDiscoverer startDiscovering];
    }
    
    /* Timer pour check la batterie */
    timerAccueil = [NSTimer scheduledTimerWithTimeInterval:10.0
                                                    target:self
                                                  selector:@selector(checkBattery)
                                                  userInfo:nil
                                                   repeats:YES];
    /* Timer pour check la montre*/
    timerWatch = [NSTimer scheduledTimerWithTimeInterval:3
                                                 target:self
                                               selector:@selector(checkConnectivityWatch)
                                               userInfo:nil
                                                repeats:YES];
    
    
    
    /* Récupération des options et mise en place des settings par defaut */
    hauteurMaxAccueil = [[NSUserDefaults standardUserDefaults] doubleForKey:@"Hauteur"];
    accelerationSettingAccueil = [[NSUserDefaults standardUserDefaults] doubleForKey:@"Acceleration"];
    _bInterieurAccueil = [[NSUserDefaults standardUserDefaults] boolForKey:@"InOut"];
    NSLog(@"INTERIEUR ACCUEIL %d",_bInterieurAccueil);
    
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
    [super viewDidDisappear:animated];
    [timerAccueil invalidate];
}

/**
 * @brief Déconnexion propre du drone
 */
- (void) deconnexionDrone{
    
    if(_service != nil){
        // in background, disconnect from the drone
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
            [_bebopDrone disconnect];
            // wait for the disconnection to appear
            dispatch_semaphore_wait(_stateSem, DISPATCH_TIME_FOREVER);
            _bebopDrone = nil;
            
            // dismiss the alert view in main thread
            dispatch_async(dispatch_get_main_queue(), ^{
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
    
    switch (state) {
        case ARCONTROLLER_DEVICE_STATE_RUNNING:
            break;
        case ARCONTROLLER_DEVICE_STATE_STOPPED:
            dispatch_semaphore_signal(_stateSem);
            break;
            
        default:
            
            break;
    }
}
/**
 * @brief Récupération du niveau de la batterie du drone
 */
- (void)bebopDrone:(BebopDrone*)bebopDrone batteryDidChange:(int)batteryPercentage {
    [ecranAccueil setBattery:[NSString stringWithFormat:@"Drone %d%%", batteryPercentage]];
    _batteryDrone = batteryPercentage;
    
    
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


/**
 * @brief Méthodes pour la rotation
 */
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
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
    return UIInterfaceOrientationMaskAll;
}
/**
 * @brief Méthodes pour la rotation
 */
- (UIInterfaceOrientation)preferredInterfaceOrientationForPresentation
{
    return UIInterfaceOrientationPortrait;
}

/**
 * @brief Méthode pour retirer la status bar
 */
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

/**
 * @brief vers le contrôle du drone
 */
-(void) goToDroneControl:(UIButton*)send{
    if(!_bWatchActive){
        droneViewActif = true;
        [self unregisterNotifications];
        [_droneDiscoverer stopDiscovering];
        [self deconnexionDrone];
    }
}
/**
 * @brief vers les options
 */
-(void) goToDroneOptions:(UIButton*)send{
    if(!_bWatchActive){
        ViewControllerOptions *secondController = [[ViewControllerOptions alloc] init];
        [self.navigationController pushViewController:secondController animated:YES];
    }
}
/**
 * @brief vers l'aide
 */
-(void) goToDroneHelp:(UIButton*)send{
    if(!_bWatchActive){
        ViewControllerOptions *secondController = [[ViewControllerAide alloc] init];
        [self.navigationController pushViewController:secondController animated:YES];
    }
}

@end
