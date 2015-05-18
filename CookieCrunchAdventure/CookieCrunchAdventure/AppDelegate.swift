//
//  AppDelegate.swift
//  CookieCrunchAdventure
//
//  Created by William Manning on 4/8/15.
//  Copyright (c) 2015 William Manning. All rights reserved.
//

import UIKit
import SpriteKit
import AVFoundation

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate, SkillzDelegate {

    var window: UIWindow?
    
    lazy var backgroundMusic: AVAudioPlayer = {
        let url = NSBundle.mainBundle().URLForResource("Mining by Moonlight", withExtension: "mp3")
        let player = AVAudioPlayer(contentsOfURL: url, error: nil)
        player.numberOfLoops = -1
        return player
        }()

    func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {
        Skillz.skillzInstance().initWithGameId("1083", forDelegate: self,
                                               withEnvironment: SkillzEnvironment.Sandbox);
        
        // Load and start background music.
        backgroundMusic.play()

        return true
    }
    func application(application: UIApplication, supportedInterfaceOrientationsForWindow window: UIWindow?) -> Int {
        return Int(UIInterfaceOrientationMask.Portrait.rawValue)
    }

    func applicationWillResignActive(application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }

    func applicationWillEnterForeground(application: UIApplication) {
        // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }

    func applicationWillTerminate(application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }

    
    func tournamentWillBegin(gameParameters: [NSObject : AnyObject]!) {
        //Get the "level_index" key and try to parse it as an integer.
        if let indx = (gameParameters["level_index"] as? String) {
            if let tryInt : Int = indx.toInt() {
                LevelIndex = tryInt
            } else {
                LevelIndex = 0
            }
        } else {
            LevelIndex = 0
        }
        
        self.window?.rootViewController?.performSegueWithIdentifier("MainToGame", sender:self)
    }
    func preferredSkillzInterfaceOrientation() -> SkillzOrientation {
        return SkillzOrientation.Portrait
    }
}