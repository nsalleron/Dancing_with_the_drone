//
//  BebopDroneRecord.m
//
//  Created by Gregoire Gasc on 04/04/2017.
//  Copyright © 2017 Parrot. All rights reserved.
//

#import <Foundation/Foundation.h>


/// \brief Class pour les enregistrements des "mouvements" suivant les intervalles de temps.
/// \code
/// Cette classe permet d'enregistrer la direction dans laquelle va le drone
/// ainsi que le temps du drone dans cette direction
/// Plusieurs valeurs sont enregistrées :
///       - Pitch : 'P'
///       - Roll : 'R'
///       - Gaz : 'G'
/// \endcode
///
@interface BebopDroneRecord:NSObject
{
    NSString *droneDirectionValue;   // Direction + Valeur sous format P;20 par exemple P = Pitch, R = Roll; G = Gaz
    float droneTime;  // Temps (en seconde ) dans cette direction
}

/// \brief Méthode pour mettre en place la direction associée à la valeur envoyée au drone.
/// \code
/// Le format doit être le suivant :
///     Direction;Valeur
/// La direction doit être la chaîne de caractère :
///     - "P" pour Pitch
///     - "R" pour Roll
///     - "G" pour Gaz
/// La valeur doit être une chaîne de caractère issue d'un entier compris entre -100 et 100
/// \endcode
///
-(void) setDroneDirectionValue:(NSString*)value;
/// \brief Méthode pour mettre en place l'intervalle de temps de la direction
/// \code
/// Un setter qui permet la mise en place du temps au format float.
/// Cette valeur doit être calculée avant entre deux dates de la manière suivante:
///     time = [Date date] difference avec _oldDate
/// Cette date est calculée uniquement quand un mouvement est en cours puis s'arrête.
/// C'est l'arrêt qui marque la fin du mouvement et donc la détermination de time.
/// \endcode
/// \param value le temps déterminé auparavant
-(void) setTimeInterval:(float)value;
/// \brief Permet de récupérer la direction
/// \return Une string contenant la direct (X ou Y ou Z)
-(NSString*) getDirection;
/// \brief Permet de récupérer la valeur envoyer au drone
/// \return la valeur à envoyer au drone.
-(int) getValue;
/// \brief Permet de récupérer l'intervalle de temps du mouvement
/// \return l'intervalle de temps
-(float) getTimeInterval;
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
