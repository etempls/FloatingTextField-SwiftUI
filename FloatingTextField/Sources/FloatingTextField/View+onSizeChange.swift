//
//  File.swift
//  
//
//  Created by Adam Nagy on 2021. 05. 15..
//

import SwiftUI

struct SizePreferenceKey: PreferenceKey {
    static func reduce(value: inout CGSize?, nextValue: () -> CGSize?) {
        value = value ?? nextValue()
    }
}

extension View {
    func onSizeChange(_ size: @escaping (CGSize) -> Void) -> some View {
        overlay(GeometryReader { p in
            Color.clear.preference(key: SizePreferenceKey.self, value: p.size)
        })
        .onPreferenceChange(SizePreferenceKey.self) { newSize in
            size(newSize ?? .zero)
        }
    }
}
