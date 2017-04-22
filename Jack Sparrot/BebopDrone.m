//
//  BebopDrone.m
//  SDKSample
//

#import "BebopDrone.h"
#import "BebopDroneRecord.h"
#import "ViewControllerManuel.h"
#import <UIKit/UIKit.h>

#define FTP_PORT 21

@interface BebopDrone ()<UIAlertViewDelegate>


@property (nonatomic, assign) ARCONTROLLER_Device_t *deviceController; /* Objet controle drone */
@property (nonatomic, assign) ARService *service;
@property (nonatomic, assign) eARCONTROLLER_DEVICE_STATE connectionState;
@property (nonatomic, assign) eARCOMMANDS_ARDRONE3_PILOTINGSTATE_FLYINGSTATECHANGED_STATE flyingState;
@property (nonatomic, strong) NSString *currentRunId;
@property (nonatomic) dispatch_semaphore_t resolveSemaphore;
@property (nonatomic,strong) NSMutableArray *timeIntervalArray;
@property (nonatomic, strong) NSDate *currentDateX;
@property (nonatomic, strong) NSDate *oldDateX;
@property (nonatomic, strong) NSDate *currentDateY;
@property (nonatomic, strong) NSDate *oldDateY;
@property (nonatomic, strong) NSDate *currentDateZ;
@property (nonatomic, strong) NSDate *oldDateZ;
@property (nonatomic) int8_t oldPitch;
@property (nonatomic) int8_t oldRoll;
@property (nonatomic) int8_t oldGaz;
@property (nonatomic) int    nbPitch;
@property (nonatomic) int    nbRoll;
@property (nonatomic) int    nbGaz;
@property (nonatomic, strong) UIAlertView *returnHomeAlert;
@property (nonatomic) boolean homeExterieur;
@property (nonatomic) boolean returnHome;
@property (nonatomic) int nbMouvement;
@property (nonatomic) int oldValue;
@property (nonatomic) int sumValueX;
@property (nonatomic) int sumValueY;
@property (nonatomic) int sumValueZ;
@property (nonatomic) float interval;
@property (nonatomic) NSString *oldDirection;
@property (nonatomic) float timeForThisMouvement;
@property (nonatomic) dispatch_semaphore_t stateSem;
@property (nonatomic) ViewControllerManuel* manuel;
@property (nonatomic) int Flying;
@end

float altitudeDrone;
float acceleration;

@implementation BebopDrone


-(id)initWithService:(ARService *)service {
    self = [super init];
    if (self) {
        _service = service;
        _flyingState = ARCOMMANDS_ARDRONE3_PILOTINGSTATE_FLYINGSTATECHANGED_STATE_LANDED;
    }
    _oldDateX = nil;
    _oldDateY = nil;
    _oldDateZ = nil;
    _oldPitch = 0;
    _oldRoll = 0;
    _oldGaz = 0;
    _timeIntervalArray = [[NSMutableArray alloc] init];
    _returnHome = false;
    _homeExterieur = false;
    _nbMouvement = 0;
    _oldValue = 0;
    _sumValueX = 0;
    _oldDirection = nil;
    _timeForThisMouvement = 0;
    return self;
}

/**
 * @brief NE PAS UTILISER. Uniquement pour le debug quand le drone n'est pas disponible
 */
- (id) init{
    
    self = [super init];
    if (self) {
        _oldDateX = nil;
        _oldDateY = nil;
        _oldDateZ = nil;
        _oldPitch = 0;
        _oldRoll = 0;
        _oldGaz = 0;
        _timeIntervalArray = [[NSMutableArray alloc] init];
        _returnHome = false;
        _homeExterieur = false;
        _nbMouvement = 0;
        _oldValue = 0;
        _sumValueX = 0;
        _oldDirection = nil;
        _timeForThisMouvement = 0;
    }
    return self;
    
}

- (void)dealloc
{
    if (_deviceController) {
        ARCONTROLLER_Device_Delete(&_deviceController);
    }
}

