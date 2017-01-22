//
//  AppDelegate.swift
//  KLPQ Client
//
//  Created by Facel on 2/4/16.
//  Copyright © 2017 klpq.men. All rights reserved.
//
import Cocoa
import Foundation


@NSApplicationMain
class AppDelegate: NSObject, NSApplicationDelegate {
    @IBOutlet weak var statusMenu: NSMenu!
    let statusItem = NSStatusBar.system().statusItem(withLength: -1)
    
    func startTimer (){  //timer settings
        Timer.scheduledTimer(timeInterval: 5.0, target: self, selector: #selector(AppDelegate.statusCheck(_:)), userInfo: nil, repeats: true)
           }
    
    func applicationDidFinishLaunching(_ aNotification: Notification) {
        // Insert code here to initialize your application
        let icon = NSImage(named: "statusIcon")  //default icon
        statusItem.image = icon
        statusItem.menu = statusMenu
        startTimer()  //Timer launch
        }
//Online Checking
    @objc func statusCheck (_ timer: Timer) {
                //URL Main channel
        let myURLString = "http://main.klpq.men/stats/ams/gib_stats.php?stream=liveevent"
                //Json parsing
                if let myURL = URL(string: myURLString) {   
                do {    
                    let myHTMLString = try! NSString(contentsOf: myURL, encoding: String.Encoding.utf8.rawValue)
                    let mess = myHTMLString.data(using: String.Encoding.utf8.rawValue, allowLossyConversion: true)
                    //Using result
                        let json = try JSONSerialization.jsonObject(with: mess!, options: []) as! [String: AnyObject]
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
    func applicationWillTerminate(_ aNotification: Notification) {
            // Insert code here to tear down your application
           }
 
    // Menu
@IBAction func launchMain(_ sender: NSMenuItem) { // Main Channel
    let task = Process()
    task.launchPath = "/usr/local/bin/livestreamer"
    task.arguments = ["rtmp://main.klpq.men/live/liveevent live=1", "best"]
    task.launch()
    }
@IBAction func launchTV(_ sender: NSMenuItem) { // TV Channel
    let task = Process()
    task.launchPath = "/usr/local/bin/livestreamer"
    task.arguments = ["rtmp://main.klpq.men/live/tvstream live=1", "best"]
    task.launch()
    }
@IBAction func launchMurshun(_ sender: NSMenuItem) { // Murshun Channel
    let task = Process()
    task.launchPath = "/usr/local/bin/livestreamer"
    task.arguments = ["rtmp://main.klpq.men/live/murshun live=1", "best"]
    task.launch()
    }
}
