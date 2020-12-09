//
//  SceneDelegate.m
//  G23
//
//  Created by yan on 2020/11/25.
//

#import "SceneDelegate.h"
#import "VCHome.h"
#import "VCFeeds.h"
#import "VCSetting.h"
#import "VCNotlogin.h"

@interface SceneDelegate ()

@end

@implementation SceneDelegate


- (void)scene:(UIScene *)scene willConnectToSession:(UISceneSession *)session options:(UISceneConnectionOptions *)connectionOptions {
    // Use this method to optionally configure and attach the UIWindow `window` to the provided UIWindowScene `scene`.
    // If using a storyboard, the `window` property will automatically be initialized and attached to the scene.
    // This delegate does not imply the connecting scene or session are new (see `application:configurationForConnectingSceneSession` instead).
    
    UIWindowScene *windowScene = (UIWindowScene*)scene;
    self.window = [[UIWindow alloc] initWithWindowScene:windowScene];
    
    // PageHome
    VCHome *home = [VCHome new];
    UINavigationController *nav1 = [[UINavigationController alloc] initWithRootViewController:home];
    nav1.tabBarItem.title = @"主页";
    nav1.tabBarItem.image = [UIImage imageNamed:@"zhuye"];
    nav1.navigationBar.translucent = NO;
    
    // PageFeeds
    VCFeeds *feeds = [VCFeeds new];
    UINavigationController *nav2 = [[UINavigationController alloc] initWithRootViewController:feeds];
    nav2.tabBarItem.title = @"广场";
    nav2.tabBarItem.image = [UIImage imageNamed:@"guangchang"];
    nav2.navigationBar.translucent = NO;
    
    // PageSetting
    UIViewController *vc3;
    NSString * loginUID = [[NSUserDefaults standardUserDefaults] stringForKey:@"loginuid"];
    if (!loginUID || [loginUID isEqualToString:@"notlogin"]) {
        vc3 = [VCNotlogin new];
    }
    else {
        vc3 = [VCSetting new];
    }
    UINavigationController *nav3 = [[UINavigationController alloc] initWithRootViewController:vc3];
    nav3.tabBarItem.title = @"设置";
    nav3.tabBarItem.image = [UIImage imageNamed:@"shezhi"];
    nav3.navigationBar.translucent = NO;
    
    // Tabbar
    UITabBarController *tab = [UITabBarController new];
    tab.viewControllers = @[nav1, nav2, nav3];
    tab.selectedIndex = 2;
    tab.tabBar.translucent = NO;

    tab.tabBar.backgroundColor = [UIColor colorWithRed:30.0/255.0 green:144.0/255.0 blue:255.0/255.0 alpha:0.5];
    tab.tabBar.tintColor = [UIColor colorWithRed:102.0/255.0 green:200.0/255.0 blue:190.0/255.0 alpha:1];

    [[self window] setRootViewController:tab];
    [[self window] makeKeyAndVisible];
}


- (void)sceneDidDisconnect:(UIScene *)scene {
    // Called as the scene is being released by the system.
    // This occurs shortly after the scene enters the background, or when its session is discarded.
    // Release any resources associated with this scene that can be re-created the next time the scene connects.
    // The scene may re-connect later, as its session was not necessarily discarded (see `application:didDiscardSceneSessions` instead).
}


- (void)sceneDidBecomeActive:(UIScene *)scene {
    // Called when the scene has moved from an inactive state to an active state.
    // Use this method to restart any tasks that were paused (or not yet started) when the scene was inactive.
}


- (void)sceneWillResignActive:(UIScene *)scene {
    // Called when the scene will move from an active state to an inactive state.
    // This may occur due to temporary interruptions (ex. an incoming phone call).
}


- (void)sceneWillEnterForeground:(UIScene *)scene {
    // Called as the scene transitions from the background to the foreground.
    // Use this method to undo the changes made on entering the background.
}


- (void)sceneDidEnterBackground:(UIScene *)scene {
    // Called as the scene transitions from the foreground to the background.
    // Use this method to save data, release shared resources, and store enough scene-specific state information
    // to restore the scene back to its current state.
}


@end
