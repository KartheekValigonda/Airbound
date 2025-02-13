import 'package:airbound/common%20widgets/infocard.dart';
import 'package:flutter/material.dart';

class Progress extends StatefulWidget {
  @override
  _ProgressState createState() => _ProgressState();
}

class _ProgressState extends State<Progress> {
  int smokedToday = 0;

  void increment() {
    setState(() {
      smokedToday++;
    });
  }

  void decrement() {
    if (smokedToday > 0) {
      setState(() {
        smokedToday--;
      });
    }
  }

  @override
  Widget build(BuildContext context) {

    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      appBar: AppBar(
        title: Text("Track and Crack",style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),),
        backgroundColor: Color(0xFF006A67),
        centerTitle: true,
      ),
      backgroundColor: Colors.grey[300],
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: screenWidth*0.06,vertical: screenHeight*0.03 ),
        child: SingleChildScrollView(
          physics: BouncingScrollPhysics(),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Last smoked info
              Text(
                "You last smoked: 20 days, 20 hours and 43 mins ago",
                style: TextStyle(fontSize: 18, color: Colors.teal),
              ),
              SizedBox(height: screenHeight*0.02),
          
              // Cigarette Counter
              Center(
                child: Container(
                  padding: EdgeInsets.symmetric(horizontal: screenWidth*0.02,vertical:screenHeight*0.02 ),
                  decoration: BoxDecoration(
                    color: Colors.orange[50],
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      IconButton(
                        icon: Icon(Icons.remove_circle, size: 32, color: Colors.grey),
                        onPressed: decrement,
                      ),
                      Text(
                        "$smokedToday",
                        style: TextStyle(fontSize: 32, fontWeight: FontWeight.bold, color: Colors.orange),
                      ),
                      IconButton(
                        icon: Icon(Icons.add_circle, size: 32, color: Colors.orange),
                        onPressed: increment,
                      ),
                    ],
                  ),
                ),
              ),
              SizedBox(height: screenHeight*0.03),

              Text("Since you joined", style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
              SizedBox(height: screenHeight*0.01),
              // Stats Cards
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  infoCard("₹0", "Misspend", Icons.attach_money, screenWidth*0.4),
                  infoCard("0", "cigs smoked", Icons.smoke_free, screenWidth*0.4),
                ],
              ),
              SizedBox(height: screenHeight*0.015),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  infoCard("<0 hrs", "life reduced", Icons.favorite, screenWidth*0.4),
                  infoCard("0 mg", "Nicotine Consumed", Icons.bubble_chart, screenWidth*0.4),
                ],
              ),
              SizedBox(height: screenHeight*0.025),
              _sinceYouJoined(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _sinceYouJoined() {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;
    return Container(
      padding: EdgeInsets.symmetric(horizontal: screenWidth*0.05,vertical:screenHeight*0.02 ),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [BoxShadow(color: Colors.grey.shade200, blurRadius: 4)],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            physics: BouncingScrollPhysics(),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                _infoCardSmall("Doc", "Days Tacked", Icons.list),
                SizedBox(width: screenWidth*0.05,),
                _infoCardSmall("Doc", "Cigarettes Smoked", Icons.list),
                SizedBox(width: screenWidth*0.05,),
                _infoCardSmall("Doc", "Cigarettes Smoked", Icons.list),
              ],
            ),
          ),
        ],
      ),
    );
  }
  Widget _infoCardSmall(String value, String label, IconData icon) {

    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;

    return Container(
      width: screenWidth*0.5,
      height: screenHeight*0.3,
      padding: EdgeInsets.symmetric(horizontal: screenWidth*0.02,vertical: screenHeight*0.02),
      decoration: BoxDecoration(
        color: Colors.grey[100],
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        children: [
          Icon(icon, color: Colors.teal, size: 28),
          SizedBox(height: 5),
          Text(value, style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
          SizedBox(height: 3),
          Text(label, style: TextStyle(fontSize: 14, color: Colors.grey)),
        ],
      ),
    );
  }
}
