//
//  StaticData.swift
//  NewsHub
//
//  Created by Nick M on 14.06.2022.
//

import Foundation

struct StaticData{
    
    static let categoryList = ["business","entertainment","general","health","science","sports","technology"]
    
    static func getKeys() -> [String]{
        var countryKeys = Array<String>()
        for (key,_) in countryList {
            countryKeys.append(key)
        }
        countryKeys = countryKeys.sorted(by: {$0 > $1}).reversed()
        return countryKeys
    }
    
    static let countryList=[
            "AE":"Arab Emirates",
            "AR":"Argentina",
            "AT":"Austria",
            "AU":"Australia",
            "AZ":"Azerbaijan",
            "BE":"Belgium",
            "BG":"Bulgaria",
            "BR":"Brazil",
            "CA":"Canada",
            "CH":"Switzerland",
            "CN":"China",
            "CO":"Colombia",
            "CZ":"Czech Republic",
            "DE":"Germany",
            "EG":"Egypt",
            "FR":"France",
            "GB":"United Kingdom",
            "GR":"Greece",
            "HK":"Hong Kong",
            "HU":"Hungary",
            "ID":"Indonesia",
            "IE":"Ireland",
            "IL":"Israel",
            "IN":"India",
            "IT":"Italy",
            "JP":"Japan",
            "KR":"Republic Of Korea",
            "LT":"Lithuania",
            "LV":"Latvia",
            "MX":"Mexico",
            "MY":"Malaysia",
            "MZ":"Mozambique",
            "NG":"Nigeria",
            "NL":"Netherlands",
            "NO":"Norway",
            "NZ":"New Zealand",
            "PH":"Philippines",
            "PL":"Poland",
            "PT":"Portugal",
            "RO":"Romania",
            "RU":"Russia",
            "SA":"Saudi Arabia",
            "SE":"Sweden",
            "SG":"Singapore",
            "SI":"Slovenia",
            "SK":"Slovakia",
            "TH":"Thailand",
            "TR":"Turkey",
            "TW":"Taiwan",
            "UA":"Ukraine",
            "US":"United States",
            "VE":"Venezuela",
            "ZA":"South Africa",
            ]
    
}
