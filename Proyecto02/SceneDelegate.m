//
//  SceneDelegate.m
//  Proyecto02
//
//  Created by MacBook Pro on 17/11/25.
//

#import "SceneDelegate.h"
#import "AppDelegate.h"

@interface SceneDelegate ()

@end

@implementation SceneDelegate


- (void)scene:(UIScene *)scene willConnectToSession:(UISceneSession *)session options:(UISceneConnectionOptions *)connectionOptions {
   
}


- (void)sceneDidDisconnect:(UIScene *)scene {
    
}


- (void)sceneDidBecomeActive:(UIScene *)scene {
    
}


- (void)sceneWillResignActive:(UIScene *)scene {
    
}


- (void)sceneWillEnterForeground:(UIScene *)scene {
    }


- (void)sceneDidEnterBackground:(UIScene *)scene {
   
    [(AppDelegate *)UIApplication.sharedApplication.delegate saveContext];
}


@end
