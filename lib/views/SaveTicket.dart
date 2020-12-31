import 'package:flutter/material.dart';
import '../models/Movie.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/gestures.dart';
import 'dart:io';
import 'package:image_gallery_saver/image_gallery_saver.dart';
import 'package:screenshot/screenshot.dart';
import '../main.dart';

class SaveTicket extends StatefulWidget {
  SaveTicket({this.movie,this.dateSchedule,this.timeSchedule,this.cinemaHall,this.seat});
  Movie movie;
  String dateSchedule;
  String timeSchedule;
  String cinemaHall;
  String seat;


  @override
  _SaveTicketState createState() => _SaveTicketState(this.movie,this.dateSchedule,this.timeSchedule,this.cinemaHall,this.seat);
}

class _SaveTicketState extends State<SaveTicket> {
  Movie movie;
  String dateSchedule;
  String timeSchedule;
  String cinemaHall;
  String seat;
  ScreenshotController screenshotController = ScreenshotController();
  File _imageFile;
  bool saveProgress = false;
  bool savedSuccessfully = false;


  _SaveTicketState(this.movie,this.dateSchedule,this.timeSchedule,this.cinemaHall,this.seat);

  @override
  Widget build(BuildContext context) {
    return  SafeArea(
        child:  Screenshot(
        controller: screenshotController,
        child: Scaffold(
      appBar: AppBar(
        title: Text("Confirm Your Ticket"),
        centerTitle: true,
      ),
      body: ListView(
        padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
        children: <Widget>[
          Text("Cinema Ticket",
              textAlign: TextAlign.center,
              overflow: TextOverflow.ellipsis,
              maxLines: 2,
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
          Divider(
            color: Colors.black,
            height: 20,
            indent: MediaQuery.of(context).size.width * 0.25,
            endIndent: MediaQuery.of(context).size.width * 0.25,
          ),
          Text(this.movie.title,
              textAlign: TextAlign.center,
              overflow: TextOverflow.ellipsis,
              maxLines: 2,
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
          //QR Code
          topMovieCard(),
          //ticket details
          Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                SizedBox(
                  height: 10,
                ),
                //movie title
                Divider(color: Colors.grey),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "Date",
                              style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: Theme.of(context).primaryColor),
                            ),
                            Text(dateSchedule)
                          ],
                        ),
                        SizedBox(height: 20),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text("Cinema Hall",
                                style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    color: Theme.of(context).primaryColor)),
                            Text(cinemaHall)
                          ],
                        )
                      ],
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text("Time",
                                style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    color: Theme.of(context).primaryColor)),
                            Text(timeSchedule)
                          ],
                        ),
                        SizedBox(height: 20),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text("Seat",
                                style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    color: Theme.of(context).primaryColor)),
                            Text(seat)
                          ],
                        )
                      ],
                    )
                  ],
                ),
                Divider(color: Colors.grey),
                Align(
                    alignment: Alignment.centerLeft,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        SizedBox(height: 10),
                        Text(
                          "Note",
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                        Text("1.Keep this receipt safe and secret",
                            style: TextStyle(fontWeight: FontWeight.bold)),
                        Text("2.Don't share or duplicate this receipt",
                            style: TextStyle(fontWeight: FontWeight.bold)),
                        Text("3.The above code is valid for only one use",
                            style: TextStyle(fontWeight: FontWeight.bold)),
                        SizedBox(height: 10),
                      ],
                    )),
                SizedBox(height: 10),
                InkWell(
                    onTap: () async{
                      setState(() {
                        saveProgress = true;
                      });
                      //taking screenshot
                      _imageFile = null;
                      screenshotController
                          .capture(delay: Duration(milliseconds: 10))
                          .then((File image) async {
                        setState(() {
                          _imageFile = image;
                        });
                        await ImageGallerySaver.saveImage(image.readAsBytesSync());
                        setState(() {
                          savedSuccessfully = true;
                        });
                        //going to main page after saving
                        Navigator.push(
                            context,MaterialPageRoute(
                            builder: (context) =>
                                MyApp()));
                      }).catchError((onError) {
                        print(onError);
                      });
                      setState(() {
                        saveProgress = false;
                      });
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
                            saveProgress ? CircularProgressIndicator() :Text(savedSuccessfully ? "Saved" :"Save Ticket",
                                textAlign: TextAlign.center,
                                style: TextStyle(color: Colors.white)),
                            Icon(Icons.chevron_right, color: Colors.white)
                          ]),
                    ))
                //
              ])
        ],
      ),
    )));
  }

  //movie image builder
  topMovieCard() {
    return Container(
        margin: EdgeInsets.only(bottom: 10, top: 10),
        height: MediaQuery.of(context).size.height * 0.4,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.vertical(top: Radius.circular(15)),
        ),
        child: ClipRRect(
            borderRadius: BorderRadius.vertical(top: Radius.circular(15)),
            child: FittedBox(
              child: Image.asset(
                 "assets/images/movie_qr.png"
              ),
              fit: BoxFit.cover,
            )));
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
