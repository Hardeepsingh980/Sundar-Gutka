import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sundargutka/banidetails.dart';
import 'package:sundargutka/bloc/details_bloc.dart';
import 'package:sundargutka/custompageroute.dart';
import 'package:sundargutka/hukam.dart';
import 'package:sundargutka/settings.dart';

import 'bloc/home_bloc.dart';

class BaniListPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    // ignore: close_sinks
    HomeBloc _homeBloc = BlocProvider.of<HomeBloc>(context);
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        bottomNavigationBar: TabBar(
          tabs: <Widget>[
            Tab(
              icon: Icon(CupertinoIcons.book),
              text: 'Bani List',
            ),
            Tab(
              icon: Icon(CupertinoIcons.heart_solid),
              text: 'Favourite Banis',
            ),
          ],
        ),
        appBar: AppBar(
          centerTitle: true,
          title: Text(
            'ਸੁੰਦਰ ਗੁਟਕਾ',
            style: TextStyle(color: Colors.orange),
            textScaleFactor: 1.5,
          ),
          actions: <Widget>[
            IconButton(
              icon: Icon(CupertinoIcons.news),
              onPressed: () => Navigator.push(context,
                    MyCustomRoute(builder: (_) => HukamScreen())),
            ),
            IconButton(
                icon: Icon(CupertinoIcons.settings),
                onPressed: () => Navigator.push(context,
                    MyCustomRoute(builder: (_) => SettingsScreen())))
          ],
        ),
        body: BlocBuilder(
          bloc: _homeBloc,
          builder: (context, state) {
            if (state is HomeStateLoading) {
              return Center(
                child: CupertinoActivityIndicator(),
              );
            } else if (state is HomeStateError) {
              return Center(
                child: Text('Something Went Wrong While Loading Data...'),
              );
            } else if (state is HomeStateLoaded) {
              List favList = [];
              state.favourites.forEach((element) => favList.add(element.id));
              return TabBarView(
                children: <Widget>[
                  CupertinoScrollbar(
                    child: ListView.builder(
                      itemCount: state.data.length,
                      itemBuilder: (context, i) => Column(children: <Widget>[
                        ListTile(
                          onTap: () => Navigator.push(
                              context,
                              MyCustomRoute(
                                builder: (_) => BlocProvider(
                                  create: (context) => DetailsBloc()
                                    ..add(DetailsEventInitial(
                                        id: state.data[i].id)),
                                  child: BaniContentPage(),
                                ),
                              )),
                          title: Text(
                            state.data[i].name,
                            textScaleFactor: 1.3,
                          ),
                          trailing: favList.contains(state.data[i].id) ? IconButton(icon: Icon(Icons.remove),onPressed: () {
                            state.favourites.removeWhere((element) => element.id == state.data[i].id);
                            _homeBloc.add(FavouriteAdded(favourites: state.favourites));
                          },) : IconButton(icon: Icon(Icons.add) ,onPressed: () {
                            state.favourites.add(state.data[i]);
                            _homeBloc.add(FavouriteAdded(favourites: state.favourites));
                          },),
                        ),
                        Divider(),
                      ]),
                    ),
                  ),
                  CupertinoScrollbar(
                    child: state.favourites.length == 0 ? Center(child: Text('No Bani in Favourites!'),) : ListView.builder(
                      itemCount: state.favourites.length,                    
                      itemBuilder: (context, i) => Column(children: <Widget>[
                        ListTile(
                          onTap: () => Navigator.push(
                              context,
                              MyCustomRoute(
                                builder: (_) => BlocProvider(
                                  create: (context) => DetailsBloc()
                                    ..add(DetailsEventInitial(
                                        id: state.favourites[i].id)),
                                  child: BaniContentPage(),
                                ),
                              )),
                          title: Text(
                            state.favourites[i].name.toString(),
                            textScaleFactor: 1.3,
                          ),
                          trailing: IconButton(icon: Icon(Icons.remove),onPressed: () {
                            state.favourites.remove(state.favourites[i]);
                            _homeBloc.add(FavouriteAdded(favourites: state.favourites));
                          },),
                        ),
                        Divider(),
                      ]),
                    ),
                  )
                ],
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
      ),
    );
  }
}
