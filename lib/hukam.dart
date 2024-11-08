import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sundargutka/bloc/hukam_bloc.dart';
import 'package:audioplayers/audioplayers.dart';

class HukamScreen extends StatefulWidget {
  @override
  _HukamScreenState createState() => _HukamScreenState();
}

class _HukamScreenState extends State<HukamScreen> {
  final AudioPlayer audioPlayer = AudioPlayer();
  bool isPlaying = false;
  Duration duration = Duration.zero;
  Duration position = Duration.zero;
  bool isLoading = false;

  @override
  void initState() {
    super.initState();

    audioPlayer.onDurationChanged.listen((newDuration) {
      setState(() {
        duration = newDuration;
      });
    });

    audioPlayer.onPositionChanged.listen((newPosition) {
      setState(() {
        position = newPosition;
      });
    });

    audioPlayer.onPlayerComplete.listen((_) {
      setState(() {
        isPlaying = false;
        position = Duration.zero;
      });
    });
  }

  @override
  void dispose() {
    audioPlayer.dispose();
    super.dispose();
  }

  String formatTime(Duration duration) {
    String twoDigits(int n) => n.toString().padLeft(2, '0');
    final hours = twoDigits(duration.inHours);
    final minutes = twoDigits(duration.inMinutes.remainder(60));
    final seconds = twoDigits(duration.inSeconds.remainder(60));
    return [if (duration.inHours > 0) hours, minutes, seconds].join(':');
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => HukamBloc()..add(HukamEventLoading()),
      child: BlocBuilder<HukamBloc, HukamState>(
        builder: (context, state) {
          if (state is HukamStateLoading) {
            return Scaffold(
              appBar: AppBar(
                elevation: 0,
                title: Text('Loading Hukamnama...'),
                leading: IconButton(
                  icon: Icon(Icons.arrow_back_ios),
                  onPressed: () => Navigator.pop(context),
                ),
              ),
              body: Center(
                child: CupertinoActivityIndicator(),
              ),
            );
          } else if (state is HukamStateError) {
            return Scaffold(
              appBar: AppBar(
                elevation: 0,
                title: Text('No Internet'),
                leading: IconButton(
                  icon: Icon(Icons.arrow_back_ios),
                  onPressed: () => Navigator.pop(context),
                ),
              ),
              body: Center(
                child: Text('Please check your internet connection ...'),
              ),
            );
          } else if (state is HukamStateLoaded) {
            return Scaffold(
                appBar: AppBar(
                  elevation: 0,
                  leading: IconButton(
                    icon: Icon(Icons.arrow_back_ios),
                    onPressed: () => Navigator.pop(context),
                  ),
                  title: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      Text(state.data.date),
                      Text('ਅੰਗ:- ${state.data.ang}')
                    ],
                  ),
                ),
                body: Stack(
                  children: [
                    CupertinoScrollbar(
                      child: ListView.builder(
                          itemCount: state.data.baniEnglish.length,
                          itemBuilder: (_, i) {
                            return Column(
                              children: <Widget>[
                                Container(
                                  padding: const EdgeInsets.symmetric(
                                      vertical: 5, horizontal: 0),
                                  child: Text(state.data.baniGurmukhi[i] ?? '',
                                      textAlign: TextAlign.center,
                                      textScaleFactor: 1.8),
                                ),
                                Container(
                                  padding: const EdgeInsets.symmetric(
                                      vertical: 2, horizontal: 0),
                                  child: Text(
                                    state.data.baniPunjabi[i] ?? '',
                                    textAlign: TextAlign.center,
                                    textScaleFactor: 1.3,
                                    style: TextStyle(color: Colors.orange),
                                  ),
                                ),
                                Container(
                                  padding: const EdgeInsets.symmetric(
                                      vertical: 5, horizontal: 0),
                                  child: Text(
                                    state.data.baniEnglish[i] ?? '',
                                    textAlign: TextAlign.center,
                                    style: TextStyle(color: Colors.grey),
                                  ),
                                ),
                                (i == state.data.baniEnglish.length - 1)
                                    ? SizedBox(height: 150)
                                    : Container()
                              ],
                            );
                          }),
                    ),
                    Positioned(
                      left: 0,
                      right: 0,
                      bottom: 0,
                      child: Container(
                        padding: EdgeInsets.only(bottom: 20),
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            begin: Alignment.topCenter,
                            end: Alignment.bottomCenter,
                            colors: [
                              Colors.black.withOpacity(0),
                              Colors.black.withOpacity(0.5),
                              Colors.black.withOpacity(0.9),
                            ],
                          ),
                        ),
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Slider(
                              value: position.inSeconds.toDouble(),
                              min: 0,
                              max: duration.inSeconds.toDouble(),
                              onChanged: (value) async {
                                final position =
                                    Duration(seconds: value.toInt());
                                await audioPlayer.seek(position);
                              },
                            ),
                            Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 16),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(formatTime(position)),
                                  Text(formatTime(duration)),
                                ],
                              ),
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                IconButton(
                                  iconSize: 45,
                                  icon: Icon(CupertinoIcons.gobackward_15),
                                  onPressed: () async {
                                    await audioPlayer.seek(Duration(
                                        seconds: position.inSeconds - 15));
                                  },
                                ),
                                IconButton(
                                  iconSize: 65,
                                  icon: isLoading 
                                      ? CircularProgressIndicator()
                                      : Icon(isPlaying
                                          ? CupertinoIcons.pause_circle_fill 
                                          : CupertinoIcons.play_circle_fill),
                                  onPressed: () async {
                                    if (isPlaying) {
                                      setState(() {
                                        isLoading = true;
                                      });
                                      await audioPlayer.pause();
                                      setState(() {
                                        isLoading = false;
                                      });
                                    } else {
                                      setState(() {
                                        isLoading = true;
                                      });
                                      await audioPlayer.play(UrlSource(
                                          'https://old.sgpc.net/hukumnama/jpeg%20hukamnama/hukamnama.mp3'));
                                      setState(() {
                                        isLoading = false;
                                      });
                                    }
                                    setState(() {
                                      isPlaying = !isPlaying;
                                    });
                                  },
                                ),
                                IconButton(
                                  iconSize: 45,
                                  icon: Icon(CupertinoIcons.goforward_15),
                                  onPressed: () async {
                                    await audioPlayer.seek(Duration(
                                        seconds: position.inSeconds + 15));
                                  },
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ));
          } else {
            return Scaffold(
              body: Text('Initial Screen'),
            );
          }
        },
      ),
    );
  }
}
