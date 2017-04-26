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
#define STATIONNAIRE 6
#define THRESHSTABILITE 6
#define THRESH 0.3


@interface InterfaceController()<WCSessionDelegate>

@property (readwrite,nonatomic, strong) WCSession* session;
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

- (void) session:(WCSession *)session activationDidCompleteWithState:(WCSessionActivationState)activationState error:(NSError *)error{}

- (void)workoutSession:(HKWorkoutSession *)workoutSession didFailWithError:(NSError *)error{}

- (void)awakeWithContext:(id)context {
    [super awakeWithContext:context];
    [self updateUserActivity:sharedUserActivityType userInfo:[[NSDictionary alloc] initWithObjectsAndKeys:sharedIdentifierKey, @"123456", nil] webpageURL:nil];
    
    if ([WCSession isSupported]) {
        _session = [WCSession defaultSession];
        _session.delegate = self;
        [_session activateSession];
    }

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
    
    
    NSDictionary *applicationDict = [[NSDictionary alloc] initWithObjectsAndKeys:@"MONTRE;",@"CMD", nil];
    [_session sendMessage:applicationDict
     
             replyHandler:^(NSDictionary *replyHandler) {
                 
                 NSLog(@"REPLY PARAMS: %@",[replyHandler valueForKey:@"response"]); //PARAMETRES DU MOBILE
                 NSArray * ArrayCommand = [[NSArray alloc] init];
                 ArrayCommand = [[replyHandler valueForKey:@"response"]componentsSeparatedByString:@";"];
                 
                 [[NSUserDefaults standardUserDefaults] setDouble:[ArrayCommand[0] doubleValue] forKey:@"Acceleration"];
                 [[NSUserDefaults standardUserDefaults] setDouble:[ArrayCommand[1] doubleValue] forKey:@"Hauteur"];
                 [[NSUserDefaults standardUserDefaults] setBool:[ArrayCommand[2] boolValue] forKey:@"InOut"];
                 
             }
     
             errorHandler:^(NSError *error) {
                 NSLog(@"ERROR");
             }
     ];
    
    self.motionManager = [[CMMotionManager alloc] init];
    
    if (self.motionManager.deviceMotionAvailable) {
        
        
        _motionManager.deviceMotionUpdateInterval = 1.0/5.0F;
        [_motionManager startDeviceMotionUpdatesUsingReferenceFrame:CMAttitudeReferenceFrameXArbitraryCorrectedZVertical];
        [_motionManager startDeviceMotionUpdatesToQueue:[NSOperationQueue currentQueue] withHandler:^(CMDeviceMotion *motion, NSError *error) {
            [self mouvementDeviceMotion:motion];
        }];
        
        
    }
    
    
    
}


- (void)didDeactivate {
    // This method is called when watch view controller is no longer visible
    [super didDeactivate];
    self.motionManager = nil;
    NSDictionary *applicationDict = [[NSDictionary alloc] initWithObjectsAndKeys:@"END;",@"CMD", nil];
    [_session sendMessage:applicationDict
     
             replyHandler:^(NSDictionary *replyHandler) {
                 
             }
     
             errorHandler:^(NSError *error) {
             }
     ];
    
    
}



/**
 * @brief interprétation des mouvements via CoreMotion
 * @param motion Object CMDeviceMotion possédant les données CoreMotion
 * REM : Quasiment la même que la version mobile
 */
