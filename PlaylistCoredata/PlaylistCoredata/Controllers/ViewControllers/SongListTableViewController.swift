//
//  SongListTableViewController.swift
//  PlaylistCoredata
//
//  Created by Trevor Walker on 2/11/20.
//  Copyright © 2020 Trevor Walker. All rights reserved.
//

import UIKit

class SongListTableViewController: UITableViewController {

    // MARK: - IBOutlets
    @IBOutlet weak var artistNameTextField: UITextField!
    @IBOutlet weak var trackNameTextField: UITextField!
    
    // MARK: - Properties
    /// Reciever / Landing pad / thing that recieves data from the PlaylistVC segue
    var playlist: Playlist?
    
    // MARK: - Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
    }

    // MARK: - IBActions
    @IBAction func addSongButtonTapped(_ sender: Any) {
        guard let songName = trackNameTextField.text, !songName.isEmpty, let artistName = artistNameTextField.text, !artistName.isEmpty, let playlist = playlist else {return}
        SongController.create(songWithName: songName, artist: artistName, playlist: playlist)
        
        // Clean up the dust
        trackNameTextField.text = ""
        artistNameTextField.text = ""
        tableView.reloadData()
        
    }
    
    // MARK: - Table view data source
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return playlist?.songs?.count ?? 0
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "songCell", for: indexPath)
        
        guard let unwrappedPlaylist = playlist, let song = unwrappedPlaylist.songs?[indexPath.row] as? Song else {return UITableViewCell()}
        
        cell.textLabel?.text = song.name
        cell.detailTextLabel?.text = song.artist
        return cell
    }


    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            //Making sure we have a play list, if we do then we grab the song, if not then we return out of the function
            guard let unwrappedPlaylist = playlist, let song = unwrappedPlaylist.songs?[indexPath.row] as? Song else {return}
            
            SongController.delete(song: song)
            tableView.deleteRows(at: [indexPath], with: .fade)
        }
    }
}
