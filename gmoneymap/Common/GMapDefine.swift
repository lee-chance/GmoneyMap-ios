//
//  GMapDefine.swift
//  gmoneymap
//
//  Created by Changsu Lee on 2021/06/08.
//

import Foundation

struct GMapDefine {
    
    enum Storyboard: String {
        case Main
        case Popup
    }
    
    enum UserDefaultsKey: String {
        case categoryMap
        case downloadedCityList
    }
    
    enum Category: String, CaseIterable {
        case all = "모두보기"
        case restaurant1 = "음식점1"
        case restaurant2 = "음식점2"
        case store1 = "상가1"
        case store2 = "상가2"
        case building1 = "가게1"
        case building2 = "가게2"
        case cafeMartCon = "카페/마트/편의점"
        case medical = "병원/약국/기타의료"
        case travel = "숙박/여행"
        case leisure = "레저"
        case culture = "도서/미용/문화"
        case home = "가전/가구/의류"
        case study = "학원/교육"
        case service = "서비스"
        case manufacturing = "제조업"
        case oil = "주유소"
        case agriculture = "꽃/과일/떡/농업"
        case construct = "건축/건설"
        case etc = "기타"
    }
    
    enum City: String, CaseIterable {
        case 가평군
        case 고양시
        case 과천시
        case 광명시
        case 광주시
        case 구리시
        case 군포시
        case 김포시
        case 남양주시
        case 동두천시
        case 부천시
        case 성남시
        case 수원시
        case 시흥시
        case 안산시
        case 안성시
        case 안양시
        case 양주시
        case 양평군
        case 여주시
        case 연천군
        case 오산시
        case 용인시
        case 의왕시
        case 의정부시
        case 이천시
        case 파주시
        case 평택시
        case 포천시
        case 하남시
        case 화성시
    }
    
}
