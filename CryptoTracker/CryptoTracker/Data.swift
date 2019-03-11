//
//  Data.swift
//  CryptoTracker
//
//  Created by Micah Yong on 3/7/19.
//  All rights reserved.
//

import Foundation

class Data {
    
    let cryptoData = ["Bitcoin": "BTC",
                      "Litecoin": "LTC",
                      "Etherium": "ETH",
                      "Bitcoin Cash": "BCH",
                      "Ripple": "XRP",
                      "ZCash": "ZEC",
                      "Monero": "XMR",
                      "Maker": "MKR"]
    var cryptoNames:[String]!
    let currencyData = ["USD": "$",
                        "EUR": "€",
                        "GBP": "£"]
    var currencyNames:[String]!
    
    init() {
        // KEYS SORTED IN ALPHABETICAL ORDER
        cryptoNames = Array(cryptoData.keys).sorted()
        currencyNames = Array(currencyData.keys).sorted()
    }
    
}
