//
//  ViewDrone.h
//  Jack Sparrot
//
//  Created by Gregoire Gasc on 07/03/2017.
//
//

#import <UIKit/UIKit.h>
#import "ViewControllerOptions.h"
/// \brief Cette classe définit la vue d'aide
@interface ViewAide : UIView

@property (readwrite,nonatomic,retain) UIButton *btnChangementMode;
@property (readwrite,nonatomic,retain) UIButton *btnChangementCouleur;
@property (readwrite,nonatomic,retain) UIButton *btnChangementAxes;
@property (readwrite,nonatomic,retain) UIButton *btnRetourAccueil;
@property (assign, nonatomic) CGFloat tailleIcones;

- (void) updateView:(CGSize) format;

@end
