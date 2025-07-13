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
        bottomNavigationBar: Container(
          decoration: BoxDecoration(
            boxShadow: [
              BoxShadow(
                color: Colors.black12,
                blurRadius: 8,
              ),
            ],
          ),
          child: TabBar(
            labelColor: Colors.orange,
            unselectedLabelColor: Colors.grey,
            indicatorColor: Colors.orange,
            tabs: <Widget>[
              Tab(
                icon: Icon(CupertinoIcons.book_fill),
                text: 'Bani List',
              ),
              Tab(
                icon: Icon(CupertinoIcons.heart_fill),
                text: 'Favourites',
              ),
            ],
          ),
        ),
        appBar: AppBar(
          elevation: 0,
          centerTitle: true,
          title: Text(
            'ਸੁੰਦਰ ਗੁਟਕਾ',
            style: TextStyle(
              color: Colors.orange,
              fontWeight: FontWeight.bold,
              letterSpacing: 1.2,
            ),
            textScaleFactor: 1.5,
          ),
          actions: <Widget>[
            IconButton(
              icon: Icon(CupertinoIcons.news, color: Colors.orange),
              onPressed: () => Navigator.push(context,
                  MyCustomRoute(builder: (_) => HukamScreen(), settings: RouteSettings(name: 'HukamScreen'))),
            ),
            IconButton(
              icon: Icon(CupertinoIcons.settings, color: Colors.orange),
              onPressed: () => Navigator.push(context,
                  MyCustomRoute(builder: (_) => SettingsScreen(), settings: RouteSettings(name: 'SettingsScreen')))
            )
          ],
        ),
        body: BlocBuilder(
          bloc: _homeBloc,
          builder: (context, state) {
            if (state is HomeStateLoading) {
              return Center(
                child: CircularProgressIndicator(
                  valueColor: AlwaysStoppedAnimation<Color>(Colors.orange),
                ),
              );
            } else if (state is HomeStateError) {
              return Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.error_outline, size: 48, color: Colors.red),
                    SizedBox(height: 16),
                    Text(
                      'Something Went Wrong While Loading Data...',
                      style: TextStyle(color: Colors.red),
                    ),
                  ],
                ),
              );
            } else if (state is HomeStateLoaded) {
              List favList = [];
              state.favourites.forEach((element) => favList.add(element.id));
              return TabBarView(
                children: <Widget>[
                  CupertinoScrollbar(
                    child: ListView.builder(
                      padding: EdgeInsets.symmetric(vertical: 8),
                      itemCount: state.data.length,
                      itemBuilder: (context, i) => Column(
                        children: [
                          
                          (i == 0) ? Container(
                            height: 100,
                            margin: EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                            decoration: BoxDecoration(
                              color: Colors.orange.withOpacity(0.1),
                              borderRadius: BorderRadius.circular(12),
                              border: Border.all(color: Colors.orange.withOpacity(0.3))
                            ),
                            child: Material(
                              color: Colors.transparent,
                              child: InkWell(
                                borderRadius: BorderRadius.circular(12),
                                onTap: () => Navigator.push(context,
                                    MyCustomRoute(builder: (_) => HukamScreen(), settings: RouteSettings(name: 'HukamScreen'))),
                                child: Center(
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Icon(CupertinoIcons.news, color: Colors.orange, size: 32),
                                      SizedBox(height: 8),
                                      Text(
                                        "Listen to Today's Hukamnama\nSahib from Sri Darbar Sahib",
                                        textAlign: TextAlign.center,
                                        style: TextStyle(
                                          color: Colors.orange,
                                          fontSize: 16,
                                          fontWeight: FontWeight.w500
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          ) : Container(),

                          Card(
                            margin: EdgeInsets.symmetric(horizontal: 16, vertical: 4),
                            elevation: 2,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: ListTile(
                              contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                              onTap: () => Navigator.push(
                                context,
                                MyCustomRoute(
                                  builder: (_) => BlocProvider(
                                    create: (context) => DetailsBloc()
                                      ..add(DetailsEventInitial(id: state.data[i].id)),
                                    child: BaniContentPage(),
                                  ),
                                  settings: RouteSettings(name: 'BaniContentPage'),
                                )),
                              title: Text(
                                state.data[i].name,
                                style: TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                              trailing: IconButton(
                                icon: Icon(
                                  favList.contains(state.data[i].id) 
                                    ? Icons.favorite 
                                    : Icons.favorite_border,
                                  color: Colors.orange,
                                ),
                                onPressed: () {
                                  if (favList.contains(state.data[i].id)) {
                                    state.favourites.removeWhere((element) => element.id == state.data[i].id);
                                  } else {
                                    state.favourites.add(state.data[i]);
                                  }
                                  _homeBloc.add(FavouriteAdded(favourites: state.favourites));
                                },
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  CupertinoScrollbar(
                    child: state.favourites.isEmpty 
                      ? Center(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(CupertinoIcons.heart, size: 48, color: Colors.grey),
                              SizedBox(height: 16),
                              Text(
                                'No Bani in Favourites!',
                                style: TextStyle(
                                  fontSize: 16,
                                  color: Colors.grey,
                                ),
                              ),
                            ],
                          ),
                        )
                      : ListView.builder(
                          padding: EdgeInsets.symmetric(vertical: 8),
                          itemCount: state.favourites.length,
                          itemBuilder: (context, i) => Card(
                            margin: EdgeInsets.symmetric(horizontal: 16, vertical: 4),
                            elevation: 2,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: ListTile(
                              contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                              onTap: () => Navigator.push(
                                context,
                                MyCustomRoute(
                                  builder: (_) => BlocProvider(
                                    create: (context) => DetailsBloc()
                                      ..add(DetailsEventInitial(id: state.favourites[i].id)),
                                    child: BaniContentPage(),
                                  ),
                                  settings: RouteSettings(name: 'BaniContentPage'),
                                )),
                              title: Text(
                                state.favourites[i].name.toString(),
                                style: TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                              trailing: IconButton(
                                icon: Icon(Icons.favorite, color: Colors.orange),
                                onPressed: () {
                                  state.favourites.remove(state.favourites[i]);
                                  _homeBloc.add(FavouriteAdded(favourites: state.favourites));
                                },
                              ),
                            ),
                          ),
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
