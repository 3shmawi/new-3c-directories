import 'package:flutter/material.dart';
import 'package:new_3c/model.dart';

class CounterPage extends StatefulWidget {
  const CounterPage({super.key});

  @override
  State<CounterPage> createState() => _CounterPageState();
}

List<ZkrModel> azkar = [
  ZkrModel(
    id: 1,
    zkr: "أستغفر الله",
    count: 10,
  ),
  ZkrModel(
    id: 2,
    zkr: "سبحان الله",
    count: 10,
  ),
  ZkrModel(
    id: 3,
    zkr: "الحمد لله",
    count: 10,
  ),
];

class _CounterPageState extends State<CounterPage> {
  int counter = azkar.firstOrNull?.count ?? 0;
  final pageController = PageController(initialPage: 0);

  int currentIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Counter Page'),
      ),
      body: azkar.isEmpty
          ? Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(
                    Icons.warning,
                    size: 100,
                    color: Colors.cyan,
                  ),
                  const Text(
                    "No Azkar Available",
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.w400,
                      color: Colors.grey,
                    ),
                  ),
                ],
              ),
            )
          : PageView.builder(
              controller: pageController,
              itemBuilder: (context, index) {
                return RosaryItem(azkar[index], counter);
              },
              itemCount: azkar.length,
            ),
      floatingActionButton: azkar.isEmpty
          ? FloatingActionButton(
              onPressed: () {
                showModalBottomSheet(
                    context: context,
                    builder: (context) {
                      //todo add zkr
                      return SizedBox();
                    });
              },
              child: Icon(Icons.add),
            )
          : FloatingActionButton(
              onPressed: () {
                setState(() {
                  if (currentIndex == azkar.length - 1 && counter == 0) {
                    pageController.jumpToPage(0);
                    currentIndex = 0;
                    counter = azkar[currentIndex].count;
                  } else if (counter <= 0) {
                    currentIndex++;
                    counter = azkar[currentIndex].count;
                    pageController.nextPage(
                      duration: const Duration(milliseconds: 300),
                      curve: Curves.easeIn,
                    );
                  } else {
                    counter--;
                  }
                });
              },
              child: Icon(
                (currentIndex == azkar.length - 1 && counter == 0)
                    ? Icons.refresh
                    : counter <= 0
                        ? Icons.navigate_next
                        : Icons.touch_app_outlined,
              ),
            ),
    );
  }
}

class RosaryItem extends StatelessWidget {
  const RosaryItem(this.zkrModel, this.counter, {super.key});

  final ZkrModel zkrModel;
  final int counter;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Spacer(),
          Stack(
            alignment: Alignment.center,
            children: [
              SizedBox(
                height: 300,
                width: 300,
                child: CircularProgressIndicator(
                  value: counter / zkrModel.count,
                  strokeWidth: 10,
                  backgroundColor: Colors.grey[300],
                  color: Colors.green,
                  strokeCap: StrokeCap.round,
                ),
              ),
              Text(
                "$counter",
                style: TextStyle(
                  fontSize: 70,
                  fontWeight: FontWeight.bold,
                  color: Colors.cyan,
                ),
              ),
            ],
          ),
          Spacer(),
          Text(
            zkrModel.zkr,
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: Colors.cyan,
            ),
          ),
          Spacer(),
          Spacer(),
        ],
      ),
    );
  }
}
