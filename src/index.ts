import { showHUD } from "@raycast/api";
import { usePromise } from "@raycast/utils";
import { shazam } from "swift:../swift";

type ShazamMedia = {
  title: string;
  artist: string;
  artwork: URL;
  appleMusicUrl: URL;
};

export default function Command() {
  const { isLoading, data, error } = usePromise(async () => {
    const media: ShazamMedia = await shazam();

    return media.title;

  });
  showHUD(isLoading ? "Listening..." : data || (error && `Error: ${error.message}`) || "No match found");
  // return Detail({ markdown: isLoading ? "Listening..." : data || (error && `Error: ${error.message}`) || "Hello World" });
}
