//
//  ViewDimensionViewController.m
//  Jack Sparrot
//
//  Created by Nicolas Salleron on 28/02/2017.
//
//

#import "ViewDimensionViewController.h"
#import "ViewDimension.h"

@interface ViewDimensionViewController ()
@end
ViewDimension *ecranDimension;

@implementation ViewDimensionViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    //Horizontal
    NSNumber *value = [NSNumber numberWithInt:UIInterfaceOrientationLandscapeLeft];
    [[UIDevice currentDevice] setValue:value forKey:@"orientation"];
    
    ecranDimension = [[ViewDimension alloc ] initWithFrame:[[UIScreen mainScreen] bounds]];
    [ecranDimension setBackgroundColor:[UIColor colorWithRed:250.0/255 green:246.0/255 blue:244.0/255 alpha:1.0]];
    //[[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent];
    [self setView: ecranDimension];
    [self setTitle:@"Dimensions"];
    // Do any additional setup after loading the view from its nib.
    
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)viewWillTransitionToSize:(CGSize)size withTransitionCoordinator:(id<UIViewControllerTransitionCoordinator>)coordinator{
    
    [ecranDimension updateView:size];
}
/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
