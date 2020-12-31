import 'package:flutter/material.dart';
import '../widgets/CinemaSeatSelector.dart';
import '../models/Movie.dart';
import 'package:flutter/rendering.dart';
import 'SaveTicket.dart';

class CinemaSeatBooker extends StatefulWidget {
  CinemaSeatBooker({Key key, this.movie, this.dateSchedule,this.timeSchedule})
      : super(key: key);
  Movie movie;
  String dateSchedule;
  String timeSchedule;

  @override
  _CinemaSeatBookerState createState() =>
      _CinemaSeatBookerState(this.movie, this.dateSchedule,this.timeSchedule);
}

class _CinemaSeatBookerState extends State<CinemaSeatBooker> {

  _CinemaSeatBookerState(this.movie, this.dateSchedule,this.timeSchedule);
  Movie movie;
  String dateSchedule;
  String timeSchedule;

  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Scaffold(
            appBar: AppBar(
              title: Text("Book Your Seats"),
              centerTitle: true,
            ),
            body: ListView(
                padding: EdgeInsets.symmetric(horizontal: 10),
                children: <Widget>[
                  SizedBox(
                    height: 30,
                  ),
                  //movie title
                  Text(this.movie.title,
                      textAlign: TextAlign.center,
                      overflow: TextOverflow.ellipsis,
                      maxLines: 2,
                      style:
                          TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
                  SizedBox(height: 10),
                  //schedule
                  Text("Schedule Selected",
                      textAlign: TextAlign.center,
                      overflow: TextOverflow.ellipsis,
                      maxLines: 2,
                      style: TextStyle(fontSize: 15, color: Colors.grey)),
                  //
                  SizedBox(height: 10),
                  Text(dateSchedule + " | " + timeSchedule,
                      textAlign: TextAlign.center,
                      overflow: TextOverflow.ellipsis,
                      maxLines: 2,
                      style:
                          TextStyle(fontSize: 15, fontWeight: FontWeight.bold)),
                  SizedBox(height: 10),
                  Container(
                    height: 20,
                    decoration: BoxDecoration(
                        gradient: LinearGradient(
                            colors: [Colors.grey[300], Colors.white],
                            begin: Alignment.topCenter,
                            end: Alignment.bottomCenter)),
                  ),
                  CinemaSelector(movie: this.movie,dateSchedule: this.dateSchedule, timeSchedule: this.timeSchedule,),


                  //
                ])));
  }

}
