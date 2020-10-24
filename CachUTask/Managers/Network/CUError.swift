//
//  ErrorMessage.swift
//  GitFollowers
//
//  Created by zeyad on 6/23/20.
//  Copyright © 2020 zeyad. All rights reserved.
//

import Foundation

enum CUError: String , Error {
    case invalidURL = "This URL created an invalid request."
    case connectionError = "Unable to complete your request. Check your internet connection."
    case invalidResponse = "Invalid response from the server. Please try again."
    case invalidDate = "The data received from the server is invalid. Please try again."
    case decodeError = "Unable to decode the data received from the server. Please try again."
    case updateFail = "Unable to update favorites."
}
