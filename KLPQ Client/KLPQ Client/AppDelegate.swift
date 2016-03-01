//
//  AppDelegate.swift
//  KLPQ Client
//
//  Created by Facel on 2/4/16.
//  Copyright © 2016 podkolpakom.net. All rights reserved.
//
import Cocoa
import Foundation

@NSApplicationMain
class AppDelegate: NSObject, NSApplicationDelegate {
    @IBOutlet weak var statusMenu: NSMenu!
    let statusItem = NSStatusBar.systemStatusBar().statusItemWithLength(-1)
    
    func startTimer (){  //timer settings
        NSTimer.scheduledTimerWithTimeInterval(5.0, target: self, selector: "statusCheck:", userInfo: nil, repeats: true)
            }
    
    func applicationDidFinishLaunching(aNotification: NSNotification) {
        // Insert code here to initialize your application
        let icon = NSImage(named: "statusIcon")  //default icon
        statusItem.image = icon
        statusItem.menu = statusMenu
        startTimer()  //Timer launch
        }
//Online Checking
    @objc func statusCheck (timer:NSTimer!) {
                //URL Main channel
        let myURLString = "http://dedick.podkolpakom.net/stats/ams/gib_stats.php?stream=liveevent"
                //Json parsing
                if let myURL = NSURL(string: myURLString) {
                    let myHTMLString = try! NSString(contentsOfURL: myURL, encoding: NSUTF8StringEncoding)
                    let mess = myHTMLString.dataUsingEncoding(NSUTF8StringEncoding, allowLossyConversion: false)!
                    //Using result
                    do {
                        let json = try NSJSONSerialization.JSONObjectWithData(mess, options: []) as! [String: AnyObject]
                        if let isOnline = json["live"] as! String? {
                            if isOnline == "Online" {
                                let icon = NSImage(named: "statusIconOn")
                                statusItem.image = icon
                                statusItem.menu = statusMenu
                                                            }
                            else {
                                let icon = NSImage(named: "statusIcon")
                                statusItem.image = icon
                                statusItem.menu = statusMenu
                            }
                        }
                    }
                    catch let error as NSError {
                        print("Failed to load: \(error.localizedDescription)")
                    }
                }
            }


    func applicationWillTerminate(aNotification: NSNotification) {
            // Insert code here to tear down your application
           }
 
    // Menu
@IBAction func launchMain(sender: NSMenuItem) { // Main Channel
    let task = NSTask()
    task.launchPath = "/usr/local/bin/livestreamer"
    task.arguments = ["rtmp://dedick.podkolpakom.net/live/liveevent live=1", "best"]
    task.launch()
    }
@IBAction func launchTV(sender: NSMenuItem) { // TV Channel
    let task = NSTask()
    task.launchPath = "/usr/local/bin/livestreamer"
    task.arguments = ["rtmp://dedick.podkolpakom.net/live/tvstream live=1", "best"]
    task.launch()
    }
@IBAction func launchMurshun(sender: NSMenuItem) { // Murshun Channel
    let task = NSTask()
    task.launchPath = "/usr/local/bin/livestreamer"
    task.arguments = ["rtmp://dedick.podkolpakom.net/live/murshun live=1", "best"]
    task.launch()
    }
}