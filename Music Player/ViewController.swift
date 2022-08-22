import UIKit

class ViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    @IBOutlet var tableView: UITableView!
    
    var songs = [Song]()
    
   
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Music"
        configureSongs()
        tableView.delegate = self
        tableView.dataSource = self
    }

    private func configureSongs() {
        songs.append(Song(name: "ROLLING STONE",
                          albumName: "Wasteland",
                          artistName: "Brent Faiyaz",
                          imageName: "cover1",
                          trackName: "song1"))
        
        songs.append(Song(name: "Wusyaname",
                          albumName: "CMIYGL",
                          artistName: "Tyler, the creator",
                          imageName: "cover2",
                          trackName: "song2"))
        
        songs.append(Song(name: "Ivy",
                          albumName: "Blonde",
                          artistName: "Frank Ocean",
                          imageName: "cover3",
                          trackName: "song3"))
        songs.append(Song(name: "ROLLING STONE",
                          albumName: "Wasteland",
                          artistName: "Brent Faiyaz",
                          imageName: "cover1",
                          trackName: "song1"))
        
        songs.append(Song(name: "Wusyaname",
                          albumName: "CMIYGL",
                          artistName: "Tyler, the creator",
                          imageName: "cover2",
                          trackName: "song2"))
        
        songs.append(Song(name: "Ivy",
                          albumName: "Blonde",
                          artistName: "Frank Ocean",
                          imageName: "cover3",
                          trackName: "song3"))
        songs.append(Song(name: "ROLLING STONE",
                          albumName: "Wasteland",
                          artistName: "Brent Faiyaz",
                          imageName: "cover1",
                          trackName: "song1"))
        
        songs.append(Song(name: "Wusyaname",
                          albumName: "CMIYGL",
                          artistName: "Tyler, the creator",
                          imageName: "cover2",
                          trackName: "song2"))
        
        songs.append(Song(name: "Ivy",
                          albumName: "Blonde",
                          artistName: "Frank Ocean",
                          imageName: "cover3",
                          trackName: "song3"))
    }

    //Table
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return songs.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        let song = songs[indexPath.row]
        cell.textLabel?.text = song.name
        cell.detailTextLabel?.text = song.albumName
        cell.accessoryType = .disclosureIndicator
        cell.textLabel?.font = UIFont(name: "Helvetica-Bold", size: 18)
        cell.detailTextLabel?.font = UIFont(name: "Helvetica", size: 17)
        cell.imageView?.image = UIImage(named: song.imageName)
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        //present the player
        let position = indexPath.row
        //songs
        guard let vc = storyboard?.instantiateViewController(withIdentifier: "player") as? PlayerViewController else {return}
        
        vc.songs = songs
        vc.position = position
        
        present(vc,animated: true)
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 100
    }
}


struct Song {
    let name: String
    let albumName: String
    let artistName: String
    let imageName: String
    let trackName: String
}
