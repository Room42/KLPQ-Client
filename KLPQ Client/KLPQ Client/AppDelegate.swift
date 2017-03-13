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
    let KLPQ = "tvstream"
    let Mursh = "murshun"
    var trueName = "Some"
    var liveStreamer = "/usr/local/bin/livestreamer"
    var streamLink = "/usr/local/bin/streamlink"
    let klpqStreamUrl = "rtmp://stream.klpq.men/live/"
    let statusUrl = "http://stats.klpq.men/channel/"
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
    
//menubar icon changer
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
            case "tvstream": trueName = "KLPQ"
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
                if let isOnline = json["isLive"] as! Bool? {
                    statusAll.remove("Error")
                    if isOnline == true {
                        if !statusAll.contains("\(trueName)"){
                            showNotification(message: "\(trueName) Channel is Online")
                            statusAll.insert("\(trueName)")
                        }
                    }
                    else {
                        if statusAll.contains("\(trueName)"){
                            showNotification(message: "\(trueName) Channel is Offline")
                            statusAll.remove("\(trueName)")
                        }
                    }
                }
            }
            catch _ as NSError {
                if !statusAll.contains("Error"){
                statusAll.removeAll(keepingCapacity: false)
                statusAll.insert("Error")
                showNotification(message:"Unable to receive status 👽")
                }
            }
        }
    }
    
@objc func scheDuled (_ timer: Timer){
    checkStatus(url: statusUrl, channel: Main)
    checkStatus(url: statusUrl, channel: KLPQ)
    checkStatus(url: statusUrl, channel: Mursh)
    iconChange()
    }
    
//stream launcher
    func launchStream(channel: String, quality: String, tool: String) {
        let task = Process()
        task.launchPath = tool
        task.arguments = ["\(channel)", "\(quality)"]
        task.launch()
    }
  
    func applicationWillTerminate(_ aNotification: Notification) {
            // Insert code here to tear down your application
           }
 
//Menu
@IBAction func launchMain(_ sender: NSMenuItem) { // Main Channel
    launchStream(channel: "\(klpqStreamUrl)\(Main) live=1", quality: qBest, tool: liveStreamer)
    }
@IBAction func launchTV(_ sender: NSMenuItem) { // TV Channel
    launchStream(channel: "\(klpqStreamUrl)\(KLPQ) live=1", quality: qBest, tool: liveStreamer)
    }
@IBAction func launchMurshun(_ sender: NSMenuItem) { // Murshun Channel
   launchStream(channel: "\(klpqStreamUrl)\(Mursh) live=1", quality: qBest, tool: liveStreamer)
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
        launchStream(channel: cUrl, quality: qual, tool: streamLink)
        getUrl.stringValue = ""
        LPanel.close()
    }
}
