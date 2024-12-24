// ignore_for_file: library_private_types_in_public_api

import 'package:flutter/material.dart';

/// Entrypoint of the application.
void main() {
  runApp(const MyApp());
}

/// [Widget] building the [MaterialApp].
class MyApp extends StatelessWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        backgroundColor: Colors.white,
        body: Center(
          child: Container(
            height: 120,
            color: Colors.grey[900],
            width: MediaQuery.of(context).size.width,
            child: const Center(child: Dock()),
          ),
        ),
      ),
    );
  }
}

/// Dock of the reorderable [items].
class Dock extends StatefulWidget {
  const Dock({super.key});
  @override
  _DockState createState() => _DockState();
}

class _DockState extends State<Dock> {
  String? selectedIndexItem;
  int? hoveredIndex;
  int? oldHoverIndex;
  double hoverIconDx = 0.0;
  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      scrollDirection: Axis.horizontal,
      itemCount: dockItemsList.length,
      shrinkWrap: true,
      itemBuilder: (context, index) {
        // Define Initial Icon Size and Magnification Size

        double initialIconSize = 40;
        double magnificationSize = 10;
        double iconSize = initialIconSize;
        double bottomPadding = 0;
        if (hoveredIndex != null) {
          int distance = (index - hoveredIndex!).abs();

          // Manage icon size and padding based on hover index
          switch (distance) {
            case 0:
              iconSize = initialIconSize + magnificationSize * 4;
              bottomPadding = 10;
              break;
            case 1:
              iconSize = initialIconSize + magnificationSize * 3;
              bottomPadding = 5;

              // Additional size adjust based on hover
              if ((hoverIconDx >= 0 && hoverIconDx <= 30) && (index - hoveredIndex!).isNegative) {
                int size = ((40 - hoverIconDx) * (10 - 0) / (40 - 0) + 0).round();
                iconSize = initialIconSize + (magnificationSize * 3) + size;
                bottomPadding = 10;
                break;
              } else if ((hoverIconDx >= 51 && hoverIconDx <= 80) && !(index - hoveredIndex!).isNegative) {
                int size = ((40 - hoverIconDx) * (10 - 0) / (40 - 0) + 0).round();
                iconSize = initialIconSize + (magnificationSize * 3) - size;
                bottomPadding = 10;
                break;
              }
            case 2:
              iconSize = initialIconSize + magnificationSize * 2;
              break;
            case 3:
              iconSize = initialIconSize + magnificationSize;
              break;
          }
        }

        return (selectedIndexItem != null && hoveredIndex == null && (dockItemsList[index] == selectedIndexItem!))
            ? const SizedBox()
            : DragTarget(
                builder: (context, candidateData, rejectedData) {
                  return Draggable(
                    onDraggableCanceled: (velocity, offset) {
                      setState(() {
                        selectedIndexItem = null;
                      });
                    },
                    onDragStarted: () {
                      selectedIndexItem = dockItemsList[index];
                    },
                    onDragCompleted: () {
                      selectedIndexItem = null;
                      setState(() {});
                    },
                    onDragEnd: (details) {
                      setState(() {
                        selectedIndexItem = null;
                        oldHoverIndex = null;
                      });
                    },
                    data: index,
                    feedback: Column(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        Image.network(
                          dockItemsList[index],
                          height: iconSize,
                          errorBuilder: (context, error, stackTrace) => const Icon(Icons.error, color: Colors.white),
                        ),
                      ],
                    ),
                    child: MouseRegion(
                      cursor: MouseCursor.defer,
                      onHover: (PointerEvent details) {
                        setState(() {
                          hoverIconDx = details.localPosition.dx;
                        });
                      },
                      onExit: (_) => setState(() {
                        oldHoverIndex = index;
                        hoveredIndex = null;
                      }),
                      onEnter: (_) => setState(() {
                        hoveredIndex = index;
                        if (selectedIndexItem != null) {
                          if (oldHoverIndex != null) {
                            dockItemsList[oldHoverIndex!] = dockItemsList[index];
                          }
                          dockItemsList[index] = selectedIndexItem!;
                        }
                      }),
                      child: TweenAnimationBuilder<double>(
                        tween: Tween<double>(begin: initialIconSize, end: iconSize),
                        duration: const Duration(milliseconds: 700),
                        curve: Curves.fastLinearToSlowEaseIn,
                        builder: (context, size, child) {
                          return Opacity(
                            opacity: ((hoveredIndex == index) && selectedIndexItem != null) ? 0 : 1,
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: [
                                Image.network(
                                  dockItemsList[index],
                                  height: size,
                                  errorBuilder: (context, error, stackTrace) => const Icon(Icons.error, color: Colors.white),
                                ),
                                AnimatedContainer(
                                  height: bottomPadding,
                                  duration: const Duration(milliseconds: 700),
                                  curve: Curves.fastLinearToSlowEaseIn,
                                ),
                                const Text(
                                  '•',
                                  style: TextStyle(fontSize: 8, fontWeight: FontWeight.bold, color: Colors.white),
                                )
                              ],
                            ),
                          );
                        },
                      ),
                    ),
                  );
                },
              );
      },
    );
  }
}

/// Initial [T] items to put in this [Dock].
final List<String> dockItemsList = [
  "https://uploads-ssl.webflow.com/5f7081c044fb7b3321ac260e/5f70853981255cc36b3a37af_finder.png",
  "https://uploads-ssl.webflow.com/5f7081c044fb7b3321ac260e/5f70853ff3bafbac60495771_siri.png",
  "https://uploads-ssl.webflow.com/5f7081c044fb7b3321ac260e/5f70853943597517f128b9b4_launchpad.png",
  "https://uploads-ssl.webflow.com/5f7081c044fb7b3321ac260e/5f70853743597518c528b9b3_contacts.png",
  "https://uploads-ssl.webflow.com/5f7081c044fb7b3321ac260e/5f70853c849ec3735b52cef9_notes.png",
  "https://uploads-ssl.webflow.com/5f7081c044fb7b3321ac260e/5f70853d44d99641ce69afeb_reminders.png",
  "https://uploads-ssl.webflow.com/5f7081c044fb7b3321ac260e/5f70853c55558a2e1192ee09_photos.png",
  "https://uploads-ssl.webflow.com/5f7081c044fb7b3321ac260e/5f70853a55558a68e192ee08_messages.png",
  "https://uploads-ssl.webflow.com/5f7081c044fb7b3321ac260e/5f708537f18e2cb27247c904_facetime.png",
  "https://uploads-ssl.webflow.com/5f7081c044fb7b3321ac260e/5f70853ba0782d6ff2aca6b3_music.png",
  "https://uploads-ssl.webflow.com/5f7081c044fb7b3321ac260e/5f70853cc718ba9ede6888f9_podcasts.png",
  "https://uploads-ssl.webflow.com/5f7081c044fb7b3321ac260e/5f708540dd82638d7b8eda70_tv.png",
  "https://uploads-ssl.webflow.com/5f7081c044fb7b3321ac260e/5f70853270b5e2ccfd795b49_appstore.png",
  "https://uploads-ssl.webflow.com/5f7081c044fb7b3321ac260e/5f70853ddd826358438eda6d_safari.png",
];
