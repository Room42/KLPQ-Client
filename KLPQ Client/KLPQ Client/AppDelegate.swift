//
//  AppDelegate.swift
//  KLPQ Client
//
//  Created by Facel on 2/4/16.
//  Copyright © 2017 klpq.men. All rights reserved.
//
import Cocoa

@NSApplicationMain
class AppDelegate: NSObject, NSApplicationDelegate, NSUserNotificationCenterDelegate {
    
    @IBOutlet weak var statusMenu: NSMenu!
    let statusItem = NSStatusBar.system().statusItem(withLength: -1)
    
    let Main = "liveevent"
    let TV = "tvstream"
    let Mursh = "murshun"
    var trueName = "Some"
    var liveStreamer = "/usr/local/bin/livestreamer"
    let klpqStreamUrl = "rtmp://main.klpq.men/live/"
    let statusUrl = "http://main.klpq.men/stats/ams/gib_stats.php?stream="
    let qBest = "best"
    let qMedium = "medium"
    let qWorst = "worst"
    var qual = "best"
    
    var proxy = 0
    
    func startTimer (){  //timer settings
        Timer.scheduledTimer(timeInterval: 5.0, target: self, selector: #selector(AppDelegate.scheDuled), userInfo: nil, repeats: true)
           }
    
    
    func applicationDidFinishLaunching(_ aNotification: Notification) {
        // Insert code here to initialize your application
        let icon = NSImage(named: "statusIcon")  //default icon
        statusItem.image = icon
        statusItem.menu = statusMenu
        startTimer()  //Timer launch
    }

    
    
    //notifications
    
    func showNotification(message: String) -> Void {
        let notification = NSUserNotification()
        notification.title = "\(message)"
        NSUserNotificationCenter.default.deliver(notification)
    }
    
    //lol, but it works
    func doNotRepeatNotification(){
        if (1..<4).contains(proxy) {
            showNotification(message: "\(trueName) Channel is Online")
        }
        if (12..<37706).contains(proxy){
            proxy = 6
        }
        if proxy == 37707{
            showNotification(message: "Unable to recieve status 👽")
            proxy += 1
        }
        if proxy > 37708{
            proxy = 0
        }
    }
    
    
    
    
//Online Checking
func checkStatus(url: String, channel: String){
        
        //Channel Name Resolver
        func nameRes() -> String{
            if channel == "liveevent"{
                trueName = "Main"
            }
            if channel == "tvstream"{
                trueName = "TV"
            }
            if channel == "murshun"{
                trueName = "Murshun"
            }; return trueName
        }
        _ = nameRes()

    
    //recieve status
        let fullUrl = "\(url)\(channel)"
        if let reqURL = URL(string: fullUrl){
            do {
                let HTMLString = try NSString(contentsOf: reqURL, encoding: String.Encoding.utf8.rawValue)
                let encode = HTMLString.data(using: String.Encoding.utf8.rawValue, allowLossyConversion: true)
                let json = try JSONSerialization.jsonObject(with: encode!, options: []) as! [String: AnyObject]
                if let isOnline = json["live"] as! String? {
                    if isOnline == "Online" {
                        let icon = NSImage(named: "statusIconOn")
                        statusItem.image = icon
                        statusItem.menu = statusMenu
                          print("\(trueName) Channel is Online")
                        proxy += 1
                    }
                    else {
                        let icon = NSImage(named: "statusIcon")
                        statusItem.image = icon
                        statusItem.menu = statusMenu
                          print ("\(trueName) Channel is Offline")
                        proxy = 0
                    }
                }
            }
            catch let error as NSError {
                let icon = NSImage(named: "statusIcon")
                statusItem.image = icon
                statusItem.menu = statusMenu

                print("Failed to load: \(error.localizedDescription)")
                
                if proxy > 37707{
                } else{
                proxy = 37707
                    }
            }
        }
    }

@objc func scheDuled (_ timer: Timer){
        checkStatus(url: statusUrl, channel: Main)
    doNotRepeatNotification()
        checkStatus(url: statusUrl, channel: TV)
    doNotRepeatNotification()
        checkStatus(url: statusUrl, channel: Mursh)
    doNotRepeatNotification()
    print(proxy)
    }
    
    
//Lauch Stream Fuction. Requires channel and quality
    func launchStream(channel: String, quality: String) {
        let task = Process()
        task.launchPath = liveStreamer
        task.arguments = ["\(klpqStreamUrl)\(channel) live=1", "\(quality)"]
        task.launch()
    }

    
    
    func applicationWillTerminate(_ aNotification: Notification) {
            // Insert code here to tear down your application
           }
 
    // Menu

@IBAction func launchMain(_ sender: NSMenuItem) { // Main Channel
    launchStream(channel: Main, quality: qBest)
    }
@IBAction func launchTV(_ sender: NSMenuItem) { // TV Channel
   launchStream(channel: TV, quality: qBest)
    }
@IBAction func launchMurshun(_ sender: NSMenuItem) { // Murshun Channel
   launchStream(channel: Mursh, quality: qBest)
    }
    
//custom launcher


    
    
}
