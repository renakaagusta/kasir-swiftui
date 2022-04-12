//
//  TransactionSuccessView.swift
//  Kasir
//
//  Created by renaka agusta on 07/04/22.
//

import SwiftUI

struct TransactionSuccessView: View {
    var body: some View {
        VStack {
            Image(systemName: "checkmark.circle").resizable()
                .frame(width: 50, height: 50).foregroundColor(.blue)
                Text("Berhasil melakukan transaksi")
                NavigationLink(destination: ContentView()) {
                    Text("Kembali").foregroundColor(.blue)
                }.padding()
        }
    }
}

struct TransactionSuccessView_Previews: PreviewProvider {
    static var previews: some View {
        TransactionSuccessView()
    }
}
