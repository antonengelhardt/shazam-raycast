import { Action, ActionPanel, Detail } from "@raycast/api";
import { usePromise } from "@raycast/utils";
import { shazam } from "swift:../swift";

type ShazamMedia = {
  title: string;
  subtitle: string;
  artist: string;
  genres: [string];
  creationDate: Date;
  artwork: URL;
  appleMusicUrl: URL;
};

export default function Command() {
  const { isLoading, data, error } = usePromise(async () => {
    const media: ShazamMedia = await shazam();
    return media;
  });

  // dummy data
  // const { isLoading, data, error } = usePromise(async () => {
  // //   return {
  // //     title: "Gang Shit No Lame Shit",
  // //     subtitle: "Song",
  // //     artist: "Key Glock",
  // //     genres: ["Rap", "Hip Hop"],
  // //     creationDate: new Date(),
  // //     artwork: new URL("https://artwork.anghcdn.co/webp/?id=60938735&size=320"),
  // //     appleMusicUrl: new URL(
  // //       "https://music.apple.com/de/album/lestasi-delloro-dal-film-il-buono-il-brutto-il-cattivo/526517272?i=526517281&l=en-GB",
  // //     ),
  // //   };
  // // });

  return isLoading ? (
    <Detail isLoading={true} markdown={"# Listening"} />
  ) : // if media is null show error
  error ? (
    <Detail
      isLoading={false}
      markdown={"##" + error.name + "\n\n" + error.message + "\n\n" + error.stack}
    />
  ) : (
    <Detail
      markdown={`![Artwork](${data?.artwork})`}
      metadata={
        <Detail.Metadata>
          <Detail.Metadata.Label title="Title" text={data?.title} />
          <Detail.Metadata.Label title="Subtitle" text={data?.subtitle} />
          <Detail.Metadata.Label title="Artist" text={data?.artist} />
          <Detail.Metadata.TagList title="Genres">
            {data?.genres.map((genre, index) => (
              <Detail.Metadata.TagList.Item key={index} text={genre} color={"#fffff"} />
            ))}
          </Detail.Metadata.TagList>
          <Detail.Metadata.Label
            title="Creation Date"
            text={data?.creationDate.toLocaleDateString("en-US", {
              year: "numeric",
              month: "long",
              day: "numeric",
            })}
          />
        </Detail.Metadata>
      }
      actions={
        <ActionPanel title={data?.title + " by " + data?.artist}>
          <Action title="Open in Apple Music" onAction={() => open(data?.appleMusicUrl)} />
        </ActionPanel>
      }
    />
  );
}
