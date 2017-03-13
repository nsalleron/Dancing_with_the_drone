//
//  ViewCouleurs.m
//  Jack Sparrot
//
//  Created by Nicolas Salleron on 28/02/2017.
//
//

#import <Foundation/Foundation.h>
#import "ViewCouleurs.h"
#import "ViewCouleursController.h"

@implementation ViewCouleurs



- (id) initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    
    if(self){

        _couleurs = [[NSArray alloc] initWithObjects:
                      [[UIColor alloc] initWithRed:26/255.0 green:188/255.0 blue:156/255.0 alpha:1.0]
                     ,[[UIColor alloc] initWithRed:46/255.0 green:204/255.0 blue:113/255.0 alpha:1.0]
                     ,[[UIColor alloc] initWithRed:52/255.0 green:152/255.0 blue:219/255.0 alpha:1.0]
                     ,[[UIColor alloc] initWithRed:155/255.0 green:89/255.0 blue:182/255.0 alpha:1.0]
                     ,[[UIColor alloc] initWithRed:52/255.0 green:73/255.0 blue:94/255.0 alpha:1.0]
                     ,[[UIColor alloc] initWithRed:22/255.0 green:160/255.0 blue:133/255.0 alpha:1.0]
                     ,[[UIColor alloc] initWithRed:39/255.0 green:174/255.0 blue:96/255.0 alpha:1.0]
                     ,[[UIColor alloc] initWithRed:41/255.0 green:128/255.0 blue:185/255.0 alpha:1.0]
                     ,[[UIColor alloc] initWithRed:142/255.0 green:68/255.0 blue:173/255.0 alpha:1.0]
                     ,[[UIColor alloc] initWithRed:127/255.0 green:140/255.0 blue:141/255.0 alpha:1.0]
                     ,[[UIColor alloc] initWithRed:241/255.0 green:196/255.0 blue:15/255.0 alpha:1.0]
                     ,[[UIColor alloc] initWithRed:230/255.0 green:126/255.0 blue:34/255.0 alpha:1.0]
                     ,[[UIColor alloc] initWithRed:231/255.0 green:76/255.0 blue:60/255.0 alpha:1.0]
                     ,[[UIColor alloc] initWithRed:236/255.0 green:240/255.0 blue:241/255.0 alpha:1.0]
                     ,[[UIColor alloc] initWithRed:149/255.0 green:165/255.0 blue:166/255.0 alpha:1.0]
                     ,[[UIColor alloc] initWithRed:243/255.0 green:156/255.0 blue:18/255.0 alpha:1.0]
                     , nil ];
   
        
        
        _tmp = [NSMutableArray new];
        
        for (int i = 0; i < 16; ++i) {
            UIButton *TmpBtn = [[UIButton alloc] init];
            TmpBtn = [[UIButton alloc] init ];
            [TmpBtn setBackgroundColor:[_couleurs objectAtIndex:i]];
            [TmpBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
            
            #pragma clang diagnostic push
            #pragma clang diagnostic ignored "-Wundeclared-selector"
            [TmpBtn addTarget:self.superview action:@selector(endColorChoice:) forControlEvents:UIControlEventTouchUpInside];
            #pragma clang diagnostic pop
            
            NSLog(@"Ajout de : %@",[TmpBtn titleLabel].text);
            [_tmp addObject:TmpBtn];
            [self addSubview:TmpBtn];
        }
    
        
    }
    
    return self;
}




- (void)updateView:(CGSize)format{
    
    CGFloat height = format.height;
    CGFloat width = format.width;
    int i = 0;
    
    if (UIDeviceOrientationIsLandscape([UIDevice currentDevice].orientation))
    {
        
        
        height = height/2;
        width = width /8;
        
        for (UIButton *boutton in _tmp) {
            if(i<8){
                //NSLog(@"btn %d X = %d Y = %f width : %f height : %f",i,0,i*width, width,height);
                [boutton setFrame:CGRectMake(i*width,0  , width, height)];
            }else{
                //NSLog(@"btn %d X = %d Y = %f width : %f height : %f",i,0,i*width, width,height);
                [boutton setFrame:CGRectMake((i-8)*width,height  , width, height)];
            }
            i++;
        }
        
                                          
        
        
    }else{ //Vertical
        width = width /2;
        height = (height-10) /8;
        
        for (UIButton *boutton in _tmp) {
            if(i<8){
                NSLog(@"btn %d X = %d Y = %f width : %f height : %f",i,0,i*width, width,height);
                [boutton setFrame:CGRectMake(0,20+i*height  , width, height)];
            }else{
                NSLog(@"btn %d X = %d Y = %f width : %f height : %f",i,0,i*width, width,height);
                [boutton setFrame:CGRectMake(width, 20+(i-8)*height,width, height)];
            }
            i++;
        }
    }
    
    
}


-(void) drawRect:(CGRect)rect{
    [self updateView:rect.size];
}


@end
