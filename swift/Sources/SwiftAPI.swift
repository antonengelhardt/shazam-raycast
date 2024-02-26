import Foundation
import AVFoundation
import RaycastSwiftMacros
import ShazamKit

// Renamed @raycast function
@raycast func shazam() async throws -> ShazamMedia? {
    let shazamInstance = Shazam()
    shazamInstance.session.delegate = shazamInstance
    try await shazamInstance.startShazam()

    sleep(1)

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

    override init() {
        self.session = SHSession()
        super.init()
        self.session.delegate = self
    }

    // Shazam method
    func startShazam() async throws  {

      // Create a new Shazam session
      let session = SHSession()
      session.delegate = self

      // Start the session
      let audioEngine = AVAudioEngine()
      let inputNode = audioEngine.inputNode
      let format = inputNode.inputFormat(forBus: 0)

      inputNode.installTap(onBus: 0, bufferSize: 5000, format: format) { buffer, time in

        // Process the audio buffer
        session.matchStreamingBuffer(buffer, at: time)
      }

      // Start the audio engine
      try audioEngine.start()

      // Wait for the session to complete
      sleep(5)

      // Stop the audio engine
      audioEngine.stop()
    }
}

extension Shazam : SHSessionDelegate {
    func session(_ session: SHSession, didFind match: SHMatch) {

        let match = match.mediaItems.first

        self.match = match
    }

    func session(_ session: SHSession, didNotFindMatchFor signature: SHSignature, error: Error?) {
        print("No match found")
    }
}

struct ShazamMedia : Encodable {
    var title: String
    var artist: String
    var appleMusicURL: URL
    var artWorkURL: URL
}
