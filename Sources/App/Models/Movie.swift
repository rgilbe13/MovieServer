//
//  Movies.swift
//  MovieServer
//
//  Created by Rob Gilbert on 9/2/17.
//
//

import Foundation
import FluentProvider
final class Movie: JSONSerializable {
    public var name: String = ""
    public var year: String = ""
    public var director: String = ""
    public var rating: String = ""
    public var genre: String = ""
    let storage = Storage()
    
    
    init(name: String, year: String, director: String, rating: String, genre: String) {
        self.name = name
        self.year = year
        self.director = director
        self.rating = rating
        self.genre = genre
    }
    
    init(row: Row) throws {
        name = try row.get("name")
        year = try row.get("year")
        director = try row.get("director")
        rating = try row.get("rating")
        genre = try row.get("genre")
    }
    
    func makeRow() throws -> Row {
        var row = Row()
        try row.set("name", name)
        try row.set("year", year)
        try row.set("director", director)
        try row.set("rating", rating)
        try row.set("genre", genre)
        return row
    }
    
    // in order to convert a custom object in swift to json you must first convert it to a dictionary or array. This was my way of doing it. The code below I borrowed from https://codelle.com/blog/2016/5/an-easy-way-to-convert-swift-structs-to-json/ that works on all objects by iterating through them
    func myToJSON() -> String {
        var dic:[String:String] = [:]
        dic["name"] = name
        dic["year"] = year
        dic["director"] = director
        dic["rating"] = rating
        dic["genre"] = genre
        
        do {
            let jsonData = try JSONSerialization.data(withJSONObject: dic)
            let jsonString = String(data: jsonData, encoding: String.Encoding(rawValue: String.Encoding.utf8.rawValue))
            return jsonString! as String
        } catch {
            
        }
        return "Error"
    }
}

protocol JSONRepresentable {
    var JSONRepresentation: AnyObject { get }
}

protocol JSONSerializable: JSONRepresentable {
}

extension JSONSerializable {
    var JSONRepresentation: AnyObject {
        var representation = [String: AnyObject]()
        
        for case let (label?, value) in Mirror(reflecting: self).children {
            switch value {
            case let value as JSONRepresentable:
                representation[label] = value.JSONRepresentation
                
            case let value as NSObject:
                representation[label] = value
                
            default:
                // Ignore any unserializable properties
                break
            }
        }
        
        return representation as AnyObject
    }
}

extension JSONSerializable {
    func toJSON() -> String? {
        let representation = JSONRepresentation
        
        guard JSONSerialization.isValidJSONObject(representation) else {
            return nil
        }
        
        do {
            let data = try JSONSerialization.data(withJSONObject: representation, options: [])
            return String(data: data, encoding: String.Encoding.utf8)
        } catch {
            return nil
        }
    }
}


