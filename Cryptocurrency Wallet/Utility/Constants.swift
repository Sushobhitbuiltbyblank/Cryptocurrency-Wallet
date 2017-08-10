//
//  Constants.swift
//  Cryptocurrency Wallet
//
//  Created by Sushobhit Jain on 05/08/17.
//  Copyright © 2017 Sushobhit Jain. All rights reserved.
//

import Foundation
// MARK: Crytocurrency
struct Crytocurrency {
    static let ApiScheme = "http"
    static let ApiHost = "139.59.27.120"
    static let ApiPort = 8080
    static let ApiPath = ""
}

// MARK: Methods
struct Methods {
    static let userRegister = "/register/"
    static let userLogin = "/login/"
    static let getEthereumWallet = "/wallet/ethereum/"
    static let getEthereumTransactionHistory = "/wallet/ethereum/history/"
    static let createEthereumWallet = "/wallet/ethereum/create/"
    static let sendFundEthereum = "/wallet/ethereum/send/"
}

struct  RegisterRequestKey {
    static let name = "name"
    static let password = "password"
    static let phone = "phone"
    static let email = "email"
}

struct UserResponseKey {
    static let id = "_id"
    static let token = "token"
}

struct JSONCityResponseKey {
    static let Country_id = "country_id"
    static let Id = "id"
    static let Name = "name"
    static let State_id = "state_id"
}

struct JSONCountryResponseKey {
    static let Id = "id"
    static let Name = "name"
    static let SortName = "sortname"
}

struct JSONStateResponseKey {
    static let Id = "id"
    static let Name = "name"
    static let Country_id = "country_id"
}
struct Alert {
    static let Title = "No internet connection"
    static let Message = "Please check your internet connectivity. "
}

struct Entity {
    static let City = "City"
    static let Store = "Store"
    static let Category = "Categories"
    static let Country = "Country"
    static let State = "State"
}
struct Font {
    static let Size = 18
    static let TypeHelvetica = "Helvetica"
}
struct image {
    static let Back = "back"
    static let BackBtnBlue = "backBtnBlue"
    static let BackBtnGreen = "backBtnGreen"
    static let BackBtnRed = "backBtnRed"
    static let BlueCircle = "blueCircle"
    static let BluePin = "bluePin"
    static let BlueRedCircle = "blueRedCircle"
    static let BlueRedPin = "blueRedPin"
    static let Cross = "cross"
    static let GreenBlueCircle = "greenBlueCircle"
    static let GreenBluePin = "greenBluePin"
    static let GreenCircle = "greenCircle"
    static let GreenPin = "greenPin"
    static let Info = "info"
    static let Logo = "logo"
    static let RedCircle = "redCircle"
    static let RedGreenCircle = "redGreenCircle"
    static let RedGreenPin = "redGreenPin"
    static let RedPin = "redPin"
    static let SelectedTriagle = "selectedTriagle"
    static let Share = "share"
    static let Triangle = "triangle"
}
struct CDStoreKey {
    static let CityName = "cityName"
}
