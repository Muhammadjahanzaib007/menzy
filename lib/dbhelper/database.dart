import 'dart:async';

import 'package:floor/floor.dart';
import 'package:menzy/dbhelper/dao/RunningDao.dart';
import 'package:menzy/dbhelper/dao/StepsDao.dart';
import 'package:menzy/dbhelper/dao/WaterDao.dart';
import 'package:menzy/dbhelper/dao/WeightDao.dart';
import 'package:menzy/dbhelper/datamodel/RunningData.dart';
import 'package:menzy/dbhelper/datamodel/StepsData.dart';
import 'package:menzy/dbhelper/datamodel/WaterData.dart';
import 'package:menzy/dbhelper/datamodel/WeightData.dart';
import 'package:sqflite/sqflite.dart' as sqflite;

part 'database.g.dart';

@Database(version: 1, entities: [RunningData , WaterData, WeightData, StepsData])
abstract class FlutterDatabase extends FloorDatabase {
  RunningDao get runningDao;

  WaterDao get waterDao;

  WeightDao get weightDao;

  StepsDao get stepsDao;
}
