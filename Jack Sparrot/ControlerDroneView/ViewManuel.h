//
//  ViewDrone.h
//  Jack Sparrot
//
//  Created by Nicolas Salleron on 02/02/2017.
//
//

#import <UIKit/UIKit.h>

@interface ViewManuel : UIView

@property (readonly,nonatomic,retain) UILabel *label;
@property (readonly,nonatomic,retain) UIButton *btnRotateAvant;
@property (readonly,nonatomic,retain) UIButton *btnRotateArriere;
@property (readonly,nonatomic,retain) UIButton *btnRotateGauche;
@property (readonly,nonatomic,retain) UIButton *btnRotateDroit;

@property (assign, nonatomic) CGFloat tailleIcones;

@end
