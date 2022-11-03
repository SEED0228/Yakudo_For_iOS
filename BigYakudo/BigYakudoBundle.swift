//
//  BigYakudoBundle.swift
//  YakudoForiOS
//
//  Created by 多根直輝 on 2022/11/02.
//

import WidgetKit
import SwiftUI

@main
struct BigYakudoBundle: WidgetBundle {
    var body: some Widget {
        if #available(iOSApplicationExtension 16.0, *) {
            return WidgetBundleBuilder.buildBlock(
                BigYakudo(),
                LockYakudo()
            )
        } else {
            return WidgetBundleBuilder.buildBlock(
                BigYakudo()
            )
        }
    }
}
