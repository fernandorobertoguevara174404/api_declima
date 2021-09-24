import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Reporte meteorológico',
      theme: ThemeData(
        primarySwatch: Colors.green,
      ),
      home: MyHomePage(title: 'Reporte meteorológico'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key? key, required this.title}) : super(key: key);

  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  List _weatherList = [];

  void _callAPI() async {
    dynamic data = await http.read(Uri.parse(
        'https://www.7timer.info/bin/civillight.php?lon=-97.8610&lat=22.2331&ac=0&unit=metric&output=json&tzshift=0'));
    dynamic dic = jsonDecode(data);
    setState(() {
      _weatherList = dic["dataseries"];
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: ListView.builder(
          itemCount: _weatherList.length,
          itemBuilder: (context, index) {
            dynamic weather = _weatherList[index];
            dynamic weatherIcon = ((){
              switch(weather['weather']){
                case 'cloudy':
                case 'pcloudy':
                case 'mcloudy':
                  return Icons.wb_cloudy_outlined;
                case 'rain':
                case 'lightrain':
                case 'ishower':
                  return Icons.water;
                case 'clear':
                case 'ts':
                  return Icons.wb_sunny_outlined;
                default:
                  return Icons.cancel;
              }
            })();
            String weathertype = weather['weather'];
            DateTime date = DateTime.parse(weather['date'].toString());
            int max = weather['temp2m']['max'];
            int min = weather['temp2m']['min'];

            return ListTile(title: Row(
              children: <Widget>[
                Row(
                  children: [
                    Text("${date.day}/${date.month}/${date.year}",style: TextStyle(fontSize: 14.0),),
                    SizedBox(width: 15),
                  ],
                )
                ,
                Row(
                  children: [
                    Text("Max:$max°C",style: TextStyle(fontSize: 14.0)),
                    SizedBox(width: 15),
                    Text("Min:$min°C",style: TextStyle(fontSize: 14.0))
                  ],
                ),
                Row(
                  children: [
                    SizedBox(width: 15),
                    Icon(weatherIcon),
                    SizedBox(width: 15),
                    Text(weathertype, style: TextStyle(fontSize: 14.0),),
                  ],
                )
              ],
            ));
          }),
      floatingActionButton: FloatingActionButton(
        onPressed: _callAPI,
        tooltip: 'Increment',
        child: Icon(Icons.wb_sunny),
      ), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }
}