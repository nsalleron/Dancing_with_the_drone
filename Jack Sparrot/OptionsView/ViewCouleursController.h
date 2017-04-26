//
//  ViewCouleursController.h
//  Jack Sparrot
//
//  Created by Nicolas Salleron on 28/02/2017.
//
//

#ifndef ViewCouleursController_h
#define ViewCouleursController_h

#import <UIKit/UIKit.h>

/// \brief Class définissant un protocole + gère le ViewCouleur
/// \code
/// Cette classe se charge de l'affiche de la classe ViewCouleurs.h
/// Elle met également en place un protocole pour pouvoir récupérer le résultat (la couleur)
/// \endcode
///
@class ViewCouleursController;

/// \brief Le nom du protocole qui va nous permettre de récupérer le résultat
@protocol ViewCouleursControllerDelegate <NSObject>
/// \brief La méthode de ce protocole
/// \param controller le view controller qui utilisera le protocole
/// \param item la couleur que l'utilisateur choisit en cliquant.
- (void)addCouleur:(ViewCouleursController *)controller didFinishEnteringItem:(UIColor *)item;
@end


@interface ViewCouleursController : UIViewController

//Delegate du protocole, le viewcontroller qui accepte ce protocole.
@property (nonatomic, weak) id <ViewCouleursControllerDelegate> delegate;

@end

#endif
