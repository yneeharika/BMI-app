// ignore_for_file: dead_code

import 'dart:ffi'; 
import 'package:flutter/material.dart';
import 'package:swipeable_button_view/swipeable_button_view.dart';
import 'package:your_bmi_app/ageweight.dart';
import 'package:your_bmi_app/gender.dart';
import 'package:your_bmi_app/height.dart';
import 'dart:math';
import 'package:your_bmi_app/scorescreen.dart';
import 'package:page_transition/page_transition.dart';
class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _gender = 0;
  int _height = 150;
  int _age = 30;
  int _weight =50;
  bool _isFinished = false;
  double _bmiScore = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blue,
        centerTitle: true,
        title: const Text('BMI CALCULATOR'),
      ),
      body: SingleChildScrollView(
        child: Container(
          padding: const EdgeInsets.all(12),
          child: Card(
            elevation: 12,
            shape: const RoundedRectangleBorder(),
            child: Column(
              children: [
                GenderWidget(
                  onChange: (genderval) {
                    setState(() {
                      _gender = genderval;
                    });
                  },
                ),
                HeightWidget(
                  onChange: (heightval){
                    setState(() {
                      _height=heightval;
                    });
                  },
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    AgeWeightWidget(onChange:(ageval){
                      setState(() {
                        _age = ageval;
                      });
                    }, title: "Age", initValue: 30, min: 0, max: 100),
                    AgeWeightWidget(onChange:(weightval){
                      setState(() {
                        _weight = weightval;
                      });
                    }, title: "Weight(kg)", initValue: 50, min: 0, max: 200),
                  ],
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 20,horizontal:60 ),
                  child: SwipeableButtonView(
                    isFinished:  _isFinished,
                    onFinish: ()   async {
                          await Navigator.push(
                              context,
                              PageTransition(
                                  child: ScoreScreen(
                                    bmiScore: _bmiScore,
                                    age: _age,
                                  ),
                                  type: PageTransitionType.fade));
                       setState(() {
                        _isFinished=false;
                      });
                    },
                   onWaitingProcess: (){
                     calculateBmi(); // Call calculateBmi here
                     Future.delayed(Duration(seconds: 1),(){
                       setState(() {
                         _isFinished=true;
                       });
                     });
                   },
                    activeColor: Colors.blue,
                     buttonWidget: const Icon(Icons.arrow_forward_ios_rounded,
                     color: Colors.black,
                     ),
                      buttonText: "CALCULATE"),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }

  void calculateBmi() {
    _bmiScore = _weight / pow(_height / 100, 2);
  }
}