- (void)connect {
    
    if (!_deviceController) {
        // call createDeviceControllerWithService in background
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
            // if the product type of the service matches with the supported types
            eARDISCOVERY_PRODUCT product = _service.product;
            eARDISCOVERY_PRODUCT_FAMILY family = ARDISCOVERY_getProductFamily(product);
            if (family == ARDISCOVERY_PRODUCT_FAMILY_ARDRONE) {
                // create the device controller
                [self createDeviceControllerWithService:_service];
                
            }
        });
    } else {
        ARCONTROLLER_Device_Start (_deviceController);
    }
}

- (void)disconnect {
    ARCONTROLLER_Device_Stop (_deviceController);
}

- (eARCONTROLLER_DEVICE_STATE)connectionState {
    return _connectionState;
}

- (eARCOMMANDS_ARDRONE3_PILOTINGSTATE_FLYINGSTATECHANGED_STATE)flyingState {
    return _flyingState;
}

- (void)createDeviceControllerWithService:(ARService*)service {
    // first get a discovery device
    ARDISCOVERY_Device_t *discoveryDevice = [self createDiscoveryDeviceWithService:service];
    
    if (discoveryDevice != NULL) {
        eARCONTROLLER_ERROR error = ARCONTROLLER_OK;
        
        // create the device controller
        _deviceController = ARCONTROLLER_Device_New (discoveryDevice, &error);
        
        // add the state change callback to be informed when the device controller starts, stops...
        if (error == ARCONTROLLER_OK) {
            error = ARCONTROLLER_Device_AddStateChangedCallback(_deviceController, stateChanged, (__bridge void *)(self));
        }
        
        // add the command received callback to be informed when a command has been received from the device
        if (error == ARCONTROLLER_OK) {
            error = ARCONTROLLER_Device_AddCommandReceivedCallback(_deviceController, onCommandReceived, (__bridge void *)(self));
        }
        
        // add the received frame callback to be informed when a frame should be displayed
        if (error == ARCONTROLLER_OK) {
            error = ARCONTROLLER_Device_SetVideoStreamMP4Compliant(_deviceController, 1);
        }
        
        // add the received frame callback to be informed when a frame should be displayed
        if (error == ARCONTROLLER_OK) {
            error = ARCONTROLLER_Device_SetVideoStreamCallbacks(_deviceController, configDecoderCallback,
                                                                didReceiveFrameCallback, NULL , (__bridge void *)(self));
        }
        
        // start the device controller (the callback stateChanged should be called soon)
        if (error == ARCONTROLLER_OK) {
            error = ARCONTROLLER_Device_Start (_deviceController);
        }
        
        // we don't need the discovery device anymore
        ARDISCOVERY_Device_Delete (&discoveryDevice);
        [self setDefaultSetting];
        // if an error occured, inform the delegate that the state is stopped
        if (error != ARCONTROLLER_OK) {
            dispatch_async(dispatch_get_main_queue(), ^{
                [_delegate bebopDrone:self connectionDidChange:ARCONTROLLER_DEVICE_STATE_STOPPED];
            });
        }
    } else {
        // if an error occured, inform the delegate that the state is stopped
        dispatch_async(dispatch_get_main_queue(), ^{
            [_delegate bebopDrone:self connectionDidChange:ARCONTROLLER_DEVICE_STATE_STOPPED];
        });
    }
    
    _deviceController->aRDrone3->sendMediaStreamingVideoEnable(_deviceController->aRDrone3, (uint8_t)0);

}

- (ARDISCOVERY_Device_t *)createDiscoveryDeviceWithService:(ARService*)service {
    ARDISCOVERY_Device_t *device = NULL;
    eARDISCOVERY_ERROR errorDiscovery = ARDISCOVERY_OK;
    
    device = ARDISCOVERY_Device_New (&errorDiscovery);
    
    if (errorDiscovery == ARDISCOVERY_OK) {
        // need to resolve service to get the IP
        BOOL resolveSucceeded = [self resolveService:service];
        
        if (resolveSucceeded) {
            NSString *ip = [[ARDiscovery sharedInstance] convertNSNetServiceToIp:service];
            int port = (int)[(NSNetService *)service.service port];
            
            if (ip) {
                // create a Wifi discovery device
                errorDiscovery = ARDISCOVERY_Device_InitWifi (device, service.product, [service.name UTF8String], [ip UTF8String], port);
            } else {
                NSLog(@"ip is null");
                errorDiscovery = ARDISCOVERY_ERROR;
            }
        } else {
            NSLog(@"Resolve error");
            errorDiscovery = ARDISCOVERY_ERROR;
        }
        
        if (errorDiscovery != ARDISCOVERY_OK) {
            NSLog(@"Discovery error :%s", ARDISCOVERY_Error_ToString(errorDiscovery));
            ARDISCOVERY_Device_Delete(&device);
        }
    }
    
    return device;
}

