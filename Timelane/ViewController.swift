//
//  ViewController.swift
//  Timelane
//
//  Created by Marin Todorov on 1/26/20.
//  Copyright © 2020 Underplot ltd. All rights reserved.
//

import Cocoa
import Down

class ViewController: NSViewController {

    @IBOutlet var tabView: NSTabView!
    @IBOutlet var instrumentIcon: NSImageView!
    @IBOutlet var adView: NSImageView!
    @IBOutlet var timelaneLabel: NSTextField!
    
    @IBOutlet var combineTextView: NSTextField!
    @IBOutlet var rxSwiftTextView: NSTextField!
    @IBOutlet var otherTextView: NSTextField!

    @IBOutlet var moreButton: NSButton!
    @IBOutlet var adContainer: NSView!
    
    var adController: AdController!
    
    let instrumentURL = Bundle.main.url(forResource: "TimelaneInstrument", withExtension: "instrdst")!
    let stylesURL = Bundle.main.url(forResource: "markdown/styles", withExtension: "css")!
    let combineTextURL = Bundle.main.url(forResource: "markdown/combine", withExtension: "markdown")!
    let rxSwiftTextURL = Bundle.main.url(forResource: "markdown/rxSwift", withExtension: "markdown")!
    let otherTextURL = Bundle.main.url(forResource: "markdown/other", withExtension: "markdown")!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        timelaneLabel.stringValue.append(contentsOf: " \(Bundle.main.object(forInfoDictionaryKey: "CFBundleShortVersionString") as! String)")
        adController = AdController()
        adController.setView(adView)
        
        instrumentIcon.image = NSWorkspace.shared.icon(forFile: instrumentURL.path)
        instrumentIcon.addGestureRecognizer(
            NSClickGestureRecognizer(target: self, action: #selector(installTimelane))
        )
        
        let combineMarkdown = Down(markdownString: try! String(contentsOf: combineTextURL))
        combineTextView.attributedStringValue = try! combineMarkdown.toAttributedString(.hardBreaks, stylesheet: String(contentsOf: stylesURL))
        
        let rxSwiftMarkdown = Down(markdownString: try! String(contentsOf: rxSwiftTextURL))
        rxSwiftTextView.attributedStringValue = try! rxSwiftMarkdown.toAttributedString(.hardBreaks, stylesheet: String(contentsOf: stylesURL))
        
        let otherMarkdown = Down(markdownString: try! String(contentsOf: otherTextURL))
        otherTextView.attributedStringValue = try! otherMarkdown.toAttributedString(.hardBreaks, stylesheet: String(contentsOf: stylesURL))
        
        tabView.delegate = self
        tabView.selectTabViewItem(at: 0)
        
        updateMoreButton()
    }

    @IBAction func downloadXcode(_ sender: Any) {
        NSWorkspace.shared.open(URL(string: "https://developer.apple.com/xcode/resources/")!)
    }
    
    @objc func installTimelane(_ sender: Any) {
        NSWorkspace.shared.open(instrumentURL)
    }
    
    @IBAction func selectCombineTab(_ sender: Any) {
        tabView.selectTabViewItem(at:
            tabView.tabViewItems.firstIndex { tabItem -> Bool in
                return (tabItem.identifier as? String) == "combine"
            }!
        )
    }

    @IBAction func selectRxSwiftTab(_ sender: Any) {
        tabView.selectTabViewItem(at:
            tabView.tabViewItems.firstIndex { tabItem -> Bool in
                return (tabItem.identifier as? String) == "rxswift"
            }!
        )
    }

    @IBAction func selectOtherTab(_ sender: Any) {
        tabView.selectTabViewItem(at:
            tabView.tabViewItems.firstIndex { tabItem -> Bool in
                return (tabItem.identifier as? String) == "other"
            }!
        )
    }
    
    @IBAction func openTimelaneTools(_ sender: Any) {
        NSWorkspace.shared.open(URL(string: "http://timelane.tools")!)
    }
    
    var moreURL: URL?
    func updateMoreButton() {
        switch tabView.selectedTabViewItem!.identifier as? String {
        case "setup":
            moreButton.isHidden = false
            moreButton.title = "Official Website: http://timelane.tools"
            moreURL = URL(string: "http://timelane.tools")!
        case "combine":
            moreButton.isHidden = false
            moreButton.title = "More at: https://github.com/icanzilb/TimelaneCombine"
            moreURL = URL(string: "https://github.com/icanzilb/TimelaneCombine")!
        case "rxswift":
            moreButton.isHidden = false
            moreButton.title = "More at: https://github.com/icanzilb/RxTimelane"
            moreURL = URL(string: "https://github.com/icanzilb/RxTimelane")!
        case "other":
            moreButton.isHidden = false
            moreButton.title = "More at: https://github.com/icanzilb/TimelaneCore"
            moreURL = URL(string: "https://github.com/icanzilb/TimelaneCore")!
        default:
            moreButton.isHidden = true
            moreURL = nil
        }
    }
    
    @IBAction func openMore(_ sender: Any) {
        guard let url = moreURL else { return }
        NSWorkspace.shared.open(url)
    }
}

extension ViewController: NSTabViewDelegate {
    func tabView(_ tabView: NSTabView, didSelect tabViewItem: NSTabViewItem?) {
        guard let label = tabViewItem?.label else { return }
        adController.setContext(label)
        updateMoreButton()
    }
}
