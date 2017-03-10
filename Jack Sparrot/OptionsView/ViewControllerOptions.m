//
//  ViewController.m
//  Jack Sparrot
//
//  Created by Nicolas Salleron on 03/03/2017.
//
//


#import "ViewControllerOptions.h"
#import "ViewOptions.h"


@interface ViewControllerOptions ()

@end
UIView *ecranOptions;

@implementation ViewControllerOptions

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
 
    //[[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent];
    //[self setView: ecranDrone];
    [self setTitle:@"Options"];
    self.view.backgroundColor = [UIColor colorWithRed:250.0/255 green:246.0/255 blue:244.0/255 alpha:1.0];
    
    ecranOptions = [[ViewOptions alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    [self setView:ecranOptions];
    
    [[self navigationController] setNavigationBarHidden:NO];
    

    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



@end
