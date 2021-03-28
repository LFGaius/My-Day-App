import 'package:dots_indicator/dots_indicator.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:localize_and_translate/localize_and_translate.dart';
import 'package:my_day_app/configs/config_datas.dart';
import 'package:my_day_app/widgets/onboarding_slide.dart';
import 'package:sembast/sembast.dart';

class OnboardingScreen extends StatefulWidget {
  final Database database;

  const OnboardingScreen({Key key, this.database}) : super(key: key);

  @override
  _OnboardingScreenState createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  final int numpages=2;
  final PageController pagecontroller=PageController(initialPage: 0);
  int currentpage=0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body:Container(
          color: Colors.white,
          child: Padding(
              padding: EdgeInsets.only(top:MediaQuery.of(context).size.height*0.1),
              child:Column(
                  children:[
                    Container(
                      height:MediaQuery.of(context).size.height*0.7,
                      child:PageView(
                          physics: ClampingScrollPhysics(),
                          controller:pagecontroller,
                          onPageChanged: (int page) {
                            setState(() {
                              currentpage=page;
                            });
                          },
                          children:[
                            OnboardingSlide(
                              imagepath: 'assets/onboardillust1.png',
                              message: translator.translate('onboardMsg1'),
                            ),
                            OnboardingSlide(
                              imagepath: 'assets/onboardillust2.png',
                              message: translator.translate('onboardMsg2'),
                            )
                          ]
                      ),
                    ),
                    Container(
                      height: MediaQuery.of(context).size.height*0.1,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: <Widget>[
                          DotsIndicator(
                              dotsCount: numpages,
                              position: currentpage.toDouble(),
                              decorator:DotsDecorator(
                                  color: ConfigDatas.appBlueColorDotDeactivated,
                                  activeColor: ConfigDatas.appBlueColor,
                                  size: Size.fromRadius(17),
                                  activeSize:Size.fromRadius(17)
                              )
                          )
                        ],
                      ),
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        TextButton(
                          child: Text(
                            (currentpage==numpages-1)?translator.translate('getStarted'):translator.translate('skip'),
                            style: TextStyle(
                              fontWeight:FontWeight.bold,
                              fontSize: 23,
                              color: ConfigDatas.appBlueColor
                            ),
                          ),
                          onPressed: () {
                            Navigator.of(context).popAndPushNamed(
                                '/home',
                                arguments:{'database':widget.database}
                            );
                          },
                        )
                      ],
                    ),
                  ]
              )
          ),
        )
    );
  }

}

