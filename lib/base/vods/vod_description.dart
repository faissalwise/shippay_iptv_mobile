import 'package:fastotv_common/colors.dart';
import 'package:fastotvlite/channels/vod_stream.dart';
import 'package:fastotvlite/localization/app_localizations.dart';
import 'package:fastotvlite/mobile/vods/vod_player_page.dart';
import 'package:fastotvlite/mobile/vods/vod_trailer_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_fastotv_common/base/vods/vod_description.dart';
import 'package:persist_theme/persist_theme.dart';
import 'package:provider/provider.dart';

class SideInfo extends StatelessWidget {
  final int duration;
  final int primeDate;
  final String country;
  final double fontSize;
  final ScrollController scrollController;

  SideInfo({this.country, this.duration, this.primeDate, this.fontSize, this.scrollController});

  String getDuration(int msec) {
    String twoDigits(int n) {
      if (n >= 10) {
        return "$n";
      }
      return "0$n";
    }

    String twoDigitMinutes = twoDigits(Duration(milliseconds: msec).inMinutes.remainder(60));
    return '${twoDigits(Duration(milliseconds: msec).inHours)}:$twoDigitMinutes';
  }

  Widget sideDescription(String title, {String data}) =>
      SideInfoItem(title: AppLocalizations.toUtf8(title), data: data);

  Widget infoBuilder() {
    List<Widget> info = [
      sideDescription('Country', data: country),
      sideDescription('Runtime', data: getDuration(duration)),
      sideDescription('Year', data: DateTime.fromMillisecondsSinceEpoch(primeDate).year.toString())
    ];
    return SingleChildScrollView(
        controller: scrollController ?? ScrollController(),
        scrollDirection: Axis.horizontal,
        child: Row(mainAxisAlignment: MainAxisAlignment.start, children: info));
  }

  @override
  Widget build(BuildContext context) {
    return infoBuilder();
  }
}

class VodTrailerButton extends StatelessWidget {
  final VodStream channel;
  final double fontSize;
  final BuildContext context;
  final Color color;

  VodTrailerButton(this.channel, this.context, {this.fontSize, this.color});

  void onTrailer(VodStream channel) {
    Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) =>
                VodTrailer("Trailer: " + channel.displayName(), channel.trailerUrl(), channel.previewIcon())));
  }

  Widget trailerButton(ThemeModel model) {
    return RaisedButton(
      elevation: 0,
      onPressed: () {
        onTrailer(channel);
      },
      color: Colors.transparent,
      shape: OutlineInputBorder(
          borderRadius: BorderRadius.circular(24), borderSide: BorderSide(color: color ?? model.accentColor, width: 2)),
      child: Center(child: Text(AppLocalizations.toUtf8("Trailer"), style: TextStyle(fontSize: fontSize ?? 14))),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<ThemeModel>(builder: (context, model, child) {
      return trailerButton(model);
    });
  }
}

class VodPlayButton extends StatelessWidget {
  final VodStream channel;
  final BuildContext context;
  final double fontSize;
  final Color color;

  VodPlayButton(this.channel, this.context, {this.fontSize, this.color});

  void onTapped(VodStream channel) async {
    int interruptTime = await Navigator.push(context, MaterialPageRoute(builder: (context) => VodPlayer(channel)));
    channel.setInterruptTime(interruptTime);
  }

  Widget playButton(ThemeModel model) {
    Color buttonColor = color ?? model.accentColor;
    return RaisedButton(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(24),
        ),
        onPressed: () {
          onTapped(channel);
        },
        color: buttonColor,
        child: Center(
            child: Text(AppLocalizations.toUtf8("Play"),
                style: TextStyle(
                  fontSize: fontSize ?? 14,
                  color: CustomColor().backGroundColorBrightness(buttonColor),
                ))));
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<ThemeModel>(builder: (context, model, child) {
      return playButton(model);
    });
  }
}
