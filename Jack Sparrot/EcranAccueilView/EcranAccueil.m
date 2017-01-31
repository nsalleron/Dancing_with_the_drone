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
        [_btnDrone setContentHorizontalAlignment:UIControlContentHorizontalAlignmentLeft];
        _btnChore = [UIButton buttonWithType:UIButtonTypeSystem];
        [_btnChore setTitle:@"Chorégraphier drone" forState:UIControlStateNormal];
        [_btnChore setContentHorizontalAlignment:UIControlContentHorizontalAlignmentLeft];
        _btnOptions  = [UIButton buttonWithType:UIButtonTypeSystem];
        [_btnOptions setTitle:@"Options" forState:UIControlStateNormal];
        [_btnOptions setContentHorizontalAlignment:UIControlContentHorizontalAlignmentLeft];
        
        
        _labelVersionApp = [[UILabel alloc] init];
        _labelBatteryDrone = [[UILabel alloc ]init];
        _labelBatterySmartphone = [[UILabel alloc ]init];
        
        double batteryLevel = (float)[myDevice batteryLevel] * 100;
        [_labelBatterySmartphone setText:[NSString stringWithFormat:@"Niveau : %d",(int)batteryLevel]];
        [_labelBatteryDrone setText:@"ABS"];
        [_labelVersionApp setText:@"Version 0.01"];
        
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
                                       format.height/5.5 + tailleIcones + 10,
                                       tailleIcones*2, tailleIcones/2)];
        
        /* Mise en place des labels */
        [_labelBatterySmartphone setFrame:CGRectMake(format.width - tailleIcones*1.2,10,tailleIcones*2,tailleIcones/3)];
        
        [_labelBatteryDrone setFrame:CGRectMake(10,10,tailleIcones,tailleIcones/2)];
        
        [_labelVersionApp setFrame:CGRectMake(format.width - tailleIcones*1.2 ,format.height -tailleIcones/2 - 20,tailleIcones,tailleIcones/2)];
        
    }else{
        
        /* Mise en place du logo et des boutons */
        [_imgLogo setFrame:CGRectMake (format.width/4.0,
                                       (format.height)/6.0, tailleIcones, tailleIcones)];
        
        
        [_btnDrone setFrame:CGRectMake(format.width/4.0 ,
                                       (format.height/6.0) + tailleIcones + 10,
                                       tailleIcones*2, tailleIcones/2)];
        
        [_btnChore setFrame:CGRectMake(format.width/4.0 ,
                                       format.height/6.0 + tailleIcones + 40,
                                       tailleIcones*2, tailleIcones/2)];
        
        [_btnOptions setFrame:CGRectMake(format.width/4.0,
                                         format.height/6.0 + tailleIcones + 70,
                                         tailleIcones*2, tailleIcones/2)];
        
        /* Mise en place des labels */
        [_labelBatterySmartphone setFrame:CGRectMake(format.width - tailleIcones*1.2,10,tailleIcones*2,tailleIcones/3)];
        
        [_labelBatteryDrone setFrame:CGRectMake(10,10,tailleIcones,tailleIcones/2)];
        
        [_labelVersionApp setFrame:CGRectMake(format.width - tailleIcones*1.2 ,format.height -tailleIcones/2 - 20,tailleIcones,tailleIcones/2)];
        
    }
    
    
    
    
}

-(void) drawRect:(CGRect)rect{
    [self updateView:rect.size];
}


@end
