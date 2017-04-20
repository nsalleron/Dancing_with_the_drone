//
//  InterfaceController.m
//  Jack Sparrot Watch Extension
//
//  Created by Nicolas Salleron on 22/02/2017.
//
//

#import "InterfaceController.h"
#import <WatchConnectivity/WatchConnectivity.h>
#import <CoreMotion/CoreMotion.h>
#import <HealthKit/HealthKit.h>
#define GAUCHE 0
#define DROITE 1
#define HAUT 2
#define BAS 3
#define AVANT 4
#define ARRIERE 5
#define STABLE 6
#define SURPLACE 7
#define THRESH 0.2

@interface InterfaceController()<WCSessionDelegate>

@property (nonatomic, strong) WCSession* session;
@property (readonly, nonatomic) double incX;
@property (readonly, nonatomic) double incY;
@property (readonly, nonatomic) double incZ;
@property (readonly, nonatomic) int incStabX;
@property (readonly, nonatomic) int incStabY;
@property (readonly, nonatomic) int incStabZ;
@property (readonly, nonatomic) double absX;
@property (readonly, nonatomic) double absY;
@property (readonly, nonatomic) double absZ;
@property (readonly, nonatomic) bool stabX;
@property (readonly, nonatomic) bool stabY;
@property (readonly, nonatomic) bool stabZ;
@property (readonly, nonatomic) int lastMoveX;
@property (readonly, nonatomic) int lastMoveY;
@property (readonly, nonatomic) int lastMoveZ;
@property (readonly, nonatomic) int flagMode;
@property (strong, nonatomic) CMMotionManager *motionManager;

@end

static NSString *sharedUserActivityType = @"fr.upmc.sar.project.Jack-Sparrot";
static NSString *sharedIdentifierKey = @"SALLERONGASC";
int currentDimensions = 1;
Boolean axeX = TRUE;
Boolean axeY = FALSE;
Boolean _enStatio = TRUE;
HKWorkoutSession *workoutSession;


@implementation InterfaceController

- (void) session:(WCSession *)session activationDidCompleteWithState:(WCSessionActivationState)activationState error:(NSError *)error{
    
}

- (void)awakeWithContext:(id)context {
    [super awakeWithContext:context];
    
}

/**
 * @brief Action sur l'axe Z pendant un swipe
 */
- (IBAction)swipeAction:(id)sender {
    
    
    
    WKSwipeGestureRecognizer* send = (WKSwipeGestureRecognizer*)sender;
    
    if(send.direction == WKSwipeGestureRecognizerDirectionRight){
        NSLog(@"RIGHT -> UP 30");
        
        
        NSDictionary *applicationDict = [[NSDictionary alloc] initWithObjectsAndKeys:@"Z;30",@"CMD", nil];
        [_session sendMessage:applicationDict
                                   replyHandler:^(NSDictionary *replyHandler) {
                                       NSLog(@"REPLY : %@",[replyHandler valueForKey:@"reply"]);
                                   }
                                   errorHandler:^(NSError *error) {
                                       NSLog(@"ERROR");
                                   }
         ];
        NSLog(@"DONE");
        
    }else if(send.direction == WKSwipeGestureRecognizerDirectionLeft){
        NSLog(@"LEFT -> Down -30");
        
        
        NSDictionary *applicationDict = [[NSDictionary alloc] initWithObjectsAndKeys:@"Z;-30",@"CMD", nil];
        [_session sendMessage:applicationDict
                                   replyHandler:^(NSDictionary *replyHandler) {
                                       NSLog(@"REPLY : %@",[replyHandler valueForKey:@"reply"]);
                                   }
                                   errorHandler:^(NSError *error) {
                                       NSLog(@"ERROR");
                                   }
         ];
        NSLog(@"DONE");
        
    }
    
}
/**
 * @brief Changement d'Axe X/Y
 */
- (IBAction)btnClick {
    if (currentDimensions ==1){
        if(axeX){
            [_btnChgMode setTitle:@"Axe X"];
            axeX = FALSE;
            axeY = FALSE;
        }else{
            [_btnChgMode setTitle:@"Axe Y"];
            axeX = TRUE;
            axeY = TRUE;
        }
    }
    
}

