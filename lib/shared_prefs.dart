import 'dart:convert';

import 'package:fastotvlite/channels/live_stream.dart';
import 'package:fastotvlite/channels/vod_stream.dart';
import 'package:fastotvlite/constants.dart';
import 'package:shared_preferences/shared_preferences.dart';

const IARC_DEFAULT_AGE = 21;
const MAX_IARC_AGE = IARC_DEFAULT_AGE;

class LocalStorageService {
  static LocalStorageService _instance;
  static SharedPreferences _preferences;

  static Future<LocalStorageService> getInstance() async {
    if (_instance == null) {
      _instance = LocalStorageService();
    }

    if (_preferences == null) {
      _preferences = await SharedPreferences.getInstance();
    }

    return _instance;
  }

  static const String _channelsKey = 'channels';
  static const String _vodsKey = 'vods';

  static const String _soundAbsoluteKey = "sound_abs";
  static const String _brightnessAbsoluteKey = "brightness_abs";
  static const String _isLastSaved = "save_last";
  static const String _lastChannelKey = "last_channel";
  static const String _ageRatingKey = 'iarc';
  static const String _epgLinkKey = 'epg';

  static const String _screenScaleKey = 'content_padding';

  static const String _langCodeKey = 'lang_code';
  static const String _countryCodeKey = 'country_code';

  String langCode() {
    return _preferences.getString(_langCodeKey);
  }

  void setLangCode(String code) {
    _preferences.setString(_langCodeKey, code);
  }

  String countryCode() {
    return _preferences.getString(_countryCodeKey);
  }

  void setCountryCode(String code) {
    _preferences.setString(_countryCodeKey, code);
  }

  List<LiveStream> liveChannels() {
    List<LiveStream> _channels = [];
    final _jsonList = _preferences.getStringList(_channelsKey) ?? [];
    _jsonList.forEach((element) => _channels.add(LiveStream.fromJson(json.decode(element))));
    return _channels;
  }

  void saveLiveChannels(List<LiveStream> list) {
    List<String> _jsonList = [];
    list.forEach((element) => _jsonList.add(json.encode(element)));
    _preferences.setStringList(_channelsKey, _jsonList);
  }

  List<VodStream> vods() {
    List<VodStream> _channels = [];
    final _jsonList = _preferences.getStringList(_vodsKey) ?? [];
    _jsonList.forEach((element) => _channels.add(VodStream.fromJson(json.decode(element))));
    return _channels;
  }

  void saveVods(List<VodStream> list) {
    List<String> _jsonList = [];
    list.forEach((element) => _jsonList.add(json.encode(element)));
    _preferences.setStringList(_vodsKey, _jsonList);
  }

  double screenScale() {
    return _preferences.getDouble(_screenScaleKey) ?? 1.0;
  }

  void setscreenScale(double padding) {
    _preferences.setDouble(_screenScaleKey, padding);
  }

  bool soundChange() {
    return _preferences.getBool(_soundAbsoluteKey) ?? false;
  }

  bool brightnessChange() {
    return _preferences.getBool(_brightnessAbsoluteKey) ?? false;
  }

  bool saveLastViewed() {
    return _preferences.getBool(_isLastSaved) ?? false;
  }

  String lastChannel() {
    return _preferences.getString(_lastChannelKey);
  }

  int ageRating() {
    return _preferences.getInt(_ageRatingKey) ?? IARC_DEFAULT_AGE;
  }

  String epgLink() {
    return _preferences.getString(_epgLinkKey) ?? EPG_URL;
  }

  void setSoundChange(bool value) {
    _preferences.setBool(_soundAbsoluteKey, value);
  }

  void setBrightnessChange(bool value) {
    _preferences.setBool(_brightnessAbsoluteKey, value);
  }

  void setSaveLastViewed(bool value) {
    _preferences.setBool(_isLastSaved, value);
  }

  void setLastChannel(String url) {
    _preferences.setString(_lastChannelKey, url);
  }

  void setAgeRating(int age) {
    _preferences.setInt(_ageRatingKey, age);
  }

  void setEpgLink(String epgLink) {
    _preferences.setString(_epgLinkKey, epgLink);
  }
}
