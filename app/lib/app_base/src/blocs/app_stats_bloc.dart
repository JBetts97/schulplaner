import 'package:bloc/bloc_base.dart';
import 'package:rxdart/rxdart.dart';
import 'package:schulplaner8/app_base/src/models/app_stats.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AppStatsBloc extends BlocBase {
  final _appStatsSubject = BehaviorSubject<AppStats>();

  AppStatsBloc() {
    _appStatsSubject.add(AppStats());
    _initializeAppStats();
  }

  Stream<AppStats> get appStats => _appStatsSubject;

  AppStats get currentAppStats => _appStatsSubject.value;

  Future<void> _initializeAppStats() async {
    final instance = await SharedPreferences.getInstance();
    String statsstring = instance.getString("appstats");
    if (statsstring != null) {
      _appStatsSubject.add(AppStats.fromString(statsstring));
    }
  }

  void updateAppStats(AppStats newAppStats) {
    _appStatsSubject.add(newAppStats);

    SharedPreferences.getInstance().then((pref) {
      pref.setString("appstats", newAppStats.toJsonString());
    });
  }

  void incrementOpenHomePage() {
    final currentStatsData = _appStatsSubject.value;
    currentStatsData.openedapp++;

    SharedPreferences.getInstance().then((pref) {
      pref.setString("appstats", currentStatsData.toJsonString());
    });
  }

  void incrementAddedTask() {
    final currentStatsData = _appStatsSubject.value.copy();
    currentStatsData.addedtask++;

    SharedPreferences.getInstance().then((pref) {
      pref.setString("appstats", currentStatsData.toJsonString());
    });
  }

  @override
  void dispose() {
    _appStatsSubject.close();
  }
}
