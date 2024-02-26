import { Detail } from "@raycast/api";
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

    return media;

  });

  return Detail(
    { markdown: isLoading ? "Listening..." :
      data?.title + " by " + data?.artist || (error && `Error: ${error.message}`) || "No match found" });
}