#pragma mark commands
- (void)emergency {
    if (_deviceController && (_connectionState == ARCONTROLLER_DEVICE_STATE_RUNNING)) {
        _deviceController->aRDrone3->sendPilotingEmergency(_deviceController->aRDrone3);
    }
}

- (void)takeOff {
    if (_deviceController && (_connectionState == ARCONTROLLER_DEVICE_STATE_RUNNING)) {
        _deviceController->aRDrone3->sendPilotingTakeOff(_deviceController->aRDrone3);
        _Flying = 1;
    }
}

- (int)isFlying{
    return _Flying;
}

- (void)land {
    if (_deviceController && (_connectionState == ARCONTROLLER_DEVICE_STATE_RUNNING)) {
        _deviceController->aRDrone3->sendPilotingLanding(_deviceController->aRDrone3);
    }
}

- (void)setMaxHauteur:(float)attitude{
    altitudeDrone = attitude;
}
- (void)setAcceleration:(float)coef{
    acceleration = coef;
}

- (void)setDefaultSetting{
    NSLog(@"RAZ SETTING");
    _deviceController->common->sendSettingsReset(_deviceController->common);
}

- (void) cancelReturnHome{
    NSLog(@"ANNULATION DU RETOUR HOME");
    if(_homeExterieur) {
        //Annulation
        _deviceController->aRDrone3->sendPilotingNavigateHome(_deviceController->aRDrone3,0);
        _homeExterieur = false;
    }else{
        [self setFlag:0];
        [self setRoll:0];
        [self setPitch:0];
        [self setGaz:0];
    }
    _returnHome = false;
}

- (void) returnHomeExterieur{
    _returnHomeAlert = [[UIAlertView alloc] initWithTitle:[_service name] message:@"Home Exterieur..."
                                                 delegate:self cancelButtonTitle:@"Annuler" otherButtonTitles:nil, nil];
    [_returnHomeAlert show];
    
    
    _returnHome = true;
    _homeExterieur = true;
    _deviceController->aRDrone3->sendPilotingNavigateHome(_deviceController->aRDrone3,1);
    
    
    
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    if (buttonIndex == [alertView cancelButtonIndex]){
        [self cancelReturnHome];
    }
}

- (void) returnHomeInterieur{
    
    _returnHomeAlert = [[UIAlertView alloc] initWithTitle:[_service name] message:@"Home interieur..."
                                                 delegate:self cancelButtonTitle:@"Annuler" otherButtonTitles:nil, nil];
    
    [_returnHomeAlert show];
    //in background disconnect the drone
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        // DANS LE BACKGROUND
        
        _returnHome = true;
        long i;
        for (i = (_timeIntervalArray.count -1); i>=0; i-- ) {
            
            BebopDroneRecord *tmp = [_timeIntervalArray objectAtIndex:i];
            
            if(_returnHome == false) break;
            
            int valeur = [tmp getValue];
            float interval = [tmp getTimeInterval];
            
            //On applique le mouvement
            [self setFlag:1];
            if([tmp.getDirection isEqualToString:@"P"]){
                NSLog(@"Valeur pour le %@ est %d durée : %0.2f",@"PITCH",(-1)*valeur, interval);
                [self setPitch:(-1)*valeur];
            }else if([tmp.getDirection isEqualToString:@"R"]){
                NSLog(@"Valeur pour le %@ est %d durée : %0.2f",@"ROLL",(-1)*valeur, interval);
                [self setRoll:(-1)*valeur];
            }else if([tmp.getDirection isEqualToString:@"G"]){
                NSLog(@"Valeur pour le %@ est %d durée : %0.2f",@"GAZ",(-1)*valeur, interval);
                [self setGaz:(-1)*valeur];
            }
            
            //On s'endort la durée du mouvement
            [NSThread sleepForTimeInterval:interval];
            [self setFlag:0];
            [self setRoll:0];
            [self setPitch:0];
            [self setGaz:0];
            
        }
        _returnHome = false;
        _timeIntervalArray = [[NSMutableArray alloc] init];
        _manuel.homeActivate = false;
        //dismiss AlertView in main thread
        dispatch_async(dispatch_get_main_queue(),^{
            [_returnHomeAlert dismissWithClickedButtonIndex:0 animated:YES];
            
        });
    });
    
    
}


