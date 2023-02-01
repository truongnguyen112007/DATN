//
//  FlutterChannelManager.swift
//  Runner
//
//  Created by Tà on 18/01/2023.
//  Copyright © 2023 The Chromium Authors. All rights reserved.
//

import Foundation
import Flutter

class FlutterChannelManager: NSObject {
    
    private struct Constant {
        struct ChannelName {
            static let beaconsPlugin = "beacons_plugin"
        }
        
        struct ChannelMethod {
            static let scanEddyStone = "scanEddyStone"
            static let clearRegions = "clearRegions"
        }
        
        struct ChannelEvent {
            static let scanEddystoneStream = "scan_eddystone_stream"
        }
    }
    
    private var beaconScanner: BeaconScannerManager?
    private var beaconMethodChannel: FlutterMethodChannel?
    private var beaconEventChannel: FlutterEventChannel?
    private var eventSink: FlutterEventSink?

    override init() {
        super.init()
        guard let flutterVC = UIApplication.shared.windows.first?.rootViewController as? FlutterViewController else { return }
        beaconMethodChannel = FlutterMethodChannel(name: Constant.ChannelName.beaconsPlugin, binaryMessenger: flutterVC.binaryMessenger)
        bindMethodChannel()
        
        beaconEventChannel = FlutterEventChannel(name: Constant.ChannelEvent.scanEddystoneStream, binaryMessenger: flutterVC.binaryMessenger)
        beaconEventChannel?.setStreamHandler(self)
    }
    
    private func bindMethodChannel() {
        beaconMethodChannel?.setMethodCallHandler({ [weak self] (methodCall, result) in
            guard let self = self else { return }
            
            switch methodCall.method {
            case Constant.ChannelMethod.scanEddyStone:
                self.configBeaconScanner()
            case Constant.ChannelMethod.clearRegions:
                self.clearRegions()
            default:
                break
            }
        })
    }
}

extension FlutterChannelManager: FlutterStreamHandler {
    func onListen(withArguments arguments: Any?, eventSink events: @escaping FlutterEventSink) -> FlutterError? {
        self.eventSink = events
        return nil
    }
    
    func onCancel(withArguments arguments: Any?) -> FlutterError? {
        self.eventSink = nil
        return nil
    }
}

// MARK: Beacon Scanner
extension FlutterChannelManager {
    private func configBeaconScanner() {
        if beaconScanner == nil {
            beaconScanner = BeaconScannerManager()
            beaconScanner?.didObserveURLBeacon = { [weak self] url in
                guard let self = self else { return }
                self.sendBeaconURL(url: url)
            }
            beaconScanner?.startScanning()
        }
    }
    
    private func clearRegions() {
        beaconScanner?.clearRegions()
    }
    
    private func sendBeaconURL(url: String?) {
        eventSink?(url)
    }
}
