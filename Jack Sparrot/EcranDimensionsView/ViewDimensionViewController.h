//
//  ViewDimensionViewController.h
//  Jack Sparrot
//
//  Created by Nicolas Salleron on 28/02/2017.
//
//

#import <UIKit/UIKit.h>
/// \brief Class définissant un protocole + gère la vue dimension
/// \code
/// Cette classe se charge de l'affiche de la classe ViewDimension.h
/// Elle met également en place un protocole pour pouvoir récupérer le résultat (la dimension sous forme de string)
/// \endcode
///
@class ViewDimensionViewController;

/// \brief Le nom du protocole qui va nous permettre de récupérer le résultat
@protocol ViewDimensionViewControllerDelegate <NSObject>
/// \brief La méthode de ce protocole
/// \param controller le view controller qui utilisera le protocole
/// \param item la couleur que l'utilisateur a choisie.
- (void)addItemViewController:(ViewDimensionViewController *)controller didFinishEnteringItem:(NSString *)item;
@end

@interface ViewDimensionViewController : UIViewController

/**
 * @brief Delegate du protocole, le viewcontroller qui accepte ce protocole.
 */
@property (nonatomic, weak) id <ViewDimensionViewControllerDelegate> delegate;

/**
 * @brief Mise en place de la valeur vers la variable globale à la fenêtre
 */
-(void) endDimensionChoice:(UIButton*)send;

@end

