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
                Text("The Song upload request form is at https://forms.gle/AVgfr4h1kZKh9ndM9")
                    .font(.title2)
                    .padding(.bottom, 100)

                
                Text("NaN is Template Song by Someone, file at ⊥ BPM")
                    .padding(.bottom, 5)
                    .frame(maxWidth: .infinity, alignment: .leading)
                Text("Song description if there is one")
                    .padding(.horizontal, 30)
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .padding(.bottom, 20)

                
                Text("Test with 5 padding")
                    .padding(.bottom, 5)
                    .frame(maxWidth: .infinity, alignment: .leading)
                Text("Song description if there is one")
                    .padding(.horizontal, 30)
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .padding(.bottom, 20)

                Text("Test with 0 padding")
                    .frame(maxWidth: .infinity, alignment: .leading)
                Text("Song description if there is one")
                    .padding(.horizontal, 30)
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .padding(.bottom, 20)

                Text("Test with -5 padding")
                    .padding(.bottom, -5)
                    .frame(maxWidth: .infinity, alignment: .leading)
                Text("Song description if there is one")
                    .padding(.horizontal, 30)
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .padding(.bottom, 20)

                Text("Test with -10 padding")
                    .padding(.bottom, -10)
                    .frame(maxWidth: .infinity, alignment: .leading)
                Text("Song description if there is one")
                    .padding(.horizontal, 30)
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .padding(.bottom, 20)

                
                Text("1 is TestAudioFile.wav by me, file at 180.")
                    .padding(.bottom, 5)
                    .frame(maxWidth: .infinity, alignment: .leading)
                Text("My creation with Garage Band. It's an endless anoying scale:) I place it in the public domain.")
                    .padding(.horizontal, 30)
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .padding(.bottom, 20)
                
                Text("2 is Double-tempo TestAudioFile.wav by me, file at 180.")
                    .padding(.bottom, 5)
                    .frame(maxWidth: .infinity, alignment: .leading)
                Text("In case you want double tempo for some reason. Entered as 90 BPM to make it speed up twice as fast.")
                    .padding(.horizontal, 30)
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .padding(.bottom, 20)
                                       
                Text("3 is Shepards Tone by Connor, file at 180.")
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .padding(.bottom, 5)
                Text("This is the same file that plays for the pacing. I also made it a playable song for fun even though it's a terrible song.")
                    .padding(.horizontal, 30)
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .padding(.bottom, 20)
                
                Text("4 is Halfstep Shepard's Tone by Connor, file at 180.")
                    .padding(.bottom, 5)
                    .frame(maxWidth: .infinity, alignment: .leading)
                Text("Also in the pacing algorithm, an even worse song than #3.")
                    .padding(.horizontal, 30)
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .padding(.bottom, 20)
                
                Text("5 is Piano Korobienki by Gregor Quendel, file at 150")
                    .padding(.bottom, 5)
                    .frame(maxWidth: .infinity, alignment: .leading)
                Text("A piano version of the Tetris song. It's notably quieter than the string version. It's a fun song and is easy to hear the beats of. It's from https://www.classicals.de/music-licenses/p/tetris-piano?rq=korobeiniki. They want it to be attributed like this:")
                    .padding(.horizontal, 30)
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .padding(.bottom, 5)
                Text("Music: “Tetris Theme - Korobeiniki - Rearranged - Arr. for Piano” by Gregor Quendel / Classicals.de Source: https://www.classicals.de.")
                    .padding(.horizontal, 50)
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .padding(.bottom, 20)

                Text("6 is double tempo Piano Korobienki by Gregor Quendel, file at 150")
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .padding(.bottom, 5)
                Text("Same file and stuff as #5. I entered it as 75 BPM to make it play at double speed.")
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .padding(.horizontal, 30)
                    .padding(.bottom, 20)
                
                Text("7 is String Korobienki by Gregor Quendel, file at 152.")
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .padding(.bottom, 5)
                Text("A string version of the Tetris song. It's notably louder than the piano verson. Actually the tempo is a little over 152. It's from https://www.classicals.de/music-licenses/p/tetris-strings?rq=korobeiniki. They want it to be attributed like this:")
                    .padding(.horizontal, 30)
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .padding(.bottom, 5)
                Text("Music: “Tetris Theme - Korobeiniki - Rearranged - Arr. for Strings” by Gregor Quendel / Classicals.de Source: https://www.classicals.de")
                    .padding(.horizontal, 50)
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .padding(.bottom, 20)
                
                Text("8 is double Tempo String Korobienki by Gregor Quendel, file at 152.")
                    .padding(.bottom, 5)
                    .frame(maxWidth: .infinity, alignment: .leading)
                Text("Same file and stuff as #7. I entered it as 76 BPM to make it play at double speed.")
                    .padding(.horizontal, 30)
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .padding(.bottom, 20)
                
                Text("9 is music box Pachelbel's Canon by Gregor Quendel, file at 120.")
                    .padding(.bottom, 5)
                    .frame(maxWidth: .infinity, alignment: .leading)
                Text("In my opinion this is a worse version of of Canon than the Kevin MacLeod version in #10 and #11. This is from https://www.classicals.de/music-licenses/p/pachelbel-canon-in-d-musicbox. They want it to be attributed like this:")
                    .padding(.horizontal, 30)
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .padding(.bottom, 5)
                Text("Pachelbel - Canon in D - P. 37 - Arranged for Music Box” by Gregor Quendel / Classicals.de Source: https://www.classicals.de")
                    .padding(.horizontal, 50)
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .padding(.bottom, 20)
                
                Text("10 is Pachelbel's Canon by Kevin MacLeod, file at 80")
                    .padding(.bottom, 5)
                    .frame(maxWidth: .infinity, alignment: .leading)
                Text("This is a great, serene violin/cello song. I entered it as 160 BPM to get one footstep per two beats instead of one footstep per beat, to play closer to it's actual tempo when you run. The file is from https://en.wikipedia.org/wiki/File:Kevin_MacLeod_-_Canon_in_D_Major.ogg")
                    .padding(.horizontal, 30)
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .padding(.bottom, 20)
                
                Text("11 is double Tempo Canon by Kevin MacLeod, file at 80")
                    .padding(.bottom, 5)
                    .frame(maxWidth: .infinity, alignment: .leading)
                Text("Same stuff as #10, this time at one footstep per beat. It will go really fast if you try to run with this speed, which is sometimes fun but usually not reccomended.")
                    .padding(.horizontal, 30)
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .padding(.bottom, 20)
                
                Text("12 is broken MP3 Pachelbel's Canon by Kevin Macleod, file at 80.")
                    .padding(.bottom, 5)
                    .frame(maxWidth: .infinity, alignment: .leading)
                Text("This is Canon as an MP3, to test the MP3 decoder. I think the file is broken somehow and won't decode correctly. However, the other MP3s work so it's fine I guess.")
                    .padding(.horizontal, 30)
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .padding(.bottom, 20)
                
                Text("13 is Running in the 90's, file at 158ish")
                    .padding(.bottom, 5)
                    .frame(maxWidth: .infinity, alignment: .leading)
                Text("The first song I s̶t̶o̶l̶e̶ downloaded from YouTube. The file's around 158 BPM, a metronome was dragging a little bit and fell behind about a beat over the course of the song but was pretty accurate")
                    .padding(.horizontal, 30)
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .padding(.bottom, 20)
                
                Text("14 is Don't Fear the Reaper by Blue Öyster Cult, file at 141.5.")
                    .padding(.bottom, 5)
                    .frame(maxWidth: .infinity, alignment: .leading)
                Text("Uploaded for Haloween! The file's tempos vary from 141.25 to 141.5 I think. Most websites on the internet (which only use elements of ℕ) say 142, some say 141. Might be a good test file for multitempo songs sometimes. I entered it as 141.5.")
                    .padding(.horizontal, 30)
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .padding(.bottom, 20)
                
                Text("15 is Party in the USA by Miley Cyrus, file at 96")
                    .padding(.bottom, 5)
                    .frame(maxWidth: .infinity, alignment: .leading)
                Text("Entered in cut time at 192, so it plays at closer to orignal speed when you run. Added because of #17.")
                    .padding(.horizontal, 30)
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .padding(.bottom, 20)
                
                Text("16 is double tempo Party USA by Miley Cyrus, file at 96")
                    .padding(.bottom, 5)
                    .frame(maxWidth: .infinity, alignment: .leading)
                Text("Entered at 1 beat per footstep. Will play really fast if you run to it.")
                    .padding(.horizontal, 30)
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .padding(.bottom, 20)
                
                Text("17 is Party in the CIA by \"Weird Al\" Yankovic, file at 96")
                    .padding(.bottom, 5)
                    .frame(maxWidth: .infinity, alignment: .leading)
                Text("Entered in cut time at 192, so it plays at closer to orignal speed when you run.")
                    .padding(.horizontal, 30)
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .padding(.bottom, 20)
                
                Text("18 is double tempo Party CIA by \"Weird Al\" Yankovic, file at 96")
                    .padding(.bottom, 5)
                    .frame(maxWidth: .infinity, alignment: .leading)
                Text("Entered at 1 beat per footstep. Will play really fast if you run to it.")
                    .padding(.horizontal, 30)
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .padding(.bottom, 20)

                
                
                Text("19 is Template Song by Someone, file at __")
                    .padding(.bottom, 5)
                    .frame(maxWidth: .infinity, alignment: .leading)
                Text("Song description if there is one")
                    .padding(.horizontal, 30)
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .padding(.bottom, 20)
                
                Text("20 is Template Song by Someone, file at __")
                    .padding(.bottom, 5)
                    .frame(maxWidth: .infinity, alignment: .leading)
                Text("Song description if there is one")
                    .padding(.horizontal, 30)
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .padding(.bottom, 20)
                
                Text("21 is Template Song by Someone, file at __")
                    .padding(.bottom, 5)
                    .frame(maxWidth: .infinity, alignment: .leading)
                Text("Song description if there is one")
                    .padding(.horizontal, 30)
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .padding(.bottom, 20)
    
                Text("22 is Template Song by Someone, file at __")
                    .padding(.bottom, 5)
                    .frame(maxWidth: .infinity, alignment: .leading)
                Text("Song description if there is one")
                    .padding(.horizontal, 30)
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .padding(.bottom, 20)
                
                Text("23 is Lay All Your Love On Me by A𐤡BA, file at 133") // I got a unicode 𐤡 charecter which is a slightly different font but matches how they write it.
                    .padding(.bottom, 5)
                    .frame(maxWidth: .infinity, alignment: .leading)
                Text("Song description if there is one")
                    .padding(.horizontal, 30)
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .padding(.bottom, 20)
                
                Text("24 is slow Moskau by Dschinghis Khan, file at 121")
                    .padding(.bottom, 5)
                    .frame(maxWidth: .infinity, alignment: .leading)
                Text("Entered at 242 BPM, will play a lot slower than the origninal song if you run.")
                    .padding(.horizontal, 30)
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .padding(.bottom, 20)

                Text("25 is fast Moskau by Dschinghis Khan, file at 121")
                    .padding(.bottom, 5)
                    .frame(maxWidth: .infinity, alignment: .leading)
                Text("Entered at 121 BPM, will play a lot faster than the origninal song if you run.")
                    .padding(.horizontal, 30)
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .padding(.bottom, 20)


                Text("19-25 is CultOfPersonality92.5, MotorcycleDriver160, 500Miles130, SuperTrouper115, LayAllYourLoveOnMe133, slow Moskau121, fast Moskau121")
                    .padding(.bottom, 20)
                    .frame(maxWidth: .infinity, alignment: .leading)


                Text("26 is Don't Stop the Music by Yarbrough & Peoples, file at 122.5")
                    .padding(.bottom, 5)
                    .frame(maxWidth: .infinity, alignment: .leading)
                Text("Song description if there is one")
                    .padding(.horizontal, 30)
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .padding(.bottom, 20)
                
                Text("27 is Danger Zone by Kenny Loggins, file at 158")
                    .padding(.bottom, 5)
                    .frame(maxWidth: .infinity, alignment: .leading)
                Text("Song description if there is one")
                    .padding(.horizontal, 30)
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .padding(.bottom, 20)
                
                Text("28 is Final Countdown by Europe, file at 118")
                    .padding(.bottom, 5)
                    .frame(maxWidth: .infinity, alignment: .leading)
                Text("Song description if there is one")
                    .padding(.horizontal, 30)
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .padding(.bottom, 20)
                
                Text("29 is William Tell Overture by Gioachino Rossini, file at ~147")
                    .padding(.bottom, 5)
                    .frame(maxWidth: .infinity, alignment: .leading)
                Text("The tempo varies slightly which will make it not follow you perfectly, but it's a fun song.")
                    .padding(.horizontal, 30)
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .padding(.bottom, 20)
                
                Text("30 is Bolero by Maurice Ravel, file at ~72")
                    .padding(.bottom, 5)
                    .frame(maxWidth: .infinity, alignment: .leading)
                Text("The tempo was detirmined to be between 68 and 76 BPM, so I averaged it to be 72. I also entered it at 144 so it plays closer to the original speed when you run with it.")
                    .padding(.horizontal, 30)
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .padding(.bottom, 20)

                Text("31 is The Veldt from FFIV, file at 180")
                    .padding(.bottom, 5)
                    .frame(maxWidth: .infinity, alignment: .leading)
                Text("It's a fun cadence with percussion and bassline.")
                    .padding(.horizontal, 30)
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .padding(.bottom, 20)

                // No bottom 5 padding if there's no description.

                    .padding(.bottom, 50)
                
                Text("ω+1 is Template Song by Someone, file at __")
                    .padding(.bottom, 5)
                    .frame(maxWidth: .infinity, alignment: .leading)
                Text("Song description if there is one")
                    .padding(.horizontal, 30)
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .padding(.bottom, 20)
            }
            .padding(20) // This is for the edge margins
            .preferredColorScheme(.dark)
            .background(Color(red: (13/256.0), green: (67.0/256.0), blue: (67.0/256.0)))
        }
    }
}

#Preview {
    TabBarController()
}
