import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pantrypal/controllers/settings/theme_controller.dart';
import 'package:pantrypal/core/theme/app_theme.dart';
import 'package:pantrypal/core/theme/theme_colors.dart';
import 'package:pantrypal/screens/root_screen.dart';
import 'package:pantrypal/models/hive_manager.dart';

// import 'package:pantrypal/models/ingredient_template.dart';
// import 'package:pantrypal/models/inventory_item.dart';
// import 'package:pantrypal/models/recipe_ingredient.dart';
// import 'package:pantrypal/models/recipe.dart';
// import 'package:pantrypal/models/meal.dart';
// import 'package:pantrypal/models/enums/meal_type.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await HiveManager.init();
  // await _seedSampleData();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  final ThemeController themeController = Get.put(ThemeController());

  MyApp({super.key});

  // This widget is the root of your application.
  // @override
  // Widget build(BuildContext context) {
  //   return MaterialApp(
  //     title: 'Flutter Demo',
  //     theme: ThemeData(
  //       // This is the theme of your application.
  //       //
  //       // TRY THIS: Try running your application with "flutter run". You'll see
  //       // the application has a purple toolbar. Then, without quitting the app,
  //       // try changing the seedColor in the colorScheme below to Colors.green
  //       // and then invoke "hot reload" (save your changes or press the "hot
  //       // reload" button in a Flutter-supported IDE, or press "r" if you used
  //       // the command line to start the app).
  //       //
  //       // Notice that the counter didn't reset back to zero; the application
  //       // state is not lost during the reload. To reset the state, use hot
  //       // restart instead.
  //       //
  //       // This works for code too, not just values: Most code changes can be
  //       // tested with just a hot reload.
  //       colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
  //     ),
  //     home: const MyHomePage(title: 'Flutter Demo Home Page'),
  //   );
  // }
  @override
  Widget build(BuildContext context) {
    return Obx(
      () => GetMaterialApp(
        title: 'Theme Switcher',
        theme: AppTheme.light,
        darkTheme: AppTheme.dark,
        themeMode: themeController.themeMode.value,
        home: RootScreen(),
      ),
    );
  }
}

/// Test screen to test the theme switcher
class ThemeSwitcherScreen extends StatelessWidget {
  final ThemeController themeController = Get.find<ThemeController>();

  ThemeSwitcherScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).extension<ThemeColors>()!;

    return Scaffold(
      appBar: AppBar(
        title: Text('Theme Switcher Screen'),
        backgroundColor: Theme.of(context).colorScheme.primary,
      ),
      body: Center(
        child: ElevatedButton(
          onPressed: () {
            themeController.toggleTheme();
          },
          style: ElevatedButton.styleFrom(
            backgroundColor: colors.testButtonColor,
          ),
          child: Text(
            'Toggle Theme',
            style: TextStyle(color: colors.testTextColor),
          ),
        ),
      ),
    );
  }
}

// Future<void> _seedSampleData() async {
//   // ----- INGREDIENT TEMPLATES -----
//   if (IngredientTemplate.all().isEmpty) {
//     await IngredientTemplate.create(
//       IngredientTemplate(
//         id: 1,
//         name: 'Egg',
//         defaultUnit: 'piece',
//         proteinPerUnit: 6.0,
//         carbsPerUnit: 0.6,
//         fatPerUnit: 5.3,
//       ),
//     );
//     await IngredientTemplate.create(
//       IngredientTemplate(
//         id: 2,
//         name: 'Bread Slice',
//         defaultUnit: 'slice',
//         proteinPerUnit: 3.0,
//         carbsPerUnit: 15.0,
//         fatPerUnit: 1.0,
//       ),
//     );
//   }

//   // ----- INVENTORY -----
//   if (InventoryItem.all().isEmpty) {
//     final eggTemp = IngredientTemplate.getById(1)!;
//     final breadTemp = IngredientTemplate.getById(2)!;
//     await InventoryItem.create(
//       InventoryItem(
//         id: 1,
//         template: eggTemp,
//         quantity: 4,
//         dateAdded: DateTime.now(),
//         expirationDate: DateTime.now().add(Duration(days: 7)),
//       ),
//     );
//     await InventoryItem.create(
//       InventoryItem(
//         id: 2,
//         template: breadTemp,
//         quantity: 6,
//         dateAdded: DateTime.now(),
//         expirationDate: DateTime.now().add(Duration(days: 3)),
//       ),
//     );
//   }

