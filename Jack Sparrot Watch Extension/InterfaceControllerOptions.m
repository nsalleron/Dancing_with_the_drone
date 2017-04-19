//
//  InterfaceControllerOptions.m
//  Jack Sparrot
//
//  Created by Nicolas Salleron on 19/04/2017.
//
//

#import "InterfaceControllerOptions.h"

@interface InterfaceControllerOptions ()

@end

float hauteurMax, coefAccel;
bool home;
@implementation InterfaceControllerOptions

- (void)awakeWithContext:(id)context {
    [super awakeWithContext:context];
    
    // Configure interface objects here.
}

- (void)willActivate {
    // This method is called when watch view controller is about to be visible to user
    [super willActivate];
    
    
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
    
    coefAccel = [[NSUserDefaults standardUserDefaults] doubleForKey:@"Acceleration"];

    [_labelAccel setText:[[NSString alloc] initWithFormat:@"Coef : %0.2f m.",coefAccel]];
    [_stepAcc setValue:coefAccel];
    
    
    hauteurMax = [[NSUserDefaults standardUserDefaults] doubleForKey:@"Hauteur"];
    
    [_labelHauteur setText:[[NSString alloc] initWithFormat:@"Haut. Max: %0.0f m.",hauteurMax]];
    
    [_stepHauteur setValue:hauteurMax];
    
    bool tmpB = [[NSUserDefaults standardUserDefaults] boolForKey:@"InOut"];
    
    [_switchBtn setOn:tmpB];
    
    
    
}

- (IBAction)changeHome:(BOOL)value {
    home = value;
    
}

- (IBAction)changeHauteurMax:(float)value {
    hauteurMax = value;
    [_labelHauteur setText:[[NSString alloc] initWithFormat:@"Haut. Max: %0.0f m.",value]];
    
}

- (IBAction)changeCoefAccel:(float)value {
    coefAccel = value;
    [_labelAccel setText:[[NSString alloc] initWithFormat:@"Coef : %0.2f m.",value]];
}




- (void)didDeactivate {
    // This method is called when watch view controller is no longer visible
    [super didDeactivate];
    NSString * temp = [[NSString alloc] initWithFormat:@"P;%f;%f;%d",coefAccel,hauteurMax,home];
    NSLog(@"P;%f;%f;%d",coefAccel,hauteurMax,home);
    
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



