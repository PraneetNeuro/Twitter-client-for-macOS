//
//  API.swift
//  Twitter
//
//  Created by Praneet S on 18/02/21.
//

import Foundation

class URLs {
    public static let authBaseURL = URL(string: "https://api.twitter.com/oauth2/token")!
    public static func userTimelineURL(userID: String) -> URL {
        return URL(string: "https://api.twitter.com/2/users/\(userID)/tweets")!
    }
    public static func userLookupURL(username: String) -> URL {
        return URL(string: "https://api.twitter.com/2/users/by?usernames=\(username.replacingOccurrences(of: " ", with: "", options: .literal))&expansions=pinned_tweet_id&user.fields=profile_image_url,verified")!
    }
}

struct authResponse: Decodable {
    let token_type: String
    let access_token: String
}

class API: ObservableObject {
    private init() {}
    public static var shared: API = API()
    @Published var publishedUserTimeline: Timeline?
    @Published var usersSearchResult: UserSearchResponse?
    
    public func usersFetch(username: String, completion: @escaping (Data) -> Void) {
        var getTimelineRequest = URLRequest(url: URLs.userLookupURL(username: username))
        getTimelineRequest.httpMethod = "GET"
        getTimelineRequest.setValue("application/json;charset=UTF-8", forHTTPHeaderField: "Content-Type")
        getTimelineRequest.setValue("Bearer " + Authentication.shared.authenticationResponse!.access_token, forHTTPHeaderField: "Authorization")
        let task = URLSession.shared.dataTask(with: getTimelineRequest) { data, response, error in
            guard let data = data,
                  let response = response as? HTTPURLResponse,
                  (200 ..< 300) ~= response.statusCode,
                  error == nil else {
                print("Error: \(error)")
                return
            }
            completion(data)
        }
        task.resume()
    }
    
    public func userTimelineFetch(userID: String, completion: @escaping (Data) -> Void) {
        var getTimelineRequest = URLRequest(url: URLs.userTimelineURL(userID: userID))
        getTimelineRequest.httpMethod = "GET"
        getTimelineRequest.setValue("application/json;charset=UTF-8", forHTTPHeaderField: "Content-Type")
        getTimelineRequest.setValue("Bearer " + Authentication.shared.authenticationResponse!.access_token, forHTTPHeaderField: "Authorization")
        let task = URLSession.shared.dataTask(with: getTimelineRequest) { data, response, error in
            guard let data = data,
                  let response = response as? HTTPURLResponse,
                  (200 ..< 300) ~= response.statusCode,
                  error == nil else {
                return
            }
            completion(data)
        }
        task.resume()
    }
    
    public func timelineSearch(userID: String) {
        userTimelineFetch(userID: userID) { userTimeline in
            DispatchQueue.main.async {
                self.publishedUserTimeline = try? JSONDecoder().decode(Timeline.self, from: userTimeline)
            }
        }
    }
    
    public func userSearch(username: String) {
        usersFetch(username: username) { users in
            DispatchQueue.main.async {
                print("debug: ", String(data: users, encoding: .utf8))
                do {
                self.usersSearchResult = try JSONDecoder().decode(UserSearchResponse.self, from: users)
                } catch {
                    print(error)
                }
                print(self.usersSearchResult)
            }
        }
    }

    
}

class Authentication: ObservableObject {
    private init() {}
    public static var shared: Authentication = Authentication()
    public var authenticationResponse: authResponse?
    @Published var isAuthenticated: Bool = false
    
    enum authenticationMode {
        case appOnly
    }
    
    public let authRequestBody: Data = "grant_type=client_credentials".data(using: .utf8)!
    private let consumerKey: String = "APIKey"
    private let consumerSecret: String = "APISecret"
    private var encodedAuthKey: String {
        String(consumerKey + ":" + consumerSecret).data(using: .utf8)!.base64EncodedString()
    }
    
    public func initAuthRequest(callback: @escaping (authResponse) -> Void) {
        var authRequest = URLRequest(url: URLs.authBaseURL)
        authRequest.httpMethod = "POST"
        authRequest.setValue("application/x-www-form-urlencoded;charset=UTF-8", forHTTPHeaderField: "Content-Type")
        authRequest.setValue("Basic " + encodedAuthKey, forHTTPHeaderField: "Authorization")
        authRequest.httpBody = authRequestBody
        let task = URLSession.shared.dataTask(with: authRequest) { data, response, error in
            guard let data = data, error == nil else {
                print(error?.localizedDescription ?? "No data")
                return
            }
            self.authenticationResponse = try? JSONDecoder().decode(authResponse.self, from: data)
            guard self.authenticationResponse != nil else { return }
            callback(self.authenticationResponse!)
        }
        task.resume()
    }
    
    public func authenticate() {
        initAuthRequest(callback: { authResponse in
            DispatchQueue.main.async {
                self.isAuthenticated = true
            }
        })
    }
    
}
