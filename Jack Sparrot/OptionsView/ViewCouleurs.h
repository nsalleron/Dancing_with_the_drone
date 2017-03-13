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

@interface ViewCouleurs : UIView

//@property (readonly,nonatomic,retain) UILabel *lblCouleurChoice;
@property (readonly,nonatomic,retain) UIButton *btnCouleur0;
@property (readonly,nonatomic,retain) UIButton *btnCouleur1;

@property (assign, nonatomic) CGFloat tailleIcones;
@property (assign, nonatomic) ViewCouleursController *vc;

- (void) updateView:(CGSize) format;

@end

#endif
