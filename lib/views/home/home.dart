import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:flutter_muzic/consts/colors.dart';
import 'package:on_audio_query/on_audio_query.dart';
import 'package:flutter_muzic/consts/text_style.dart';
import 'package:flutter_muzic/views/player/player.dart';
import 'package:flutter_muzic/controllers/player_controller.dart';

class Home extends StatelessWidget {
  const Home({super.key});

  @override
  Widget build(BuildContext context) {
    var controller = Get.put(PlayerController());

    return Scaffold(
        backgroundColor: darkColor,
        appBar: AppBar(
          backgroundColor: darkColor,
          actions: [
            IconButton(
                onPressed: () {},
                icon: const Icon(
                  Icons.search,
                  color: whiteColor,
                ))
          ],
          leading: const Icon(
            Icons.sort_rounded,
            color: whiteColor,
          ),
          title: Text(
            "Muzic On",
            style: ourStyle(
              family: bold,
              size: 18,
            ),
          ),
        ),
        body: FutureBuilder<List<SongModel>>(
          future: controller.audioQuery.querySongs(
            ignoreCase: true,
            orderType: OrderType.ASC_OR_SMALLER,
            sortType: null,
            uriType: UriType.EXTERNAL,
          ),
          builder: (BuildContext context, snapshot) {
            if (snapshot.data == null) {
              return const Center(
                child: CircularProgressIndicator(),
              );
            } else if (snapshot.data!.isEmpty) {
              // print(snapshot.data);
              return Center(
                child: Text(
                  "No song Found",
                  style: ourStyle(),
                ),
              );
            } else {
              // print(snapshot.data);
              return Padding(
                padding: const EdgeInsets.all(8.0),
                child: ListView.builder(
                  physics: const BouncingScrollPhysics(),
                  itemCount: snapshot.data!.length,
                  itemBuilder: (BuildContext context, int index) {
                    return Container(
                      margin: const EdgeInsets.only(bottom: 4),
                      decoration: BoxDecoration(
                        color: kcDarkGreyColor,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Obx(
                        () => ListTile(
                          title: Text(
                            snapshot.data![index].displayNameWOExt,
                            style: ourStyle(family: bold, size: 15),
                          ),
                          subtitle: Text(
                            "${snapshot.data![index].artist}",
                            style: ourStyle(family: regular, size: 12),
                          ),
                          leading: QueryArtworkWidget(
                            id: snapshot.data![index].id,
                            type: ArtworkType.AUDIO,
                            nullArtworkWidget: const Icon(
                              Icons.music_note_rounded,
                              color: whiteColor,
                              size: 32,
                            ),
                          ),
                          trailing: controller.playIndex.value == index &&
                                  controller.isPlaying.value
                              ? const Icon(
                                  Icons.pause,
                                  color: whiteColor,
                                  size: 26,
                                )
                              : const Icon(
                                  Icons.play_arrow_rounded,
                                  color: whiteColor,
                                  size: 26,
                                ),
                          onTap: () {
                            Get.to(
                                () => Player(
                                      data: snapshot.data!,
                                    ),
                                transition: Transition.downToUp);
                            controller.playerSong(
                                snapshot.data![index].uri, index);
                          },
                        ),
                      ),
                    );
                  },
                ),
              );
            }
          },
        ));
  }
}
