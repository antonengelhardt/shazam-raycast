import { showHUD } from "@raycast/api";
import { Shazam, s16LEToSamplesArray } from 'shazam-api';
import fs from 'fs';
// import mic from 'mic';
// import ffmpeg from 'fluent-ffmpeg';
// import { PassThrough } from "stream";

export default async function main() {

  // // Initialize microphone
  // console.log("Initializing microphone")
  // const micInstance = mic({
  //   rate: '16000',
  //   channels: '1',
  //   debug: true,
  //   exitOnSilence: 6,
  // });

  // console.log("Getting audio stream")
  // const micInputStream = micInstance.getAudioStream();

  // micInstance.start();

  // setTimeout(() => {
  //   micInstance.stop();
  // }, 10000);

  // const pcmStream = new PassThrough();

  // ffmpeg
  //   .inputFormat('wav')
  //   .input(micInputStream)
  //   .audioCoded('pcm_s16le')
  //   .on('end', function() {
  //     console.log('file has been converted succesfully');
  //   })
  //   .on('error', function(err: { message: string; }) {
  //     console.log('an error happened: ' + err.message);
  //   })
  //   .pipe(pcmStream);

  // Initialize Shazam
  console.log("Initializing Shazam")
  const shazam = new Shazam();

  // Read PCM file for debugging
  console.log("Reading file")
  const fileContents = fs.readFileSync("/Users/antonengelhardt/Documents/develop/shazam-raycast/audio/test.pcm");
  console.log("Loaded file", fileContents.length, "bytes")

  // Convert PCM to samples
  console.log("Converting to samples")
  const samples = s16LEToSamplesArray(fileContents);

  // Recognize song
  console.log("Recognizing song")
  const songData = await shazam.recognizeSong(samples);

  // Show result
  console.log("Song data", songData);
  showHUD(songData?.title + " by " + songData?.artist ?? "No song found");
}
