//
//  ViewDrone.h
//  Jack Sparrot
//
//  Created by Nicolas Salleron on 02/02/2017.
//
//

#import <UIKit/UIKit.h>
#import "ViewControllerManuel.h"

/// \brief Cette classe définit la vue de contrôle du drone

@interface ViewManuel : UIView

@property (readwrite,nonatomic,retain) UIButton *btnDimensions;
@property (readonly,nonatomic,retain) UIButton *btnChangementMode;
@property (readonly,nonatomic,retain) UIButton *btnStatioDecoAttr;
@property (readonly,nonatomic,retain) UIButton *btnHome;
@property (readwrite,nonatomic,retain) UILongPressGestureRecognizer *longPressBackAccueil ;
@property (readwrite,nonatomic,retain) UILongPressGestureRecognizer *longPressDecoAttr ;
@property (readwrite,nonatomic,retain) UILongPressGestureRecognizer *longPressDim ;
@property (readwrite,nonatomic,retain) UILongPressGestureRecognizer *longPressHome ;
@property (readwrite,nonatomic,retain) UIColor *color1D;
@property (readwrite,nonatomic,retain) UIColor *color2D;
@property (readwrite,nonatomic,retain) UIColor *color3D;
@property (readwrite,nonatomic,retain) UIColor *colorX;
@property (readwrite,nonatomic,retain) UIColor *colorY;
@property (assign, nonatomic) CGFloat tailleIcones;
@property (assign, nonatomic) ViewControllerManuel *vc;

- (void) updateView:(CGSize) format;
/**
 * @brief Mise à jour de la vue quand l'utilisateur est en mode 2D ou 3D
 */
- (void) update2D3D:(CGSize)format;
/**
 * @brief mise à jour du texte du btnDimensions
 * @param item le texte
 */
- (void) updateBtnDimensions:(NSString*) item;
/**
 * @brief mise à jour du texte du btnChangementMode
 * @param item le texte
 */
- (void) updateBtnChangementMode:(NSString*) item;
/**
 * @brief mise à jour du texte du btnStatioDecoAttr
 * @param item le texte
 */
- (void) updateBtnStatioDecoAttr:(NSString*) item;
/**
 * @brief mise à jour du texte du btnHome
 * @param item le texte
 */
- (void) updateBtnHome:(NSString*) item;
/**
 * @brief Référence vers le viewController
 * @param me le viewController
 */
- (void) setViewController:(ViewControllerManuel *) me;
/**
 * @brief Handler pour le décollage et atterrisage
 * @param gesture l'appuiLong
 */
- (void) changeDecoAttr:(UILongPressGestureRecognizer*)gesture;
/**
 * @brief Handler pour la fonction Home
 * @param gesture l'appuiLong
 */
- (void) homeFunction:(UILongPressGestureRecognizer*)gesture;
/**
 * @brief Mise en place des couleurs et autre settings enregistrés par l'utilisateur
 */
- (void) getUserSettings;
/**
 * @brief Permet de sortir de la vue
 */
- (void) exit:(UILongPressGestureRecognizer*)gesture;
@end
