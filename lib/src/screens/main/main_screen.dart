import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:dio/dio.dart';
import 'package:hive/hive.dart';
import 'package:qwe/src/common/models/subcategory.dart';
import 'package:qwe/src/common/models/category_model.dart';
import 'dart:developer';
import 'package:qwe/src/screens/chat/chat_screen.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  List<Category> categoryList = [];
  List<SubCategory> subCategoryList = [];
  Dio dio = Dio();
  bool isLoading = true;

  List<List<List<Color>>> gradientsList = [
    [
      [
        const Color(0xff00387B),
        const Color(0xff3B609D),
      ],
      [
        const Color(0xff008C84),
        const Color(0xff2CB191),
      ],
      [
        const Color(0xffC36900),
        const Color(0xffD48246),
      ],
      [
        const Color(0xff6700B8),
        const Color(0xffA945E7),
      ],
    ],
    [
      [
        const Color(0xffC36900),
        const Color(0xffD48246),
      ],
      [
        const Color(0xff6700B8),
        const Color(0xffA945E7),
      ],
      [
        const Color(0xff00387B),
        const Color(0xff3B609D),
      ],
      [
        const Color(0xff008C84),
        const Color(0xff2CB191),
      ],
    ],
    [
      [
        const Color(0xff008C84),
        const Color(0xff2CB191),
      ],
      [
        const Color(0xff00387B),
        const Color(0xff3B609D),
      ],
      [
        const Color(0xffC36900),
        const Color(0xffD48246),
      ],
      [
        const Color(0xff6700B8),
        const Color(0xffA945E7),
      ],
    ],
  ];

  void getData() async {
    final response = await dio.get("http://10.0.2.2:53000/categories");
    if (response.statusCode == 200) {
      setState(() {
        for (var i in response.data) {
          categoryList.add(Category.fromJson(i));
          for (var j in i["subCategories"]) {
            subCategoryList.add(SubCategory.fromJson(j));
          }
        }
      });
      log(subCategoryList.toString());
    } else {}
  }

  @override
  void initState() {
    super.initState();
    getData();
    getHistoryData();
  }

  // Получаем уже открытую коробку
  final Box hBox = Hive.box('historyBox');

  List<dynamic> historyList = [];
  Map<dynamic, dynamic> historyItem = {};
  List<String> historyTime = [];

  void getHistoryData() {
    final times = hBox.get('timeList', defaultValue: []);
    for (var i in times) {
      historyList.add({i: hBox.get(i, defaultValue: [])});
    }
    log(historyList.toString());
  }

  @override
  Widget build(BuildContext context) {
    return CupertinoPageScaffold(
        navigationBar: const CupertinoNavigationBar(
          backgroundColor: Colors.black,
          middle: Text(
            'Главная',
            style: TextStyle(fontWeight: FontWeight.w400, fontSize: 20),
          ),
        ),
        child: SafeArea(
            child: SafeArea(
                child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'История',
                    style: TextStyle(fontSize: 20),
                  ),
                  SizedBox(
                    height: 130,
                    child: ListView.separated(
                      itemCount: 3,
                      scrollDirection: Axis.horizontal,
                      separatorBuilder: (context, index) {
                        return const SizedBox(
                          width: 10,
                        );
                      },
                      itemBuilder: (context, index) {
                        return GestureDetector(
                          onTap: () {
                            Navigator.push(
                                context,
                                CupertinoPageRoute(
                                    builder: (context) =>  ChatScreen()));
                          },
                          child: Container(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 15, vertical: 10),
                            width: 320,
                            decoration: BoxDecoration(
                              color: Colors.white.withOpacity(0.1),
                              borderRadius: BorderRadius.circular(15),
                            ),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Text(
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                  'Какая самая длинная река?',
                                  style: TextStyle(fontSize: 18),
                                ),
                                Container(
                                  margin:
                                      const EdgeInsets.symmetric(vertical: 10),
                                  height: 2,
                                  width: double.infinity,
                                  decoration: BoxDecoration(
                                    color: Colors.white.withOpacity(0.2),
                                    borderRadius: BorderRadius.circular(3),
                                  ),
                                )
                              ],
                            ),
                          ),
                        );
                      },
                    ),
                  )
                ],
              ),
            ),
          ],
        ))));
  }
}
