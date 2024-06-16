//
//  RestroomDetailView.swift
//  RestroomFinderSwiftUI
//
//  Created by HardiB.Salih on 6/16/24.
//

import SwiftUI

struct AmenitiesView: View {
    let restroom: Restroom
    var body: some View {
        HStack(spacing: 12) {
            AmenitieView(symble: "♿️", isEnabled: restroom.accessible)
            AmenitieView(symble: "🚻", isEnabled: restroom.unisex)
            AmenitieView(symble: "🚼", isEnabled: restroom.changingTable)


        }
    }
}


struct AmenitieView: View {
    let symble : String
    let isEnabled : Bool
    var body: some View {
        if isEnabled {
            Text(symble)
        }
    }
}

struct RestroomDetailView: View {
    let restroom: Restroom
    let onClear: () -> Void
    
    var body: some View {
        VStack (alignment: .leading, spacing: 12){
            Image(systemName: "xmark.circle.fill")
                .font(.title)
                .frame(maxWidth: .infinity, alignment: .trailing)
                .onTapGesture {
                    onClear()
                }
            
            VStack(alignment: .leading) {
                Text(restroom.name)
                    .font(.headline)
                
                Text(restroom.address)
                    .font(.subheadline)
            }
           
            
            VStack(alignment: .leading) {
                if !restroom.directions.isEmpty {
                    Text("Directions").bold()
                    Text(restroom.directions)
                        .font(.caption)
                        .foregroundStyle(.gray)
                }
                
                if !restroom.comment.isEmpty {
                    Text("Comment").bold()
                    Text(restroom.comment)
                        .font(.caption)
                        .foregroundStyle(.gray)
                }
            }
            
            AmenitiesView(restroom: restroom)
            ActionButtonsView(mapItem: restroom.mapItem)
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding()
        .padding(.bottom, 40)
        .background(Color(.systemBackground))
        .clipShape(.rect(cornerRadii: .init(topLeading: 20, topTrailing: 20), style: .continuous))
        .shadow(radius: 10)
        .ignoresSafeArea()

    }
        
}

#Preview {
    RestroomDetailView(restroom: .placeholder(3), onClear: { })
}
