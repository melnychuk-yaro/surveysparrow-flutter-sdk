import 'package:flutter/material.dart';
import 'package:surveysparrow_flutter_sdk/components/common/questionColumn.dart';

import '../common/skipAndNext.dart';
import 'package:sizer/sizer.dart';

class ColumnOpnionScale extends StatefulWidget {
  final Function func;
  final Map<dynamic, dynamic> answer;
  final Map<dynamic, dynamic> question;
  final Map<dynamic, dynamic> theme;
  final Map<String, String> customParams;
  final int currentQuestionNumber;
  final bool isLastQuestion;
  final Function submitData;
  final Map<dynamic, dynamic>? euiTheme;

  const ColumnOpnionScale({
    Key? key,
    required this.func,
    required this.answer,
    required this.question,
    required this.theme,
    required this.customParams,
    required this.currentQuestionNumber,
    required this.isLastQuestion,
    required this.submitData,
    this.euiTheme,
  }) : super(key: key);

  @override
  State<ColumnOpnionScale> createState() => _ColumnOpnionScaleState(
      func: this.func,
      answer: this.answer,
      question: question,
      theme: this.theme,
      customParams: this.customParams,
      currentQuestionNumber: currentQuestionNumber);
}

class _ColumnOpnionScaleState extends State<ColumnOpnionScale> {
  Function func;
  final Map<dynamic, dynamic> answer;
  final Map<dynamic, dynamic> question;
  final Map<dynamic, dynamic> theme;
  final Map<String, String> customParams;
  final int currentQuestionNumber;
  var _selectedOption = -1;

  _ColumnOpnionScaleState({
    required this.func,
    required this.answer,
    required this.question,
    required this.theme,
    required this.customParams,
    required this.currentQuestionNumber,
  });

  setSelectedOption(val) {
    setState(() {
      _selectedOption = val;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        QuestionColumn(
          question: question,
          currentQuestionNumber: this.currentQuestionNumber,
          customParams: this.customParams,
          theme: this.theme,
          euiTheme: this.widget.euiTheme,
        ),
        // SizedBox(height: 40),
        SizedBox(height: 2.h),
        // SizedBox(height: 40),
        OpnionScaleQuestion(
          func: this.func,
          answer: this.answer,
          question: this.question,
          theme: this.theme,
          setSelectedOption: setSelectedOption,
          euiTheme: this.widget.euiTheme,
        ),
        SizedBox(height: 7.h),
        // SizedBox(height: 40),
        SkipAndNextButtons(
          key: UniqueKey(),
          disabled: _selectedOption == -1,
          showNext: this.widget.isLastQuestion,
          showSkip: (this.question['required'] || this.widget.isLastQuestion)
              ? false
              : true,
          showSubmit: this.widget.isLastQuestion,
          onClickSkip: () {
            this.func(null, question['id']);
          },
          onClickNext: () {
            // this.widget.submitData();
            if (_selectedOption != -1) {
              this.widget.submitData();
            }
          },
          theme: this.theme,
          euiTheme: this.widget.euiTheme,
        ),
      ],
    );
  }
}

class OpnionScaleQuestion extends StatefulWidget {
  final Function func;
  final Map<dynamic, dynamic> answer;
  final Map<dynamic, dynamic> question;
  final Map<dynamic, dynamic> theme;
  final Function setSelectedOption;
  final Map<dynamic, dynamic>? euiTheme;

  const OpnionScaleQuestion({
    Key? key,
    required this.func,
    required this.answer,
    required this.question,
    required this.theme,
    required this.setSelectedOption,
    this.euiTheme,
  }) : super(key: key);

  @override
  State<OpnionScaleQuestion> createState() => _OpnionScaleQuestionState(
      func: this.func,
      answer: this.answer,
      question: this.question,
      theme: this.theme);
}

class _OpnionScaleQuestionState extends State<OpnionScaleQuestion> {
  Function func;
  final Map<dynamic, dynamic> answer;
  final Map<dynamic, dynamic> question;
  final Map<dynamic, dynamic> theme;
  var _start;
  var _mid;
  var _end;
  var _step;
  var luminanceValue = 0.5;
  var reversedOrder = false;
  var startLabel;
  var midLabel;
  var endLabel;

