import 'dart:async';
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:mask_camera_new_package/src/mask_for_camera.dart';
import 'package:mask_for_camera_view/mask_for_camera_view.dart';
import 'package:mask_for_camera_view/mask_for_camera_view_result.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await MaskCameraView.initialize();
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
        debugShowCheckedModeBanner: false, home: HomePage());
  }
}

class HomePage extends StatelessWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaskCameraView(
      visiblePopButton: false,
      appBarColor: Colors.black,
      bottomBarColor: Colors.black,
      takeButtonActionColor: Colors.green,
      takeButtonColor: Colors.white,
      boxBorderRadius: 100,
      boxBorderColor: Colors.green,
      iconsColor: Colors.white,
      titleStyle: const TextStyle(
        color: Colors.white,
        fontSize: 18.0,
        fontWeight: FontWeight.w800,
      ),
      boxBorderWidth: 3.8,
      onTake: (MaskForCameraViewResult res) => showModalBottomSheet(
        context: context,
        isScrollControlled: true,
        backgroundColor: Colors.transparent,
        builder: (context) => Container(
          padding: const EdgeInsets.symmetric(vertical: 12.0, horizontal: 14.0),
          decoration: const BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(26.0),
              topRight: Radius.circular(26.0),
            ),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text(
                "Cropped Images",
                style: TextStyle(
                  fontSize: 24.0,
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(height: 12.0),
              res.croppedImage != null
                  ? MyImageView(imageBytes: res.croppedImage!)
                  : Container(),
              const SizedBox(height: 8.0),
              Row(
                children: [
                  res.firstPartImage != null
                      ? Expanded(
                          child: MyImageView(imageBytes: res.firstPartImage!))
                      : Container(),
                  res.firstPartImage != null && res.secondPartImage != null
                      ? const SizedBox(width: 8.0)
                      : Container(),
                  res.secondPartImage != null
                      ? Expanded(
                          child: MyImageView(imageBytes: res.secondPartImage!))
                      : Container(),
                ],
              ),
              const SizedBox(height: 12.0),
            ],
          ),
        ),
      ),
    );
  }
}

class MyImageView extends StatelessWidget {
  const MyImageView({Key? key, required this.imageBytes}) : super(key: key);
  final Uint8List imageBytes;

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(4.0),
      child: SizedBox(
        width: double.infinity,
        child: Image.memory(imageBytes),
      ),
    );
  }
}