- (void)setPitch:(int)pitch {
    
    
    if(_returnHome == false){
        _currentDateX = [NSDate date];
        if( (pitch > 0 && _oldPitch < 0) || (pitch < 0 && _oldPitch > 0) || (pitch == 0 && _oldPitch != 0) ){ //Changement de mouvement;
            float f = [_currentDateX timeIntervalSinceDate:_oldDateX];
            BebopDroneRecord *tmp = [[BebopDroneRecord alloc] init];
            [tmp setTimeInterval:f];
            [tmp setDroneDirectionValue:[[NSString alloc] initWithFormat:@"P;%d", _sumValueX/_nbPitch]];
            @synchronized(_timeIntervalArray)
            {
                [_timeIntervalArray addObject:tmp];
                NSLog(@"Ajout de %@  de valeur %d et d'une durée de %0.2f",[tmp getDirection],[tmp getValue],[tmp getTimeInterval]);
            }
            
            //NSLog(@"Temps en seconde depuis le dernier pitch : %0.2f COUNT:%ld",f,_timeIntervalArray.count);
            _oldDateX = nil;
            _oldPitch = 0;
            _nbPitch = 0;
            _sumValueX = 0;
        }else{                                                                                         // Meme mouvement;
            if(_oldDateX == nil){
                _oldDateX = [NSDate date];
            }
            if(pitch != 0){
                //NSLog(@"AJOUT %d, NB ACTUEL %d",pitch,_nbPitch);
                _sumValueX +=  pitch;
                _oldPitch = pitch;
                _nbPitch++;
            }else{
                _oldDateX = [NSDate date]; 
            }
            
        }
        
    }
    if (_deviceController && (_connectionState == ARCONTROLLER_DEVICE_STATE_RUNNING)) {
           _deviceController->aRDrone3->setPilotingPCMDPitch(_deviceController->aRDrone3, (uint8_t) pitch);
    }
}

- (void)setViewCall:(id)view{
    _manuel = (ViewControllerManuel*) view;
}

- (void)setRoll:(uint8_t)roll {
    
    
    if(_returnHome == false){
        _currentDateY = [NSDate date];
        if( (roll > 0 && _oldRoll < 0) || (roll < 0 && _oldRoll > 0) || (roll == 0 && _oldRoll != 0) ){ //Changement de mouvement;
            float f = [_currentDateY timeIntervalSinceDate:_oldDateY];
            BebopDroneRecord *tmp = [[BebopDroneRecord alloc] init];
            [tmp setTimeInterval:f];
            [tmp setDroneDirectionValue:[[NSString alloc] initWithFormat:@"P;%d", _sumValueY/_nbRoll]];
            @synchronized(_timeIntervalArray)
            {
                [_timeIntervalArray addObject:tmp];
                NSLog(@"Ajout de %@  de valeur %d et d'une durée de %0.2f",[tmp getDirection],[tmp getValue],[tmp getTimeInterval]);
            }
            
            //NSLog(@"Temps en seconde depuis le dernier pitch : %0.2f COUNT:%ld",f,_timeIntervalArray.count);
            _oldDateY = nil;
            _oldRoll = 0;
            _nbRoll = 0;
            _sumValueY = 0;
        }else{                                                                                         // Meme mouvement;
            if(_oldDateY == nil){
                _oldDateY = [NSDate date];
            }
            if(roll != 0){
                //NSLog(@"AJOUT %d, NB ACTUEL %d",pitch,_nbPitch);
                _sumValueY +=  roll;
                _oldRoll = roll;
                _nbRoll++;
            }else{
                _oldDateY = [NSDate date];
            }
            
        }
        
    }
    if (_deviceController && (_connectionState == ARCONTROLLER_DEVICE_STATE_RUNNING)) {
        _deviceController->aRDrone3->setPilotingPCMDRoll(_deviceController->aRDrone3, (uint8_t) roll);
    }
    
    
}

