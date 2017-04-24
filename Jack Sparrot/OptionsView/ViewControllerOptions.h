//
//  ViewController.h
//  Jack Sparrot
//
//  Created by Gregoire Gasc on 07/03/2017.
//
//

#import <UIKit/UIKit.h>
#import "ViewDimensionViewController.h"
#import "ViewCouleurs.h"

/// \brief Class qui gère la View Options
/// \code
/// Cette classe se charge de l'affiche de la classe ViewOptions.h
/// Elle permet à l'utilisateur de définir les options de l'application notamment :
///     - le coefficient d'acceleration
///     - la hauteur maximal pour le drone
///     - le mode exterieur interieur pour la fonction home
/// Les différentes informations sont sauvegardées quand l'utilisateur ferme la view (voir fonction saveData et viewDidDisappear)
/// Les différentes informations utilisateur sont chargés par la view en elle-même
/// \endcode
///
@interface ViewControllerOptions : UIViewController <ViewCouleursControllerDelegate>
/**
 * @brief Permet le choix d'une couleur pour un bouton
 */
-(void) goToColorChoice:(UIButton*) send;

@end

