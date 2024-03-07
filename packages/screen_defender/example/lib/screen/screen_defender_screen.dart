import 'dart:io';

import 'package:flutter/material.dart';
import 'package:screen_defender/screen_defender_plugin.dart';

class ScreenDefenderScreen extends StatefulWidget {
  const ScreenDefenderScreen({Key? key}) : super(key: key);

  @override
  _ScreenDefenderScreenState createState() => _ScreenDefenderScreenState();
}

class _ScreenDefenderScreenState extends State<ScreenDefenderScreen> {

  final plugin = ScreenDefenderPlugin();

  @override
  void initState() {
    _addListenerPreventScreenshot();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text('Protect Screen Data Leakage'),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            const Center(
              child: Text('Protect Screen Data Leakage'),
            ),
            TextButton(
              onPressed: () async {
                await plugin.capturePreventImageOn('KtLogo');
              },
              child: const Text("캡처 방지 화면 켜기"),
            ),
            TextButton(
              onPressed: () async {
                await plugin.disableCapturePreventImage();
              },
              child: const Text("캡처 방지 화면 끄기"),
            ),
            TextButton(
              onPressed: () async {
                await plugin.secureTaskViewImageOn('KtLogo');
              },
              child: const Text("태스크 뷰 켜기 - 이미지"),
            ),
            TextButton(
              onPressed: () async {
                await plugin.secureTaskViewImageOff();
              },
              child: const Text("태스크 뷰 끄기 - 이미지"),
            ),
            TextButton(
              onPressed: () async {
                await plugin.secureTaskViewColorOn(Colors.indigoAccent);
              },
              child: const Text("태스크 뷰 켜기 - 컬러"),
            ),
            TextButton(
              onPressed: () async {
                await plugin.secureTaskViewColorOff();
              },
              child: const Text("태스크 뷰 끄기 - 컬러"),
            ),
            TextButton(
              onPressed: () async {
                await plugin.secureTaskViewBlurOn();
              },
              child: const Text("태스크 뷰 켜기 - 블러"),
            ),
            TextButton(
              onPressed: () async {
                await plugin.secureTaskViewBlurOff();
              },
              child: const Text("태스크 뷰 끄기 - 블러"),
            ),
            TextButton(
              onPressed: () async {
                await plugin.secureTaskViewBlurOff();
              },
              child: const Text("태스크 뷰 켜기 - 안드로이드"),
            ),
          ],
        ),
      ),
    );
  }

  @override
  void dispose() async {
    super.dispose();
    plugin.removeListener();
    await plugin.disableSecureTaskView();
    await plugin.disableCapturePreventImage();
  }

  void _protectDataLeakageOn() async {
    if (Platform.isIOS) {
      await plugin.secureTaskViewColorOn(Colors.indigoAccent);
    } else if (Platform.isAndroid) {
      // await plugin.secureScreenOn(); // TODO android interface 어떻게 ios랑 맞출지..~~
    }
  }
  void _addListenerPreventScreenshot() async {
    plugin.addListener(
      screenshotListener: () {
        // Screenshot
        debugPrint('Screenshot:');
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Screenshot!'),
          ),
        );
      },
      screenRecordListener: (isCaptured) {
        // Screen Record
        debugPrint('Screen Record:');
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Screen Record!'),
          ),
        );
      },
    );
  }
}
