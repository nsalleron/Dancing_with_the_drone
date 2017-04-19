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
@property (nonatomic, strong) WCSession* session;
@end
