//
//  ViewDrone.h
//  Jack Sparrot
//
//  Created by Gregoire Gasc on 07/03/2017.
//
//

#import <UIKit/UIKit.h>
#import "ViewControllerOptions.h"
/// \brief Cette classe affiche les différentes options du client
/// \code
/// Cette classe se charge du chargement des options de l'utilisateur.
/// Elle affichera les différentes options ainsi que les couleurs des différents bouttons.
/// \endcode
///
@interface ViewOptions : UIView

@property (readonly,nonatomic,retain) UILabel *lblHauteurMax;
@property (readonly,nonatomic,retain) UILabel *lblCoeffAccel;
@property (readonly,nonatomic,retain) UILabel *lblModeIntExt;
@property (readonly,nonatomic,retain) UILabel *lblCouleurDim;

@property (readwrite,nonatomic,retain) UIColor *color1D;
@property (readwrite,nonatomic,retain) UIColor *color2D;
@property (readwrite,nonatomic,retain) UIColor *color3D;
@property (readwrite,nonatomic,retain) UIColor *colorX;
@property (readwrite,nonatomic,retain) UIColor *colorY;

@property (readwrite,nonatomic,retain) UIButton *btnColor1D;
@property (readwrite,nonatomic,retain) UIButton *btnColor2D;
@property (readwrite,nonatomic,retain) UIButton *btnColor3D;
@property (readwrite,nonatomic,retain) UIButton *btnColorAxeX;
@property (readwrite,nonatomic,retain) UIButton *btnColorAxeY;

@property (readonly,nonatomic,retain) UILabel *lblHauteurMaxInt;
@property (readonly,nonatomic,retain) UILabel *lblCoeffAccelInt;
@property (readonly,nonatomic,retain) UILabel *lblModeIntExtBool;

@property (readwrite, nonatomic, retain) IBOutlet UIStepper *stpHauteurMax;
@property (readwrite, nonatomic, retain) IBOutlet UIStepper *stpCoeffAccel;
@property (readwrite, nonatomic, retain) IBOutlet UISwitch *swhInOut;

@property (assign, nonatomic) CGFloat tailleIcones;
@property (assign, nonatomic) CGFloat tailleMarges;
@property (assign, nonatomic) ViewControllerOptions *vc;

- (void) updateView:(CGSize) format;
/**
 * @brief mise à jour de la couleur des boutons.
 */
- (void) updateBtn:(int)btn color: (UIColor*) color;
/**
 * @brief Mise à jour du stepper concernant la hauteurMax
 */
- (IBAction)stepperHauteurMaxUpdate:(UIStepper *)sender;
/**
 * @brief Mise à jour du stepper concernant l'acceleration
 */
- (IBAction)stepperCoeffAccelUpdate:(UIStepper *)sender;
/**
 * @brief Mise à jour du switch
 */
- (IBAction)switchModeIntExt:(UISwitch *)sender;
/**
 * @brief Réalise un tableau de couleurs
 * @return tableau de couleurs
 */
- (NSArray *) getBtnColors;
/**
 * @brief Getter pour stepper Acceleration
 * @return valStepper
 */
- (double) getStepperValueCoefAcce;
/**
 * @brief Getter pour stepper Hauteur
 * @return valStepper
 */
- (double) getStepperValueMax;
/**
 * @brief Getter pour le switch
 * @return true or false
 */
- (BOOL) getSwitchValueInOut;
/**
 *  @brief Mise en place des couleurs suivant les valeurs enregistrées.
 */
- (void) getUserSettings;
/**
 * @brief Méthode pour afficher le texte en clair ou non suivant la couleur de fond du bouton.
 */
- (void) btnColorText;
@end
