import Foundation
import AVFoundation
import RaycastSwiftMacros
import ShazamKit

// Renamed @raycast function
@raycast func shazam() async throws -> ShazamMedia? {

  if #available(macOS 14.0, *) {
    let session = SHManagedSession()
    let result = await session.result()

    switch result {
      case .match(let match ):
        print("Matched \(match.mediaItems.count) items")
        let matchedMediaItem = match.mediaItems.first

        return ShazamMedia(
            title: (matchedMediaItem?.title!)!,
            artist: (matchedMediaItem?.artist!)!,
            appleMusicURL: (matchedMediaItem?.appleMusicURL!)!,
            artWorkURL: (matchedMediaItem?.artworkURL!)!
        )
      case .error(let error, let signature):
        print("Error: \(error) for \(signature)")
      case .noMatch:
        print("No match found")

    }
  } else {
    // Fallback on earlier versions
    return nil
  }
  return nil
}

struct ShazamMedia : Encodable {
    var title: String
    var artist: String
    var appleMusicURL: URL
    var artWorkURL: URL
}
