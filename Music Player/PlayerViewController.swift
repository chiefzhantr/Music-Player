import UIKit
import AVFoundation

class PlayerViewController: UIViewController {
    
    public var position: Int = 0
    public var songs: [Song] = []
    
    @IBOutlet var holder: UIView!
    
    //UI elements
    
    private let albumImageView: UIImageView = {
       let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.layer.cornerRadius = 20
        return imageView
    }()
    
    private let songNameLabel: UILabel = {
       let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 23, weight: .bold)
        label.numberOfLines = 0 // line wrap
        return label
    }()
    
    private let artistNameLabel: UILabel = {
       let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 17, weight: .thin)
        label.numberOfLines = 0 // line wrap
        return label
    }()
    
    private let albumNameLabel: UILabel = {
       let label = UILabel()
        label.textAlignment = .center
        label.font = UIFont.systemFont(ofSize: 15, weight: .regular)
        label.numberOfLines = 0 // line wrap
        return label
    }()
    
    let playPauseButton = UIButton()
    
    let volumeSlider = UISlider()
    
    let durationSlider = UISlider()
    let startLabel:UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 10, weight: .ultraLight)
        label.textAlignment = .center
        return label
    }()
    
    let endLabel:UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 10, weight: .ultraLight)
        label.textAlignment = .center
        return label
    }()
    
    
    var player: AVAudioPlayer?
    
    var timer: Timer?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        if holder.subviews.count == 0 {
            configure()
        }
        
        
    }
    
    func configure() {
        //set up player
        let song = songs[position]
        
        let urlString = Bundle.main.path(forResource: song.trackName, ofType: "mp3")?.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)
        do {
            
            try AVAudioSession.sharedInstance().setMode(.default)
            try AVAudioSession.sharedInstance().setActive(true, options: .notifyOthersOnDeactivation)
            
            guard let urlString = urlString else {return}
            
            player = try AVAudioPlayer(contentsOf: URL(string: urlString)!)
            
            guard let player = player else {return}
            player.volume = 0.5
            durationSlider.maximumValue = Float(player.duration)
            player.play()
            
        } catch {
            print("error")
        }
        //set up ui elements
        
        //album cover
        albumImageView.frame = CGRect(x: 10,
                                      y: 10,
                                      width: holder.frame.size.width-20,
                                      height: holder.frame.size.width-20)
        albumImageView.image = UIImage(named: song.imageName)
        holder.addSubview(albumImageView)
        
        //labels: song name, album, artist
        
        songNameLabel.frame   = CGRect(x: 10,
                                       y: albumImageView.frame.size.height+20,
                                       width: holder.frame.size.width-20,
                                       height: 70)
        albumNameLabel.frame  = CGRect(x: 10,
                                       y: albumImageView.frame.size.height,
                                       width: holder.frame.size.width-20,
                                       height: 70)
        artistNameLabel.frame = CGRect(x: 10,
                                       y: albumImageView.frame.size.height+50,
                                       width: holder.frame.size.width-20,
                                       height: 70)
        
        
        
        songNameLabel.text = song.name
        albumNameLabel.text = song.albumName
        artistNameLabel.text = song.artistName
        
        holder.addSubview(songNameLabel)
        holder.addSubview(albumNameLabel)
        holder.addSubview(artistNameLabel)
        
        //player controls
        let nextButton = UIButton()
        let backButton = UIButton()
        
        //frame
        let yPosition = artistNameLabel.frame.origin.y+70+175
        let size: CGFloat = 30
        
        
        playPauseButton.frame = CGRect(x: (holder.frame.size.width - size)/2.0,
                                       y: yPosition,
                                       width: size,
                                       height: size)
        
        nextButton.frame = CGRect(x: holder.frame.size.width - size - 20,
                                  y: yPosition,
                                  width: size,
                                  height: size)

        backButton.frame = CGRect(x: 20,
                                  y: yPosition,
                                  width: size,
                                  height: size)
        
        
        //add actions
        playPauseButton.addTarget(self, action: #selector(didTapPlayPauseButton), for: .touchUpInside)
        backButton.addTarget(self, action: #selector(didTapBackButton), for: .touchUpInside)
        nextButton.addTarget(self, action: #selector(didTapNextButton), for: .touchUpInside)
        
        //styling
        playPauseButton.setBackgroundImage(UIImage(systemName: "pause"), for: .normal)
        backButton.setBackgroundImage(UIImage(systemName: "backward"), for: .normal)
        nextButton.setBackgroundImage(UIImage(systemName: "forward"), for: .normal)
        
        
        playPauseButton.tintColor = .systemBlue
        backButton.tintColor = .systemBlue
        nextButton.tintColor = .systemBlue
        
        holder.addSubview(playPauseButton)
        holder.addSubview(backButton)
        holder.addSubview(nextButton)
        
        //volume slider
        
        volumeSlider.value = 0.5
        volumeSlider.frame = CGRect(x: 20, y: holder.frame.size.height-60, width: holder.frame.size.width-40, height: 50)
        volumeSlider.addTarget(self, action: #selector(didSlideVolumeSlider), for: .valueChanged)
        volumeSlider.minimumValueImage = UIImage(systemName: "volume.1")
        volumeSlider.maximumValueImage = UIImage(systemName: "volume.3")
        holder.addSubview(volumeSlider)
        
        //duration slider, time start/end labels
        
        startLabel.frame = CGRect(x: 10, y: Int(holder.frame.size.height)-170, width: 50, height: 50)
        endLabel.frame = CGRect(x: Int(holder.frame.size.width)-60, y: Int(holder.frame.size.height)-170, width: 50, height: 50)
        
        
        timer = Timer.scheduledTimer(timeInterval: 1.0, target: self, selector: #selector(updateTime), userInfo: nil, repeats: true)
        
        durationSlider.addTarget(self, action: #selector(didSlideDurationSlider(_:)), for: .valueChanged)
        durationSlider.frame = CGRect(x: 20, y: holder.frame.size.height-190, width: holder.frame.size.width-40, height: 50)
        durationSlider.addTarget(self, action: #selector(didSlideVolumeSlider), for: .valueChanged)
        holder.addSubview(durationSlider)
        holder.addSubview(startLabel)
        holder.addSubview(endLabel)
    }
 
    @objc func didTapPlayPauseButton() {
        if player?.isPlaying == true {
            playPauseButton.setBackgroundImage(UIImage(systemName: "play"), for: .normal)
            player?.pause()
        } else {
            playPauseButton.setBackgroundImage(UIImage(systemName: "pause"), for: .normal)
            player?.play()
        }
    }
    
    @objc func didTapBackButton() {
        if position > 0 {
            position = position - 1
            player?.stop()
            for subview in holder.subviews {
                subview.removeFromSuperview()
            }
            configure()
        }
    }
    
    @objc func didTapNextButton() {
        if position < songs.count - 1 {
            position = position + 1
            player?.stop()
            for subview in holder.subviews {
                subview.removeFromSuperview()
            }
            configure()
        }
    }
    
    @objc func updateTime() {
        
        guard let player = player else {return}
        
        durationSlider.value = Float(player.currentTime)
        let timePlayed = player.currentTime
        let minutesFromStart = Int(timePlayed/60)
        let secondsFromStart = Int(timePlayed)%60
        startLabel.text = NSString(format: "%02d:%02d", minutesFromStart, secondsFromStart) as String

        let diffOfTime = player.duration - player.currentTime
        let minutesToEnd = Int(diffOfTime/60)
        let secondsToEnd = Int(diffOfTime)%60
        endLabel.text = NSString(format: "%02d:%02d", minutesToEnd, secondsToEnd) as String
    }
    
    @objc func didSlideDurationSlider(_ slider: UISlider) {
        if slider == durationSlider {
            player?.currentTime = TimeInterval(slider.value)
        }
    }
    
    @objc func didSlideVolumeSlider(_ slider: UISlider) {
        if slider == volumeSlider {
            let value = slider.value
            player?.volume = value
        }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        if let player = player {
            player.stop()
        }
    }
    
}
