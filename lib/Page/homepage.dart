import 'dart:developer' as debug;
import 'dart:math';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:moodtracker/Misc/appstorage.dart';
import 'package:moodtracker/Misc/formatting.dart';
import 'package:moodtracker/Misc/mood_class.dart';
import 'package:moodtracker/SidemenuFunctions/export_to_image.dart';
import 'package:moodtracker/Widget/happyness_streak.dart';
import 'package:moodtracker/Widget/line_with_time.dart';
import 'package:moodtracker/Widget/mood_widget.dart';
import 'package:moodtracker/Widget/sidemenu_element.dart';
import 'package:moodtracker/Widget/topmenu.dart';
import 'package:moodtracker/Misc/navigator.dart';
import 'package:moodtracker/Misc/notifications.dart';

class HomePage extends StatefulWidget{
  const HomePage({super.key});
  @override
  State<StatefulWidget> createState() => _HomePage();
}

class _HomePage extends State<HomePage> with SingleTickerProviderStateMixin{

  static const double topmenuCallerSensitivity = 100;
  static const bool needsDevControls = false;
  
  List<Mood> _moods = <Mood>[].toList();
  List<Widget> _moodsWidgets = <Widget>[].toList();
  int _selectedYear = DateTime.now().year;

  bool _topmenuState = false;
  bool _debounce = false;

  late final AnimationController _topmenuController;
  late Animation<double> _topmenuAnimation;
  final GlobalKey _topmenuGlobalkey = GlobalKey();

  bool _isDragging = false;
  double _dragXstart = 0;
  double _dragXelapsed = 0;

  bool _showMoodPopup = false;
  int _selectedMood = -1;
  final TextEditingController _moodPopupController = TextEditingController();

  bool _canExportImage = true;

  int _happyStreak = -1;
  bool _canRateDay = false;

  @override
  void dispose() {
    super.dispose();
    _moodsWidgets.clear();
    _moods.clear();
    _moodPopupController.dispose();
    _topmenuController.dispose();
  }

