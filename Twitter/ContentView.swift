//
//  ContentView.swift
//  Twitter
//
//  Created by Praneet S on 18/02/21.
//

import SwiftUI
import Kingfisher

struct TweetsSearchView: View {
    @ObservedObject var api: API = API.shared
    var body: some View {
        ForEach(api.tweetsSearchResult?.data ?? [], id: \.id) { tweet in
            TweetViewLite(datum: tweet)
        }
    }
}

struct TrendsView: View {
    @ObservedObject var api: API = API.shared
    var body: some View {
        VStack {
            HStack {
                Text("Trending around 🌎")
                    .bold()
                    .font(.title)
                    .padding([.horizontal, .bottom])
                Spacer()
            }
            ForEach(api.publishedTrends?.first?.trends ?? [], id: \.url) { trend in
                VStack {
                    Text("\(trend.name)")
                    Text("\(trend.tweetVolume ?? 0) tweets")
                        .italic()
                        .font(.subheadline)
                }
                .padding()
                .background(Rectangle().foregroundColor(.black).frame(width: 350).cornerRadius(12))
            }
        }
    }
}

struct detailedTweetView: View {
    var body: some View {
        Text("Detailed Tweet")
    }
}

struct mediaDetailedView: View {
    var datum: Datum
    var body: some View {
        VStack {
            ScrollView {
                ForEach(datum.attachments?.mediaKeys ?? [], id: \.self) { mediaKey in
                    KFImage(API.shared.fetchMediaURL((mediaKey)))
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .cornerRadius(12)
                }
            }
        }
    }
}

struct TweetViewLite: View {
    var datum: Datum
    @State var profileImgUrl: String = ""
    @State var username: String = "username"
    @State var name: String = "name"
    var body: some View {
        VStack {
            HStack {
                KFImage(URL(string: profileImgUrl))
                    .cornerRadius(12)
                    .padding()
                VStack {
                    Text(name)
                        .bold()
                        .font(.title)
                    Text(username)
                        .italic()
                        .font(.subheadline)
                }
                Spacer()
            }
            Text(datum.text ?? "Loading tweet...")
                .bold()
                .font(.body)
                .padding()
            Spacer()
            HStack {
                Label("\(datum.public_metrics?.likeCount ?? 0)", systemImage: "heart")
                    .padding(.trailing)
                Label("\(datum.public_metrics?.retweetCount ?? 0)", systemImage: "return")
                    .padding(.trailing)
                Label("\(datum.public_metrics?.quoteCount ?? 0)", systemImage: "quote.bubble")
                    .padding(.trailing)
                Label("\(datum.public_metrics?.replyCount ?? 0)", systemImage: "arrowshape.turn.up.left")
            }.frame(width: 400)
            .padding(.bottom)
        }
        .frame(width: 400, height: 225, alignment: /*@START_MENU_TOKEN@*/.center/*@END_MENU_TOKEN@*/)
        .background(Color.black)
        .cornerRadius(12)
        .shadow(color: .pink, radius: 2)
        .onAppear(perform: {
            API.shared.userFetch(userID: datum.authorid!) { data in
                do {
                    let userObj: userLookup? = try JSONDecoder().decode(userLookup.self, from: data)
                    profileImgUrl = userObj?.data.profile_image_url ?? ""
                    username = userObj?.data.username ?? ""
                    name = userObj?.data.name ?? ""
                } catch {
                    print("Error decoding JSON response to user object \(error)")
                }
            }
        })
    }
}

struct TweetView: View {
    var datum: Datum
    @State var isMediaViewPresented: Bool = false
    @State var profileImgUrl: String = ""
    @State var username: String = ""
    @State var name: String = ""
    var body: some View {
        VStack {
            HStack {
                KFImage(URL(string: profileImgUrl))
                    .cornerRadius(12)
                    .padding()
                VStack {
                    Text(name)
                        .bold()
                        .font(.title)
                    Text(username)
                        .italic()
                        .font(.subheadline)
                }
                Spacer()
            }
            Text(datum.text ?? "Loading tweet...")
                .bold()
                .font(.body)
                .padding()
            
            if(datum.attachments?.mediaKeys?.count ?? 0 > 0) {
                ZStack {
                    KFImage(API.shared.fetchMediaURL((datum.attachments?.mediaKeys?.first!)!))
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .cornerRadius(12)
                        .onTapGesture {
                            isMediaViewPresented = true
                        }
                        .popover(isPresented: $isMediaViewPresented){
                            mediaDetailedView(datum: datum)
                                .frame(width: 300, height: 300, alignment: /*@START_MENU_TOKEN@*/.center/*@END_MENU_TOKEN@*/)
                        }
                    VStack{
                        Spacer()
                        Text("+\((datum.attachments?.mediaKeys!.count)! - 1)")
                            .bold()
                            .font(.title)
                            .background(Rectangle().foregroundColor(.black).opacity(0.6).cornerRadius(6))
                    }.padding(.bottom, 3)
                }
            }
            Spacer()
            
            HStack {
                Label("\(datum.public_metrics?.likeCount ?? 0)", systemImage: "heart")
                    .padding(.trailing)
                Label("\(datum.public_metrics?.retweetCount ?? 0)", systemImage: "return")
                    .padding(.trailing)
                Label("\(datum.public_metrics?.quoteCount ?? 0)", systemImage: "quote.bubble")
                    .padding(.trailing)
                Label("\(datum.public_metrics?.replyCount ?? 0)", systemImage: "arrowshape.turn.up.left")
            }.frame(width: 400)
            .padding(.bottom)
        }
        .frame(width: 400, height: 225, alignment: /*@START_MENU_TOKEN@*/.center/*@END_MENU_TOKEN@*/)
        .background(Color.black)
        .cornerRadius(12)
        .shadow(color: .pink, radius: 2)
        .onAppear(perform: {
            API.shared.userFetch(userID: datum.authorid!) { data in
                do {
                    let userObj: userLookup? = try JSONDecoder().decode(userLookup.self, from: data)
                    profileImgUrl = userObj?.data.profile_image_url ?? ""
                    username = userObj?.data.username ?? ""
                    name = userObj?.data.name ?? ""
                } catch {
                    print("Error decoding JSON response to user object \(error)")
                }
            }
        })
    }
}