- (void)willActivate {
    // This method is called when watch view controller is about to be visible to user
    [super willActivate];
    
    [self updateUserActivity:sharedUserActivityType userInfo:[[NSDictionary alloc] initWithObjectsAndKeys:sharedIdentifierKey, @"123456", nil] webpageURL:nil];
    
    if ([WCSession isSupported]) {
        _session = [WCSession defaultSession];
        _session.delegate = self;
        [_session activateSession];
    }
    
    self.motionManager = [[CMMotionManager alloc] init];
    
    if (self.motionManager.deviceMotionAvailable) {
        
        
        _motionManager.deviceMotionUpdateInterval = 1.0/10.0F;
        [_motionManager startDeviceMotionUpdatesUsingReferenceFrame:CMAttitudeReferenceFrameXArbitraryCorrectedZVertical];
        [_motionManager startDeviceMotionUpdatesToQueue:[NSOperationQueue currentQueue] withHandler:^(CMDeviceMotion *motion, NSError *error) {
            [self mouvementDeviceMotion:motion];
        }];
        
        
    }else{
        [_btnDim setTitle:@"NON DISPONIBLE MOTIONMANAGER"];
    }
    
    
    
    
    
}


- (void)didDeactivate {
    // This method is called when watch view controller is no longer visible
    [super didDeactivate];
}


/**
 * @brief interprétation des mouvements via CoreMotion
 * @param motion Object CMDeviceMotion possédant les données CoreMotion
 * REM : Quasiment la même que la version mobile
 */
