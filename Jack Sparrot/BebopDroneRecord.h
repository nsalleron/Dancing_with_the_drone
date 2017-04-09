//
//  BebopDroneRecord.m
//  SDKSample
//
//  Created by Gregoire Gasc on 04/04/2017.
//  Copyright © 2017 Parrot. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface BebopDroneRecord:NSObject
{
    NSString *droneDirectionValue;   // Direction + Valeur sous format P;20 par exemple P = Pitch, R = Roll; G = Gaz
    float droneTime;  // Temps (en seconde ) dans cette direction
}

-(void) setDroneDirectionValue:(NSString*)value;
-(void) setTimeInterval:(float)value;
-(NSString*) getDirection;
-(int) getValue;
@end

@implementation BebopDroneRecord


-(id)init
{
    self = [super init];
    droneTime = 0;
    return self;
}

-(void) setDroneDirectionValue:(NSString *)value
{
    droneDirectionValue = [[NSString alloc] initWithString:value];
    NSLog(@"%@",droneDirectionValue);
}
-(void) setTimeInterval:(float)value{
    droneTime = value;
}
-(float) getTimeInterval{
    return droneTime;
}
-(NSString*) getDirection{
    return [droneDirectionValue componentsSeparatedByString:@";"][0];
}
-(int) getValue{
    return [[droneDirectionValue componentsSeparatedByString:@";"][1] intValue];
}
@end