- (void)setYaw:(uint8_t)yaw {
    if (_deviceController && (_connectionState == ARCONTROLLER_DEVICE_STATE_RUNNING)) {
        _deviceController->aRDrone3->setPilotingPCMDYaw(_deviceController->aRDrone3, yaw);
    }
}

- (void)setGaz:(uint8_t)gaz {
    
    
    if(_returnHome == false){
        _currentDateZ = [NSDate date];
        if( (gaz > 0 && _oldGaz < 0) || (gaz < 0 && _oldGaz > 0) || (gaz == 0 && _oldGaz != 0) ){ //Changement de mouvement;
            float f = [_currentDateZ timeIntervalSinceDate:_oldDateZ];
            BebopDroneRecord *tmp = [[BebopDroneRecord alloc] init];
            [tmp setTimeInterval:f];
            [tmp setDroneDirectionValue:[[NSString alloc] initWithFormat:@"P;%d", _sumValueZ/_nbGaz]];
            @synchronized(_timeIntervalArray)
            {
                [_timeIntervalArray addObject:tmp];
                NSLog(@"Ajout de %@  de valeur %d et d'une durée de %0.2f",[tmp getDirection],[tmp getValue],[tmp getTimeInterval]);
            }
            
            //NSLog(@"Temps en seconde depuis le dernier pitch : %0.2f COUNT:%ld",f,_timeIntervalArray.count);
            _oldDateZ = nil;
            _oldGaz = 0;
            _nbGaz = 0;
            _sumValueZ = 0;
        }else{                                                                                         // Meme mouvement;
            if(_oldDateZ == nil){
                _oldDateZ = [NSDate date];
            }
            if(gaz != 0){
                //NSLog(@"AJOUT %d, NB ACTUEL %d",pitch,_nbPitch);
                _sumValueZ +=  gaz;
                _oldGaz = gaz;
                _nbGaz++;
            }else{
                _oldDateZ = [NSDate date];
            }
            
        }
        
    }
    if (_deviceController && (_connectionState == ARCONTROLLER_DEVICE_STATE_RUNNING)) {
        _deviceController->aRDrone3->setPilotingPCMDGaz(_deviceController->aRDrone3, gaz);
    }
}

- (void)setFlag:(uint8_t)flag {
    if (_deviceController && (_connectionState == ARCONTROLLER_DEVICE_STATE_RUNNING)) {
        _deviceController->aRDrone3->setPilotingPCMDFlag(_deviceController->aRDrone3, flag);
    }
}

