import 'package:flutter/material.dart';
import '../models/Movie.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/gestures.dart';
import 'CinemaSitBooker.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';

class MovieDetail extends StatefulWidget {
  MovieDetail({Key key, this.movie}) : super(key: key);
  Movie movie;

  @override
  _MovieDetailState createState() => _MovieDetailState(this.movie);
}

class _MovieDetailState extends State<MovieDetail> {
  Movie movie;
  String dateScheduled;
  bool timeSelected = false;
  bool dateSelected = false;
  String timeScheduled = "";
  bool dateEmpty = false;
  bool timeEmpty = false;
  bool rated = false;

  @override
  void initState() {
    super.initState();
    //var length = reviewProvider.getReviewRepliesLength(review.id);
    //WidgetsBinding.instance.addPostFrameCallback((_) => updateData());
    setState(() {
      dateScheduled = "";
    });
  }

  _MovieDetailState(this.movie);

  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Scaffold(
      appBar: AppBar(
        title: Text(movie.title),
        centerTitle: true,
      ),
      body: ListView(
        padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
        children: <Widget>[
          //top image
          topMovieCard(),
          Column(crossAxisAlignment: CrossAxisAlignment.center, children: <
              Widget>[
            SizedBox(
              height: 10,
            ),
            //movie title
            Text(this.movie.title,
                textAlign: TextAlign.start,
                overflow: TextOverflow.ellipsis,
                maxLines: 2,
                style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
            //rate,time and 3d
            Container(
              margin: EdgeInsets.only(top: 10),
              child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Row(children: <Widget>[
                      Icon(
                        Icons.star_border_outlined,
                        color: Colors.grey,
                      ),
                      SizedBox(width: 5),
                      Text(this.movie.rating.toString())
                    ]),
                    SizedBox(width: MediaQuery.of(context).size.width * 0.1),
                    Row(children: <Widget>[
                      Icon(
                        Icons.access_time,
                        color: Colors.grey,
                      ),
                      SizedBox(width: 5),
                      Text(this.movie.runningTimeInMinutes.toString() + " mins")
                    ]),
                    SizedBox(width: MediaQuery.of(context).size.width * 0.1),
                    Row(children: <Widget>[
                      Icon(
                        Icons.desktop_windows,
                        color: Colors.grey,
                      ),
                      SizedBox(width: 5),
                      Text("3D")
                    ])
                  ]),
            ),
            SizedBox(height: 10),
            RatingBar.builder(
              initialRating: movie.userRating,
              minRating: 0,
              direction: Axis.horizontal,
              allowHalfRating: false,
              itemCount: 5,
              itemPadding: EdgeInsets.symmetric(horizontal: 4.0),
              itemBuilder: (context, _) => Icon(
                rated ?Icons.star :Icons.star_border,
                color: Theme.of(context).primaryColor,
                size: 10,
              ),
              itemSize: 25,

              unratedColor: Colors.grey[300],
              onRatingUpdate: (rating) {
                  if(rating > 0){
                    setState(() {
                      rated = true;
                    });
                  }else{
                    setState(() {
                      rated = false;
                    });
                  }
                  movie.userRating = rating;
              },
            ),
            SizedBox(height: 10),
            Divider(
              color: Colors.grey,
              height: 1,
            ),
            SizedBox(height: 10),
            //
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Text("Synopsis",
                    textAlign: TextAlign.start,
                    overflow: TextOverflow.ellipsis,
                    maxLines: 2,
                    style:
                        TextStyle(fontSize: 15, fontWeight: FontWeight.bold)),
                Row(children: <Widget>[
                  Container(
                    height: 25,
                    padding: EdgeInsets.symmetric(horizontal: 20, vertical: 5),
                    decoration: BoxDecoration(
                        color: Colors.grey[300],
                        borderRadius: BorderRadius.circular(30)),
                    child: Text(
                      movie.genres[0],
                      style: TextStyle(fontSize: 14),
                    ),
                  ),
                  SizedBox(width: 10),
                  Container(
                    height: 25,
                    padding: EdgeInsets.symmetric(horizontal: 20, vertical: 5),
                    decoration: BoxDecoration(
                        color: Colors.grey[300],
                        borderRadius: BorderRadius.circular(30)),
                    child: Text(
                      movie.genres[1],
                      style: TextStyle(fontSize: 14),
                    ),
                  ),
                ])
              ],
            ),
            SizedBox(height: 10),
            // Synopsis
            ExpandableText(movie.summary, trimLines: 6),
            //Calendar
            SizedBox(height: 10),
            Column(crossAxisAlignment: CrossAxisAlignment.start, children: <
                Widget>[
              Text("Date",
                  textAlign: TextAlign.start,
                  overflow: TextOverflow.ellipsis,
                  maxLines: 2,
                  style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold)),
              SizedBox(height: 10),
              Container(
                  height: 85,
                  child: ListView(
                      scrollDirection: Axis.horizontal,
                      children: <Widget>[
                        calendarDayWidget(
                                    date: "1",
                                    day: "Mon",
                                    month: "Jan",
                                  ),
                        SizedBox(width: 10),
                        calendarDayWidget(
                              date: "2",
                              day: "Tue",
                              month: "Jan",
                            ),
                        SizedBox(width: 10),
                        calendarDayWidget(
                              date: "3",
                              day: "Wed",
                              month: "Jan",
                            ),
                        SizedBox(width: 10),
                        calendarDayWidget(
                              date: "4",
                              day: "Thu",
                              month: "Jan",
                            ),
                        SizedBox(width: 10),
                        calendarDayWidget(
                              date: "5",
                              day: "Fri",
                              month: "Jan",
                            ),
                        SizedBox(width: 10),
                        calendarDayWidget(
                              date: "6",
                              day: "Sat",
                              month: "Jan",
                            ),
                        SizedBox(width: 10),
                        calendarDayWidget(
                              date: "7",
                              day: "Sun",
                              month: "Jan",
                            ),
                      ])),
              dateEmpty ?  Text("*Select a date please", style: TextStyle(color: Colors.red)) : Text(""),
            ]),
            //available time
            SizedBox(height: 10),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text("Date",
                    textAlign: TextAlign.start,
                    overflow: TextOverflow.ellipsis,
                    maxLines: 2,
                    style:
                        TextStyle(fontSize: 15, fontWeight: FontWeight.bold)),
                SizedBox(height: 10),
                InkWell(
                    onTap: () {
                      setState(() {
                        timeScheduled = timeScheduled == "9:30 AM" ? "" : "9:30 AM";
                        timeEmpty = timeScheduled == "" ? true : false;
                      });
                    },
                    child: Container(
                      padding: EdgeInsets.symmetric(vertical: 10),
                      width: MediaQuery.of(context).size.width * 0.9,
                      decoration: BoxDecoration(
                          color: timeScheduled == "9:30 AM"
                              ? Theme.of(context).primaryColor
                              : Colors.white,
                          border: Border.all(color: Colors.black26),
                          borderRadius: BorderRadius.all(Radius.circular(5))),
                      child: Text(
                        "9:30 AM (Available)",
                        textAlign: TextAlign.center,
                        style: TextStyle(
                            color: timeScheduled == "9:30 AM"
                                 ? Colors.white : Colors.black),
                      ),
                    )),
                SizedBox(height: 10),
                InkWell(
                    child: Container(
                  padding: EdgeInsets.symmetric(vertical: 10),
                  width: MediaQuery.of(context).size.width * 0.9,
                  decoration: BoxDecoration(
                      border: Border.all(color: Colors.black26),
                      borderRadius: BorderRadius.all(Radius.circular(5))),
                  child: Text(
                    "12:30 AM (Not - Available)",
                    textAlign: TextAlign.center,
                  ),
                )),
                SizedBox(height: 10),
                InkWell(
                    child: Container(
                  padding: EdgeInsets.symmetric(vertical: 10),
                  width: MediaQuery.of(context).size.width * 0.9,
                  decoration: BoxDecoration(
                      border: Border.all(color: Colors.black26),
                      borderRadius: BorderRadius.all(Radius.circular(5))),
                  child: Text(
                    "3:30 PM (Not - Available)",
                    textAlign: TextAlign.center,
                  ),
                )),
                SizedBox(height: 10),
                InkWell(
                    child: Container(
                  padding: EdgeInsets.symmetric(vertical: 10),
                  width: MediaQuery.of(context).size.width * 0.9,
                  decoration: BoxDecoration(
                      border: Border.all(color: Colors.black26),
                      borderRadius: BorderRadius.all(Radius.circular(5))),
                  child: Text(
                    "8:40 PM (Not - Available)",
                    textAlign: TextAlign.center,
                  ),
                ))
              ],
            ),
            timeEmpty ?  Text("*Select a time please", style: TextStyle(color: Colors.red)) : Text(""),
            SizedBox(height: 25),
            //Continue button
            InkWell(
                onTap: () {
                  if(dateScheduled != "" && timeScheduled != "") {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) =>
                                CinemaSeatBooker(movie: this.movie, dateSchedule: dateScheduled, timeSchedule: timeScheduled)));
                  }else{
                    if(dateScheduled == ""){
                      setState(() {
                        dateEmpty = true;
                      });
                    }
                    if(timeScheduled == ""){
                      setState(() {
                        timeEmpty = true;
                      });
                    }
                  }
                },
                child: Container(
                  padding: EdgeInsets.symmetric(vertical: 10),
                  width: MediaQuery.of(context).size.width * 0.9,
                  decoration: BoxDecoration(
                      color: Theme.of(context).primaryColor,
                      border: Border.all(color: Colors.black26),
                      borderRadius: BorderRadius.all(Radius.circular(5))),
                  child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: <Widget>[
                        Text("Continue to seat Selector",
                            textAlign: TextAlign.center,
                            style: TextStyle(color: Colors.white)),
                        Icon(Icons.chevron_right, color: Colors.white)
                      ]),
                )),
            SizedBox(height: 10),
            //
          ])
        ],
      ),
    ));
  }

  //movie image builder
  topMovieCard() {
    return Container(
        margin: EdgeInsets.only(bottom: 10, top: 10),
        height: MediaQuery.of(context).size.height * 0.6,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.vertical(top: Radius.circular(15)),
        ),
        child: ClipRRect(
            borderRadius: BorderRadius.vertical(top: Radius.circular(15)),
            child: FittedBox(
              child: CachedNetworkImage(
                imageUrl: movie.image,
                errorWidget: (context, url, error) =>
                    Icon(Icons.error, size: 18),
              ),
              fit: BoxFit.cover,
            )));
  }
  //calendar date widget
  calendarDayWidget({String day, String date, String month}){
    return InkWell(
        onTap: (){
          setState(() {
            if(dateScheduled == day+", " + month +" "+date ){
              dateScheduled = "";
            }else{
              dateScheduled = day+", " + month +" "+date;
              dateEmpty = false;
            }
          });
        },
        child : Column(mainAxisAlignment: MainAxisAlignment.center, children: [
          Container(
            width: 60,
            height: 80,
            decoration: BoxDecoration(
                border: Border.all(color: dateScheduled == day+", " + month +" "+date ? Theme.of(context).primaryColor : Colors.grey[400]),
                borderRadius: BorderRadius.all(Radius.circular(10))),
            child: Column(
              children: [
                Container(
                    width: MediaQuery.of(context).size.width,
                    padding: EdgeInsets.symmetric(vertical: 5, horizontal: 5),
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.only(
                            topLeft: Radius.circular(10),
                            topRight: Radius.circular(10)),
                        color: dateScheduled == day+", " + month +" "+date ? Theme.of(context).primaryColor : Colors.grey[400]),
                    child: Text(day,
                        textAlign: TextAlign.center,
                        style: TextStyle(color: Colors.white))),
                SizedBox(height: 10),
                Text(date,
                    textAlign: TextAlign.center,
                    style: TextStyle(color: Colors.black)),
                Text(month,
                    textAlign: TextAlign.center,
                    style: TextStyle(color: Colors.black))
              ],
            ),
          )
        ]));
  }
}

