import 'dart:async';

import 'package:equatable/equatable.dart';
import '../models/Movie.dart';
import '../repositories/MovieRepo.dart';
class MovieEvent extends Equatable{
  @override
  List<Object> get props => [];
}

class FetchMovies extends MovieEvent{
  @override
  List<Object> get props => [];
}
//
class SetMovieDate extends MovieEvent{
  static String date;
  SetMovieDate(date);
  @override
  // TODO: implement props
  List<Object> get props => [date];
}
//
class SetMovieTime extends MovieEvent{
  static String time;
  SetMovieTime(time);
  @override
  // TODO: implement props
  List<Object> get props => [time];
}
//
class SetCinemaSeat extends MovieEvent{
  static String seat;
  SetCinemaSeat(seat);
  @override
  // TODO: implement props
  List<Object> get props => [seat];
}

class ReloadMovies extends MovieEvent{
  @override
  List<Object> get props => [];
}

class MovieBloc{
  List<Movie> movies;
  // movie controllers
  StreamController _movieStreamController = StreamController<List<Movie>>();
  StreamSink<List<Movie>> get _movieSink => _movieStreamController.sink;
  Stream<List<Movie>> get movieStream => _movieStreamController.stream;
  //user action controllers
  StreamController _actionStreamController = StreamController<MovieEvent>();
  StreamSink<MovieEvent> get actionSink => _actionStreamController.sink;
  Stream<MovieEvent> get _actionStream => _actionStreamController.stream;

  MovieRepo movieRepo;
  MovieBloc({MovieRepo mRepo}){
    movieRepo = mRepo;
    _actionStream.listen((event) async {
      if(event is FetchMovies){
        try{
          movies = await movieRepo.getMovies();
          _movieSink.add(movies);
        } on Exception catch (e) {
          _movieSink.addError("Couldn't connect to server");
        }
      }else if (event is ReloadMovies){
        movies = [];
        _movieSink.add(null);
      }
    });
  }
  //closing stream
  void dispose(){
    _movieStreamController.close();
    _actionStreamController.close();
  }
}