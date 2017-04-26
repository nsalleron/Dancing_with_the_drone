//
//  ViewCouleurs.h
//  Jack Sparrot
//
//  Created by Nicolas Salleron on 28/02/2017.
//
//

#ifndef ViewCouleurs_h
#define ViewCouleurs_h
#import <UIKit/UIKit.h>

#import "ViewCouleursController.h"
/// \brief Cette classe affiche les différentes couleurs disponibles pour le client.
///
@interface ViewCouleurs : UIView

@property (readonly,nonatomic,retain) NSMutableArray * tmp;
@property (readonly,nonatomic,retain) NSArray *couleurs;
@property (assign, nonatomic) CGFloat tailleIcones;
@property (assign, nonatomic) ViewCouleursController *vc;

- (void) updateView:(CGSize) format;

@end

#endif
