import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pantrypal/widgets/rounded_box.dart';

class MealController extends GetxController {
  var selectedTab = 0.obs;
  var favoriteStatus = <int, bool>{}.obs;

  void toggleTab(int index) {
    selectedTab.value = index;
  }

  void toggleFavorite(int index) {
    favoriteStatus[index] = !(favoriteStatus[index] ?? false);
  }
}

class MealScreen extends StatelessWidget {
  final MealController controller = Get.put(MealController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: const Text("Meal Suggestions"),
      ),
      body: Obx(
        () => Column(
            children: [
              Divider(height: 1, color: Colors.grey.withOpacity(0.2)),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: List.generate(3, (index) {
                  final titles = ["Suggestions", "My Recipes", "Favorites"];
                  final isSelected = controller.selectedTab.value == index;
                  return Expanded(
                    child: GestureDetector(
                      onTap: () {
                        controller.toggleTab(index);
                      },
                      child: Stack(
                        alignment: Alignment.bottomCenter,
                        children: [
                          RoundedBox(
                            padding: const EdgeInsets.all(12),
                            borderRadius: 0,
                            width: double.infinity,
                            outlineStroke: 0,
                            outlineColor: isSelected ? Colors.white : Colors.transparent,
                            color: isSelected ? Colors.white : Colors.transparent,
                            child: Column(
                              children: [
                                Text(
                                  titles[index],
                                  style: TextStyle(
                                    color: isSelected ? Colors.blue : Color(0xFF707070),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          if (isSelected)
                            Container(
                              height: 2,
                              decoration: BoxDecoration(
                                color: Colors.blue,
                              ),
                              // width: double.infinity,
                            ),
                        ],
                      ),
                    ),
                  );
                }),
              ),
              const SizedBox(height: 16),
              // Expanded(
              //   child: ListView.builder(
              //     itemCount: 10, // Example item count
              //     itemBuilder: (context, index) {
              //       return Padding(
              //         padding: const EdgeInsets.only(bottom: 16.0),
              //         child: Column(
              //           crossAxisAlignment: CrossAxisAlignment.start,
              //           children: [
              //             Stack(
              //               children: [
              //                 Image.network(
              //                   'https://via.placeholder.com/150',
              //                   height: 150,
              //                   width: double.infinity,
              //                   fit: BoxFit.cover,
              //                 ),
              //                 Positioned(
              //                   top: 8,
              //                   right: 8,
              //                   child: RoundedBox(
              //                     child: Text(
              //                       'Label',
              //                       style: const TextStyle(color: Colors.white),
              //                     ),
              //                     color: Colors.black.withOpacity(0.5),
              //                   ),
              //                 ),
              //               ],
              //             ),
              //             const SizedBox(height: 8),
              //             Column(
              //               crossAxisAlignment: CrossAxisAlignment.start,
              //               children: [
              //                 Row(
              //                   mainAxisAlignment: MainAxisAlignment.spaceBetween,
              //                   children: [
              //                     const Text(
              //                       'Title',
              //                       style: TextStyle(
              //                         fontWeight: FontWeight.bold,
              //                         fontSize: 16,
              //                       ),
              //                     ),
              //                     GestureDetector(
              //                       onTap: () => controller.toggleFavorite(index),
              //                       child: Icon(
              //                         controller.favoriteStatus[index] == true
              //                             ? Icons.star
              //                             : Icons.star_border,
              //                         color: controller.favoriteStatus[index] == true
              //                             ? Colors.yellow
              //                             : Colors.grey,
              //                       ),
              //                     ),
              //                   ],
              //                 ),
              //                 const SizedBox(height: 4),
              //                 const Text(
              //                   'Description',
              //                   style: TextStyle(fontSize: 14),
              //                 ),
              //                 const SizedBox(height: 8),
              //                 Row(
              //                   children: List.generate(3, (boxIndex) {
              //                     return Padding(
              //                       padding: const EdgeInsets.only(right: 8.0),
              //                       child: RoundedBox(
              //                         child: Text('Box ${boxIndex + 1}'),
              //                       ),
              //                     );
              //                   }),
              //                 ),
              //               ],
              //             ),
              //           ],
              //         ),
              //       );
              //     },
              //   ),
              // ),
            ],
        ),
      ),
    );
  }
}