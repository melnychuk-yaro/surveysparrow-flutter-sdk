import 'package:flutter/material.dart';
import 'package:surveysparrow_flutter_sdk/components/questions/yesorno.dart';

import '../components/questions/multichoice.dart';
import '../components/questions/opnion.dart';
import '../components/questions/phone.dart';
import '../components/questions/rating.dart';
import '../components/questions/text.dart';

parsedHeading(question, replacementVal) {
  if (question['rtxt'] == null ||
      question['rtxt']['blocks'] == null ||
      question['rtxt']['blocks'][0] == null ||
      question['rtxt']['blocks'][0]['text'] == null) {
    return '';
  }

  var entityRanges = question['rtxt']['blocks'][0]['entityRanges'];
  var entityMapping = question['rtxt']['entityMap'];
  final Map<dynamic, dynamic> stringToReplace = {};

  if (entityRanges.length <= 0) {
    return question['rtxt']['blocks'][0]['text'];
  }

  var replacedString = question['rtxt']['blocks'][0]['text'];
  var extraOffset = 0;

  for (var i = 0; i < entityRanges.length; i++) {
    var currentEntity = entityRanges[i];
    var textToReplace =
        '#CHANGE_${entityMapping[currentEntity['key'].toString()]['data']['component_txt']}';
    replacedString = replacedString.replaceFirst(
        RegExp(entityMapping[currentEntity['key'].toString()]['data']
            ['component_txt']),
        textToReplace,
        currentEntity['offset'] + extraOffset);
    extraOffset += 8;
    stringToReplace[i] = {};
    stringToReplace[i]['pramKey'] =
        entityMapping[currentEntity['key'].toString()]['data']['component_txt'];
    stringToReplace[i]['regexKey'] = textToReplace;

    // entityMapping[currentEntity['key'].toString()]['data']['component_txt']['replace_txt'] = textToReplace;
  }

  for (var i = 0; i < stringToReplace.length; i++) {
    var stringToReplaceHere =
        replacementVal[stringToReplace[i]['pramKey']] ?? '';
    replacedString = replacedString.replaceAll(
        stringToReplace[i]['regexKey'], stringToReplaceHere);
  }
  return replacedString;
}

convertQuestionListToWidget(
    questionsToConvert,
    _currentQuestionToRender,
    storeAnswers,
    _workBench,
    _themeData,
    customParams,
    _currentQuestionNumber,
    submitData,
    _lastQuestion,
    _scrollController,
    euiTheme,
    toggleNextButtonBlock) {
  List<Widget> _newquestionList = List<Widget>.empty(growable: true);

  var i = 0;

  for (var question in questionsToConvert) {
    if (question['type'] == 'Rating') {
      _newquestionList.add(
        AnimatedOpacity(
          opacity: _currentQuestionToRender['id'] == null
              ? 1.0
              : _currentQuestionToRender['id'] == question['id']
                  ? 1.0
                  : 0.0,
          duration: const Duration(milliseconds: 200),
          child: Center(
            child: SingleChildScrollView(
              physics: BouncingScrollPhysics(),
              child: ColumnRating(
                func: storeAnswers,
                answer: _workBench,
                question: question,
                theme: _themeData,
                customParams: customParams,
                currentQuestionNumber: i + 1,
                isLastQuestion: question['id'] == _lastQuestion['id'],
                lastQuestionId: _lastQuestion['id'],
                submitData: submitData,
                euiTheme: euiTheme,
              ),
            ),
          ),
        ),
      );
    }
    if (question['type'] == 'TextInput' || question['type'] == 'EmailInput') {
      _newquestionList.add(
        AnimatedOpacity(
          opacity: _currentQuestionToRender['id'] == null
              ? 1.0
              : _currentQuestionToRender['id'] == question['id']
                  ? 1.0
                  : 0.0,
          duration: const Duration(milliseconds: 200),
          child: Center(
            child: SingleChildScrollView(
              physics: BouncingScrollPhysics(),
              child: TextRating(
                  func: storeAnswers,
                  answer: _workBench,
                  question: question,
                  theme: _themeData,
                  customParams: customParams,
                  currentQuestionNumber: i + 1,
                  isLastQuestion: question['id'] == _lastQuestion['id'],
                  submitData: submitData,
                  euiTheme: euiTheme,
                  toggleNextButtonBlock: toggleNextButtonBlock),
            ),
          ),
        ),
      );
    }
    if (question['type'] == 'MultiChoice') {
      _newquestionList.add(
        AnimatedOpacity(
          opacity: _currentQuestionToRender['id'] == null
              ? 1.0
              : _currentQuestionToRender['id'] == question['id']
                  ? 1.0
                  : 0.0,
          duration: const Duration(milliseconds: 200),
          child: Center(
            child: SingleChildScrollView(
              physics: BouncingScrollPhysics(),
              controller: _scrollController,
              child: MultiChoice(
                func: storeAnswers,
                answer: _workBench,
                question: question,
                theme: _themeData,
                customParams: customParams,
                currentQuestionNumber: i + 1,
                submitData: submitData,
                isLastQuestion: question['id'] == _lastQuestion['id'],
                euiTheme: euiTheme,
                toggleNextButtonBlock: toggleNextButtonBlock,
              ),
            ),
          ),
        ),
      );
    }
    if (question['type'] == 'OpinionScale') {
      _newquestionList.add(
        AnimatedOpacity(
          opacity: _currentQuestionToRender['id'] == null
              ? 1.0
              : _currentQuestionToRender['id'] == question['id']
                  ? 1.0
                  : 0.0,
          duration: const Duration(milliseconds: 200),
          child: Center(
            child: SingleChildScrollView(
              physics: BouncingScrollPhysics(),
              controller: _scrollController,
              child: ColumnOpnionScale(
                func: storeAnswers,
                answer: _workBench,
                question: question,
                theme: _themeData,
                customParams: customParams,
                currentQuestionNumber: i + 1,
                submitData: submitData,
                isLastQuestion: question['id'] == _lastQuestion['id'],
                euiTheme: euiTheme,
              ),
            ),
          ),
        ),
      );
    }
    if (question['type'] == 'PhoneNumber') {
      _newquestionList.add(
        AnimatedOpacity(
          opacity: _currentQuestionToRender['id'] == null
              ? 1.0
              : _currentQuestionToRender['id'] == question['id']
                  ? 1.0
                  : 0.0,
          duration: const Duration(milliseconds: 200),
          child: Center(
            child: SingleChildScrollView(
              physics: BouncingScrollPhysics(),
              child: ColumnPhone(
                func: storeAnswers,
                answer: _workBench,
                question: question,
                theme: _themeData,
                customParams: customParams,
                currentQuestionNumber: i + 1,
                isLastQuestion: question['id'] == _lastQuestion['id'],
                submitData: submitData,
                euiTheme: euiTheme,
              ),
            ),
          ),
        ),
      );
    }
    if (question['type'] == 'YesNo') {
      _newquestionList.add(
        AnimatedOpacity(
          opacity: _currentQuestionToRender['id'] == null
              ? 1.0
              : _currentQuestionToRender['id'] == question['id']
                  ? 1.0
                  : 0.0,
          duration: const Duration(milliseconds: 200),
          child: Center(
            child: SingleChildScrollView(
              physics: BouncingScrollPhysics(),
              child: YesOrNo(
                func: storeAnswers,
                answer: _workBench,
                question: question,
                theme: _themeData,
                customParams: customParams,
                currentQuestionNumber: i + 1,
                submitData: submitData,
                isLastQuestion: question['id'] == _lastQuestion['id'],
                euiTheme: euiTheme,
              ),
            ),
          ),
        ),
      );
    }
    i += 1;
  }
  return _newquestionList;
}

