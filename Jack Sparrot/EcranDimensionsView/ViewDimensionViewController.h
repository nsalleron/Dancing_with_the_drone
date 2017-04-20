//
//  ViewDimensionViewController.h
//  Jack Sparrot
//
//  Created by Nicolas Salleron on 28/02/2017.
//
//

#import <UIKit/UIKit.h>

@class ViewDimensionViewController;

/**
 * @brief protocole pour récupérer la dimension actuel de l'utilisateur
 */
@protocol ViewDimensionViewControllerDelegate <NSObject>
/**
 * @brief méthode pour récuperer et afficher la valeur
 */
- (void)addItemViewController:(ViewDimensionViewController *)controller didFinishEnteringItem:(NSString *)item;
@end

@interface ViewDimensionViewController : UIViewController

/**
 * @brief Delegate du protocole, le viewcontroller accepte ce protocole.
 */
@property (nonatomic, weak) id <ViewDimensionViewControllerDelegate> delegate;

@end

