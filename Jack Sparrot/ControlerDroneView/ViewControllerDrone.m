//
//  ViewController.m
//  Jack Sparrot
//
//  Created by Nicolas Salleron on 02/02/2017.
//
//

#import "ViewControllerDrone.h"
#import "ViewControllerManuel.h"
#import "ViewControllerImitation.h"
#import "ViewControllerChoregraphie.h"


#import "ViewManuel.h"
#import "ViewImitation.h"
#import "ViewEcranChoregraphie.h"


@interface ViewControllerDrone ()

@end
UIView *ecranDrone;

@implementation ViewControllerDrone

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
 
    //[[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent];
    //[self setView: ecranDrone];
    [self setTitle:@"Drone"];
    
    self.pageController = [[UIPageViewController alloc] initWithTransitionStyle:UIPageViewControllerTransitionStyleScroll navigationOrientation:UIPageViewControllerNavigationOrientationHorizontal options:nil];
    
    self.pageController.dataSource = self;
    [[self.pageController view] setFrame:[[self view] bounds]];
    
    //On place les views
    UIViewController *page1 = [self viewControllerAtIndex:0];
    
    // load the view controllers in our pages array
    NSArray *pages = [[NSArray alloc] initWithObjects:page1, nil];
    
    //NSArray *viewControllers = [NSArray arrayWithObject:initialViewController];
   
    
    [self.pageController setViewControllers:pages direction:UIPageViewControllerNavigationDirectionForward animated:YES completion:nil];
    
    //[self.pageController setViewControllers:pages direction:UIPageViewControllerNavigationDirectionForward animated:NO completion:nil];
    
    [self addChildViewController:self.pageController];
    [[self view] addSubview:[self.pageController view]];
    [self.pageController didMoveToParentViewController:self];
    
    self.view.backgroundColor = [UIColor colorWithRed:250.0/255 green:246.0/255 blue:244.0/255 alpha:1.0];
    
    UIPageControl *pageControl = [UIPageControl appearance];
    pageControl.pageIndicatorTintColor = [UIColor grayColor];
    pageControl.currentPageIndicatorTintColor = [UIColor redColor];
  
    
    
    
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

- (UIViewController *)pageViewController:(UIPageViewController *)pageViewController viewControllerBeforeViewController:(UIViewController *)viewController {

    NSUInteger index = [(ViewControllerManuel *)viewController index];
    
    if (index == 0) {
        return nil;
    }
    
    index--;
   
    return [self viewControllerAtIndex:index];
    
}

- (UIViewController *)pageViewController:(UIPageViewController *)pageViewController viewControllerAfterViewController:(UIViewController *)viewController {
    
    NSLog(@"Passage pageViewController2");
    
    NSUInteger index = [(ViewControllerManuel *)viewController index];
    
    index++;
    
    if (index == 3) {
        return nil;
    }
    
    return [self viewControllerAtIndex:index];
    
}

- (NSInteger)presentationCountForPageViewController:(UIPageViewController *)pageViewController {
    // The number of items reflected in the page indicator.
    return 3;
}

- (NSInteger)presentationIndexForPageViewController:(UIPageViewController *)pageViewController {
    // The selected item reflected in the page indicator.
    return 0;
}

- (UIViewController *)viewControllerAtIndex:(NSUInteger)index {
    
    UIViewController *childViewController;
    childViewController = [[ViewControllerManuel alloc] init];
    
    NSLog(@"Page :  %ld",index);
    
    switch (index) {
        case 0:
            childViewController = [[ViewControllerManuel alloc] init];
            
            ecranDrone = [[ViewManuel alloc ] initWithFrame:[[UIScreen mainScreen] bounds]];
            [ecranDrone setBackgroundColor:[UIColor colorWithRed:250.0/255 green:246.0/255 blue:244.0/255 alpha:1.0]];
            
            [childViewController setView:ecranDrone];
             ((ViewControllerManuel*)childViewController).index = index;
            
            break;
            
        case 1:
            childViewController = [[ViewControllerImitation alloc] init];
            
            ecranDrone = [[ViewImitation alloc ] initWithFrame:[[UIScreen mainScreen] bounds]];
            [ecranDrone setBackgroundColor:[UIColor colorWithRed:250.0/255 green:246.0/255 blue:244.0/255 alpha:1.0]];
            
            [childViewController setView:ecranDrone];
            ((ViewControllerImitation*)childViewController).index = 1;
            
            // LE BREAK LAAAA
            break;
            
        case 2:
            childViewController = [[ViewControllerChoregraphie alloc] init];
           
            ecranDrone = [[ViewEcranChoregraphie alloc ] initWithFrame:[[UIScreen mainScreen] bounds]];
            [ecranDrone setBackgroundColor:[UIColor colorWithRed:250.0/255 green:246.0/255 blue:244.0/255 alpha:1.0]];
            
            [childViewController setView:ecranDrone];
            
             ((ViewControllerChoregraphie*)childViewController).index = index;
           
            break;
        default:
            childViewController = nil;
    }
    
    
    return childViewController;
    
}



@end
