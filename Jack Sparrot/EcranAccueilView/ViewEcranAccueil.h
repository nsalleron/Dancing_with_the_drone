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

/// \brief Cette classe définit la vue de l'écran d'accueil
/// \code
/// Cette classe met en place le logo de l'application ainsi que les différents boutons et label.
/// \endcode
///
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

/**
 * @brief Mise à jour de la vue
 */
- (void) updateView:(CGSize) format;
/**
 * @brief permet de mettre à jour la vue au niveau de la batterie
 */
- (void) setBattery:(NSString *) battery;

/**
 * @brief retourne le niveau actuel de batterie
 */
-(double)battery;

@end

#endif