setTheme(_themeData, _surveyThemeClass) {
  _themeData['questionColor'] = _surveyThemeClass.questionColor;
  _themeData['answerColor'] = _surveyThemeClass.answerColor;
  _themeData['backgroundColor'] = _surveyThemeClass.backgroundColor;
  _themeData['questionDescriptionColor'] =
      _surveyThemeClass.questionDescriptionColor;
  _themeData['questionNumberColor'] = _surveyThemeClass.questionNumberColor;
  _themeData['decodedOpnionBackgroundColorSelected'] =
      _surveyThemeClass.decodedOpnionBackgroundColorSelected;
  _themeData['decodedOpnionBackgroundColorUnSelected'] =
      _surveyThemeClass.decodedOpnionBackgroundColorUnSelected;
  _themeData['decodedOpnionBorderColor'] =
      _surveyThemeClass.decodedOpnionBorderColor;
  _themeData['decodedOpnionLabelColor'] =
      _surveyThemeClass.decodedOpnionLabelColor;
  _themeData['ctaButtonColor'] = _surveyThemeClass.ctaButtonColor;
  _themeData['ratingRgba'] = _surveyThemeClass.ratingRgba;
  _themeData['ratingRgbaBorder'] = _surveyThemeClass.ratingRgbaBorder;
  _themeData['ctaButtonDisabledColor'] =
      _surveyThemeClass.ctaButtonDisabledColor;
  _themeData['showRequired'] = _surveyThemeClass.showRequired;
  _themeData['buttonStyle'] = _surveyThemeClass.buttonStyle;
  _themeData['showBranding'] = _surveyThemeClass.showBranding;
  _themeData['questionString'] = _surveyThemeClass.questionString;
  _themeData['hasGradient'] = _surveyThemeClass.hasGradient;
  _themeData['gradientColors'] = _surveyThemeClass.gradientColors;
  _themeData['showQuestionNumber'] = _surveyThemeClass.showQuestionNumber;
  _themeData['showProgressBar'] = _surveyThemeClass.showProgressBar;
  _themeData['hasHeader'] = _surveyThemeClass.hasHeader;
  _themeData['headerText'] = _surveyThemeClass.headerText;
  _themeData['headerLogoUrl'] = _surveyThemeClass.headerLogoUrl;
  _themeData['hasFooter'] = _surveyThemeClass.hasFooter;
  _themeData['footerText'] = _surveyThemeClass.footerText;
}