- (void) mouvementDeviceMotion:(CMDeviceMotion *)motion{
    NSDictionary *applicationDict;
    /* Le mouvement est-il autorisé */
    if( _enStatio ){
        
        applicationDict = [[NSDictionary alloc] initWithObjectsAndKeys:@"0;",@"CMD", nil];
        [_session sendMessage:applicationDict
                 replyHandler:^(NSDictionary *replyHandler) {
                     //NSLog(@"REPLY : %@",[replyHandler valueForKey:@"PARAMS"]);
                     //[_btnDim setTitle:@"PARAMS rep"];
                     //[_btnChgMode setTitle:[[NSString alloc ] initWithFormat:@"%@",[replyHandler valueForKey:@"reply"]]];
                     NSArray * ArrayCommand = [[NSArray alloc] init];
                     ArrayCommand = [[replyHandler valueForKey:@"reply"]componentsSeparatedByString:@";"];
                     
                     [[NSUserDefaults standardUserDefaults] setDouble:[ArrayCommand[0] doubleValue] forKey:@"Acceleration"];
                     [[NSUserDefaults standardUserDefaults] setDouble:[ArrayCommand[1] doubleValue] forKey:@"Hauteur"];
                     [[NSUserDefaults standardUserDefaults] setBool:[ArrayCommand[2] boolValue] forKey:@"InOut"];
                     return;

                 }
                 errorHandler:^(NSError *error) {
                     NSLog(@"ERROR REPLY");
                 }
         ];
        return;
    }
    
    
    Boolean MVTX = false,
            MVTY = false,
            MVTZ = false;
    
    /* Récupération de l'userAcceleration */
    _incX = motion.userAcceleration.x;
    _incY = motion.userAcceleration.y;
    _incZ = motion.userAcceleration.z;
    
    /* Vérification si mouvement */
    _absX = fabs(_incX);
    _absY = fabs(_incY);
    _absZ = fabs(_incZ);
    applicationDict = [[NSDictionary alloc] initWithObjectsAndKeys:[[NSString alloc] initWithFormat:@"X;%f",_incX],@"CMD", nil];
    [_session sendMessage:applicationDict
             replyHandler:^(NSDictionary *replyHandler) {
                 NSLog(@"REPLY : %@",[replyHandler valueForKey:@"reply"]);
             }
             errorHandler:^(NSError *error) {
                 NSLog(@"ERROR");
             }
     ];
    
    if(_absX > THRESH){
        MVTX = true;
    }else{
        if(_incStabX < THRESHSTABILITE){
            _incStabX++;
        }else{
            if(_lastMoveX != STATIONNAIRE){
                applicationDict = [[NSDictionary alloc] initWithObjectsAndKeys:@"X;0",@"CMD", nil];
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
            _lastMoveX = STATIONNAIRE;
            _incStabX = 0;
            //[_btnDim setTitle:@"STABLE"];
        }
    }
    
    if(_absY > THRESH){
        MVTY = true;
    }else{
        if(_incStabY < THRESHSTABILITE){
            _incStabY++;
        }else{
            if(_lastMoveY != STATIONNAIRE){
                applicationDict = [[NSDictionary alloc] initWithObjectsAndKeys:@"Y;0",@"CMD", nil];
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
            _lastMoveY = STATIONNAIRE;
            _incStabY = 0;
            //[_btnDim setTitle:@"STABLE"];
        }
    }
    
    if(_absZ > THRESH){
        MVTZ = true;
    }else{
        if(_incStabZ < THRESHSTABILITE){
            _incStabZ++;
        }else{
            if(_lastMoveZ != STATIONNAIRE){
                applicationDict = [[NSDictionary alloc] initWithObjectsAndKeys:@"Z;0",@"CMD", nil];
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
            _lastMoveZ = STATIONNAIRE;
            _incStabZ = 0;
            //[_btnDim setTitle:@"STABLE"];
        }
    }
    
    if(MVTX == false && MVTY == false && MVTZ == false) return; /* Pas besoin d'en faire plus */
    
    
    /* Si mouvement en X ou Y ou Z alors on applique suivant le sens*/
    if(MVTX){
        [_btnChgMode setTitle:[[NSString alloc] initWithFormat:@"X : %f",_incX]];
        if(_incX < -THRESH && _stabX){
            [_btnDim setTitle:@"AVANT"];
            if(!axeY && currentDimensions == 1){
                
                applicationDict = [[NSDictionary alloc] initWithObjectsAndKeys:@"X;100",@"CMD", nil];
                [_session sendMessage:applicationDict
                         replyHandler:^(NSDictionary *replyHandler) {
                             NSLog(@"REPLY : %@",[replyHandler valueForKey:@"reply"]);
                         }
                         errorHandler:^(NSError *error) {
                             NSLog(@"ERROR");
                         }
                 ];
                
            }else if(currentDimensions == 2 || currentDimensions == 3){
                applicationDict = [[NSDictionary alloc] initWithObjectsAndKeys:@"X;100",@"CMD", nil];
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
        }else if(_incX > THRESH && _stabX){
            [_btnDim setTitle:@"ARRIERE"];
            if(!axeY && currentDimensions == 1){
                
                applicationDict = [[NSDictionary alloc] initWithObjectsAndKeys:@"X;-100",@"CMD", nil];
                [_session sendMessage:applicationDict
                         replyHandler:^(NSDictionary *replyHandler) {
                             NSLog(@"REPLY : %@",[replyHandler valueForKey:@"reply"]);
                         }
                         errorHandler:^(NSError *error) {
                             NSLog(@"ERROR");
                         }
                 ];
            }else if(currentDimensions == 2 || currentDimensions == 3){
                applicationDict = [[NSDictionary alloc] initWithObjectsAndKeys:@"X;-100",@"CMD", nil];
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
        }
        _incX = 0;
    }
    
    
    if(MVTY){
        //[_btnChgMode setTitle:[[NSString alloc] initWithFormat:@"Y : %f",_incY]];
        if(_incY < -THRESH && _stabY){
            NSLog(@"DROITE");
            if(axeY && currentDimensions == 1){
                [_btnDim setTitle:@"DROITE"];
                applicationDict = [[NSDictionary alloc] initWithObjectsAndKeys:@"Y;100",@"CMD", nil];
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
                applicationDict = [[NSDictionary alloc] initWithObjectsAndKeys:@"Y;100",@"CMD", nil];
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
        }else if(_incY > THRESH && _stabY){
            if(axeY && currentDimensions == 1){
                [_btnDim setTitle:@"GAUCHE"];
                applicationDict = [[NSDictionary alloc] initWithObjectsAndKeys:@"Y;-100",@"CMD", nil];
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
                applicationDict = [[NSDictionary alloc] initWithObjectsAndKeys:@"Y;-100",@"CMD", nil];
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
            
        }
        _incY = 0;
    }
    
    if(MVTZ){
        if(_incZ < -THRESH && _stabZ){
            [_btnDim setTitle:@"HAUT"];
            if(currentDimensions == 3){
                applicationDict = [[NSDictionary alloc] initWithObjectsAndKeys:@"Z;100",@"CMD", nil];
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
        }else if(_incZ > THRESH && _stabZ){
            [_btnDim setTitle:@"BAS"];
            if(currentDimensions == 3){
                applicationDict = [[NSDictionary alloc] initWithObjectsAndKeys:@"Z;-100",@"CMD", nil];
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
        }
        _incZ = 0;
    }
}

/**
 * @brief Handler pour les actions sur le bouton de changement de dimensions
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
 * @brief Lancement retour Home
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