  var runSpacing = 5.0;
  var positionedLabelTopValue = -8.0;

  int _selectedOption = -1;
  _OpnionScaleQuestionState({
    required this.func,
    required this.answer,
    required this.question,
    required this.theme,
  });

  updateOpnionScale(val) {
    this.widget.setSelectedOption(val);
    setState(() {
      _selectedOption = val;
    });
    this.func(val, question['id']);
  }

  generateStartStep(step, start) {
    _start = start;
    var totalOptions = start == 0 ? step + 1 : step;

    _mid = totalOptions % 2 == 0 ? -1 : ((start == 0 ? totalOptions - 1 : totalOptions) / 2).ceil();
    _end = step;

    _step = start == 0 ? step + 1 : step;
  }

  var customFont = null ;

  var opnionBlockSizeWidth = 48.0;
  var opnionBlockSizeHeight = 60.0;

  var innerOpnionBlockSizeWidth = 40.0;
  var innerOpnionBlockSizeHeight = 40.0;

  var opnionLabelFontSize = 12.0;
  var numberFontSize = 13.0;

  @override
  initState() {
    super.initState();

     if(this.widget.euiTheme != null){
      if(this.widget.euiTheme!['font'] != null){
        customFont = this.widget.euiTheme!['font'];
      }

      if(this.widget.euiTheme!['opnionScale'] != null){
        if(this.widget.euiTheme!['opnionScale']['outerBlockSizeWidth'] != null ){
          opnionBlockSizeWidth = this.widget.euiTheme!['opnionScale']['outerBlockSizeWidth'];
        }
        if(this.widget.euiTheme!['opnionScale']['outerBlockSizeHeight'] != null ){
          opnionBlockSizeHeight = this.widget.euiTheme!['opnionScale']['outerBlockSizeHeight'];
        }

        if(this.widget.euiTheme!['opnionScale']['innerBlockSizeWidth'] != null ){
          innerOpnionBlockSizeWidth = this.widget.euiTheme!['opnionScale']['innerBlockSizeWidth'];
        }
        if(this.widget.euiTheme!['opnionScale']['innerBlockSizeHeight'] != null ){
          innerOpnionBlockSizeHeight = this.widget.euiTheme!['opnionScale']['innerBlockSizeHeight'];
        }
        if(this.widget.euiTheme!['opnionScale']['labelFontSize'] != null ){
          opnionLabelFontSize = this.widget.euiTheme!['opnionScale']['labelFontSize'];
        }
        if(this.widget.euiTheme!['opnionScale']['numberFontSize'] != null ){
          numberFontSize = this.widget.euiTheme!['opnionScale']['numberFontSize'];
        }
        if(this.widget.euiTheme!['opnionScale']['runSpacing'] != null ){
          runSpacing = this.widget.euiTheme!['opnionScale']['runSpacing'];
        }
        if(this.widget.euiTheme!['opnionScale']['positionedLabelTopValue'] != null ){
          positionedLabelTopValue = this.widget.euiTheme!['opnionScale']['positionedLabelTopValue'];
        }
      }

    }

    startLabel = this.question['properties']['data']['min'] ==
            'builder.opinion_scale.min'
        ? 'Least Likely'
        : this.question['properties']['data']['min'];
    midLabel = this.question['properties']['data']['mid'] ==
            'builder.opinion_scale.mid'
        ? 'Neutral'
        : this.question['properties']['data']['mid'];
    endLabel = this.question['properties']['data']['max'] ==
            'builder.opinion_scale.max'
        ? 'Most Likely'
        : this.question['properties']['data']['max'];

    luminanceValue =
        this.theme['decodedOpnionBackgroundColorUnSelected'].computeLuminance();

    reversedOrder = this.question['properties']['data']['reversedOrder'];

    this.generateStartStep(this.question['properties']['data']['step'],
        this.question['properties']['data']['start']);

    if (this.answer[this.question['id']] != null) {
      setState(() {
        _selectedOption = this.answer[this.question['id']];
      });
    } else {
      setState(() {
        _selectedOption = -1;
      });
    }
  }

  transformLabel(text){
    var value = text.length > 12 ? '${text.substring(0, 12)}..' : text;
    return value;
  }

