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
    var qual = "best"
    var statusAll = Set<String>()

    
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
    
//change icon
    func iconChange (){
        if statusAll.contains("Error"){
            let icon = NSImage(named: "statusError")
            statusItem.image = icon
            statusItem.menu = statusMenu
        } else {
            if statusAll.isEmpty {
                let icon = NSImage(named: "statusIcon")
                statusItem.image = icon
                statusItem.menu = statusMenu
            }
            if !statusAll.isEmpty {
                let icon = NSImage(named: "statusIconOn")
                statusItem.image = icon
                statusItem.menu = statusMenu
            }
        }
    }
    
//Online Checking
    func checkStatus(url: String, channel: String) {
//channel name resolver
        switch channel {
            case "liveevent": trueName = "Main"
            case "tvstream": trueName = "TV"
            case "murshun": trueName = "Murshun"
        default: trueName = "Some"
        }
//recieve status
        let fullUrl = "\(url)\(channel)"
        if let reqURL = URL(string: fullUrl){
            do {
                let HTMLString = try NSString(contentsOf: reqURL, encoding: String.Encoding.utf8.rawValue)
                let encode = HTMLString.data(using: String.Encoding.utf8.rawValue, allowLossyConversion: true)
                let json = try JSONSerialization.jsonObject(with: encode!, options: []) as! [String: AnyObject]
                if let isOnline = json["live"] as! String? {
                    statusAll.remove("Error")
                    if isOnline == "Online" {
                        if statusAll.contains("\(trueName)"){
                        } else {
                            showNotification(message: "\(trueName) Channel is Online")
                            statusAll.insert("\(trueName)")
                        }
                    }
                    else {
                        if statusAll.contains("\(trueName)"){
                            statusAll.remove("\(trueName)")
                            showNotification(message: "\(trueName) Channel is Offline")
                        }
                    }
                }
            }
            catch _ as NSError {
                if statusAll.contains("Error"){
                }
                else{
                statusAll.removeAll(keepingCapacity: false)
                statusAll.insert("Error")
                showNotification(message:"Unable to receive status 👽")
                }
            }
        }
    }
    
@objc func scheDuled (_ timer: Timer){
    checkStatus(url: statusUrl, channel: Main)
    checkStatus(url: statusUrl, channel: TV)
    checkStatus(url: statusUrl, channel: Mursh)

    iconChange()
    }
    
//Lauch Stream Fuction. Requires channel and quality
    func launchStream(channel: String, quality: String) {
        let task = Process()
        task.launchPath = liveStreamer
        task.arguments = ["\(channel)", "\(quality)"]
        task.launch()
    }
  
    func applicationWillTerminate(_ aNotification: Notification) {
            // Insert code here to tear down your application
           }
 
//Menu
@IBAction func launchMain(_ sender: NSMenuItem) { // Main Channel
    launchStream(channel: "\(klpqStreamUrl)\(Main) live=1", quality: qBest)
    }
@IBAction func launchTV(_ sender: NSMenuItem) { // TV Channel
   launchStream(channel: "\(klpqStreamUrl)\(TV) live=1", quality: qBest)
    }
@IBAction func launchMurshun(_ sender: NSMenuItem) { // Murshun Channel
   launchStream(channel: "\(klpqStreamUrl)\(Mursh) live=1", quality: qBest)
    }
  
//Custom Launcher
    @IBOutlet weak var LPanel: NSPanel!
    @IBOutlet weak var getUrl: NSTextField!
    @IBOutlet weak var LQCheck: NSButton!
    @IBAction func cGo(_ sender: Any) {
        let qControl = LQCheck.stringValue
        if qControl == "1"{
            qual = "worst"
        } else {
            qual = "best"
        }
        let cUrl = getUrl.stringValue
        launchStream(channel: cUrl, quality: qual)
        getUrl.stringValue = ""
        LPanel.close()
    }
}
