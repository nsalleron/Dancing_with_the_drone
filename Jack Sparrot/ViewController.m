//
//  ViewController.m
//  Jack Sparrot
//
//  Created by Nicolas Salleron on 31/01/2017.
//
//

#import "ViewController.h"
#import "EcranAccueil.h"

@interface ViewController ()

@end

EcranAccueil *ecranAccueil;

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    ecranAccueil = [[EcranAccueil alloc ] initWithFrame:[[UIScreen mainScreen] bounds]];
    [ecranAccueil setBackgroundColor:[UIColor whiteColor]];
    [self setView: ecranAccueil];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
