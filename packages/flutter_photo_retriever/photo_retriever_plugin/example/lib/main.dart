import 'package:example/photo_grid_view.dart';
import 'package:flutter/material.dart';
import 'dart:io' show Platform;

import 'package:photo_retriever_plugin/photo_retriever_plugin.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({super.key, required this.title});

  final String title;

  final PhotoRetrieverPlugin plugin = PhotoRetrieverPlugin();

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  List<RetrievedPhoto> photos = [];
  final PhotoCacheType type = PhotoCacheType.memory;

  @override
  void initState() {
    super.initState();
    widget.plugin.onSelectedAccessUpdated().listen((e) {
      setState(() {
        if (e.updatedPhotos != null) photos = e.updatedPhotos!;
      });
    });
    widget.plugin.onGalleryUpdated().listen((e) {
      debugPrint("gallery updated: ${e.changes.toString()}");
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text(widget.title),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            TextButton(
              onPressed: () async {
                try {
                  if(Platform.isIOS) {
                    final res = await widget.plugin.getPhotos(
                      IosThumbnailOption(
                        deliveryMode: ImageDeliveryMode.opportunistic,
                        resizeMode: ImageResizeMode.fast,
                        contentMode: ImageContentMode.aspectFill,
                        width: 100,
                        height: 100,
                        quality: 50,
                        format: ThumbImageLoadOption.png,
                      ),
                    );
                    if (res != null) {
                      setState(() {
                        photos = res;
                      });
                    }
                  }
                } catch (e) {
                  debugPrint("error: $e");
                }
              },
              child: const Text("사진 가져오기"),
            ),
            PhotoGridView(
              type: type,
              photos: photos,
            ),
          ],
        ),
      ),
    );
  }
}
