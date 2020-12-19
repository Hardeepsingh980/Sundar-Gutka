import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sundargutka/bloc/home_bloc.dart';
import 'package:sundargutka/bloc/hukam_bloc.dart';
import 'package:sundargutka/model.dart';

class HukamScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) =>
          HukamBloc(HukamStateLoading())..add(HukamEventLoading()),
      child: BlocBuilder<HukamBloc, HukamState>(
        builder: (context, state) {
          if (state is HukamStateLoading) {
            return Scaffold(
              body: Center(
                child: CircularProgressIndicator(),
              ),
            );
          } else if (state is HukamStateError) {
            return Scaffold(
              body: Center(
                child: Text('Please check your internet connection ...'),
              ),
            );
          } else if (state is HukamStateLoaded) {
            return Scaffold(
                appBar: AppBar(
                  leading: IconButton(
                    icon: Icon(Icons.arrow_back_ios),
                    onPressed: () => Navigator.pop(context),
                  ),
                  title:
                      Text('${state.data.date}        ਅੰਗ:- ${state.data.ang}'),
                ),
                body: CupertinoScrollbar(
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
                              )
                            ],
                          );
                        })));
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
