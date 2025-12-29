import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

class Showimages extends StatefulWidget {
  const Showimages({super.key});

  @override
  State<Showimages> createState() => _ShowimagesState();
}

class _ShowimagesState extends State<Showimages> {
  int imageCount = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 10),
            child: GestureDetector(
              onTap: (imageCount != 0)
                  ? () {
                      Navigator.pop(context, "lib/Images/$imageCount.jpg");
                    }
                  : null,
              child: Container(
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(8),
                    color: Colors.white),
                child: Padding(
                  padding: const EdgeInsets.only(
                      right: 10, left: 10, top: 5, bottom: 5),
                  child: Text("Save",
                      style: TextStyle(
                          fontWeight: FontWeight.bold, color: Colors.black)),
                ),
              ),
            ),
          )
        ],
        backgroundColor: Colors.black,
        title: Text(
          "Choose how your appear",
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
      ),
      backgroundColor: Colors.black,
      body: Padding(
        padding: const EdgeInsets.all(10),
        child: GridView.builder(
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 3,
            crossAxisSpacing: 10,
            mainAxisSpacing: 10,
            childAspectRatio: 1,
          ),
          itemCount: 13,
          itemBuilder: (context, index) {
            return GestureDetector(
              onTap: () {
                imageCount = index + 1;
                if (!mounted) return;
                setState(() {});
                //print(imageCount);
              },
              child: Stack(children: [
                Container(
                  clipBehavior: Clip.hardEdge,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                  ),
                  child: Center(
                      child: ClipOval(
                          child: Opacity(
                    opacity: (imageCount == index + 1) ? 0.3 : 1,
                    child: Image.asset(
                      "lib/Images/${index + 1}.jpg",
                      fit: BoxFit.cover,
                    ),
                  ))),
                ),
                Center(
                  child: (imageCount == index + 1)
                      ? Icon(
                          Icons.check,
                          size: 40,
                          color: Colors.white,
                        )
                      : SizedBox.shrink(),
                ),
              ]),
            );
          },
        ),
      ),
    );
  }
}
