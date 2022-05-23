//
//  PricechangeVC.swift
//  AssessmentTest
//
//  Created by Viabhav Powar on 23/05/22.
//

import UIKit
import Toast_Swift

class PricechangeVC: UIViewController {
    
    @IBOutlet weak var priceCollectionview: UICollectionView!
    
    var priceChangeArr: priceChange?

    
    fileprivate var redShades = ["a30000", "ad0000", "b80000", "c20000", "cc0000", "f50000"]
    fileprivate let greenShades = ["008a00", "009900", "00a300", "00b300", "00bd00", "00f000"]


    override func viewDidLoad() {
        super.viewDidLoad()
        getPricechange()
        setUpUI()
    }
    
    private func setUpUI(){
        self.navigationController?.navigationBar.prefersLargeTitles = true
        self.navigationItem.title = "Price Change"
    }
    
}
extension PricechangeVC {
    
    func getPricechange() {
      

        self.view.makeToastActivity(.center)
        
        NetworkManager.instance.getprice { (returnedResponse, error) in
            
            if error != nil {
                DispatchQueue.main.async {
                    self.view.hideToastActivity()
                    self.view.makeToast(error?.localizedDescription, duration: 0.10, position: .bottom)
                }
            }else {
                
                if let returnedResponse = returnedResponse {
                    DispatchQueue.main.async {
                        self.view.hideToastActivity()
                        self.view.makeToast(error?.localizedDescription, duration: 2.0, position: .bottom)
                    }
                    self.priceChangeArr = returnedResponse
                    

                    DispatchQueue.main.async {
                        self.priceCollectionview.reloadData()
                    }
                }else {
                    //Failure
                    
                }
                
            }
            
        }
        
    }
    
    
}



extension PricechangeVC:UICollectionViewDataSource{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.priceChangeArr?.symbol.count ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "PricechangeCell", for: indexPath) as! PricechangeCell
        
        guard let price = self.priceChangeArr else { return cell }
        let symbolitem = price.symbol[indexPath.item]
        let priceChangeitem = price.priceChange[indexPath.item]
        let priceitem = price.price[indexPath.item]
        
        if priceChangeitem > 0{
            let hex = indexPath.row+1 >= self.greenShades.count ? self.greenShades[self.redShades.count-1] :  self.greenShades[indexPath.row]
            cell.backgroundColor = UIColor.init(hexString: hex) ?? .green
            cell.lblSymbolTitle.textColor = .black
            cell.lblPricevalue.textColor = .black
            cell.lblpricechangevalue.textColor = .black
            cell.lblPriceTitle.textColor = .black
            cell.lblPriceChangeTitle.textColor = .black
        }else{
            let hex = indexPath.row+1 >= self.redShades.count ? self.redShades[self.redShades.count-1] :  self.redShades[indexPath.row]
            cell.backgroundColor = UIColor.init(hexString: hex) ?? .red
            cell.lblSymbolTitle.textColor = .white
            cell.lblPricevalue.textColor = .white
            cell.lblpricechangevalue.textColor = .white
            cell.lblPriceTitle.textColor = .white
            cell.lblPriceChangeTitle.textColor = .white
        }
        cell.lblSymbolTitle.text = symbolitem
        cell.lblPricevalue.text = priceitem.string
        cell.lblpricechangevalue.text = priceChangeitem.string
        return cell
    }
    
    
}
extension PricechangeVC:UICollectionViewDelegateFlowLayout{
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        CGSize(width: collectionView.frame.size.width / 3 - 1, height: collectionView.frame.size.height / 5 - 1)
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 1
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 1
    }
}


public extension String {
    func double(locale: Locale = .current) -> Double? {
        let formatter = NumberFormatter()
        formatter.locale = locale
        formatter.allowsFloats = true
        return formatter.number(from: self)?.doubleValue
    }
}
public extension SignedNumeric {

    var string: String {
        return String(describing: self)
    }

}

extension UIColor {
    var redValue: CGFloat{ return CIColor(color: self).red }
    var greenValue: CGFloat{ return CIColor(color: self).green }
    var blueValue: CGFloat{ return CIColor(color: self).blue }
    var alphaValue: CGFloat{ return CIColor(color: self).alpha }
}

public extension UIColor {
    
    convenience init?(hexString: String, transparency: CGFloat = 1) {
        var string = ""
        if hexString.lowercased().hasPrefix("0x") {
            string =  hexString.replacingOccurrences(of: "0x", with: "")
        } else if hexString.hasPrefix("#") {
            string = hexString.replacingOccurrences(of: "#", with: "")
        } else {
            string = hexString
        }

        if string.count == 3 { // convert hex to 6 digit format if in short format
            var str = ""
            string.forEach { str.append(String(repeating: String($0), count: 2)) }
            string = str
        }

        guard let hexValue = Int(string, radix: 16) else { return nil }

        var trans = transparency
        if trans < 0 { trans = 0 }
        if trans > 1 { trans = 1 }

        let red = (hexValue >> 16) & 0xff
        let green = (hexValue >> 8) & 0xff
        let blue = hexValue & 0xff
        self.init(red: red, green: green, blue: blue, transparency: trans)
    }

    convenience init?(red: Int, green: Int, blue: Int, transparency: CGFloat = 1) {
        guard red >= 0 && red <= 255 else { return nil }
        guard green >= 0 && green <= 255 else { return nil }
        guard blue >= 0 && blue <= 255 else { return nil }

        var trans = transparency
        if trans < 0 { trans = 0 }
        if trans > 1 { trans = 1 }

        self.init(red: CGFloat(red) / 255.0, green: CGFloat(green) / 255.0, blue: CGFloat(blue) / 255.0, alpha: trans)
    }

}