#pragma mark Device controller callbacks
// called when the state of the device controller has changed
static void stateChanged (eARCONTROLLER_DEVICE_STATE newState, eARCONTROLLER_ERROR error, void *customData) {
    BebopDrone *bebopDrone = (__bridge BebopDrone*)customData;
    if (bebopDrone != nil) {
        switch (newState) {
            case ARCONTROLLER_DEVICE_STATE_RUNNING:
                //bebopDrone.deviceController->aRDrone3->sendMediaStreamingVideoEnable(bebopDrone.deviceController->aRDrone3, 0);
                if(acceleration == 1){
                    bebopDrone.deviceController->aRDrone3->sendSpeedSettingsMaxRotationSpeed(bebopDrone.deviceController->aRDrone3, (float)10);
                    bebopDrone.deviceController->aRDrone3->sendSpeedSettingsMaxVerticalSpeed(bebopDrone.deviceController->aRDrone3, (float)0.5);
                    bebopDrone.deviceController->aRDrone3->sendSpeedSettingsMaxPitchRollRotationSpeed(bebopDrone.deviceController->aRDrone3, (float)80);
                    bebopDrone.deviceController->aRDrone3->sendPilotingSettingsMaxTilt(bebopDrone.deviceController->aRDrone3, (float)5);
            
                }else if(acceleration == 2){
                    
                    bebopDrone.deviceController->aRDrone3->sendSpeedSettingsMaxRotationSpeed(bebopDrone.deviceController->aRDrone3, (float)200);
                    bebopDrone.deviceController->aRDrone3->sendSpeedSettingsMaxVerticalSpeed(bebopDrone.deviceController->aRDrone3, (float)6);
                    bebopDrone.deviceController->aRDrone3->sendSpeedSettingsMaxPitchRollRotationSpeed(bebopDrone.deviceController->aRDrone3, (float)300);
                    bebopDrone.deviceController->aRDrone3->sendPilotingSettingsMaxTilt(bebopDrone.deviceController->aRDrone3, (float)35);
                    
                    
                }else{
                    float tempRot, tempVert, tempPitch, tempTilt;
                    if(acceleration>1 && acceleration <= 1.25){
                        tempRot = 50;
                        tempVert = 2;
                        tempPitch = 120;
                        tempTilt = 15;
                    }
                    if(acceleration>1.25 && acceleration <= 1.5){
                        tempRot = 100;
                        tempVert = 3;
                        tempPitch = 180;
                         tempTilt = 20;
                    }
                    if(acceleration>1.5 && acceleration <= 1.75){
                        tempRot = 150;
                        tempVert = 4;
                        tempPitch = 230;
                         tempTilt = 25;
                    }
                    if(acceleration> 1.75 && acceleration < 2){
                        tempRot = 200;
                        tempVert = 5;
                        tempPitch = 260;
                        tempTilt = 30;
                    }
                    bebopDrone.deviceController->aRDrone3->sendSpeedSettingsMaxRotationSpeed(bebopDrone.deviceController->aRDrone3, tempRot);
                    bebopDrone.deviceController->aRDrone3->sendSpeedSettingsMaxVerticalSpeed(bebopDrone.deviceController->aRDrone3, tempVert);
                    bebopDrone.deviceController->aRDrone3->sendSpeedSettingsMaxPitchRollRotationSpeed(bebopDrone.deviceController->aRDrone3,tempPitch);
                    bebopDrone.deviceController->aRDrone3->sendPilotingSettingsMaxTilt(bebopDrone.deviceController->aRDrone3, tempTilt);
                    
                }
                  bebopDrone.deviceController->aRDrone3->sendPilotingSettingsMaxAltitude(bebopDrone.deviceController->aRDrone3,(float) altitudeDrone);
                NSLog(@"GROS PASSAGE %f acceleration %f",altitudeDrone,acceleration);
                break;
            case ARCONTROLLER_DEVICE_STATE_STOPPED:
                break;
            default:
                break;
        }
        dispatch_async(dispatch_get_main_queue(), ^{
            bebopDrone.connectionState = newState;
            [bebopDrone.delegate bebopDrone:bebopDrone connectionDidChange:newState];
        });
    }
}




