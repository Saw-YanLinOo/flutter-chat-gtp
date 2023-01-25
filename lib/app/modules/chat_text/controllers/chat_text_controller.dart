import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import '../../../common/headers.dart';
import '../../../model/text_completion_model.dart';
import 'package:translator/translator.dart';

class ChatTextController extends GetxController {
  //TODO: Implement ChatTextController

  @override
  void onInit() {
    super.onInit();
  }

  @override
  void onReady() {
    super.onReady();
  }

  @override
  void onClose() {
    super.onClose();
  }

  List<TextCompletionData> messages = [];

  var state = ApiState.notFound.obs;

  final translator = GoogleTranslator();

  getTextCompletion(String query) async {
    addMyMessage();

    state.value = ApiState.loading;

    var translationToEn =
        await translator.translate("$query", from: 'my', to: 'en');
    print('MM to EN ::: $translationToEn');

    try {
      Map<String, dynamic> rowParams = {
        "model": "text-davinci-003",
        "prompt": translationToEn,
        'temperature': 0,
        'max_tokens': 2000,
        'top_p': 1,
        'frequency_penalty': 0.0,
        'presence_penalty': 0.0,
      };

      final encodedParams = json.encode(rowParams);

      final response = await http.post(
        Uri.parse(endPoint("completions")),
        body: encodedParams,
        headers: headerBearerOption(OPEN_AI_KEY),
      );
      print("Response  body     ${response.body}");
      if (response.statusCode == 200) {
        // messages =
        //     TextCompletionModel.fromJson(json.decode(response.body)).choices;
        //

        var message = json.decode(response.body)['choices'][0]['text'];
        debugPrint('Message ::: $message');

        var translationToMm =
            await translator.translate("${message}", to: 'my');
        print('En To Mm :: $translationToMm');
        addServerTranslateMessage('$translationToMm');

// addServerMessage(
//             TextCompletionModel.fromJson(json.decode(response.body)).choices);
        searchTextController.clear();
        state.value = ApiState.success;
      } else {
        // throw ServerException(message: "Image Generation Server Exception");
        state.value = ApiState.error;
      }
    } catch (e) {
      print("Errorrrrrrrrrrrrrrr  ");
    } finally {
      // searchTextController.clear();
      update();
    }
  }

  addServerMessage(List<TextCompletionData> choices) {
    for (int i = 0; i < choices.length; i++) {
      messages.insert(i, choices[i]);
    }
  }

  addServerTranslateMessage(String message) {
    messages.insert(
        0, TextCompletionData(text: message, index: 0, finish_reason: ''));
  }

  addMyMessage() {
    // {"text":":\n\nWell, there are a few things that you can do to increase","index":0,"logprobs":null,"finish_reason":"length"}
    TextCompletionData text = TextCompletionData(
        text: searchTextController.text, index: -999999, finish_reason: "");
    messages.insert(0, text);
  }

  TextEditingController searchTextController = TextEditingController();
}
