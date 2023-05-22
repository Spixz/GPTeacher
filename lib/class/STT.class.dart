import 'dart:io';

import 'package:cheetah_flutter/cheetah_error.dart';
import 'package:gpteacher/cheetah_manager.dart';

class STT {
  final String accessKey =
      'iucMFDyWvdaKiUzqtipwoQ4jiNSweUIzlUAAxhua49hi/iZHUd+Axw=='; // AccessKey obtained from Picovoice Console (https://console.picovoice.ai/)
  late CheetahManager
      _cheetahManager; //utiliser une facotry qui permettre de l'init ici avec des callbacks

  STT(Function(String) transcriptCallback,
      Function(CheetahException) errorCallback) {
    initCheetah(transcriptCallback, errorCallback);
  }

  Future<void> initCheetah(Function(String) transcriptCallback,
      Function(CheetahException) errorCallback) async {
    String platform = Platform.isAndroid
        ? "android"
        : Platform.isIOS
            ? "ios"
            : throw CheetahRuntimeException(
                "This demo supports iOS and Android only.");
    String modelPath = "assets/models/$platform/cheetah_params.pv";

    try {
      _cheetahManager = await CheetahManager.create(
          accessKey, modelPath, transcriptCallback, errorCallback);
    } on CheetahInvalidArgumentException catch (ex) {
      errorCallback(CheetahInvalidArgumentException(
          "${ex.message}\nEnsure your accessKey '$accessKey' is a valid access key."));
    } on CheetahActivationException {
      errorCallback(CheetahActivationException("AccessKey activation error."));
    } on CheetahActivationLimitException {
      errorCallback(CheetahActivationLimitException(
          "AccessKey reached its device limit."));
    } on CheetahActivationRefusedException {
      errorCallback(CheetahActivationRefusedException("AccessKey refused."));
    } on CheetahActivationThrottledException {
      errorCallback(
          CheetahActivationThrottledException("AccessKey has been throttled."));
    } on CheetahException catch (ex) {
      errorCallback(ex);
    }
  }

  Future<void> startProcess() async {
    await _cheetahManager.startProcess();
  }

  Future<void> stopProcess() async {
    await _cheetahManager.stopProcess();
  }
}
