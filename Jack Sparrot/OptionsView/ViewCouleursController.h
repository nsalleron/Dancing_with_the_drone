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

@class ViewCouleursController;

// Nom du protocol
@protocol ViewCouleursControllerDelegate <NSObject>
//Méthode du protocol
- (void)addCouleur:(ViewCouleursController *)controller didFinishEnteringItem:(UIColor *)item;
@end


@interface ViewCouleursController : UIViewController

//Delegate du protocole, le viewcontroller accepte ce protocole.
@property (nonatomic, weak) id <ViewCouleursControllerDelegate> delegate;

@end

#endif
