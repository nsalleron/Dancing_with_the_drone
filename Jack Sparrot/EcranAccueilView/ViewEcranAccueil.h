//
//  EcranAccueil.h
//  Jack Sparrot
//
//  Created by Nicolas Salleron on 31/01/2017.
//
//

#ifndef EcranAccueil_h
#define EcranAccueil_h
#import <UIKit/UIKit.h>


@interface ViewEcranAccueil : UIView

@property (readonly,nonatomic,retain)   UIImageView     *imgLogo;
@property (readonly,nonatomic,retain)   UIButton        *btnDrone;
@property (readonly,nonatomic,retain)   UIButton        *btnOptions;
@property (readwrite,nonatomic,retain)  UIButton        *btnAide;
@property (readonly,nonatomic,retain)   UILabel         *labelBatteryDrone;
@property (readonly,nonatomic,retain)   UILabel         *labelBatterySmartphone;
@property (readonly,nonatomic,retain)   UILabel         *labelVersionApp;
@property (readonly,nonatomic,retain)   UILabel         *labelMontre;
@property (nonatomic, assign)           CGFloat         tailleIcones;

- (void) updateView:(CGSize) format;

/**
 * @brief pour permettre la suite le push/pull
 */
- (void) setNavigationController:(UINavigationController*) nv;

/**
 * @brief permet de mettre à jour la vue au niveau de la battery
 */
- (void) setBattery:(NSString *) battery;

/**
 * @brief retourne le niveau de batterie
 */
-(double)battery;

@end

#endif
