//
//  ButtonBackground.swift
//  MetroGnome
//
//  Created by Connor Kale on 6/30/26.
//

import SwiftUI

struct ButtonBackground: View {
    
    @Binding var width: Double
    @Binding var height: Double
    
    @Binding var backgroundColor: Color
    
    public var ButtonEdgeThickness: Double = 5
    /*
    private var width = 150.0
    private var height = 50.0
    
    private var backgroundColor = Color(red: (DefaultSettings.MainRed/255.0), green: (DefaultSettings.MainGreen/255.0), blue: (DefaultSettings.MainBlue/255.0))
    */
    var body: some View {
        ZStack {
            RoundedRectangle(cornerRadius: 2*ButtonEdgeThickness)
                .frame(width: width, height: height)
            RoundedRectangle(cornerRadius: 2*ButtonEdgeThickness)
                .fill(backgroundColor)
                .frame(width: width-ButtonEdgeThickness, height: height-ButtonEdgeThickness)

        }

    }
}

#Preview {
    ZStack {
        ButtonBackground(width: .constant(340), height: .constant(50), backgroundColor: .constant(Color(red: (DefaultSettings.MainRed/255.0), green: (DefaultSettings.MainGreen/255.0), blue: (DefaultSettings.MainBlue/255.0))))
        
        Text("Hello World button")
            .font(.system(size: 40))
    }
    .padding(.horizontal)
    .padding(.vertical, 200)
    //ButtonBackground()
    .background(Color(red: (DefaultSettings.MainRed/255.0), green: (DefaultSettings.MainGreen/255.0), blue: (DefaultSettings.MainBlue/255.0)))
}
