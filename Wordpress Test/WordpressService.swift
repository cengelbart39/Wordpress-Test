//
//  WordpressService.swift
//  Wordpress Test
//
//  Created by Christopher Engelbart on 1/31/23.
//

import Foundation

/// A struct that handles calling from the Wordpress API and processing the raw data
struct WordpressService {
    let url = "https://thestute.com/wp-json/wp/v2/posts?per_page=1"
    
    /**
     Fetch the most recent `Post` from the Wordpress API
     - Throws: Could throw a ``WordpressError``
     - Returns: The most recent `Post`
     */
    func fetchContent() async throws -> Post {
        guard let url = URL(string: url) else {
            throw WordpressError.invalidUrl
        }
        
        
        var request = URLRequest(url: url, cachePolicy: .reloadIgnoringLocalCacheData, timeoutInterval: 10.0)
        request.httpMethod = "GET"
        
        do {
            let (data, response) = try await URLSession.shared.data(for: request)
            
            guard let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode == 200 else {
                throw WordpressError.statusCodeError
            }
            
            do {
                // Convert recieved data to GoogleCalendarData
                let rawData = try JSONDecoder().decode([RawPost].self, from: data)
                
                return self.processData(data: rawData)
                
            } catch {
                throw error
            }
            
        } catch let DecodingError.dataCorrupted(context) {
            throw WordpressError.dataCorrupted(context.debugDescription)
            
        } catch let DecodingError.keyNotFound(key, context) {
            throw WordpressError.keyNotFound("Key '\(key)' not found: \(context.debugDescription)\ncodingPath: \(context.codingPath)")
            
        } catch let DecodingError.valueNotFound(value, context) {
            throw WordpressError.valueNotFound("Value '\(value)' not found: \(context.debugDescription)\ncodingPath: \(context.codingPath)")
            
        } catch let DecodingError.typeMismatch(type, context)  {
            throw WordpressError.typeMismatch("Type '\(type)' mismatch: \(context.debugDescription)\ncodingPath: \(context.codingPath)")
            
        } catch {
            throw WordpressError.statusCodeError
        }
    }
    
    /**
     Process ``RawPost`` data into a usable ``Post``
     - Parameter data: A ``RawPost`` array fetched from the API
     - Returns: A ``Post`` with processed information from `data`
     */
    private func processData(data: [RawPost]) -> Post {
        let title = data[0].title.rendered
        let content = data[0].content.rendered
        
        let processedTitle = processHtml(content: title)
        let processedContent = processHtml(content: content)
        
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss"
        
        let processedDate = formatter.date(from: data[0].date)
        
        return Post(
            id: data[0].id,
            date: processedDate!,
            link: data[0].link,
            title: processedTitle.first!,
            content: processedContent,
            excerpt: "",
            author: data[0].author,
            categories: data[0].categories
        )
    }
    
    /**
     Process a HTML string into an `[AttributedString]`
     - Parameter content: A string assumed to be HTML
     - Returns: An array of `AttributedString` with an entry per paragraph
     */
    private func processHtml(content: String) -> [AttributedString] {
        var insertIndex = [Int: [String]]()
        
        var split = content.split(separator: "</p>").map { String($0) }
        for index in 0..<split.count {
            split[index] = split[index].replacingOccurrences(of: "\n", with: "")
            split[index] = split[index].replacingOccurrences(of: "<p>", with: "")
            split[index] = split[index].replacingOccurrences(of: "&nbsp;", with: "")
            split[index] = split[index].replacingOccurrences(of: "<em>", with: "*")
            split[index] = split[index].replacingOccurrences(of: "</em>", with: "*")
            split[index] = split[index].replacingOccurrences(of: "<strong>", with: "**")
            split[index] = split[index].replacingOccurrences(of: "</strong>", with: "**")
            split[index] = split[index].replacingOccurrences(of: "http: //", with: "http://")
            split[index] = split[index].replacingOccurrences(of: "https: //", with: "https://")
            
            if split[index].contains("<a href=\"") {
                split[index] = processHrefLink(string: split[index])
            }
            
            if split[index].contains("\\u") {
                split[index] = processUnicode(string: split[index])
            }
            
            if split[index].contains("<br>") {
                var brSplit = processBreak(string: split[index])
                
                split[index] = brSplit[0]
                brSplit.removeFirst()
                
                insertIndex[index+1] = brSplit
            }
        }
        
        let keys = insertIndex.map { Int($0.key) }.sorted().reversed()
        
        for key in keys {
            split.insert(contentsOf: insertIndex[key]!, at: key)
        }
        
        split = split.filter { !$0.isEmpty }
            
        var output = [AttributedString]()
        
        for index in 0..<split.count {
            let attrStr = try? AttributedString(markdown: split[index])
            output.append(attrStr ?? AttributedString())
        }
        
        return output
    }

