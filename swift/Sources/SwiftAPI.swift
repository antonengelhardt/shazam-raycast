import Foundation
import AVFoundation
import RaycastSwiftMacros
import ShazamKit

// Renamed @raycast function
@raycast func shazam() async throws -> ShazamMedia? {

    let shazamInstance = Shazam()

    try await shazamInstance.startShazam()

    let matchedMediaItem = shazamInstance.match

    // return the match or nil
    if matchedMediaItem != nil {
        let media = ShazamMedia(
            title: matchedMediaItem?.title ?? "",
            artist: matchedMediaItem?.artist ?? "",
            appleMusicURL: matchedMediaItem?.appleMusicURL ?? URL(string: "https://music.apple.com")!,
            artWorkURL: matchedMediaItem?.artworkURL ?? URL(string: "https://music.apple.com")!
        )
        return media
    } else {
        return nil
    }
}

class Shazam : NSObject, ObservableObject {

    var session: SHSession
    var match: SHMatchedMediaItem?
    var audioEngine: AVAudioEngine

    override init() {
        self.session = SHSession()
        self.audioEngine = AVAudioEngine()
        super.init()
        self.session.delegate = self
    }

    // Shazam method
    func startShazam() async throws  {

      // Start the session
      let inputNode = self.audioEngine.inputNode
      let format = inputNode.inputFormat(forBus: 0)

      inputNode.installTap(onBus: 0, bufferSize: 400, format: format) { buffer, time in

        // Process the audio buffer
        self.session.matchStreamingBuffer(buffer, at: time)
      }

      // Start the audio engine
      self.audioEngine.prepare()
      try self.audioEngine.start()

      // Wait for the session to complete
      sleep(5)

      // Stop the audio engine
      audioEngine.stop()
    }
}

extension Shazam : SHSessionDelegate {
    func session(_ session: SHSession, didFind match: SHMatch) {

      DispatchQueue.main.async {
        self.match = match.mediaItems.first
      }
    }

    func session(_ session: SHSession, didNotFindMatchFor signature: SHSignature, error: Error?) {

      DispatchQueue.main.async {
        self.match = nil
      }
    }
}

struct ShazamMedia : Encodable {
    var title: String
    var artist: String
    var appleMusicURL: URL
    var artWorkURL: URL
}
