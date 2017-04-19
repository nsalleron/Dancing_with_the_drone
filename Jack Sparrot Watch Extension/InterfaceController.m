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

@interface InterfaceController()<WCSessionDelegate>
typedef enum {GAUCHE, DROITE, HAUT, BAS, AVANT, ARRIERE, STABLE} moves;
typedef enum {TROIS_D, SURPLACE} modes;
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
@property (readonly, nonatomic) moves lastMoveX;
@property (readonly, nonatomic) moves lastMoveY;
@property (readonly, nonatomic) moves lastMoveZ;

@property (readonly, nonatomic) modes flagMode;
@property (strong, nonatomic) CMMotionManager *motionManager;

@end

static NSString *sharedUserActivityType = @"fr.upmc.sar.project.Jack-Sparrot";
static NSString *sharedIdentifierKey = @"SALLERONGASC";
int currentDimensions = 1;
Boolean axeX = TRUE;
Boolean _enStatio = TRUE;

@implementation InterfaceController

- (void) session:(WCSession *)session activationDidCompleteWithState:(WCSessionActivationState)activationState error:(NSError *)error{
    
}

- (void)awakeWithContext:(id)context {
    [super awakeWithContext:context];

    
    
    WKPickerItem *unD = [[WKPickerItem alloc] init];
    unD.title = @"1 Dimension.";
    
    WKPickerItem *deuxD = [[WKPickerItem alloc] init];
    deuxD.title = @"2 Dimensions.";
    
    WKPickerItem *troisD = [[WKPickerItem alloc] init];
    troisD.title = @"3 Dimensions.";
    
    _pickerItems = @[unD, deuxD, troisD];
    

    // Connect data
    [_tp setItems:self.pickerItems];
    [_tp setSelectedItemIndex:0];

    
}

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
- (IBAction)btnClick {
    if (currentDimensions ==0){
        if(axeX){
            [_btnChgMode setTitle:@"Axe X"];
            axeX = FALSE;
        }else{
            [_btnChgMode setTitle:@"Axe Y"];
            axeX = TRUE;
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
    }else{
        //WKAlertAction *act = [WKAlertAction actionWithTitle:@"OK" style:WKAlertActionStyleCancel handler:^(void){
            //exit(0);
       // }];
        
       // NSArray *actions = @[act];
        
       // [self presentAlertControllerWithTitle:@"Attention !" message:@"La connexion au mobile est impossible." preferredStyle:WKAlertControllerStyleAlert actions:actions];
    }
    
    if (![_session isReachable]) {
        // Do something
        /*
        WKAlertAction *act = [WKAlertAction actionWithTitle:@"OK" style:WKAlertActionStyleCancel handler:^(void){
            //exit(0);
        }];
        
        NSArray *actions = @[act];
        
        [self presentAlertControllerWithTitle:@"Attention !" message:@"Le mobile n'est pas détecté." preferredStyle:WKAlertControllerStyleAlert actions:actions];
        */
        
    }
    
    if (self.motionManager.deviceMotionAvailable) {
        
        _motionManager.deviceMotionUpdateInterval = 1.0/60.0F;
        [_motionManager startDeviceMotionUpdatesToQueue:[NSOperationQueue currentQueue] withHandler:^(CMDeviceMotion *motion, NSError *error) {
            [self mouvementDeviceMotion:motion];
        }];
        
        
    }
}


- (void)didDeactivate {
    // This method is called when watch view controller is no longer visible
    [super didDeactivate];
}

- (void) mouvementDeviceMotion:(CMDeviceMotion *)motion{
    
    /* Le mouvement est-il autorisé */
    
    if( _enStatio ){
        
        NSDictionary *applicationDict = [[NSDictionary alloc] initWithObjectsAndKeys:@"0",@"CMD", nil];
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
    
    
    /*  0 = STABLE
     1 = LEFT
     2 = RIGHT
     3 = UP
     4 = DOWN
     5 = FOWARD
     6 = BACKWARD
     */
    
    /* Mouvement de FOWARD et BACKWARD */
    if(_absX > 0.2){
        if(_incX < -0.2){
            if(_stabX){    //FOWARD
                
                if(axeX && currentDimensions == 1){
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
                _lastMoveX = 5;
                _stabX = NO;
            }
        }else if(_incX > 0.2){
            if(_stabX){    //BACKWARD
                NSLog(@"ARRIERE");
               
                if(axeX && currentDimensions == 1){
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
                _lastMoveX = 6;
                _stabX = NO;
            }
            _incX = 0;
        }else{
            if(_incStabX < 40){
                _incStabX++;
            }else{
                if(_lastMoveX != 0){
                    NSLog(@"STABLE X");
                    
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
                _lastMoveX = 0;
                _incStabX = 0;
            }
        }
        
        
        // DROITE / GAUCHE : OK
        if(_absY > 0.2){
            if(_incY < -0.2){
                if(_stabY){    //DROITE
                    if(!axeX && currentDimensions == 1){
                        /*
                        [_bebopDrone setFlag:1];
                        [_bebopDrone setRoll:100];
                         */
                    }else if(currentDimensions == 2 || currentDimensions == 3){
                        /*
                        [_bebopDrone setFlag:1];
                        [_bebopDrone setRoll:100];
                         */
                    }
                    _lastMoveY = 2;
                    _stabY = NO;
                }
            }else if(_incY > 0.2){
                if(_stabY){    //GAUCHE
                    if(!axeX && currentDimensions == 1){
                        /*
                        [_bebopDrone setFlag:1];
                        [_bebopDrone setRoll:-100];
                         */
                    }else if(currentDimensions == 2 || currentDimensions == 3){
                        /*
                        [_bebopDrone setFlag:1];
                        [_bebopDrone setRoll:-100];
                        */
                    }
                    _lastMoveY = 1;
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
                if(_lastMoveY != 0){    // NOMOVE
                    /*
                    [_bebopDrone setFlag:0];
                    [_bebopDrone setRoll:0];
                     */
                }
                _stabY = YES;
                _lastMoveY = 0;
                _incStabY = 0;
            }
        }
        
        
        // HAUT / BAS : OK
        if(_flagMode != 0){
            if(_absZ > 0.2){
                if(_incZ < -0.2){
                    if(_stabZ){
                        NSLog(@"HAUT");
                        // in background, gaz the drone
                        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
                            //[_bebopDrone setGaz:100];
                            NSLog(@"GAZ UP");
                            [NSThread sleepForTimeInterval:0.5f];
                            NSLog(@"GAZ DOWN");
                            //[_bebopDrone setGaz:0];
                        });
                        _lastMoveZ = 3;
                        _stabZ = NO;
                    }else{
                        NSLog(@"DECELERATION VERS LE BAS");
                    }
                }else if(_incZ > 0.2){
                    if(_stabZ){
                        NSLog(@"BAS");
                        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
                            //[_bebopDrone setGaz:-100];
                            NSLog(@"GAZ UP");
                            [NSThread sleepForTimeInterval:0.5f];
                            NSLog(@"GAZ DOWN");
                            //[_bebopDrone setGaz:0];
                        });
                        _lastMoveZ = 4;
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
                    if(_lastMoveZ != 0){
                        NSLog(@"STABLE Z");
                        //[_bebopDrone setGaz:0];
                    }
                    _stabZ = YES;
                    _lastMoveZ = 0;
                    _incStabZ = 0;
                }
            }
        }
    }
}



- (IBAction)pickerAction:(NSInteger)value {
    currentDimensions=value;
    switch (currentDimensions) {
        case 0:
            [_btnChgMode setTitle:@"Axe X"];
            axeX = FALSE;
            break;
            
        case 1:
        case 2:
            [_btnChgMode setTitle:@"<- Axe Z ->"];
            break;
        default:
            break;
    }
}

- (IBAction)chgModeStationnaire:(BOOL)value {
    if(_enStatio){
        _enStatio = false;
    }else{
        _enStatio = true;
    }
}

- (IBAction)goToOptions {
    
    [self presentControllerWithName:@"options" context:nil];
}

- (IBAction)startTakeOff {
}


- (IBAction)startLanding {
}

- (IBAction)startHome {
}

@end



