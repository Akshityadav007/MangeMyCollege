import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class Attendance extends StatefulWidget {
  @override
  _AttendanceState createState() => _AttendanceState();
}

class _AttendanceState extends State<Attendance> {
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
  int _attendedLectures;
  int _totalLectures;

  double percentage(int _attendLectures, int _ttlLectures) {
    double percent = (_attendLectures) / (_ttlLectures) * 100;
    double attendance = double.parse((percent).toStringAsFixed(2));
    return (attendance);
  }

  int lecturesToAttend(int _lecturesAttended, int _allLectures) {
    int lectures = 0;
    double z = 0.75 * _allLectures;
    int l = (z.ceil()).toInt();
    if (_lecturesAttended < l) {
      lectures = (((z - _lecturesAttended) / 0.25).ceil()).toInt();
    } else {
      lectures = 0;
    }
    return lectures;
  }

  @override
  Widget build(BuildContext context) {
    final data = MediaQuery.of(context).size;
    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        leading: IconButton(
            icon: Icon(Icons.arrow_back),
            onPressed: () => Navigator.pop(context)),
        title: Text('Attendance'),
        centerTitle: true,
        actions: <Widget>[
          Hero(
            tag: 'mark',
            child: CircleAvatar(
              radius: 21,
              child: ClipOval(
                child: Image.asset(
                  'assets/images/attendance.png',
                ),
              ),
              backgroundColor: Color(0xffDAF7A6),
            ),
          ),
          SizedBox(
            width: 10,
          )
        ],
      ),
      body: Container(
        height: data.height,
        width: data.width,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: <Widget>[
            SizedBox(
              height: 20,
            ),
            Flexible(
              flex: 1,
              fit: FlexFit.tight,
              child: SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Container(
                  child: DataTable(columns: [
                    DataColumn(
                      label: Text(
                        'Attended Lectures',
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                    ),
                    DataColumn(
                      label: Text(
                        'Total Lectures',
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                    )
                  ], rows: [
                    DataRow(cells: [
                      DataCell(
                        Row(
                          children: <Widget>[
                            IconButton(
                                icon: Icon(
                                  Icons.remove,
                                  size: 15,
                                ),
                                onPressed: () {
                                  setState(() {
                                    _attendedLectures--;
                                  });
                                }),
                            Text(
                              '$_attendedLectures',
                              style: TextStyle(fontSize: 20),
                            ),
                            IconButton(
                                icon: Icon(
                                  Icons.add,
                                  size: 20,
                                ),
                                onPressed: () {
                                  setState(() {
                                    _attendedLectures++;
                                  });
                                }),
                          ],
                        ),
                      ),
                      DataCell(
                        Row(
                          children: <Widget>[
                            IconButton(
                                icon: Icon(
                                  Icons.remove,
                                  size: 20,
                                ),
                                onPressed: () {
                                  setState(() {
                                    _totalLectures--;
                                  });
                                }),
                            Text(
                              '$_totalLectures',
                              style: TextStyle(fontSize: 20),
                            ),
                            IconButton(
                                icon: Icon(
                                  Icons.add,
                                  size: 20,
                                ),
                                onPressed: () {
                                  setState(() {
                                    _totalLectures++;
                                  });
                                }),
                          ],
                        ),
                      ),
                    ])
                  ]),
                ),
              ),
            ),
            SizedBox(
              height: 10,
            ),
            Flexible(
              flex: 2,
              child: (percentage(_attendedLectures, _totalLectures) >= 75)
                  ? Hero(
                      tag: 'dash',
                      child: Icon(
                        Icons.check,
                        size: 300,
                        color: Colors.green,
                      ),
                    )
                  : Hero(
                      tag: 'dash',
                      child: Icon(
                        Icons.cancel,
                        color: Colors.red,
                        size: 300,
                      ),
                    ),
            ),
            Flexible(
              flex: 1,
              child: Container(
                margin: EdgeInsets.symmetric(horizontal: 15),
                child: (percentage(_attendedLectures, _totalLectures) >= 75)
                    ? Text(
                        'Congratulations! Your attendance is ${percentage(_attendedLectures, _totalLectures)} %')
                    : Text(
                        'Your attendance is ${percentage(_attendedLectures, _totalLectures)} % and you need to attend ${lecturesToAttend(_attendedLectures, _totalLectures)} lectures more.'),
              ),
            ),
            SizedBox(
              height: 5,
            ),
            Text(
              "Note: The predicted lectures are based upon the data provided",
              style: TextStyle(
                  fontSize: 10,
                  fontStyle: FontStyle.italic,
                  color: Colors.green),
            )
          ],
        ),
      ),
    );
  }
}
