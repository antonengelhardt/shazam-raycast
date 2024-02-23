import Foundation
import AVFoundation
import RaycastSwiftMacros
import ShazamKit

class Shazam : NSObject, ObservableObject, SHSessionDelegate {
    var session: SHSession
    var match: SHMatch?

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
      // let buffer = AVAudioPCMBuffer(pcmFormat: format, frameCapacity: 4096)

      let signatureGenerator = SHSignatureGenerator()

      inputNode.installTap(onBus: 0, bufferSize: 4096, format: format) { buffer, time in

        // Append the buffer to the signature generator
        try! signatureGenerator.append(buffer, at: time)
      }

      // Start the audio engine
      try audioEngine.start()

      // Wait for the session to complete
      sleep(5)

      // Stop the audio engine
      audioEngine.stop()

      // Generate the signature
      let signature = signatureGenerator.signature()

      // Create a new Shazam match
      session.match(signature)
    }
}

extension SHSessionDelegate {
    func session(_ session: SHSession, didFind match: SHMatch) -> SHMatch? {
        return match
    }

    func session(_ session: SHSession, didNotFindMatchFor signature: SHSignature, error: Error?) {
        print("No match found")
    }
}

// Renamed @raycast function
@raycast func shazam() async throws -> ShazamMedia? {
    let shazamInstance = Shazam()
    shazamInstance.session.delegate = shazamInstance
    try await shazamInstance.startShazam()

    let match = shazamInstance.match?.mediaItems.first

    let media = ShazamMedia(
        title: match?.title ?? "",
        artist: match?.artist ?? "",
        appleMusicURL: match?.appleMusicURL ?? URL(string: "https://music.apple.com")!,
        artWorkURL: match?.artworkURL ?? URL(string: "https://music.apple.com")!
    )

    return media

}

struct ShazamMedia : Encodable {
    var title: String
    var artist: String
    var appleMusicURL: URL
    var artWorkURL: URL
}
