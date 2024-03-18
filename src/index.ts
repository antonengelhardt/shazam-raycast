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

  // TODO: Use Detail component to show Artwork in the middle, title, artist and genres on the side and Apple Music Action
  // return (
  //   <Detail
  //     markdown={isLoading ? "Listening..." :
  //       data?.title + " by " + data?.artist || (error && `Error: ${error.message}`) || "No match found"}
  //     metadata={
  //       <Detail.Metadata>
  //         <Detail.Metadata.Label title="Title" text={data?.title} />
  //         <Detail.Metadata.Label title="Artist" text={data?.artist} />
  //       </Detail.Metadata>
  //     }

  //   />;
  // );

  return Detail(
    { markdown: isLoading ? "Listening..." :
      data?.title + " by " + data?.artist || (error && `Error: ${error.message}`) || "No match found" });
}