  @override
  void initState() {
    super.initState();

    SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
      statusBarIconBrightness: Brightness.light,
      systemNavigationBarColor: Color.fromRGBO(22, 22, 22, 1.0), // navigation bar color
      statusBarColor: Color.fromRGBO(42, 42, 42, 1.0), // status bar color
    ));

    _topmenuController = AnimationController(vsync: this, duration: const Duration(milliseconds: 400));
    _topmenuAnimation = Tween(begin: 0.0, end: 1.0).animate(_topmenuController);

    _topmenuController.addListener(() {
      (context as Element).markNeedsBuild();
    });

    _moodsWidgets.add(const Text(
      'No Moods Recorded Yet',
      textAlign: TextAlign.center,
      style: TextStyle(
          color: Colors.white,
          fontSize: 30,
          fontWeight: FontWeight.w800
      ),
    ));

    Future.delayed(Duration.zero, ()async{
      await moodSetup();
    });

    Future.delayed(const Duration(seconds: 1), ()async{
      await AppNotifications.setup();
      await AppNotifications.showNotification();
    });

    Future.delayed(Duration.zero, ()async{
      if(!await NumberStorage.hasKey('happyStreak')){
        NumberStorage.setData('happyStreak', 0.0);
        setState(() {
          _happyStreak = 0;
        });
        return;
      }

      final streak = await NumberStorage.getData('happyStreak');
      setState(() {
        _happyStreak = streak.round();
      });
    });
  }

  Future<void> moodSetup()async{
    await fetchMoods();
    final now = DateTime.now();
    if(await NumberStorage.hasKey('lastDatetimeMoodAsked')){
      if(await NumberStorage.getData('lastDatetimeMoodAsked') < DateTime(now.year, now.month, now.day, 0, 0, 0).millisecondsSinceEpoch && now.hour >= 19){ // only ask at night, when we can say stuff about the day
        _canRateDay = true;
        showMoodPopup();
      }
    }
    else if(now.hour >= 19){
      _canRateDay = true;
      showMoodPopup();
    }
  }

  List<Mood> selectMoodsByYear(int year){
    List<Mood> moods = <Mood>[].toList();
    for (var item in _moods){
      if(item.time.year == _selectedYear){
        moods.add(item);
      }
    }
    return moods;
  }

  void onMenuPressed(bool force){
    if(!force){
      if(_debounce){
        return;
      }
      _debounce = true;
    }
    if(!_topmenuState) {
      _topmenuController.forward();
      if(!force) {
        AppNavigator.push(1, (){onMenuPressed(true);});
      }
    }
    else{
      _topmenuController.reverse();
      if(!force) {
        AppNavigator.popWithoutAction();
      }
    }
    Future.delayed(_topmenuController.duration!, (){_debounce = false;});

    _topmenuState = !_topmenuState;
  }

  Future<void> saveMood(Mood mood) async{
    setState(() {
      _canRateDay = false;
    });
    final curr = (await NumberStorage.getData('moodsLen')).round() + 1;
    NumberStorage.setData('hasMoods', 1);
    NumberStorage.setData('moodsLen', curr.roundToDouble());
    StringStorage.setData('moods_${curr - 1}', mood.toString());

    final now = DateTime.now();
    NumberStorage.setData('lastDatetimeMoodAsked', DateTime(now.year, now.month, now.day, 0, 0, 0).millisecondsSinceEpoch.roundToDouble());

    if(mood.value >= 3){
      NumberStorage.setData('happyStreak', (_happyStreak + 1).roundToDouble());
      setState(() {
        _happyStreak += 1;
      });
    }
    else if(mood.value <= 2){
      NumberStorage.setData('happyStreak', 0.0);
      setState(() {
        _happyStreak = 0;
      });
    }

    await fetchMoods();
  }

  Future<void> fetchMoods() async{
    await setupMoodsWidgets(await setupMoods());
  }

  void showMoodPopup(){
    if(_topmenuState){
      AppNavigator.pop();
    }
    AppNavigator.push(1, () {
      setState(() {
        _showMoodPopup = false;
      });
    });
    setState(() {
      _moodPopupController.clear();
      _selectedMood = -1;
      _showMoodPopup = true;
    });
  }

  Future<bool> setupMoods() async{
    _moods = <Mood>[].toList();
    if(!await NumberStorage.hasKey('hasMoods')){
      NumberStorage.setData('moodsLen', 0);
      return true;
    }

    final len = await NumberStorage.getData('moodsLen');
    for (int i = len.round() - 1; i >= 0; i--){
      final val = await StringStorage.getData('moods_$i');
      Mood currMood = Mood(0, DateTime.fromMillisecondsSinceEpoch(0), '').parseString(val);
      _moods.add(currMood);
    }
    return false;
  }

  Future<void> setupMoodsWidgets(bool emptyMoods) async{
    if(emptyMoods){
      return;
    }

    _moodsWidgets = <Widget>[].toList();

    int prevMonth = -1;
    for(var item in _moods){
      if(item.time.year != _selectedYear){
        continue;
      }
      if(prevMonth == -1){
        prevMonth = item.time.month;
      }
      else if(prevMonth != item.time.month){
        prevMonth = item.time.month;
        _moodsWidgets.add(LineWithTimeWidget(displayText: '${item.time.year} ${DisplayTextFormatting.monthToTextFullName(item.time.month)}'));
      }
      _moodsWidgets.add(MoodWidget(mood: item));
    }
    setState(() {});
  }

  void onSidemenuButtonPressed(int id){
    switch(id){
      case 0:
        setState(() {
          _canExportImage = false;
        });
        ExportMoodsToImage.export(selectMoodsByYear(_selectedYear),(){
          setState(() {
            _canExportImage = true;
          });
        });
        break;
      case 1:
        showMoodPopup();
        break;
      case 99:
        StorageHelper.clearData();
        Future.delayed(Duration.zero, ()async{
          await moodSetup();
        });
        break;
      case 100:
        Future.delayed(Duration.zero,()async{
          for (int i = 0; i < 12; i++){
            for(int j = 0; j < 31; j++){
              Future.delayed(Duration.zero, ()async{
                await saveMood(Mood(Random().nextInt(100) % 5, DateTime(2025, i, j), 'RANDOMG_$i-$j'));
              });
            }
          }
        });
        break;
      case 101:
        showMoodPopup();
        break;
      default:
        return;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: PopScope(
        canPop: false,
        onPopInvoked: (_){
          AppNavigator.pop();
        },
        child: Stack(
          children: [
            GestureDetector(
              onHorizontalDragDown: (details){
                if(_topmenuState){
                  return;
                }

                _dragXstart = details.globalPosition.dx;
                _isDragging = true;
              },
              onHorizontalDragUpdate: (details){
                if(!_isDragging){
                  return;
                }
                _dragXelapsed += details.globalPosition.dx - _dragXstart;
                if(_dragXelapsed > topmenuCallerSensitivity){
                  _isDragging = false;
                  _dragXstart = 0;
                  _dragXelapsed = 0;
                  onMenuPressed(false);
                }
              },
              child: SingleChildScrollView(
                physics: const AlwaysScrollableScrollPhysics(),
                child: Container(
                  height: MediaQuery.of(context).size.height,
                  width: MediaQuery.of(context).size.width,
                  color: const Color.fromRGBO(22, 22, 22, 1.0),
                  padding: EdgeInsets.only(top: MediaQuery.of(context).padding.top, bottom: MediaQuery.of(context).padding.bottom),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      TopMenu(
                        key: _topmenuGlobalkey,
                        onMenuPressed: (){onMenuPressed(false);},
                        progress: _topmenuAnimation,
                      ),
                      Container(
                        decoration: const BoxDecoration(
                          color: Color.fromRGBO(42, 42, 42, 1.0),
                          borderRadius: BorderRadius.all(Radius.circular(20))
                        ),
                        padding: const EdgeInsets.all(10),
                        margin: const EdgeInsets.symmetric(vertical: 20, horizontal: 10),
                        child: Row(
                          mainAxisSize: MainAxisSize.max,
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            IconButton(
                                onPressed: _moods.isNotEmpty && _moods[_moods.length - 1].time.year < _selectedYear ? (){
                                  _selectedYear -= 1;
                                  moodSetup();
                                } : null,
                                padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 10),
                                icon: Icon(
                                  Icons.arrow_back_rounded,
                                  color: _moods.isNotEmpty && _moods[_moods.length - 1].time.year < _selectedYear ? Colors.white : Colors.white.withOpacity(.4),
                                  size: 30,
                                )
                            ),
                            Expanded(
                              flex: 2,
                              child: Text(
                                '$_selectedYear',
                                textAlign: TextAlign.center,
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 22,
                                  fontWeight: FontWeight.w600
                                ),
                              ),
                            ),
                            IconButton(
                                onPressed: _moods.isNotEmpty && _moods[0].time.year > _selectedYear ? (){
                                  _selectedYear += 1;
                                  moodSetup();
                                } : null,
                                padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 10),
                                icon: Icon(
                                  Icons.arrow_forward_rounded,
                                  color: _moods.isNotEmpty && _moods[0].time.year > _selectedYear ? Colors.white : Colors.white.withOpacity(.4),
                                  size: 30,
                                )
                            ),
                          ],
                        ),
                      ),
                      Expanded(
                        child: ListView(
                          physics: const AlwaysScrollableScrollPhysics(),
                          children: _moodsWidgets,
                        ),
                      )
                    ],
                  ),
                ),
              ),
            ),
            _topmenuState || _topmenuAnimation.value != 0 ? Builder(
              builder: (context){
                return GestureDetector(
                  onHorizontalDragDown: (details){
                    if(!_topmenuState){
                      return;
                    }

                    _dragXstart = details.globalPosition.dx;
                    _isDragging = true;
                  },
                  onHorizontalDragUpdate: (details){
                    if(!_isDragging){
                      return;
                    }
                    _dragXelapsed += _dragXstart - details.globalPosition.dx;
                    if(_dragXelapsed > topmenuCallerSensitivity){
                      _isDragging = false;
                      _dragXstart = 0;
                      _dragXelapsed = 0;
                      onMenuPressed(false);
                    }
                  },
                  onTap: (){onMenuPressed(false);},
                  child: Container(
                    width: MediaQuery.of(context).size.width,
                    transform: Matrix4.translationValues(0, _topmenuGlobalkey.currentContext?.findRenderObject() != null ? (_topmenuGlobalkey.currentContext?.findRenderObject()! as RenderBox).size.height + MediaQuery.of(context).padding.top : 0, 0),
                    color: Colors.black.withOpacity(0.3 * _topmenuAnimation.value),
                    child: Container(
                        transform: Matrix4.translationValues(-MediaQuery.of(context).size.width * (1 - _topmenuAnimation.value), 0, 0),
                        margin: EdgeInsets.only(right: MediaQuery.of(context).size.width / 3, bottom: 20 + (_topmenuGlobalkey.currentContext?.findRenderObject() != null ? (_topmenuGlobalkey.currentContext?.findRenderObject()! as RenderBox).size.height + MediaQuery.of(context).padding.top : 0)),
                        decoration: const BoxDecoration(
                            color: Color.fromRGBO(42, 42, 42, 1.0),
                            borderRadius: BorderRadius.only(bottomRight: Radius.circular(40))
                        ),
                        child: ListView(
                          physics: const AlwaysScrollableScrollPhysics(),
                          children: [
                            SidemenuElement(
                                text: 'Export To Image',
                                icon: Icons.image_rounded,
                                onPress: _canExportImage ? (){onSidemenuButtonPressed(0);} : null
                            ),
                            _canRateDay ? SidemenuElement(text: 'Rate Day', icon: Icons.mood_rounded, onPress: (){onSidemenuButtonPressed(1);}) : const SizedBox(),

                            needsDevControls ? SidemenuElement(text: 'Delete Data Debug Option', icon: Icons.delete_forever_rounded, onPress: (){onSidemenuButtonPressed(99);}) : const SizedBox(),
                            needsDevControls ? SidemenuElement(text: 'Create Random Data Debug Option', icon: Icons.create_new_folder_rounded, onPress: (){onSidemenuButtonPressed(100);}) : const SizedBox(),
                            needsDevControls ? SidemenuElement(text: 'Show Mood Popup Debug Option', icon: Icons.mood_rounded, onPress: (){onSidemenuButtonPressed(101);}) : const SizedBox(),
                            _happyStreak <= 1 ? const SizedBox() : HappyStreakWidget(happyStreak: _happyStreak),
                          ],
                        )
                    ),
                  ),
                );
              },
            ) : const SizedBox(),
            _showMoodPopup ? GestureDetector(
              onTap: (){
                setState(() {
                  AppNavigator.pop();
                });
              },
              child: Container(
                width: MediaQuery.of(context).size.width,
                height: MediaQuery.of(context).size.height,
                color: Colors.black.withOpacity(0.4),
                child: Center(
                  child: SingleChildScrollView(
                    physics: const AlwaysScrollableScrollPhysics(),
                    child: Container(
                      margin: const EdgeInsets.all(40),
                      padding: const EdgeInsets.all(20),
                      decoration: const BoxDecoration(
                        color: Color.fromRGBO(42, 42, 42, 1.0),
                        borderRadius: BorderRadius.all(Radius.circular(25))
                      ),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          const Text(
                            'Mood',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.w600,
                              fontSize: 20
                            ),
                          ),
                          Text(
                            'How do you feel today?',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                                color: Colors.white.withOpacity(.4),
                                fontWeight: FontWeight.w400,
                                fontSize: 12
                            ),
                          ),
                          const SizedBox(height: 18),
                          SingleChildScrollView(
                            scrollDirection: Axis.horizontal,
                            physics: const AlwaysScrollableScrollPhysics(),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              mainAxisSize: MainAxisSize.max,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                IconButton(
                                  onPressed: (){
                                    setState(() {
                                      _selectedMood = 0;
                                    });
                                  },
                                  icon: Icon(
                                    Icons.sentiment_very_dissatisfied_rounded,
                                    color: _selectedMood == -1 || _selectedMood == 0 ? Colors.red : Colors.red.withOpacity(.4),
                                    size: 30,
                                  ),
                                  color: Colors.red,
                                ),
                                IconButton(
                                  onPressed: (){
                                    setState(() {
                                      _selectedMood = 1;
                                    });
                                  },
                                  icon: Icon(
                                    Icons.sentiment_dissatisfied_rounded,
                                    color: _selectedMood == -1 || _selectedMood == 1 ? Colors.orange : Colors.orange.withOpacity(.4),
                                    size: 30,
                                  ),
                                  color: Colors.orange,
                                ),
                                IconButton(
                                  onPressed: (){
                                    setState(() {
                                      _selectedMood = 2;
                                    });
                                  },
                                  icon: Icon(
                                    Icons.sentiment_neutral_rounded,
                                    color: _selectedMood == -1 || _selectedMood == 2 ? Colors.yellow : Colors.yellow.withOpacity(.4),
                                    size: 30,
                                  ),
                                  color: Colors.yellow,
                                ),
                                IconButton(
                                  onPressed: (){
                                    setState(() {
                                      _selectedMood = 3;
                                    });
                                  },
                                  icon: Icon(
                                    Icons.sentiment_satisfied_rounded,
                                    color: _selectedMood == -1 || _selectedMood == 3 ? Colors.greenAccent : Colors.greenAccent.withOpacity(.4),
                                    size: 30,
                                  ),
                                  color: Colors.greenAccent,
                                ),
                                IconButton(
                                  onPressed: (){
                                    setState(() {
                                      _selectedMood = 4;
                                    });
                                  },
                                  icon: Icon(
                                    Icons.sentiment_very_satisfied_rounded,
                                    color: _selectedMood == -1 || _selectedMood == 4 ? Colors.green : Colors.green.withOpacity(.4),
                                    size: 30,
                                  ),
                                  color: Colors.green,
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(height: 18),
                          TextField(
                            controller: _moodPopupController,
                            maxLength: 200,
                            maxLines: 3,
                            keyboardType: TextInputType.text,
                            decoration: const InputDecoration(
                              hintText: 'Comment the day...',
                            ),
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 14,
                              fontWeight: FontWeight.w300
                            ),
                          ),
                          const SizedBox(height: 18),
                          TextButton(
                            onPressed: _selectedMood != -1 ? (){
                              setState(() {
                                final now = DateTime.now();
                                saveMood(Mood(_selectedMood, DateTime(now.year, now.month, now.day, 0, 0, 0), _moodPopupController.value.text));
                                AppNavigator.pop();
                              });
                            } : null,
                            child: Container(
                              padding: const EdgeInsets.all(7),
                              margin: const EdgeInsets.symmetric(vertical: 8),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                mainAxisSize: MainAxisSize.max,
                                children: [
                                  Icon(
                                    Icons.check_rounded,
                                    color: Colors.white.withOpacity(_selectedMood == -1 ? .4 : 1),
                                    size: 20,
                                  ),
                                  const SizedBox(width: 8),
                                  Text(
                                    'Done',
                                    style: TextStyle(
                                      color: Colors.white.withOpacity(_selectedMood == -1 ? .4 : 1),
                                      fontSize: 16,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  )
                                ],
                              ),
                            ),
                          )
                        ],
                      ),
                    ),
                  ),
                ),
                ),
            ) : const SizedBox(),
          ],
        ),
      ),
      floatingActionButton: needsDevControls ? FloatingActionButton(
        onPressed: () { AppNavigator.pop(); },
        child: const Icon(Icons.arrow_back),
      ) : null,
    );
  }
}