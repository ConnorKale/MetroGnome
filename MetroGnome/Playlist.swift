//
//  Playlist.swift
//  MetroGnome
//
//  Created by Connor Kale on 10/26/25.
//

import SwiftUI

struct Playlist: View {
    var body: some View {
        ScrollView {
            VStack {
                
                Text("Hello world!")
                    .padding(.bottom, 20)

                Text("1 is TestAudioFile.wav, my creation from Garage Band. It's an endless anoying scale:) I place it in the public domain.")
                    .padding(.bottom, 20)
                
                Text("2 is TestAudioFile.wav at double tempo. In case you want to listen to a really fast scale. In my opinion it's even more anoying :)")
                    .padding(.bottom, 20)
                
                Text("3 is a shepherd’s tone I made in Garage Band. I’ll also put it in the public domain.")
                    .padding(.bottom, 20)
                
                Text("4 is a shepherd's tone at extra annoying halfsteps, which I also will put in public domain.")
                    .padding(.bottom, 20)
                
                Text("5 is a piano version of Korobeiniki, played by someone named Gregor Quendel and from https://www.classicals.de/music-licenses/p/tetris-piano?rq=korobeiniki. The file is at 150 PBM, although there's a slightly slower part in the middle. They wanted to be attributed as this:")
                    .padding(.bottom, 5)
                Text("Music: “Tetris Theme - Korobeiniki - Rearranged - Arr. for Piano” by Gregor Quendel / Classicals.de Source: https://www.classicals.de.")
                    .padding(.horizontal, 30)
                    .padding(.bottom, 20)
                
                Text("6 is double tempo piano Korobeiniki, same file and author as 5.")
                    .padding(.bottom, 20)
                
                Text("7 is a string version of Korobeiniki, also played by Gregor Quendel, from https://www.classicals.de/music-licenses/p/tetris-strings?rq=korobeiniki. The file is a little over 152 BPM. They want it attributed as this:")
                    .padding(.bottom, 5)
                Text("Music: “Tetris Theme - Korobeiniki - Rearranged - Arr. for Strings” by Gregor Quendel / Classicals.de Source: https://www.classicals.de")
                    .padding(.horizontal, 30)
                    .padding(.bottom, 20)
                
                Text("8 is double tempo String Korobeiniki, same file and author as 7.")
                    .padding(.bottom, 20)
                
                Text("9 is music box a version of Pachelbel’s Canon, played by Gregor Quendel. In my opinion this is worse than the Kevin MacLeod version in #10 and #11 but Quendel's tetris verions are great! Quendel's Canon is from https://www.classicals.de/music-licenses/p/pachelbel-canon-in-d-musicbox. The file is at 120 BPM. They want it attributed as this:")
                    .padding(.bottom, 5)
                Text("Pachelbel - Canon in D - P. 37 - Arranged for Music Box” by Gregor Quendel / Classicals.de Source: https://www.classicals.de")
                    .padding(.horizontal, 30)
                    .padding(.bottom, 20)
                
                Text("10 is Pachelbel’s Canon, recorded by Kevin MacLeod. The file is at 80 BPM, but I put 160 into my phone to get 1 halfnote per step. I got it from https://en.wikipedia.org/wiki/File:Kevin_MacLeod_-_Canon_in_D_Major.ogg.")
                    .padding(.bottom, 20)
                
                Text("11 is double-tempo version of #10.")
                    .padding(.bottom, 20)
                
                Text("12 is the Kevin MacLeod Canon as an mp3. It's broken for some reason and won't decode, so the app will play the last thing written to the scratchpad file. However, but other MP3s work. I think the file itself is buggy since all other MP3's work, so it's fine.")
                    .padding(.bottom, 20)
                
                Text("13 is Running in the 90's. I stole it from YouTube. The file's around 158 BPM, a metronome was dragging a little bit and fell behind about a beat over the course of the song but was pretty accurate.")
                    .padding(.bottom, 20)
                
                Text("14 is Don't Fear The Reaper, from YouTube. The file's tempos vary from 141.25 to 141.5 I think. Most websites on the internet (which use elements of en.wikipedia.org/wiki/Natural_number) say 142, some say 141. Might be a good test file for multitempo songs sometimes. I'm going to call it 141.5 for the app.")
                    .padding(.bottom, 20)
                
                Text("15 is Party in the USA, added because of 17, at cut time for running at (to be closer to the original song's speed), file at 96 BPM..")
                    .padding(.bottom, 20)
                
                Text("16 is Party in the USA, added because of 17, at normal time. It will go really fast if you play like this while running. File at 96 BPM.")
                    .padding(.bottom, 20)
                
                Text("17 is Party in the CIA, at cut time for running at (to be closer to the original song's speed), file at 96 BPM.")
                    .padding(.bottom, 20)
                
                Text("18 is Party in the CIA, at normal time. It will go really fast if you play like this while running. File at 96 BPM.")
                    .padding(.bottom, 20)
                                
                Text("19-25 is CultOfPersonality92.5, MotorcycleDriver160, 500Miles130, SuperTrouper115, LayAllYourLoveOnMe133, slow Moskau121, fast Moskau121")
                    .padding(.bottom, 20)
                
                Text("26 is The Veldt music from FFIV. It's a fun percussion/bassline. The file's at 180 BPM.")
                    .padding(.bottom, 20)
                
                Text("Hello world!")
                    .padding(.bottom, 20)
            }
            .padding(20)
            .preferredColorScheme(.dark)
            .background(Color(red: (13/256.0), green: (67.0/256.0), blue: (67.0/256.0)))
        }
    }
}

#Preview {
    Playlist()
}
