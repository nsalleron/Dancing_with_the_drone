//
//  EcranAccueil.m
//  Jack Sparrot
//
//  Created by Nicolas Salleron on 31/01/2017.
//
//

#import <Foundation/Foundation.h>
#import "EcranAccueil.h"

@implementation EcranAccueil


CGFloat tailleIcones;
UIDevice *myDevice;


- (id) initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if(self){
        
        myDevice = [UIDevice currentDevice];
        
        _imgLogo = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"ParrotUniversal"]];
        _btnDrone = [UIButton buttonWithType:UIButtonTypeSystem];
        [_btnDrone setTitle:@"Contrôler drone" forState:UIControlStateNormal];
        [_btnDrone setContentHorizontalAlignment:UIControlContentHorizontalAlignmentCenter];
        _btnChore = [UIButton buttonWithType:UIButtonTypeSystem];
        [_btnChore setTitle:@"Chorégraphier drone" forState:UIControlStateNormal];
        [_btnChore setContentHorizontalAlignment:UIControlContentHorizontalAlignmentCenter];
        _btnOptions  = [UIButton buttonWithType:UIButtonTypeSystem];
        [_btnOptions setTitle:@"Options" forState:UIControlStateNormal];
        [_btnOptions setContentHorizontalAlignment:UIControlContentHorizontalAlignmentCenter];
        
        [[_btnDrone layer] setBorderWidth:1.0f];
        [[_btnDrone layer] setBorderColor:[UIColor colorWithRed:0.0 green:122.0/255.0 blue:1.0 alpha:1.0].CGColor];
        [[_btnDrone layer] setCornerRadius:8.0f];
        [[_btnDrone layer] setBorderWidth:2.0f];
        
        [[_btnChore layer] setBorderWidth:1.0f];
        [[_btnChore layer] setBorderColor:[UIColor colorWithRed:0.0 green:122.0/255.0 blue:1.0 alpha:1.0].CGColor];
        [[_btnChore layer] setCornerRadius:8.0f];
        [[_btnChore layer] setBorderWidth:2.0f];
        
        [[_btnOptions layer] setBorderWidth:1.0f];
        [[_btnOptions layer] setBorderColor:[UIColor colorWithRed:0.0 green:122.0/255.0 blue:1.0 alpha:1.0].CGColor];
        [[_btnOptions layer] setCornerRadius:8.0f];
        [[_btnOptions layer] setBorderWidth:2.0f];
        
        
        
        _labelVersionApp = [[UILabel alloc] init];
        _labelBatteryDrone = [[UILabel alloc ]init];
        _labelBatterySmartphone = [[UILabel alloc ]init];
        
        double batteryLevel = (float)[myDevice batteryLevel] * 100;
        [_labelBatterySmartphone setText:[NSString stringWithFormat:@"Niveau SmartPhone: %d",(int)batteryLevel]];
        [_labelBatteryDrone setText:@"Batterie drone : ABS"];
        [_labelVersionApp setText:@"Version 0.01"];
        
        [_labelVersionApp setFont:[UIFont systemFontOfSize:9]];
        [_labelBatteryDrone setFont:[UIFont systemFontOfSize:9]];
        [_labelBatterySmartphone setFont:[UIFont systemFontOfSize:9]];
        
        
        [self addSubview:_imgLogo];
        [self addSubview:_btnOptions];
        [self addSubview:_btnChore];
        [self addSubview:_btnDrone];
        [self addSubview:_labelVersionApp];
        [self addSubview:_labelBatteryDrone];
        [self addSubview:_labelBatterySmartphone];
        
        
        
        [self updateView:frame.size];
    }
    return self;
}

- (void)updateView:(CGSize)format{
    
    tailleIcones = format.height/3 - 30;
    
    if (UIDeviceOrientationIsLandscape([UIDevice currentDevice].orientation))
    {
        
        
        /* Mise en place du logo et des boutons */
        [_imgLogo setFrame:CGRectMake (format.width/6.0,
                            (format.height)/5.5, tailleIcones*2, tailleIcones*2)];
        
        
        [_btnDrone setFrame:CGRectMake(format.width/6.0 + tailleIcones*2 + 10,
                                       (format.height/5.5),
                                       tailleIcones*2, tailleIcones/2)];
        
        [_btnChore setFrame:CGRectMake(format.width/6.0 + tailleIcones*2 + 10,
                                       format.height/5.5 + tailleIcones/2 + 10,
                                       tailleIcones*2, tailleIcones/2)];
        
        [_btnOptions setFrame:CGRectMake(format.width/6.0 + tailleIcones*2 + 10,
                                       format.height/5.5 + tailleIcones + 20,
                                       tailleIcones*2, tailleIcones/2)];
        
        /* Mise en place des labels */
            /* LabelBatterySmartphone */
        [_labelBatterySmartphone setHidden:NO];
        [_labelBatterySmartphone setFrame:CGRectMake(format.width - tailleIcones*1.2,10,tailleIcones*1.2,tailleIcones/3)];
        
            /* LabelBatteryDrone */
        [_labelBatteryDrone setFrame:CGRectMake(10,10,tailleIcones*2,tailleIcones/2)];
        
            /* LabelVersionApp*/
        [_labelVersionApp setFrame:CGRectMake(format.width - tailleIcones*1.2 ,format.height -tailleIcones/2 - 20,tailleIcones,tailleIcones/2)];
        [_labelVersionApp setTextAlignment:NSTextAlignmentLeft];
        
    }else{
        
        /* Mise en place du logo et des boutons */
        [_imgLogo setFrame:CGRectMake (format.width/4.0,
                                       (format.height)/6.0, tailleIcones, tailleIcones)];
        
        
        [_btnDrone setFrame:CGRectMake(format.width/4.0 ,
                                       (format.height/6.0) + tailleIcones + 10,
                                       tailleIcones, tailleIcones/5)];
        
        [_btnChore setFrame:CGRectMake(format.width/4.0 ,
                                       format.height/6.0 + tailleIcones + 10 + 50,
                                       tailleIcones, tailleIcones/5)];
        
        [_btnOptions setFrame:CGRectMake(format.width/4.0,
                                         format.height/6.0 + tailleIcones + 10 + 100,
                                         tailleIcones, tailleIcones/5)];
        
        //[_btnOptions sizeToFit];
        //[_btnDrone sizeToFit];
        //[_btnChore sizeToFit];
        
        /* Mise en place des labels */
            /* LabelBatterySmartphone */
        [_labelBatterySmartphone setHidden:YES];
            /* LabelBatteryDrone */
        [_labelBatteryDrone setFrame:CGRectMake(10,10,tailleIcones,tailleIcones/2)];
            /* LabelVersionApp */
        [_labelVersionApp setFrame:CGRectMake(format.width - tailleIcones -10 ,format.height -tailleIcones/3,tailleIcones,tailleIcones/2)];
        [_labelVersionApp setTextAlignment:NSTextAlignmentRight];
        
    }
    
    
    
    
}

-(void) drawRect:(CGRect)rect{
    [self updateView:rect.size];
}


@end
