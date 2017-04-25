//
//  ViewController.m
//  Jack Sparrot
//
//  Created by Gregoire Gasc on 07/03/2017.
//
//


#import "ViewControllerAide.h"
#import "ViewAide.h"
#import <AVFoundation/AVFoundation.h>
#import <AVKit/AVKit.h>

@interface ViewControllerAide ()
@end

ViewAide *ecranAide;


@implementation ViewControllerAide

- (void)viewDidLoad {
    [super viewDidLoad];
    ecranAide = [[ViewAide alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    [ecranAide setBackgroundColor:[UIColor colorWithRed:250.0/255 green:246.0/255 blue:244.0/255 alpha:1.0]];
    [self setView:ecranAide];
    [[self navigationController] setNavigationBarHidden:NO];
    [self setTitle:@"Aide"];

}

- (void) launchVideo:(UIButton*)send{
    
    NSURL *path;
    /* Récupération du chemin de la vidéo */
    if([send.titleLabel.text isEqualToString:@"Changement des axes"]){
        path = [NSURL fileURLWithPath:[[NSBundle mainBundle] pathForResource:@"demoChangementAxes" ofType:@"mov"]];
    }else if([send.titleLabel.text isEqualToString:@"Changement de mode"]){
        path = [NSURL fileURLWithPath:[[NSBundle mainBundle] pathForResource:@"demoChangementMode" ofType:@"mov"]];
    }else if([send.titleLabel.text isEqualToString:@"Changement de couleurs"]){
        path = [NSURL fileURLWithPath:[[NSBundle mainBundle] pathForResource:@"demoChangementCouleur" ofType:@"mov"]];
    }else if([send.titleLabel.text isEqualToString:@"Retour Accueil"]){
        path = [NSURL fileURLWithPath:[[NSBundle mainBundle] pathForResource:@"demoRetourAccueil" ofType:@"mov"]];
    }
    
    /* Lancement de la vidéo */
    AVPlayer *player = [AVPlayer playerWithURL:path];
    AVPlayerViewController *playerViewController = [AVPlayerViewController new];
    playerViewController.player = player;
    [playerViewController.player play];
    [self.navigationController pushViewController:playerViewController animated:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)viewWillTransitionToSize:(CGSize)size withTransitionCoordinator:(id<UIViewControllerTransitionCoordinator>)coordinator{
    
    [ecranAide updateView:size];
}
/**
 * @brief Méthodes pour la rotation
 */
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}
/**
 * @brief Méthodes pour la rotation
 */
- (BOOL)shouldAutorotate
{
    return YES;
}
/**
 * @brief Méthodes pour la rotation
 */
- (BOOL)prefersStatusBarHidden {
    return YES;
}
/**
 * @brief Méthodes pour la rotation
 */
- (UIInterfaceOrientationMask)supportedInterfaceOrientations
{
    return UIInterfaceOrientationMaskAll;
}
/**
 * @brief Méthodes pour la rotation
 */
- (UIInterfaceOrientation)preferredInterfaceOrientationForPresentation
{
    return UIInterfaceOrientationPortrait;
}

@end