  generateOpmionBlock(val, isSelectedOption) {
    return Container(
      width: opnionBlockSizeWidth,
      height: opnionBlockSizeHeight,
      margin:
        _step == 3 ?  val == 0 ? EdgeInsets.only(left: 0.0) : EdgeInsets.only(right: 30.0):null,
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          if (val == _start) ...[
            Positioned(
              top: positionedLabelTopValue,
              left: -1,
              child: Container(
                  child: Text(
                reversedOrder ? transformLabel(endLabel) : transformLabel(startLabel),
                style: TextStyle(
                  decoration: TextDecoration.none,
                  fontSize: opnionLabelFontSize,
                  fontWeight: FontWeight.w400,
                  // overflow: TextOverflow.ellipsis,
                  // color: Color.fromRGBO(67, 67, 67, 1),
                  color: this.theme['decodedOpnionLabelColor'],
                  fontFamily: customFont,
                ),
              )),
            ),
          ]
          // possible style change can be changing the right to -1 and positionedLabelTopValue depending on the width
          else if (val == _mid) ...[
            Positioned(
                top: positionedLabelTopValue,
                left: -1,
                child: Container(
                  child: Text(
                    transformLabel(midLabel),
                    style: TextStyle(
                      decoration: TextDecoration.none,
                      fontSize: opnionLabelFontSize,
                      fontWeight: FontWeight.w400,
                      // color: Color.fromRGBO(67, 67, 67, 1),
                      color: this.theme['decodedOpnionLabelColor'],
                      fontFamily: customFont,
                    ),
                  ),
                )),
          ] else if (val == _end) ...[
            Positioned(
              top: positionedLabelTopValue,
              left: -1,
              child: Container(
                child: Text(
                  reversedOrder ? transformLabel(startLabel) : transformLabel(endLabel),
                  style: TextStyle(
                    decoration: TextDecoration.none,
                    fontSize: opnionLabelFontSize,
                    fontWeight: FontWeight.w400,
                    color: this.theme['decodedOpnionLabelColor'],
                    fontFamily: customFont,
                  ),
                ),
              ),
            ),
          ],
          Center(
            child: Container(
              // color: Color.fromARGB(255, 255, 247, 0),
              width: innerOpnionBlockSizeWidth,
              height: innerOpnionBlockSizeHeight,
              // constraints: BoxConstraints(
              //    maxHeight: 40,maxWidth: 40),
              decoration: BoxDecoration(
                color: isSelectedOption == val
                    ? this.theme['decodedOpnionBackgroundColorSelected']
                    : this.theme['decodedOpnionBackgroundColorUnSelected'],
                border: Border.all(
                  // color: Color.fromRGBO(63, 63, 63, 0.5),
                  color: this.theme['decodedOpnionBorderColor'],
                  width: 1,
                ),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Center(
                child: Text(
                  val.toString(),
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    decoration: TextDecoration.none,
                    fontSize: numberFontSize,
                    fontWeight: FontWeight.bold,
                    color: isSelectedOption == val
                        ? luminanceValue > 0.5
                            ? Colors.black
                            : Colors.white
                        : this.theme['answerColor'],
                    fontFamily: customFont,
                  ),
                ),
              ),
            ),
          )
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    var shortestSide = MediaQuery.of(context).size.shortestSide;
    final bool useMobileLayout = shortestSide < 600;

    List<Widget> list = List<Widget>.empty(growable: true);
    if (reversedOrder) {
      for (var i = _end; i >= _start; i--) {
        list.add(
          GestureDetector(
            onTap: () {
              updateOpnionScale(i);
            },
            child: Container(
              child: generateOpmionBlock(i, _selectedOption),
            ),
          ),
        );
      }
    } else {
      for (var i = _start; i < _end + 1; i++) {
        list.add(
          GestureDetector(
            onTap: () {
              updateOpnionScale(i);
            },
            child: Container(
              child: generateOpmionBlock(i, _selectedOption),
            ),
          ),
        );
      }
    }

    // possible change is change the alignment for container to wrapalignment to start if needed in tablet

    // Have removed width:doubly.infinity
    return Container(
      child: Wrap(
        crossAxisAlignment: WrapCrossAlignment.center,
        alignment: WrapAlignment.center,
        runSpacing: runSpacing,
        direction: Axis.horizontal,
        children: [...list],
      ),
    );
  }
}
