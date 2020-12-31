//sample file of our case view provider
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:imdb_app/models/Movie.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:retry/retry.dart';
import 'dart:io';
import 'dart:async';

class MovieRepo {
  //get the list of movies
  getMovies() async {
      var headers = {
        "Accept": "application/json",
        "x-rapidapi-host": "imdb8.p.rapidapi.com",
        "x-rapidapi-key": "2316db97e6mshd8da0e934d96e9cp12541ajsnce323a7cdcc5",
      };
      var response = await retry(
            () =>
            http
                .get("https://imdb8.p.rapidapi.com/title/get-popular-movies-by-genre?page=1",
                headers: headers)
                .timeout(Duration(seconds: 10)),
        retryIf: (e) => e is SocketException || e is TimeoutException,
      );
      List<Movie> movieList = [];
      if (response.statusCode == 200) {
        var movieListResponse = json.decode(response.body);
        for (int index = 0; index < movieListResponse.length; index++) {
          if(index == 6){
            break;
          }
          Movie mv = await getMovieDetails(movieListResponse[index].toString().split('/')[2]);
          movieList.add(mv);
        }
      } else {
        print("Status code fail " + response.statusCode.toString());
      }
      return movieList;

  }
  //gets the detail of a movie
  getMovieDetails(String movieId) async {
      var headers = {
        "Accept": "application/json",
        "x-rapidapi-host": "imdb8.p.rapidapi.com",
        "x-rapidapi-key": "2316db97e6mshd8da0e934d96e9cp12541ajsnce323a7cdcc5",
      };

      var response = await retry(
            () =>
            http
                .get("https://imdb8.p.rapidapi.com/title/get-overview-details?tconst=$movieId",
                headers: headers)
                .timeout(Duration(seconds: 10)),
        retryIf: (e) => e is SocketException || e is TimeoutException,
      );
      //print(">>>>>>>>>> " + response.body.toString());
      Movie movie;
      if (response.statusCode == 200) {
        var caseListResponse = json.decode(response.body);
        movie = Movie.fromJson(caseListResponse);
      } else {
        print("Status code fail " + response.statusCode.toString());
      }
      return movie;

  }

}