- (void) mouvementDeviceMotion:(CMDeviceMotion *)motion{
    
       /* Le mouvement est-il autorisé */
    if( _enStatio ){
        
        NSDictionary *applicationDict = [[NSDictionary alloc] initWithObjectsAndKeys:@"0;",@"CMD", nil];
        [_session sendMessage:applicationDict
                 replyHandler:^(NSDictionary *replyHandler) {
                     NSLog(@"REPLY : %@",[replyHandler valueForKey:@"reply"]);
                 }
                 errorHandler:^(NSError *error) {
                     NSLog(@"ERROR");
                 }
         ];
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

    
    /* Mouvement de FOWARD et BACKWARD */
    if(_absX > THRESH){
        if(_incX < -THRESH){
            if(_stabX){
                
                if(!axeY && currentDimensions == 1){
                    //[_btnDim setTitle:@"AVANT"];
                    NSDictionary *applicationDict = [[NSDictionary alloc] initWithObjectsAndKeys:@"X;100",@"CMD", nil];
                    [_session sendMessage:applicationDict
                             replyHandler:^(NSDictionary *replyHandler) {
                                 NSLog(@"REPLY : %@",[replyHandler valueForKey:@"reply"]);
                             }
                             errorHandler:^(NSError *error) {
                                 NSLog(@"ERROR");
                             }
                     ];
                    
                }else if(currentDimensions == 2 || currentDimensions == 3){
                    NSDictionary *applicationDict = [[NSDictionary alloc] initWithObjectsAndKeys:@"X;100",@"CMD", nil];
                    [_session sendMessage:applicationDict
                             replyHandler:^(NSDictionary *replyHandler) {
                                 NSLog(@"REPLY : %@",[replyHandler valueForKey:@"reply"]);
                             }
                             errorHandler:^(NSError *error) {
                                 NSLog(@"ERROR");
                             }
                     ];
                }
                _lastMoveX = ARRIERE;
                _stabX = NO;
            }else{
                
            }
        }else if(_incX > 0.2){
            if(_stabX){
                
                if(!axeY && currentDimensions == 1){
                    //[_btnDim setTitle:@"ARRIERE"];
                    NSDictionary *applicationDict = [[NSDictionary alloc] initWithObjectsAndKeys:@"X;-100",@"CMD", nil];
                    [_session sendMessage:applicationDict
                             replyHandler:^(NSDictionary *replyHandler) {
                                 NSLog(@"REPLY : %@",[replyHandler valueForKey:@"reply"]);
                             }
                             errorHandler:^(NSError *error) {
                                 NSLog(@"ERROR");
                             }
                     ];
                }else if(currentDimensions == 2 || currentDimensions == 3){
                    NSDictionary *applicationDict = [[NSDictionary alloc] initWithObjectsAndKeys:@"X;-100",@"CMD", nil];
                    [_session sendMessage:applicationDict
                             replyHandler:^(NSDictionary *replyHandler) {
                                 NSLog(@"REPLY : %@",[replyHandler valueForKey:@"reply"]);
                             }
                             errorHandler:^(NSError *error) {
                                 NSLog(@"ERROR");
                             }
                     ];
                    
                }
                _lastMoveX = AVANT;
                _stabX = NO;
            }else{
                NSLog(@"DECELERATION VERS L'ARRIERE");
            }
        }
        _incX = 0;
    }else{
        if(_incStabX < 6){
            //NSLog(@"LE CPT : %d", _incStabX);
            _incStabX++;
        }else{
            if(_lastMoveX != STABLE){
                //[_btnDim setTitle:@"STABLE X"];
                NSDictionary *applicationDict = [[NSDictionary alloc] initWithObjectsAndKeys:@"X;0",@"CMD", nil];
                [_session sendMessage:applicationDict
                         replyHandler:^(NSDictionary *replyHandler) {
                             NSLog(@"REPLY : %@",[replyHandler valueForKey:@"reply"]);
                         }
                         errorHandler:^(NSError *error) {
                             NSLog(@"ERROR");
                         }
                 ];
            }
            _stabX = YES;
            _lastMoveX = STABLE;
            _incStabX = 0;
        }
    }
    
    // DROITE / GAUCHE : OK
    if(_absY > THRESH){
        [_btnChgMode setTitle:[[NSString alloc] initWithFormat:@"val %f",_incY]];
        if(_incY < -THRESH){
            
            if(_stabY){
                
                if(axeY && currentDimensions == 1){
                    //[_btnDim setTitle:@"DROITE"];
                    NSDictionary *applicationDict = [[NSDictionary alloc] initWithObjectsAndKeys:@"Y;100",@"CMD", nil];
                    [_session sendMessage:applicationDict
                             replyHandler:^(NSDictionary *replyHandler) {
                                 NSLog(@"REPLY : %@",[replyHandler valueForKey:@"reply"]);
                             }
                             errorHandler:^(NSError *error) {
                                 NSLog(@"ERROR");
                             }
                     ];
                    /*
                     [_bebopDrone setFlag:1];
                     [_bebopDrone setRoll:100];
                     */
                }else if(currentDimensions == 2 || currentDimensions == 3){
                    NSDictionary *applicationDict = [[NSDictionary alloc] initWithObjectsAndKeys:@"Y;100",@"CMD", nil];
                    [_btnDim setTitle:@"DROITE"];
                    [_session sendMessage:applicationDict
                             replyHandler:^(NSDictionary *replyHandler) {
                                 NSLog(@"REPLY : %@",[replyHandler valueForKey:@"reply"]);
                             }
                             errorHandler:^(NSError *error) {
                                 NSLog(@"ERROR");
                             }
                     ];
                    /*
                     [_bebopDrone setFlag:1];
                     [_bebopDrone setRoll:100];
                     */
                }
                _lastMoveY = DROITE;
                _stabY = NO;
            }else{
                NSLog(@"DECELERATION VERS LA GAUCHE");
            }
        }else if(_incY > THRESH){
            if(_stabY){
                
                if(axeY && currentDimensions == 1){
                    [_btnDim setTitle:@"GAUCHE"];
                    NSDictionary *applicationDict = [[NSDictionary alloc] initWithObjectsAndKeys:@"Y;-100",@"CMD", nil];
                    [_session sendMessage:applicationDict
                             replyHandler:^(NSDictionary *replyHandler) {
                                 NSLog(@"REPLY : %@",[replyHandler valueForKey:@"reply"]);
                             }
                             errorHandler:^(NSError *error) {
                                 NSLog(@"ERROR");
                             }
                     ];
                    /*
                     [_bebopDrone setFlag:1];
                     [_bebopDrone setRoll:-100];
                     */
                }else if(currentDimensions == 2 || currentDimensions == 3){
                    NSDictionary *applicationDict = [[NSDictionary alloc] initWithObjectsAndKeys:@"Y;-100",@"CMD", nil];
                    [_btnDim setTitle:@"GAUCHE"];
                    [_session sendMessage:applicationDict
                             replyHandler:^(NSDictionary *replyHandler) {
                                 NSLog(@"REPLY : %@",[replyHandler valueForKey:@"reply"]);
                             }
                             errorHandler:^(NSError *error) {
                                 NSLog(@"ERROR");
                             }
                     ];
                    /*
                     [_bebopDrone setFlag:1];
                     [_bebopDrone setRoll:-100];
                     */
                }
                _lastMoveY = GAUCHE;
                _stabY = NO;
            }else{
                NSLog(@"DECELERATION VERS LA DROITE");
            }
        }
        _incY = 0;
    }else{
        if(_incStabY < 6){
            //NSLog(@"LE CPT : %d", _cptStables);
            _incStabY++;
        }else{
            if(_lastMoveY != STABLE){
                //[_btnDim setTitle:@"STABLE"];
                NSDictionary *applicationDict = [[NSDictionary alloc] initWithObjectsAndKeys:@"Y;0",@"CMD", nil];
                [_session sendMessage:applicationDict
                         replyHandler:^(NSDictionary *replyHandler) {
                             NSLog(@"REPLY : %@",[replyHandler valueForKey:@"reply"]);
                         }
                         errorHandler:^(NSError *error) {
                             NSLog(@"ERROR");
                         }
                 ];
            }
            _stabY = YES;
            _lastMoveY = STABLE;
            _incStabY = 0;
        }
    }
    
    // HAUT / BAS : OK
    if(_absZ > THRESH){
        if(_incZ < -THRESH){
            if(_stabZ){
                NSLog(@"HAUT");
                if(currentDimensions == 3){
                    NSDictionary *applicationDict = [[NSDictionary alloc] initWithObjectsAndKeys:@"Z;100",@"CMD", nil];
                    [_session sendMessage:applicationDict
                             replyHandler:^(NSDictionary *replyHandler) {
                                 NSLog(@"REPLY : %@",[replyHandler valueForKey:@"reply"]);
                             }
                             errorHandler:^(NSError *error) {
                                 NSLog(@"ERROR");
                             }
                     ];
                }
                _lastMoveZ = HAUT;
                _stabZ = NO;
            }else{
                NSLog(@"DECELERATION VERS LE BAS");
            }
        }else if(_incZ > THRESH){
            if(_stabZ){
                NSLog(@"BAS");
                if(currentDimensions == 3){
                    NSDictionary *applicationDict = [[NSDictionary alloc] initWithObjectsAndKeys:@"Z;-100",@"CMD", nil];
                    [_session sendMessage:applicationDict
                             replyHandler:^(NSDictionary *replyHandler) {
                                 NSLog(@"REPLY : %@",[replyHandler valueForKey:@"reply"]);
                             }
                             errorHandler:^(NSError *error) {
                                 NSLog(@"ERROR");
                             }
                     ];
                }
                _lastMoveZ = BAS;
                _stabZ = NO;
            }else{
                NSLog(@"DECELERATION VERS LE HAUT");
            }
        }
        _incZ = 0;
    }else{
        if(_incStabZ < 6){
            //NSLog(@"LE CPT : %d", _cptStables);
            _incStabZ++;
        }else{
            if(_lastMoveZ != STABLE){
                NSLog(@"STABLE Z");
                NSDictionary *applicationDict = [[NSDictionary alloc] initWithObjectsAndKeys:@"Z;0",@"CMD", nil];
                [_session sendMessage:applicationDict
                         replyHandler:^(NSDictionary *replyHandler) {
                             NSLog(@"REPLY : %@",[replyHandler valueForKey:@"reply"]);
                         }
                         errorHandler:^(NSError *error) {
                             NSLog(@"ERROR");
                         }
                 ];
            }
            _stabZ = YES;
            _lastMoveZ = STABLE;
            _incStabZ = 0;
        }
    }
    
}

/**
 * @brief Handler pour les action sur le bouton de changement de dimensions
 */
- (IBAction)actionbtnClick {
    if(currentDimensions == 3) currentDimensions = 0;
    
    currentDimensions = (currentDimensions+1);
    
    switch (currentDimensions) {
        case 1:
            [_btnChgMode setTitle:@"Axe X"];
            axeX = TRUE;
            break;
            
        case 2:
        case 3:
            [_btnChgMode setTitle:@"<- Axe Z ->"];
            break;
        default:
            break;
    }
    if(currentDimensions == 1){
        [_btnDim setTitle:@"1 Dim."];
    }
    if(currentDimensions == 2){
        [_btnDim setTitle:@"2 Dim."];
    }
    if(currentDimensions == 3){
        [_btnDim setTitle:@"3 Dim."];
    }
}

/**
 * @brief Changement mode stationnaire
 */
- (IBAction)chgModeStationnaire:(BOOL)value {
    if(_enStatio){
        _enStatio = false;
    }else{
        _enStatio = true;
    }
}
/**
 * @brief Lancement de la vue Options
 */
- (IBAction)goToOptions {
    
    [self presentControllerWithName:@"options" context:@"Sortir"];
}

/**
 * @brief Lancement décollage
 */
- (IBAction)startTakeOff {
    NSLog(@"TAKEOFF");
    NSDictionary *applicationDict = [[NSDictionary alloc] initWithObjectsAndKeys:@"D",@"CMD", nil];
    [_session sendMessage:applicationDict
             replyHandler:^(NSDictionary *replyHandler) {
                 NSLog(@"REPLY : %@",[replyHandler valueForKey:@"reply"]);
             }
             errorHandler:^(NSError *error) {
                 NSLog(@"ERROR"); 
             }
     ];
}

/**
 * @brief Lancement atterrissage
 */
- (IBAction)startLanding {
    NSLog(@"LAND");
    NSDictionary *applicationDict = [[NSDictionary alloc] initWithObjectsAndKeys:@"A",@"CMD", nil];
    [_session sendMessage:applicationDict
             replyHandler:^(NSDictionary *replyHandler) {
                 NSLog(@"REPLY : %@",[replyHandler valueForKey:@"reply"]);
             }
             errorHandler:^(NSError *error) {
                 NSLog(@"ERROR");
             }
     ];
}
/**
 * @brief Lancement retour home
 */
- (IBAction)startHome {
    NSLog(@"HOME");
    NSDictionary *applicationDict = [[NSDictionary alloc] initWithObjectsAndKeys:@"H",@"CMD", nil];
    [_session sendMessage:applicationDict
             replyHandler:^(NSDictionary *replyHandler) {
                 NSLog(@"REPLY : %@",[replyHandler valueForKey:@"reply"]);
             }
             errorHandler:^(NSError *error) {
                 NSLog(@"ERROR");
             }
    ];
    
    WKAlertAction *action =
    [WKAlertAction actionWithTitle:@"Annuler"
                             style:WKAlertActionStyleDefault
     
                           handler:^{
                               [_session sendMessage:applicationDict
                                        replyHandler:^(NSDictionary *replyHandler) {
                                            NSLog(@"REPLY : %@",[replyHandler valueForKey:@"reply"]);
                                        }
                                        errorHandler:^(NSError *error) {
                                            NSLog(@"ERROR");
                                        }
                                ];
                           }];
    
    NSString *title = @"Home";
    NSString *message = @"Fonction home en cours.";
    
    [self presentAlertControllerWithTitle:title
     message:message
     preferredStyle:WKAlertControllerStyleAlert
     actions:@[ action ]];
}

@end



