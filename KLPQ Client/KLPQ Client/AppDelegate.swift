//
//  AppDelegate.swift
//  KLPQ Client
//
//  Created by Facel on 2/4/16.
//  Copyright © 2016 podkolpakom.net. All rights reserved.
//
import Cocoa
@NSApplicationMain
class AppDelegate: NSObject, NSApplicationDelegate {
    @IBOutlet weak var statusMenu: NSMenu!
    let statusItem = NSStatusBar.systemStatusBar().statusItemWithLength(-1)
    func applicationDidFinishLaunching(aNotification: NSNotification) {
        // Insert code here to initialize your application
        let icon = NSImage(named: "statusIcon")
        statusItem.image = icon
        statusItem.menu = statusMenu
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
