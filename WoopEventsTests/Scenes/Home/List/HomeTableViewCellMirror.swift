//
//  HomeTableViewCellMirror.swift
//  WoopEventsTests
//
//  Created by Felipe Dias Pereira on 2019-07-29.
//  Copyright © 2019 FelipeP. All rights reserved.
//

import UIKit

final class HomeTableViewCellMirror: MirrorObject {
  init(tableViewCell: UITableViewCell) {
    super.init(reflecting: tableViewCell)
  }

  var eventTitleLabel: UILabel? {
    return extract()
  }
  var eventDayLabel: UILabel? {
    return extract()
  }
  var eventMonthLabel: UILabel? {
    return extract()
  }
  var eventDescriptionLabel: UILabel? {
    return extract()
  }
  var eventImageView: UIImageView? {
    return extract()
  }
}
