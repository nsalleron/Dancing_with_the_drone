//
//  InterfaceControllerOptions.m
//  Jack Sparrot
//
//  Created by Nicolas Salleron on 19/04/2017.
//
//

#import "InterfaceControllerOptions.h"

@interface InterfaceControllerOptions ()<WCSessionDelegate>

@end

float hauteurMax, coefAccel;
bool home;
@implementation InterfaceControllerOptions

- (void)awakeWithContext:(id)context {
    [super awakeWithContext:context];
    [self setTitle:(NSString *) context];
}

- (void) session:(WCSession *)session activationDidCompleteWithState:(WCSessionActivationState)activationState error:(NSError *)error{
    
}

- (void)willActivate {
    [super willActivate];
    
    
    if ([WCSession isSupported]) {
        _session = [WCSession defaultSession];
        _session.delegate = self;
        [_session activateSession];
    }
    
    
    /* Acceleration */
    coefAccel = [[NSUserDefaults standardUserDefaults] doubleForKey:@"Acceleration"];
    [_labelAccel setText:[[NSString alloc] initWithFormat:@"Coef : %0.2f m.",coefAccel]];
    [_stepAcc setValue:coefAccel];
    
    /* Hauteur */
    hauteurMax = [[NSUserDefaults standardUserDefaults] doubleForKey:@"Hauteur"];
    [_labelHauteur setText:[[NSString alloc] initWithFormat:@"Haut. Max: %0.0f m.",hauteurMax]];
    [_stepHauteur setValue:hauteurMax];
    
    /* Switch */
    bool tmpB = [[NSUserDefaults standardUserDefaults] boolForKey:@"InOut"];
    [_switchBtn setOn:tmpB];
    
    
    
}

/**
 *  @brief changement du type de Home;
 *  @param value true = intérieur
 */
- (IBAction)changeHome:(BOOL)value {
    home = value;
    
}
/**
 *  @brief changement de la valeur de la hauteur
 *  @param value valeur actuelle de la hauteur maximale du drone
 */
- (IBAction)changeHauteurMax:(float)value {
    hauteurMax = value;
    [_labelHauteur setText:[[NSString alloc] initWithFormat:@"Haut. Max: %0.0f m.",value]];
    
}
/**
 *  @brief changement de la valeur d'accélération
 *  @param value valeur actuel de l'accélération
 */
- (IBAction)changeCoefAccel:(float)value {
    coefAccel = value;
    [_labelAccel setText:[[NSString alloc] initWithFormat:@"Coef : %0.2f m.",value]];
}

- (void)didDeactivate {
    [super didDeactivate];
    
    
    
    /* Sauvegarde et envoie des données vers le mobile */
    NSString * temp = [[NSString alloc] initWithFormat:@"P;%f;%f;%d",coefAccel,hauteurMax,home];
    NSDictionary *applicationDict = [[NSDictionary alloc] initWithObjectsAndKeys:temp,@"CMD", nil];
    [_session sendMessage:applicationDict
             replyHandler:^(NSDictionary *replyHandler) {
                 NSLog(@"REPLY : %@",[replyHandler valueForKey:@"reply"]);
             }
             errorHandler:^(NSError *error) {
                 NSLog(@"ERROR");
             }
     ];
    
    
    [[NSUserDefaults standardUserDefaults] setDouble:coefAccel forKey:@"Acceleration"];
    [[NSUserDefaults standardUserDefaults] setDouble:hauteurMax forKey:@"Hauteur"];
    [[NSUserDefaults standardUserDefaults] setBool:home forKey:@"InOut"];
    
    
    
}

@end



