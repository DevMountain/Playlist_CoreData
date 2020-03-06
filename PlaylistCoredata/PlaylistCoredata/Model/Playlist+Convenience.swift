//
//  Playlist+Convenience.swift
//  PlaylistNSUserDefaults
//
//  Created by DevMountain on 9/5/18.
//  Copyright © 2018 DevMountain. All rights reserved.
//

import Foundation

extension Playlist{
    
    @discardableResult
    convenience init(name: String){
        self.init(context: CoreDataStack.context)
        self.name = name
    }
    
}
