//
//  InterfaceControllerOptions.h
//  Jack Sparrot
//
//  Created by Nicolas Salleron on 19/04/2017.
//
//

#import <WatchKit/WatchKit.h>
#import <Foundation/Foundation.h>
#import <WatchConnectivity/WatchConnectivity.h>

@interface InterfaceControllerOptions : WKInterfaceController
@property (unsafe_unretained, nonatomic) IBOutlet WKInterfaceLabel *labelHauteur;
@property (unsafe_unretained, nonatomic) IBOutlet WKInterfaceLabel *labelAccel;

@property (unsafe_unretained, nonatomic) IBOutlet WKInterfaceSwitch *switchBtn;
@property (unsafe_unretained, nonatomic) IBOutlet WKInterfaceSlider *stepHauteur;
@property (unsafe_unretained, nonatomic) IBOutlet WKInterfaceSlider *stepAcc;
@property (nonatomic, strong) WCSession* session;
@end
