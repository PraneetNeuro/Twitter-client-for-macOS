//
//  ContentView.swift
//  Twitter
//
//  Created by Praneet S on 18/02/21.
//

import SwiftUI
import Kingfisher

struct TweetView: View {
    var datum: Datum
    var body: some View {
        ZStack {
            Rectangle()
                .frame(width: 425, height: 200, alignment: .center)
                .foregroundColor(.clear)
            Text(datum.text ?? "Loading tweet...")
                .bold()
                .font(.body)
                .frame(width: 400, height: 190, alignment: .center)
        }.background(Color.black)
        .cornerRadius(12)
        .shadow(color: .pink, radius: 2)
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
            TextField("Search", text: $searchTerm).onChange(of: searchTerm){ query in
                API.shared.userSearch(username: query)
                print(query)
            }
            .font(.title)
            .textFieldStyle(PlainTextFieldStyle())
            .padding()
            if api.usersSearchResult != nil {
                ScrollView {
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
                }
                Spacer()
            } else {
                Spacer()
                Text("#GoTwitter")
                    .bold()
                    .font(.title)
                Spacer()
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

