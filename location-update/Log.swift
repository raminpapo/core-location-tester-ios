//
//  MyLogger.swift
//  Geo Regions Test
//
//  Created by Evgenii Neumerzhitckii on 21/06/2014.
//  Copyright (c) 2014 Evgenii Neumerzhitckii. All rights reserved.
//

import Foundation
import UIKit
import MapKit

class Log {
  private var textView: UITextView?

  init() {
  }

  func setTextView(textView: UITextView) {
    self.textView = textView
  }

  private func setText(text: String) {
    if let currentTextView = textView {
      var oldOffset = currentTextView.contentOffset

      let distanceToBottomLine = (currentTextView.contentSize.height - oldOffset.y)
        - currentTextView.bounds.height

      currentTextView.text = text

      iiQ.runAfterDelay(0.0001) {

        if abs(distanceToBottomLine) < 10 { // scrolled to the bottom - preserve it
          if currentTextView.bounds.height < currentTextView.contentSize.height {
            let newOffset = (currentTextView.contentSize.height - currentTextView.bounds.height)

            currentTextView.contentOffset = CGPoint(x: 0, y: newOffset)
          }
        } else {
          currentTextView.contentOffset = oldOffset
        }
      }
    }
  }

  private var text: String {
    if let currentTextView = textView {
      return currentTextView.text
    }

    return ""
  }

  func add(text: String){
    iiQ.main {
      var newText = self.text
      if countElements(newText) > 0 {
        newText += "\n"
      }
      newText += "\(self.currentTime) \(text)"
      
      self.setText(newText)
    }
  }

  class func coordToString(location: CLLocation) -> String {
    let lat = NSString(format: "%.6f", location.coordinate.latitude)
    let lon = NSString(format: "%.6f", location.coordinate.longitude)

    return "\(lat), \(lon)"
  }

  private var currentTime: String {
    let date = NSDate()
    let formatter = NSDateFormatter()
    formatter.timeStyle = .ShortStyle
    return formatter.stringFromDate(date)
  }

  func clear() {
    iiQ.main {
      self.textView?.contentOffset = CGPoint()
      self.setText("")
    }
  }
}