    /**
     Process HTML href links for display
     - Parameter string: A `String`  assumed to be HTML that contains `href`
     - Returns: A string with the appropriate Markdown subsitution
     */
    private func processHrefLink(string: String) -> String {
        var left = string.indices(of: "<a href=\"")
        var middle = string.indices(of: "\">")
        var right = string.indices(of: "</a>")
        
        if left.count != right.count || left.count != middle.count || middle.count != right.count {
            return string
        }
        
        var str = string
        
        while !left.isEmpty {
            var displayText = str[middle[0]...right[0]]
            displayText.removeFirst()
            displayText.removeFirst()
            displayText.removeLast()
            
            var url = str[left[0]...middle[0]]
            
            for _ in 0...8 {
                url.removeFirst()
            }
            
            url.removeLast()
            
            let out = "[\(displayText)](\(url))"
            let range1 = left[0]...right[0]
            str = str.replacingCharacters(in: range1, with: out)
            
            let range2 = str.range(of: "/a>")!
            str = str.replacingCharacters(in: range2, with: "")
            
            left = str.indices(of: "<a href=\"")
            middle = str.indices(of: "\">")
            right = str.indices(of: "</a>")
        }
        
        return str
    }

    /**
     Replace Unicode Sequence with Markdown equivleent
     - Parameter string: A string containing at least 1 `\u____`
     - Returns: A `String` replacing all `\u____` with `&#x____`
     */
    private func processUnicode(string: String) -> String {
        var unicodes = string.ranges(of: "\\u")
        var str = string
        
        while !unicodes.isEmpty {
            let codeStart = unicodes.first!.upperBound
            let codeEnd = str.index(codeStart, offsetBy: 4)
            
            let code = str[codeStart..<codeEnd]
            
            let range = unicodes.first!.lowerBound..<codeEnd
            str = str.replacingCharacters(in: range, with: "&#x\(code);")
        
            unicodes = str.ranges(of: "\\u")
        }
        
        return str
    }

    /**
     Process break lines mid-string into an array of strings
     - Parameter string: A html string that contains `<br>`
     - Returns: An array of `String`s containing `string` split at all `<br>`
     */
    private func processBreak(string: String) -> [String] {
        var br = string.ranges(of: "<br>")
        
        var str = string
        var out = [String]()
        
        var first = true
        
        while !br.isEmpty {
            
            if first && br.count == 1 {
                let top = String(str[..<br.first!.lowerBound])
                let bottom = String(str[br.first!.upperBound...])
                
                out.append(contentsOf: [top, bottom])
                
                first = false
                
            } else if first {
                let top = String(str[..<br.first!.lowerBound])
                let bottom = String(str[br.first!.upperBound..<br[1].lowerBound])
                
                out.append(contentsOf: [top, bottom])
                
                first = false
                
            } else if br.count == 1 {
                let bottom = String(str[br.first!.upperBound...])
                
                out.append(bottom)
                
            } else {
                let bottom = String(str[br.first!.upperBound..<br[1].lowerBound])
                
                out.append(bottom)
            }
            
            str = str.replacingCharacters(in: br[0], with: "")
            
            br = str.ranges(of: "<br>")
        }
        
        return out
    }
}

/// A set of `Error`s that could be thrown by ``WordpressService``
enum WordpressError: Error, LocalizedError {
    
    /// An invalid URL is passed in
    case invalidUrl
    
    /// A data task error occured
    case dataTaskError(String)
    
    /// An non-200 status code was recieved
    case statusCodeError
    
    /// Decoded data is corrupted
    case dataCorrupted(String)
    
    /// The model does not contain a specific key
    case keyNotFound(String)
    
    /// The model does not contain a specific value
    case valueNotFound(String)
    
    /// There is a differeing type between the API and the model
    case typeMismatch(String)
    
    /// Localized errro description
    var errorDescription: String? {
        switch self {
        case .invalidUrl:
            return NSLocalizedString("Wordpress: An invalid url was recieved.", comment: "")
            
        case .dataTaskError(let string):
            return string
            
        case .statusCodeError:
            return NSLocalizedString("Wordpress: An invalid status code was recieved.", comment: "")

        case .dataCorrupted(let string):
            return string
            
        case .keyNotFound(let string):
            return string
            
        case .valueNotFound(let string):
            return string
            
        case .typeMismatch(let string):
            return string
        }
    }
}
