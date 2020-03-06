//
//  Song+Convenience.swift
//  PlaylistNSUserDefaults
//
//  Created by DevMountain on 9/5/18.
//  Copyright © 2018 DevMountain. All rights reserved.
//

import Foundation
import CoreData

 ///This is extending the model `Song` that we made in our `xcdatamodeld`.
extension Song{
    
    @discardableResult
    convenience init(name: String, artist: String, playlist: Playlist){
        ///creating our container
        self.init(context: CoreDataStack.context)
        self.name = name
        self.artist = artist
        self.playlist = playlist
    }
}
