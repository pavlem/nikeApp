//
//  SquareButtonView.swift
//  worklists
//
//  Created by Pavle Mijatovic on 5.9.24..
//

import SwiftUI

// The button itself is already self-contained, and adding a ViewModel would only add unnecessary complexity.
// In general, a ViewModel is used in our app when you need to manage state, data fetching, or complex business logic.

struct SquareButtonView: View {
    
    var title: String
    var height = CGFloat(48)
    var titleFontSize: CGFloat = 18
    var isEnabled: Bool = true
    var image: Image?
    var action: () -> Void
    
    var body: some View {
        
        Button {
            if isEnabled {
                action()
            }
        } label: {
            
            HStack {
                
                if let image = image {
                    image
                        .resizable()
                        .frame(width: Constants.imageSizeWH, height: Constants.imageSizeWH)
                }
                
                Text(title)
                    .font(.system(size: 18))
                    .fontWeight(.semibold)
            }
            .frame(maxWidth: .infinity, minHeight: height)
            .background(isEnabled ? Color.blue : Color.gray)
//            .foregroundColor(isEnabled ?  : Constants.disabledTitleTextColor)
            .cornerRadius(Constants.buttonCornerRadius)
        }
        .disabled(!isEnabled)
    }
    

    
   
}

extension SquareButtonView {
    private struct Constants {
        static let titleFontWeight: Font.Weight = .semibold
//        static let disabledTitleTextColor: Color = Asset.Colours.grey1100.swiftUIColor
        static let buttonCornerRadius: CGFloat = CGFloat(4)
        static let buttonSidePadding: CGFloat = CGFloat(54)
        static let imageSizeWH: CGFloat = CGFloat(20)
//        static let disabledBackgroundColor = Asset.Colours.grey500.swiftUIColor
    }
}
