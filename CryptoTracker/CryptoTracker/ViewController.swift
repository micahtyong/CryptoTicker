//
//  ViewController.swift
//  CryptoTracker
//
//  Created by Micah Yong on 3/7/19.
//

import UIKit

class ViewController: UIViewController {
    
    let cryptoCurrencies = Data()
    var currencyType: String = "USD"
    var cryptoType: String = "Bitcoin"

    @IBOutlet weak var symbolLabel: UILabel!
    @IBOutlet weak var nameLabel: UILabel!
    
    @IBOutlet weak var priceLabel: UILabel!
    @IBOutlet weak var changeLabel: UILabel!
    
    @IBOutlet weak var currencyControl: UISegmentedControl!
    @IBOutlet weak var cryptoControl: UIPickerView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        fetchAndDisplayData(crypto: "Bitcoin", currency: "USD")
        self.cryptoControl.delegate = self
        self.cryptoControl.dataSource = self
    }
    
    @IBAction func refreshData(_ sender: UIButton) {
        fetchAndDisplayData(crypto: cryptoType, currency: currencyType)
    }
    
    @IBAction func currencyChoice(_ sender: Any) {
        switch currencyControl.selectedSegmentIndex {
        case 0:
            currencyType = "USD"
        case 1:
            currencyType = "EUR"
        case 2:
            currencyType = "GBP"
        default:
            break
        }
    }
    
    func fetchAndDisplayData(crypto: String, currency: String) {
        let ticker = cryptoCurrencies.cryptoData[crypto]
        guard let url = URL(string: "https://api.cryptonator.com/api/ticker/\(ticker ?? "BTC")-\(currency)") else { return }
        URLSession.shared.dataTask(with: url) { (data, response, error) in
            if error == nil {
                guard let data = data else { return }
                do {
                    let decoded = try JSONDecoder().decode(Ticker.self, from: data)
                    self.displayData(decoded: decoded, crypto: crypto)
                } catch let jsonError {
                    print("Error serializing JSON: ", jsonError)
                }
            }
            }.resume()
    }
    
    func chooseSymbol() -> String {
        if self.currencyType == "USD" {
            return "$"
        } else if self.currencyType == "EUR" {
            return "€"
        } else {
            return "£"
        }
    }
    
    func displayData(decoded: Ticker, crypto: String) {
        DispatchQueue.main.async {
            self.symbolLabel.text = decoded.ticker.base
            self.nameLabel.text = crypto
            
            let price = Double(decoded.ticker.price)
            let symbol = self.chooseSymbol()
            self.priceLabel.text = "\(symbol)\(String(format: "%.2f", price!))"
            
            let change = Double(decoded.ticker.change)!
            if change >= 0 {
                self.changeLabel.text = "+\(String(format: "%.3f", change))%"
                self.changeLabel.textColor = UIColor.green
            } else {
                self.changeLabel.text = "\(String(format: "%.3f", change))%"
                self.changeLabel.textColor = UIColor.red
            }
        }
    }
}

extension ViewController: UIPickerViewDelegate, UIPickerViewDataSource {
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return cryptoCurrencies.cryptoNames.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return cryptoCurrencies.cryptoNames[row]
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        cryptoType = cryptoCurrencies.cryptoNames[row]
    }
    
}

struct Ticker: Decodable {
    let ticker: TickerData
    let timestamp: Int
}

struct TickerData: Decodable {
    let base: String
    let target: String
    let price: String
    let change: String
}
