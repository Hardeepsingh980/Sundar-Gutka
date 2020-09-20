import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sundargutka/banidetails.dart';
import 'package:sundargutka/bloc/details_bloc.dart';
import 'package:sundargutka/settings.dart';

import 'bloc/home_bloc.dart';

class BaniListPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    // ignore: close_sinks
    HomeBloc _homeBloc = BlocProvider.of<HomeBloc>(context);
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text(
          'ਸੁੰਦਰ ਗੁਟਕਾ',
          style: TextStyle(color: Colors.orange),
          textScaleFactor: 1.5,
        ),
        actions: <Widget>[
          IconButton(
              icon: Icon(Icons.more_vert),
              onPressed: () => Navigator.push(
                  context, MaterialPageRoute(builder: (_) => SettingsScreen())))
        ],
      ),
      body: BlocBuilder(
        bloc: _homeBloc,
        builder: (context, state) {
          if (state is HomeStateLoading) {
            return Center(
              child: CircularProgressIndicator(),
            );
          } else if (state is HomeStateError) {
            return Center(
              child: Text('Something Went Wrong While Loading Data...'),
            );
          } else if (state is HomeStateLoaded) {
            return CupertinoScrollbar(
              child: ListView.builder(
                itemCount: state.data.length,
                itemBuilder: (context, i) => Column(children: <Widget>[
                  ListTile(
                    onTap: () => Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => BlocProvider(
                            create: (context) => DetailsBloc()
                              ..add(DetailsEventInitial(id: state.data[i].id)),
                            child: BaniContentPage(),
                          ),
                        )),
                    title: Text(
                      state.data[i].name,
                      textScaleFactor: 1.3,
                    ),
                  ),
                  Divider(),
                ]),
              ),
            );
          } else if (state is HomeStateDefault) {
            return Center(
              child: Text('Initial State'),
            );
          } else {
            return Center(
              child: Text('Initial State'),
            );
          }
        },
      ),
    );
  }
}
