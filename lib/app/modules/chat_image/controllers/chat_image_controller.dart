import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:image_downloader/image_downloader.dart';
import 'package:path_provider/path_provider.dart';
import 'package:uuid/uuid.dart';
import 'dart:convert';
import '../../../common/headers.dart';
import '../../../model/image_generation_model.dart';
import 'package:http/http.dart' as http;

class ChatImageController extends GetxController {
  //TODO: Implement ChatImageController

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

  List<ImageGenerationData> images = [];

  var state = ApiState.notFound.obs;

  getGenerateImages(String query) async {
    print("call   " + query);

    state.value = ApiState.loading;
    images.clear();

    try {
      // ['256x256', '512x512', '1024x1024']
      Map<String, dynamic> rowParams = {
        "n": 10,
        "size": "256x256",
        "prompt": query,
      };

      final encodedParams = json.encode(rowParams);

      final response = await http.post(
        Uri.parse(endPoint("images/generations")),
        body: encodedParams,
        headers: headerBearerOption(OPEN_AI_KEY),
      );

      debugPrint('${response.body}');
      if (response.statusCode == 200) {
        images = ImageGenerationModel.fromJson(json.decode(response.body)).data;
        print("succccccccccccccccccccccccc ");
        state.value = ApiState.success;
        searchTextController.clear();
      } else {
        print("Errorrrrrrrrrrrrrrr  ${response.body}");
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

  TextEditingController searchTextController = TextEditingController();

  clearTextField() {
    searchTextController.clear();
  }

  void saveNetworkImage(String path) async {
    // GallerySaver.saveImage(path, albumName: "ChatGTP").then((success) {
    //   if (success == true) {
    //     Get.showSnackbar(GetSnackBar(
    //       message: 'image saved!',
    //       duration: const Duration(seconds: 1),
    //     ));
    //   }
    // });
    var result = await compute(saveImage, path);

    if (result) {
      Get.showSnackbar(const GetSnackBar(
        message: 'image saved!',
        duration: Duration(seconds: 1),
      ));
    }
  }

  Future<bool> saveImage(String path) async {
    try {
      var imageId = await ImageDownloader.downloadImage(
        path,
        destination: AndroidDestinationType.directoryDCIM,
      );

      if (imageId == null) {
        return false;
      }

      // Below is a method of obtaining saved image information.
      // var fileName = await ImageDownloader.findName(imageId);
      // var paths = await ImageDownloader.findPath(imageId);
      // var size = await ImageDownloader.findByteSize(imageId);
      // var mimeType = await ImageDownloader.findMimeType(imageId);

      return true;
    } on PlatformException catch (error) {
      debugPrint('$error');
      return false;
    }
  }

  void copyImageUrl(String path) {
    Clipboard.setData(ClipboardData(text: path)).then((value) {
      Get.showSnackbar(GetSnackBar(
        message: 'copy!',
        duration: const Duration(seconds: 1),
      ));
    });
  }
}