//Description shrink and expand
class ExpandableText extends StatefulWidget {
  const ExpandableText(
    this.text, {
    Key key,
    this.trimLines = 2,
  })  : assert(text != null),
        super(key: key);

  final String text;
  final int trimLines;

  @override
  ExpandableTextState createState() => ExpandableTextState();
}

class ExpandableTextState extends State<ExpandableText> {
  bool _readMore = true;

  void _onTapLink() {
    setState(() => _readMore = !_readMore);
  }

  @override
  Widget build(BuildContext context) {
    final DefaultTextStyle defaultTextStyle = DefaultTextStyle.of(context);
    final colorClickableText = Colors.blue;
    final widgetColor = Colors.black;
    TextSpan link = TextSpan(
        text: _readMore ? "... Read more" : " Read less",
        style: TextStyle(
          color: colorClickableText,
        ),
        recognizer: TapGestureRecognizer()..onTap = _onTapLink);
    Widget result = LayoutBuilder(
      builder: (BuildContext context, BoxConstraints constraints) {
        assert(constraints.hasBoundedWidth);
        final double maxWidth = constraints.maxWidth;
        // Create a TextSpan with data
        final text = TextSpan(
          text: widget.text,
        );
        // Layout and measure link
        TextPainter textPainter = TextPainter(
          text: link,
          textDirection: TextDirection.rtl,
          //better to pass this from master widget if ltr and rtl both supported
          maxLines: widget.trimLines,
          ellipsis: '...',
        );
        textPainter.layout(minWidth: constraints.minWidth, maxWidth: maxWidth);
        final linkSize = textPainter.size;
        // Layout and measure text
        textPainter.text = text;
        textPainter.layout(minWidth: constraints.minWidth, maxWidth: maxWidth);
        final textSize = textPainter.size;
        // Get the endIndex of data
        int endIndex;
        final pos = textPainter.getPositionForOffset(Offset(
          textSize.width - linkSize.width,
          textSize.height,
        ));
        endIndex = textPainter.getOffsetBefore(pos.offset);
        var textSpan;
        if (textPainter.didExceedMaxLines) {
          textSpan = TextSpan(
            text: _readMore ? widget.text.substring(0, endIndex) : widget.text,
            style: TextStyle(
              color: widgetColor,
            ),
            children: <TextSpan>[link],
          );
        } else {
          textSpan = TextSpan(
            text: widget.text,
            style: TextStyle(
              color: widgetColor,
            ),
          );
        }
        return RichText(
          softWrap: true,
          overflow: TextOverflow.clip,
          text: textSpan,
        );
      },
    );
    return result;
  }
}
