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
    
    
}

- (void)didDeactivate {
    // This method is called when watch view controller is no longer visible
    [super didDeactivate];
}

@end



