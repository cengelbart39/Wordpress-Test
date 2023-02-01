//
//  StringProtocol+Extension.swift
//  Saint Rose of Lima
//
//  Created by Christopher Engelbart on 9/3/22.
//
//  String Extension by Paul Hudson
//  https://www.hackingwithswift.com/example-code/strings/how-to-read-a-single-character-from-a-string
//


import Foundation

extension StringProtocol {
    
    /**
     Get the lower-bound index (if it exists) of some substring
     - Parameters:
        - string: A substring conformant to `StringProtocol`
        - options: An array of comparison options
     - Returns: The lower-bound index of `string`; `nil` if `string` doesn't exist
     */
    func index<S: StringProtocol>(of string: S, options: String.CompareOptions = []) -> Index? {
        range(of: string, options: options)?.lowerBound
    }
    
    /**
     Get the upper-bound index (if it exists) of some substring
     - Parameters:
        - string: A substring conformant to `StringProtocol`
        - options: An array of comparison options
     - Returns: The upper-bound index of `string`; `nil` if `string` doesn't exist
     */
    func endIndex<S: StringProtocol>(of string: S, options: String.CompareOptions = []) -> Index? {
        range(of: string, options: options)?.upperBound
    }
    
    /**
     Get the indicies where a substring exists
     - Parameters:
        - string: A substring conformant to `StringProtocol`
        - options: An array of comparison options
     - Returns: The lower-bound indicies where `string` exists
     */
    func indices<S: StringProtocol>(of string: S, options: String.CompareOptions = []) -> [Index] {
        ranges(of: string, options: options).map(\.lowerBound)
    }
    
    /**
     Get the range(s) of some substring
     - Parameters:
        - string: A substring conformant to `StringProtocol`
        - options: An array of comparison options
     - Returns: The range(s) (lower and upper-bound) of a substring.
     */
    func ranges<S: StringProtocol>(of string: S, options: String.CompareOptions = []) -> [Range<Index>] {
        var result: [Range<Index>] = []
        var startIndex = self.startIndex
        while startIndex < endIndex,
            let range = self[startIndex...]
                .range(of: string, options: options) {
                result.append(range)
                startIndex = range.lowerBound < range.upperBound ? range.upperBound :
                    index(range.lowerBound, offsetBy: 1, limitedBy: endIndex) ?? endIndex
        }
        return result
    }
}
