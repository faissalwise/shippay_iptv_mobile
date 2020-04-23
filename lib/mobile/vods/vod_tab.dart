import 'package:fastotv_common/base/controls/favorite_button.dart';
import 'package:fastotvlite/base/vods/vod_card_favorite_pos.dart';
import 'package:fastotvlite/channels/vod_stream.dart';
import 'package:fastotvlite/localization/app_localizations.dart';
import 'package:fastotvlite/localization/translations.dart';
import 'package:fastotvlite/mobile/base_tab.dart';
import 'package:fastotvlite/mobile/vods/movie_desc.dart';
import 'package:fastotvlite/mobile/vods/vod_edit_channel.dart';
import 'package:fastotvlite/mobile/vods/vod_player_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_fastotv_common/base/vods/vod_card.dart';

class VodVideoAppState extends VideoAppState<VodStream> {
  static const EDGE_INSETS = 4.0;
  static const CARD_WIDTH = 168.0;

  String noRecent() => AppLocalizations.of(context).translate(TR_RECENT_LIVE);

  String noFavorite() => AppLocalizations.of(context).translate(TR_FAVORITE_LIVE);

  void onAddFavorite(VodStream stream) {
    addFavorite(stream);
  }

  void onDeleteFavorite(VodStream stream) {
    deleteFavorite(stream);
  }

  Widget tile(int, List<VodStream> channels) {
    var channel = channels[int];
    return Padding(
        padding: const EdgeInsets.symmetric(horizontal: EDGE_INSETS, vertical: EDGE_INSETS * 1.5),
        child: Stack(children: <Widget>[
          VodCard(
              iconLink: channel.icon(),
              duration: channel.duration(),
              interruptTime: channel.interruptTime(),
              width: CARD_WIDTH,
              onPressed: () => toDescription(channel)),
          VodFavoriteButton(
              width: 72,
              height: 36,
              child:
                  Row(mainAxisSize: MainAxisSize.min, mainAxisAlignment: MainAxisAlignment.center, children: <Widget>[
                Container(
                    width: 36,
                    child: FavoriteStarButton(channel.favorite(),
                        onFavoriteChanged: (bool value) => handleFavorite(value, channel))),
                Container(
                    width: 36,
                    child: IconButton(
                        padding: EdgeInsets.all(0.0),
                        icon: Icon(Icons.settings),
                        onPressed: () async {
                          VodStream response = await Navigator.of(context)
                              .push(MaterialPageRoute(builder: (context) => VodEditPage(channel)));
                          if (response == null) {
                            widget.channels.remove(channel);
                          }
                          handleStreamEdit();
                        }))
              ]))
        ]));
  }

  Widget listBuilder(List<VodStream> channels) {
    return Center(
        child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: GridView.builder(
                gridDelegate: SliverGridDelegateWithMaxCrossAxisExtent(
                    maxCrossAxisExtent: CARD_WIDTH + 2 * EDGE_INSETS,
                    crossAxisSpacing: EDGE_INSETS,
                    mainAxisSpacing: EDGE_INSETS,
                    childAspectRatio: 2 / 3),
                itemCount: channels.length,
                itemBuilder: (BuildContext context, int index) => tile(index, channels))));
  }

  void onTapped(List<VodStream> channels, int position) {
    Navigator.push(context, MaterialPageRoute(builder: (context) => VodPlayer(channels[position])));
  }

  void toDescription(VodStream channel) async {
    final prevFav = channel.favorite();
    await Navigator.push(context, MaterialPageRoute(builder: (context) => VodDescription(vod: channel)));
    if (channel.favorite() != prevFav) handleFavorite(channel.favorite(), channel);
    addRecent(channel);
  }
}

class VodTab extends BaseListTab<VodStream> {
  VodTab(key, channels, searchTexts) : super(key, channels, searchTexts);

  @override
  VodVideoAppState createState() => VodVideoAppState();
}
