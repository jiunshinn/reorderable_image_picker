import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:reorderable_grid/reorderable_grid.dart';

class Gallery extends StatefulWidget {
  const Gallery({Key? key}) : super(key: key);

  @override
  _GalleryState createState() => _GalleryState();
}

class _GalleryState extends State<Gallery> {
  final List<XFile>? selectedImagesList = [];
  final List<XFile> dropTargetList = [];

  void _onReorder(int oldIndex, int newIndex) {
    setState(() {
      final item = selectedImagesList!.removeAt(oldIndex);
      selectedImagesList!.insert(newIndex, item);
    });
  }

  @override
  Widget build(BuildContext context) {
    double size = 230;
    return Scaffold(
      appBar: AppBar(
        title: const Text('Gallery'),
      ),
      body: Column(
        children: [
          ElevatedButton(
            onPressed: () async {
              final List<XFile>? selectedImages =
                  await ImagePicker().pickMultiImage();
              if (selectedImages!.isNotEmpty) {
                setState(() {
                  selectedImagesList!.addAll(selectedImages);
                });
              }
            },
            child: const Text('Select Images'),
          ),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: ReorderableGridView.extent(
                maxCrossAxisExtent: 250,
                onReorder: _onReorder,
                childAspectRatio: 1,
                children: selectedImagesList!.map((item) {
                  return Card(
                    key: ValueKey(item),
                    child: Center(
                      child: Image.file(File(item.path)),
                    ),
                  );
                }).toList(),
              ),
            ),
          ),
          // Container(
          //     width: size,
          //     height: size,
          //     color: Colors.green,
          //     child: DragTarget<XFile>(
          //         builder: ((context, candidateData, rejectedData) {
          //           return Row(
          //               children: dropTargetList
          //                   .map((target) => Image.file(File(target.path),
          //                       fit: BoxFit.cover, width: size, height: size))
          //                   .toList());
          //         }),
          //         onWillAccept: (data) => data != null,
          //         onAccept: (data) {
          //           setState(() {
          //             dropTargetList.add(data);
          //             selectedImagesList
          //                 ?.removeWhere((photo) => photo.path == data.path);
          //           });
          //         })),
          // const SizedBox(height: 200)
        ],
      ),
    );
  }
}
