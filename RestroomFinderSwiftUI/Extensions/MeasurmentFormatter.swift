//
//  MeasurmentFormatter.swift
//  NearMeSwiftUI
//
//  Created by HardiB.Salih on 6/16/24.
//

import Foundation

extension MeasurementFormatter {
    static var distance: MeasurementFormatter {
        let formatter = MeasurementFormatter()
        formatter.unitStyle = .long
        formatter.unitOptions = .naturalScale
        formatter.locale = Locale.current
        return formatter
    }
}