struct TimelineView: View {
    @ObservedObject var apiSharedInstance = API.shared
    var userIDFromSearch: String?
    var body: some View {
        VStack {
            if apiSharedInstance.publishedUserTimeline != nil {
                ScrollView {
                    HStack {
                        Text("Tweets")
                            .bold()
                            .font(.title)
                            .padding([.leading, .top])
                        Spacer()
                    }
                    VStack {
                        ForEach(apiSharedInstance.publishedUserTimeline?.data ?? [], id: \.id) { datum in
                            TweetView(datum: datum)
                        }
                    }.padding()
                }
            } else {
                Text("#GoTwitter")
                    .bold()
                    .font(.title)
            }
        }.onAppear {
            if userIDFromSearch != nil {
                API.shared.timelineSearch(userID: userIDFromSearch!)
            }
        }
        .frame(width: 450, height: 600, alignment: .center)
    }
}

struct UserSearchView: View {
    @State var searchTerm: String = ""
    @ObservedObject var api = API.shared
    @State var didClickOnUser: Bool = false
    @State var userID: String = ""
    var body: some View {
        VStack {
            Group {
                TextField("Search", text: $searchTerm).onChange(of: searchTerm){ query in
                    api.userSearch(username: query)
                    api.tweetsSearch(searchTerm: query)
                    print(query)
                }
                .font(.title)
                .textFieldStyle(PlainTextFieldStyle())
                .padding()
                if api.usersSearchResult != nil {
                    ScrollView {
                        HStack {
                            Text("Users")
                                .bold()
                                .font(.title)
                                .padding()
                            Spacer()
                        }
                        
                        ForEach(api.usersSearchResult!.data, id: \.id) { user in
                            VStack(alignment: .leading){
                                HStack {
                                    KFImage(URL(string: user.profile_image_url))
                                        .resizable()
                                        .frame(width: 70, height: 70)
                                        .cornerRadius(12)
                                        .padding(.leading, 3)
                                    VStack(alignment: .leading) {
                                        Text(user.name)
                                            .bold()
                                            .font(.title)
                                        Text(user.username)
                                            .font(.subheadline)
                                    }.padding(.leading)
                                    Spacer()
                                    if user.verified {
                                        SwiftUI.Image(systemName: "checkmark.seal.fill")
                                            .padding()
                                    }
                                }
                            }.frame(width: 420, height: 75, alignment: .center)
                            .background(RoundedRectangle(cornerRadius: 12).foregroundColor(.black))
                            .cornerRadius(12)
                            .padding(3)
                            .onTapGesture {
                                self.userID = user.id
                                self.didClickOnUser = true
                            }
                        }
                        HStack {
                            Text("Recent tweets")
                                .bold()
                                .font(.title)
                                .padding()
                            Spacer()
                        }
                        TweetsSearchView()
                        TrendsView()
                    }
                    Spacer()
                } else {
                    ScrollView {
                        TrendsView()
                    }
                }
            }
        }.popover(isPresented: $didClickOnUser) {
            TimelineView(userIDFromSearch: userID)
        }
    }
}

struct ContentView: View {
    @ObservedObject var authObject = Authentication.shared
    @ObservedObject var apiSharedInstance = API.shared
    var body: some View {
        VStack {
            if authObject.isAuthenticated {
                UserSearchView()
            } else {
                ProgressView()
                    .progressViewStyle(CircularProgressViewStyle())
            }
        }
        .onAppear {
            Authentication.shared.authenticate()
        }
        .frame(width: 500, height: 500, alignment: .center)
    }
}

extension NSTextField {
    open override var focusRingType: NSFocusRingType {
        get { .none }
        set { }
    }
}

