import '../models/Movie.dart';
import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import '../views/MovieDetail.dart';

class MovieCard extends StatelessWidget {
  const MovieCard({
    Key key,
    @required Movie movie,
  })  : movie = movie,
        super(key: key);

  final Movie movie;

  String durationToString(int minutes) {
    var d = Duration(minutes:minutes);
    List<String> parts = d.toString().split(':');
    return '${parts[0]}hr ${parts[1]}min';
  }

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: (){
        Navigator.push(context, MaterialPageRoute(builder: (context) => MovieDetail(movie: this.movie)));
      },
      child:Container(
              decoration: BoxDecoration(
                color: Colors.transparent,
                borderRadius: const BorderRadius.only(
                  bottomRight: Radius.circular(5.0),
                  bottomLeft: Radius.circular(5.0),
                  topLeft: Radius.circular(5.0),
                  topRight: Radius.circular(5.0),
                ),

              ),
              margin: EdgeInsets.symmetric(vertical: 10,horizontal: 10),
              width: MediaQuery.of(context).size.width *0.9,
              child: Column(
                mainAxisSize: MainAxisSize.max,
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: <Widget>[
                  Container(
                    margin: EdgeInsets.only(bottom: 10),
                    height: MediaQuery.of(context).size.height *0.25,
                    decoration: BoxDecoration(
                      borderRadius:
                      BorderRadius.vertical(top: Radius.circular(5)),
                    ),
                    child: ClipRRect(
                        borderRadius:
                        BorderRadius.vertical(top: Radius.circular(5)),
                        child: FittedBox(
                          child: CachedNetworkImage(
                            imageUrl: movie.image,
                            errorWidget: (context, url, error) =>
                                Icon(Icons.error, size: 18),
                          ),
                          fit: BoxFit.cover,
                        )),
                  ),
                  Container(
                      decoration: BoxDecoration(
                        color: Colors.transparent
                      ),
                      padding: EdgeInsets.symmetric(horizontal: 3),
                      child:   Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children : <Widget>[Text(
                          this.movie.title,
                          textAlign: TextAlign.start,
                          overflow: TextOverflow.ellipsis,
                          maxLines: 2,
                          style: TextStyle(
                              fontSize: 12, fontWeight: FontWeight.bold)),
                        Text(
                            durationToString(movie.runningTimeInMinutes),
                            textAlign: TextAlign.start,
                            overflow: TextOverflow.ellipsis,
                            maxLines: 2,
                            style: TextStyle(
                                fontSize: 10,fontWeight: FontWeight.normal))
                      ])),
                ],
              ),
            ));
  }
}
