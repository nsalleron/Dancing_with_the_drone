//
//  BebopDroneRecord.m
//  SDKSample
//
//  Created by Gregoire Gasc on 04/04/2017.
//  Copyright © 2017 Parrot. All rights reserved.
//

#import <Foundation/Foundation.h>

/**
 * @brief Class pour les enregistrements des "mouvements" suivant les intervals de temps
 */
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

/**
 * @brief Mise en place de la directions
 * @param Valeur de la direction : X, Y, Z
 */
-(void) setDroneDirectionValue:(NSString *)value
{
    droneDirectionValue = [[NSString alloc] initWithString:value];
    NSLog(@"%@",droneDirectionValue);
}
/**
 * @brief Interval de temps de la directions (avant remise à 0)
 * @param le temps
 */
-(void) setTimeInterval:(float)value{
    droneTime = value;
}
/**
 * @brief getter
 * @return le temps
 */
-(float) getTimeInterval{
    return droneTime;
}
/**
 * @brief getter
 * @return la direction
 */
-(NSString*) getDirection{
    return [droneDirectionValue componentsSeparatedByString:@";"][0];
}
/**
 * @brief getter
 * @return la valeur à envoyer au drone.
 */
-(int) getValue{
    return [[droneDirectionValue componentsSeparatedByString:@";"][1] intValue];
}
@end
