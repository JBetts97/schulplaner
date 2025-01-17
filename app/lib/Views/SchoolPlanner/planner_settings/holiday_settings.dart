import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:schulplaner8/Data/plannerdatabase.dart';
import 'package:schulplaner8/Helper/Functions.dart';
import 'package:schulplaner8/Helper/helper_data.dart';
import 'package:schulplaner8/models/planner_settings.dart';
import 'package:schulplaner_translations/schulplaner_translations.dart';
import 'package:schulplaner_widgets/schulplaner_forms.dart';
import 'package:schulplaner8/Views/SchoolPlanner/PlannerSettings.dart';
import 'package:schulplaner8/Views/SchoolPlanner/planner_settings/select_region_page.dart';
import 'package:schulplaner8/holiday_database/logic/holiday_gateway.dart';
import 'package:schulplaner8/holiday_database/models/region.dart';
import 'package:timeago/timeago.dart' as timeago;

class HolidaySettings extends StatelessWidget {
  final PlannerDatabase database;

  HolidaySettings({Key key, this.database}) : super(key: key) {
    timeago.setLocaleMessages('de', timeago.DeMessages());
  }

  @override
  Widget build(BuildContext context) {
    return SubSettingsPlanner(
        title: getString(context).vacations,
        plannerDatabase: database,
        builder: (context, settings) {
          return [
            ListTile(
              title: Text(getString(context).vacationdatabase),
              subtitle: settings.vacationpackageid == null
                  ? Text(getString(context).nothingselected)
                  : RegionName(
                      regionID: settings.vacationpackageid,
                      holidayGateway: database.holidayGateway,
                    ),
              onTap: () {
                pushWidget(
                    context,
                    SelectRegionPage(
                      database: database,
                    ));
              },
              trailing: settings.vacationpackageid == null
                  ? null
                  : IconButton(
                      icon: Icon(Icons.cancel),
                      onPressed: () {
                        PlannerSettingsData newdata = settings.copy();
                        newdata.vacationpackageid = null;
                        _updateSettings(newdata, database);
                      }),
            ),
            FormDivider(),
            ValueListenableBuilder<int>(
              valueListenable: database
                  .holidayGateway.holidayCacheManager.lastRefreshedNotifier,
              builder: (context, lastRefreshedValue, _) {
                return ListTile(
                  title: Text(bothlang(context,
                      en: "Holidaydatabase-Cache", de: "Feriendaten-Cache")),
                  subtitle: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Text(
                        bothlang(context,
                                en: "Last refreshed: ",
                                de: "Zuletzt aktualisiert: ") +
                            (lastRefreshedValue != null
                                ? timeago.format(
                                    DateTime.fromMillisecondsSinceEpoch(
                                        lastRefreshedValue),
                                    locale: getString(context).languagecode)
                                : "/"),
                      ),
                      Text(
                        bothlang(context,
                            en: "The cache automatically updates every 7 days",
                            de: "Der Cache aktualisiert sich automatisch alle 7 Tage"),
                        style: TextStyle(
                          fontStyle: FontStyle.italic,
                        ),
                      ),
                      Text(
                        bothlang(context,
                            en: "Tap to refresh",
                            de: "Tippen zum aktualisieren"),
                        style: TextStyle(
                          fontStyle: FontStyle.italic,
                        ),
                      )
                    ],
                  ),
                  onTap: () {
                    database.forceUpdateHolidayDatabase();
                  },
                );
              },
            ),
            FormSpace(64.0),
          ];
        });
  }
}

class RegionName extends StatelessWidget {
  final String regionID;
  final HolidayGateway holidayGateway;

  const RegionName({Key key, this.regionID, this.holidayGateway})
      : super(key: key);
  @override
  Widget build(BuildContext context) {
    return StreamBuilder<Region>(
      builder: (context, snapshot) {
        if (snapshot.data == null) {
          return Text(getString(context).pleasewait);
        }
        return Text(snapshot.data.name.text ?? getString(context).error);
      },
      stream: holidayGateway.getRegion(regionID),
    );
  }
}

void _updateSettings(PlannerSettingsData newdata, PlannerDatabase database) {
  database.settings.reference.set(
    newdata.toJson(),
    SetOptions(
      merge: true,
    ),
  );
}