//   // ----- RECIPES -----
//   if (Recipe.all().isEmpty) {
//     final eggTemp = IngredientTemplate.getById(1)!;
//     final breadTemp = IngredientTemplate.getById(2)!;

//     // “Egg on Toast” recipe
//     final eggOnToast = Recipe(
//       id: 1,
//       name: 'Egg on Toast',
//       instructions: 'Fry egg, toast bread, assemble.',
//       duration: 10,
//       difficulty: 'Easy',
//       briefDescription: 'A classic breakfast staple.',
//       ingredientRequirements: [
//         RecipeIngredient(template: eggTemp, quantity: 1),
//         RecipeIngredient(template: breadTemp, quantity: 2),
//       ],
//     );
//     await Recipe.create(eggOnToast);
//   }

//   // ----- MEALS -----
//   if (Meal.all().isEmpty) {
//     final recipe = Recipe.getById(1)!;
//     // Schedule “Egg on Toast” for tomorrow breakfast
//     await Meal.scheduleRecipes(
//       recipes: [recipe],
//       dateTime: DateTime.now().add(Duration(days: 1, hours: 8)),
//       type: MealType.Breakfast,
//     );
//   }
// }

// Keep this code as example

// class MyHomePage extends StatefulWidget {
//   const MyHomePage({super.key, required this.title});

//   // This widget is the home page of your application. It is stateful, meaning
//   // that it has a State object (defined below) that contains fields that affect
//   // how it looks.

//   // This class is the configuration for the state. It holds the values (in this
//   // case the title) provided by the parent (in this case the App widget) and
//   // used by the build method of the State. Fields in a Widget subclass are
//   // always marked "final".

//   final String title;

//   @override
//   State<MyHomePage> createState() => _MyHomePageState();
// }

// class _MyHomePageState extends State<MyHomePage> {
//   int _counter = 0;

//   void _incrementCounter() {
//     setState(() {
//       // This call to setState tells the Flutter framework that something has
//       // changed in this State, which causes it to rerun the build method below
//       // so that the display can reflect the updated values. If we changed
//       // _counter without calling setState(), then the build method would not be
//       // called again, and so nothing would appear to happen.
//       _counter++;
//     });
//   }

//   @override
//   Widget build(BuildContext context) {
//     // This method is rerun every time setState is called, for instance as done
//     // by the _incrementCounter method above.
//     //
//     // The Flutter framework has been optimized to make rerunning build methods
//     // fast, so that you can just rebuild anything that needs updating rather
//     // than having to individually change instances of widgets.
//     return Scaffold(
//       appBar: AppBar(
//         // TRY THIS: Try changing the color here to a specific color (to
//         // Colors.amber, perhaps?) and trigger a hot reload to see the AppBar
//         // change color while the other colors stay the same.
//         backgroundColor: Theme.of(context).colorScheme.inversePrimary,
//         // Here we take the value from the MyHomePage object that was created by
//         // the App.build method, and use it to set our appbar title.
//         title: Text(widget.title),
//       ),
//       body: Center(
//         // Center is a layout widget. It takes a single child and positions it
//         // in the middle of the parent.
//         child: Column(
//           // Column is also a layout widget. It takes a list of children and
//           // arranges them vertically. By default, it sizes itself to fit its
//           // children horizontally, and tries to be as tall as its parent.
//           //
//           // Column has various properties to control how it sizes itself and
//           // how it positions its children. Here we use mainAxisAlignment to
//           // center the children vertically; the main axis here is the vertical
//           // axis because Columns are vertical (the cross axis would be
//           // horizontal).
//           //
//           // TRY THIS: Invoke "debug painting" (choose the "Toggle Debug Paint"
//           // action in the IDE, or press "p" in the console), to see the
//           // wireframe for each widget.
//           mainAxisAlignment: MainAxisAlignment.center,
//           children: <Widget>[
//             const Text('You have pushed the button this many times:'),
//             Text(
//               '$_counter',
//               style: Theme.of(context).textTheme.headlineMedium,
//             ),
//           ],
//         ),
//       ),
//       floatingActionButton: FloatingActionButton(
//         onPressed: _incrementCounter,
//         tooltip: 'Increment',
//         child: const Icon(Icons.add),
//       ), // This trailing comma makes auto-formatting nicer for build methods.
//     );
//   }
// }
