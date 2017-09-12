import Vapor
import FluentProvider
import SQLite
import Foundation
import JSON

extension Droplet {
    func setupRoutes() throws {
        
        get("sql") { req in
            return "hello"
        }
        get("hello") { req in
            var json = JSON()
            try json.set("hello", "world")
            return json
        }
        
        get("json") { req in
            var json = JSON()
            var testArray = ["one", "two", "three"]
            do {
                try json.set("path", testArray)
            }
            
            return json.makeJSON()
        }
        
        get("") {_ in
            var movieArray = [String]()
            //var testArray = ["one", "two", "three"]
            var movie: Movie = Movie(name: "", year: "", director: "", rating: "", genre: "")
            
            for i in 1...5 {
                movie.name = "Test\(i)"
                movie.director = "Director\(i)"
                movie.genre = "Genre\(i)"
                movie.rating = "R\(i)"
                movie.year = "1998\(i)"
                movieArray.append(movie.toJSON()!)
            }
            
             let jsonData = try JSONSerialization.data(withJSONObject: movieArray, options: JSONSerialization.WritingOptions.prettyPrinted)
            var jsonString = String(data: jsonData, encoding: String.Encoding(rawValue: String.Encoding.utf8.rawValue))
            jsonString = jsonString?.replacingOccurrences(of: "\\", with: "")

            return jsonString! as String
        }
    }
}
