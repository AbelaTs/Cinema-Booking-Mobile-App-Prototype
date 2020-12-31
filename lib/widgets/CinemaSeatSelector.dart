import '../models/Movie.dart';
import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import '../views/MovieDetail.dart';
import '../views/SaveTicket.dart';

class CinemaSelector extends StatefulWidget {
  CinemaSelector({this.movie,this.dateSchedule,this.timeSchedule});
  Movie movie;
  String dateSchedule;
  String timeSchedule;

  @override
  _CinemaSelectorState createState() => _CinemaSelectorState(this.movie,this.dateSchedule,this.timeSchedule);
}

class _CinemaSelectorState extends State<CinemaSelector> {
  _CinemaSelectorState(this.movie,this.dateSchedule,this.timeSchedule);
  Movie movie;
  String dateSchedule;
  String timeSchedule;
  List<String> seatsBooked = new List();
  int seats = 0;
  bool seatEmpty = false;

  @override
  Widget build(BuildContext context) {
    return Container(
        // /margin: EdgeInsets.symmetric(horizontal: 15),
        width: MediaQuery.of(context).size.width * 0.95,
        height: MediaQuery.of(context).size.height * 0.65,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text("Hall 1 : Block A",
                textAlign: TextAlign.start,
                overflow: TextOverflow.ellipsis,
                maxLines: 2,
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            SizedBox(height: 10),
            Text("Tap on your preference",
                textAlign: TextAlign.start,
                overflow: TextOverflow.ellipsis,
                maxLines: 2,
                style: TextStyle(fontSize: 13, color: Colors.grey)),
            SizedBox(height: 20),
            //sit generator
            sitGenerator(),
            Container(
                height: 25,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    sitDescription("",false, "Available"),
                    SizedBox(width: 10),
                    sitDescription("",true, "Booked"),
                    SizedBox(width: 10),
                    sitDescription("SS",false, "Your selection")
                  ],
                )),
            quantitySelector(context),
            seatEmpty ?  Text("*Select your seat please", style: TextStyle(color: Colors.red)) : Text(""),
            SizedBox(height: 10),
            InkWell(
                onTap: () {
                  if(seats > 0) {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) =>
                                SaveTicket(movie: this.movie,
                                    dateSchedule: this.dateSchedule,
                                    timeSchedule: this.timeSchedule,
                                    cinemaHall: "A",
                                    seat: this.seatsBooked.join(","))));
                  }else{
                    setState(() {
                      seatEmpty = true;
                    });
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
                ))
          ],
        ));
  }

  // sit generator
  sitGenerator() {
    int row = 65;
    return Expanded(
        child: ListView.builder(
          padding: EdgeInsets.only(left: MediaQuery.of(context).size.width * 0.08),
            scrollDirection: Axis.vertical,
            primary: false,
            physics: NeverScrollableScrollPhysics(),
            itemCount: 10,
            itemBuilder: (BuildContext context, int index) {
              return rowGenerator(index == 9 ? "J" :String.fromCharCode( row + (8 - index)));
            }));
  }

  // cinema sit row generator
  rowGenerator(String rowLetter) {
    return Container(
        height: 25,
        child: ListView(
          scrollDirection: Axis.horizontal,
          children: [
            rowLetter != "J" ? cinemaSeat("",false,rowLetter): cinemaSeat("",false,""),
            rowLetter != "J" ? cinemaSeat(rowLetter + "1",false,"") : cinemaSeat("",false,"1"),
            rowLetter != "J" ? cinemaSeat(rowLetter + "2",false,""): cinemaSeat("",false,"2"),
            rowLetter != "J" ? cinemaSeat(rowLetter + "3",false,""): cinemaSeat("",false,"3"),
            rowLetter != "J" ? cinemaSeat(rowLetter + "4",true,""): cinemaSeat("",false,"4"),
            rowLetter != "J" ? cinemaSeat(rowLetter + "5",false,""): cinemaSeat("",false,"5"),
            rowLetter != "J" ? cinemaSeat(rowLetter + "6",true,""): cinemaSeat("",false,"6"),
            rowLetter != "J" ? cinemaSeat(rowLetter + "7",false,""): cinemaSeat("",false,"7"),
            rowLetter != "J" ?  cinemaSeat(rowLetter + "8",false,""): cinemaSeat("",false,"8"),
            rowLetter != "J" ? cinemaSeat(rowLetter + "9",true,""): cinemaSeat("",false,"9"),
          ],
        ));
  }

  // sit description map
  sitDescription(String seatName, bool booked, String description) {
    return Row(
      children: [
        cinemaSeat( seatName,booked,""),
        SizedBox(width: 3),
        Text(
          description,
          style: TextStyle(fontSize: 13),
        )
      ],
    );
  }

  //Quantity selector
  quantitySelector(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 5, vertical: 20),
      padding: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      width: MediaQuery.of(context).size.width * 0.8,
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey),
        borderRadius: const BorderRadius.all(Radius.circular(30)),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text("Ticket QTY: "),
              SizedBox(width: 10),
              Text(seats.toString()),
              SizedBox(width: 10),

              InkWell(
                onTap: (){
                  if(seats > 0){
                    setState(() {
                      seats -= 1;
                      seatsBooked.removeAt(seatsBooked.length - 1);
                    });
                  }
                },
                child: Icon(Icons.arrow_drop_down),
              )


            ],
          ),
          Container(height: 20, child: VerticalDivider(color: Colors.black)),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text("Total Payable:"),
              SizedBox(width: 10),
              Text((75 * seats).toString() + " Br"),
            ],
          ),
        ],
      ),
    );
  }

  //cinema seat
  cinemaSeat(String seatDetail,bool booked,String sitNum){
    return InkWell(
        onTap: () {
          setState(() {
            if (!booked) {
              if(seatsBooked.contains(seatDetail)){
                seatsBooked.remove(seatDetail);
                seats -= 1;
              }else{
                seatEmpty = false;
                seats += 1;
                seatsBooked.add(seatDetail);
              }
            }
          });
        },
        child: Container(
          margin: EdgeInsets.symmetric(horizontal: 5, vertical: 5),
          width: 20,
          decoration: BoxDecoration(
            color: seatsBooked.contains(seatDetail) || seatDetail == "SS" ? Theme.of(context).primaryColor : booked ? Colors.grey : Colors.white,
            border: sitNum == "" && seatDetail != "" ? Border.all(color: Colors.black54) : Border.all(color: Colors.white),
            borderRadius: const BorderRadius.only(
              topLeft: Radius.circular(5.0),
              topRight: Radius.circular(5.0),
            ),
          ),
          child: Text(sitNum,textAlign: TextAlign.center,),
        ));
  }
}
