//  Created by dasdom on 18.09.19.
//  Copyright © 2019 dasdom. All rights reserved.
//

import UIKit

class NightDayViewController: UIViewController {
  
  var timer: Timer?
  
  var contentView: NightDayView {
    return view as! NightDayView
  }
  
  override func loadView() {
    let contentView = NightDayView(frame: UIScreen.main.bounds)
    contentView.button.addTarget(self, action: #selector(openMusic), for: .touchUpInside)
    view = contentView
  }
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Settings", style: .plain, target: self, action: #selector(settings(sender:)))
    
    timer = Timer.scheduledTimer(timeInterval: 60, target: self, selector: #selector(updateView), userInfo: nil, repeats: true)
    
    updateView()
    
    UIScreen.main.brightness = 0.1
    
    NotificationCenter.default.addObserver(self, selector: #selector(updateButton), name: hideRaggitButtonChangeNotification, object: nil)
  }
  
  override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(animated)
    
    contentView.button.isHidden = UserDefaults.standard.bool(forKey: hideRabbitButtonKey)
  }
  
  override func viewDidAppear(_ animated: Bool) {
    super.viewDidAppear(animated)
    
    updateView()
  }
  
  @objc func settings(sender: UIBarButtonItem) {
    let next = UINavigationController(rootViewController: SettingsTableViewController())
    present(next, animated: true, completion: nil)
  }
  
  @objc func updateView() {
    
    do {
      let url = FileManager.settingsPath()
      let data = try Data(contentsOf: url)
      let timeSettings = try JSONDecoder().decode([TimeSetting].self, from: data)
      if let start = timeSettings.first, let end = timeSettings.last {
        let timePeriod = TimePeriod(date: Date(), start: start.time, end: end.time)
        switch timePeriod {
        case .day:
          contentView.imageView.image = UIImage(named: "day")
        case .night:
          contentView.imageView.image = UIImage(named: "night")
        }
      }
    } catch {
      print("error: \(error)")
    }
    
  }
  
  @objc func openMusic() {
    UIApplication.shared.openURL(URL(string: "music://")!)
  }
  
  @objc func updateButton() {
    contentView.button.isHidden = UserDefaults.standard.bool(forKey: hideRabbitButtonKey)
  }
}