// called when a command has been received from the drone
static void onCommandReceived (eARCONTROLLER_DICTIONARY_KEY commandKey, ARCONTROLLER_DICTIONARY_ELEMENT_t *elementDictionary, void *customData) {
    BebopDrone *bebopDrone = (__bridge BebopDrone*)customData;
    
    // if the command received is a battery state changed
    if ((commandKey == ARCONTROLLER_DICTIONARY_KEY_COMMON_COMMONSTATE_BATTERYSTATECHANGED) &&
        (elementDictionary != NULL)) {
        ARCONTROLLER_DICTIONARY_ARG_t *arg = NULL;
        ARCONTROLLER_DICTIONARY_ELEMENT_t *element = NULL;
        
        HASH_FIND_STR (elementDictionary, ARCONTROLLER_DICTIONARY_SINGLE_KEY, element);
        if (element != NULL) {
            HASH_FIND_STR (element->arguments, ARCONTROLLER_DICTIONARY_KEY_COMMON_COMMONSTATE_BATTERYSTATECHANGED_PERCENT, arg);
            if (arg != NULL) {
                uint8_t battery = arg->value.U8;
                dispatch_async(dispatch_get_main_queue(), ^{
                    [bebopDrone.delegate bebopDrone:bebopDrone batteryDidChange:battery];
                });
            }
        }
    }
    // if the command received is a battery state changed
    else if ((commandKey == ARCONTROLLER_DICTIONARY_KEY_ARDRONE3_PILOTINGSTATE_FLYINGSTATECHANGED) &&
             (elementDictionary != NULL)) {
        ARCONTROLLER_DICTIONARY_ARG_t *arg = NULL;
        ARCONTROLLER_DICTIONARY_ELEMENT_t *element = NULL;
        
        HASH_FIND_STR (elementDictionary, ARCONTROLLER_DICTIONARY_SINGLE_KEY, element);
        if (element != NULL) {
            HASH_FIND_STR (element->arguments, ARCONTROLLER_DICTIONARY_KEY_ARDRONE3_PILOTINGSTATE_FLYINGSTATECHANGED_STATE, arg);
            if (arg != NULL) {
                bebopDrone.flyingState = arg->value.I32;
                dispatch_async(dispatch_get_main_queue(), ^{
                    [bebopDrone.delegate bebopDrone:bebopDrone flyingStateDidChange:bebopDrone.flyingState];
                });
            }
        }
    }
    // if the command received is a run id changed
    else if ((commandKey == ARCONTROLLER_DICTIONARY_KEY_COMMON_RUNSTATE_RUNIDCHANGED) &&
             (elementDictionary != NULL)) {
        ARCONTROLLER_DICTIONARY_ARG_t *arg = NULL;
        ARCONTROLLER_DICTIONARY_ELEMENT_t *element = NULL;
        
        HASH_FIND_STR (elementDictionary, ARCONTROLLER_DICTIONARY_SINGLE_KEY, element);
        if (element != NULL) {
            HASH_FIND_STR (element->arguments, ARCONTROLLER_DICTIONARY_KEY_COMMON_RUNSTATE_RUNIDCHANGED_RUNID, arg);
            if (arg != NULL) {
                char * runId = arg->value.String;
                if (runId != NULL) {
                    bebopDrone.currentRunId = [NSString stringWithUTF8String:runId];
                }
            }
        }
    }
    if ((commandKey == ARCONTROLLER_DICTIONARY_KEY_COMMON_SETTINGSSTATE_RESETCHANGED)
              && (elementDictionary != NULL)){
        NSLog(@"Fin passage");
        [bebopDrone setCustomSetting];
    }
}


static eARCONTROLLER_ERROR configDecoderCallback (ARCONTROLLER_Stream_Codec_t codec, void *customData) {
    return ARCONTROLLER_OK;
}

static eARCONTROLLER_ERROR didReceiveFrameCallback (ARCONTROLLER_Frame_t *frame, void *customData) {
    return ARCONTROLLER_OK;
}


#pragma mark resolveService
- (BOOL)resolveService:(ARService*)service {
    BOOL retval = NO;
    _resolveSemaphore = dispatch_semaphore_create(0);
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(discoveryDidResolve:) name:kARDiscoveryNotificationServiceResolved object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(discoveryDidNotResolve:) name:kARDiscoveryNotificationServiceNotResolved object:nil];
    
    [[ARDiscovery sharedInstance] resolveService:service];
    
    // this semaphore will be signaled in discoveryDidResolve or discoveryDidNotResolve
    dispatch_semaphore_wait(_resolveSemaphore, DISPATCH_TIME_FOREVER);
    
    NSString *ip = [[ARDiscovery sharedInstance] convertNSNetServiceToIp:service];
    if (ip != nil)
    {
        retval = YES;
    }
    
    [[NSNotificationCenter defaultCenter] removeObserver:self name:kARDiscoveryNotificationServiceResolved object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:kARDiscoveryNotificationServiceNotResolved object:nil];
    _resolveSemaphore = nil;
    return retval;
}

- (void)discoveryDidResolve:(NSNotification *)notification {
    dispatch_semaphore_signal(_resolveSemaphore);
}

- (void)discoveryDidNotResolve:(NSNotification *)notification {
    NSLog(@"Resolve failed");
    dispatch_semaphore_signal(_resolveSemaphore);
}


@end
