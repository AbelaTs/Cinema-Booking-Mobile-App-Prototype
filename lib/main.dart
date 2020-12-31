import 'package:flutter/material.dart';
import 'package:imdb_app/view_models/MovieBloc.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'widgets/MovieCard.dart';
import 'repositories/MovieRepo.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Movie List',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.blueGrey,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: MyHomePage(title: 'Now Showing'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  MovieBloc movieBloc;

  populateData() async {
    movieBloc.actionSink.add(FetchMovies());
  }
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    movieBloc = new MovieBloc(mRepo: new MovieRepo());
    populateData();
  }

  @override
  void dispose() {
    // TODO: impleme nt dispose
    super.dispose();
    movieBloc.dispose();
  }



  Future<void> refresh() async {
    movieBloc.actionSink.add(ReloadMovies());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: movieList(context)
    );
  }
  movieList(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return  RefreshIndicator(
            onRefresh: refresh,
            child: StreamBuilder(
              stream: movieBloc.movieStream,
              builder: (context, snapshot) {
                if (snapshot.data == null) {
                  return Center(child: CircularProgressIndicator());
                } else if (snapshot.hasData) {
                  return snapshot.data.length == 0
                      ? Center(
                      child: Container(
                          margin: EdgeInsets.symmetric(horizontal: 20),
                          child: Align(
                              alignment: Alignment.center,
                              child: Column(
                                  mainAxisAlignment:
                                  MainAxisAlignment.center,
                                  children: <Widget>[
                                    Icon(Icons.people_outline,
                                        size: 80,
                                        color:
                                        Theme.of(context).primaryColor),
                                    Text(
                                        "No movies yet!",
                                        textAlign: TextAlign.center,
                                        style: TextStyle(
                                          fontSize: 22,
                                          color: Theme.of(context)
                                              .primaryColor,
                                        ))
                                  ]))))
                      :ListView.builder(
                          //key: animatedListKey,
                          scrollDirection: Axis.vertical,
                          itemCount: 3,
                          itemBuilder: (BuildContext context, int index) {
                              return Row(children : <Widget>[Expanded(child : MovieCard(movie:snapshot.data[((2*index))])),Expanded(child :MovieCard(movie:snapshot.data[((2*index)+1)]))]);
                          },
                        );
                } else if (snapshot.hasError) {
                  return Container(
                      margin: EdgeInsets.only(top: 100),
                      child: Align(
                          alignment: Alignment.center,
                          child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: <Widget>[
                                Icon(Icons.error, size: 80, color: Colors.red),
                                Text(
                                    "Sorry, couldn't connect to Server. Please refresh the page!",
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                      fontSize: 20,
                                      color: Colors.red,
                                    ))
                              ])));
                }
                return Container(
                    margin: EdgeInsets.only(top: 100),
                    child: Align(
                        alignment: Alignment.center,
                        child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: <Widget>[
                              Icon(Icons.error, size: 80, color: Colors.red),
                              Text(
                                "",
                              )
                            ])));
              },
            ));
  }

}
