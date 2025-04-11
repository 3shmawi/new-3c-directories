import 'package:flutter/material.dart';
import 'package:new_3c/model.dart';

class CounterPage extends StatefulWidget {
  const CounterPage({super.key});

  @override
  State<CounterPage> createState() => _CounterPageState();
}

List<ZkrModel> azkar = [];

class _CounterPageState extends State<CounterPage> {
  int counter = azkar.firstOrNull?.count ?? 0;
  final pageController = PageController(initialPage: 0);
  final titleCtrl = TextEditingController();
  final counterCtrl = TextEditingController();
  final formKey = GlobalKey<FormState>();
  int currentIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Counter Page'),
        actions: [
          PopupMenuButton(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
              itemBuilder: (context) {
                return [
                  PopupMenuItem(
                    onTap: _addOrEditNewZkr,
                    child: ListTile(
                      onTap: _addOrEditNewZkr,
                      leading: Icon(
                        Icons.add_circle_outline,
                        color: Colors.cyan,
                      ),
                      title: Text("Add new zkr"),
                    ),
                  ),
                  PopupMenuItem(
                      child: ListTile(
                    onTap: azkar.isEmpty
                        ? null
                        : () {
                            _addOrEditNewZkr(zkrModel: azkar[currentIndex]);
                          },
                    leading: Icon(
                      Icons.edit,
                      color: Colors.cyan,
                    ),
                    title: Text("Edit zkr"),
                  )),
                  PopupMenuItem(
                      child: ListTile(
                    onTap: azkar.isEmpty ? null : _onPressedDeleteButton,
                    leading: Icon(
                      Icons.delete,
                      color: Colors.red,
                    ),
                    title: Text("Delete zkr"),
                  )),
                ];
              }),
        ],
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
                return RosaryItem(
                  azkar[index],
                  counter,
                  onPressed: _counterClick,
                );
              },
              itemCount: azkar.length,
            ),
      floatingActionButton: azkar.isEmpty
          ? FloatingActionButton(
              onPressed: _addOrEditNewZkr,
              child: Icon(Icons.add),
            )
          : FloatingActionButton(
              onPressed: _counterClick,
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

  void _counterClick() {
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
  }

  void _addOrEditNewZkr({ZkrModel? zkrModel}) {
    if (zkrModel != null) {
      titleCtrl.text = zkrModel.zkr;
      counterCtrl.text = zkrModel.count.toString();
    }
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (context) {
        return Form(
          key: formKey,
          child: SingleChildScrollView(
            child: Padding(
              padding: EdgeInsets.only(
                bottom: MediaQuery.of(context).viewInsets.bottom,
                top: 15,
                right: 15,
                left: 15,
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Align(
                    alignment: Alignment.center,
                    child: const Text(
                      "Add Zkr",
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: Colors.cyan,
                      ),
                    ),
                  ),
                  Divider(),
                  const SizedBox(height: 20),
                  TextFormField(
                    controller: titleCtrl,
                    minLines: 5,
                    maxLines: 5,
                    validator: (title) {
                      if (title!.isEmpty) {
                        return "Please enter a title";
                      }
                      if (title.length < 3) {
                        return "Title should be at least 3 characters";
                      }

                      return null;
                    },
                    decoration: InputDecoration(
                      hintText: "Zkr Title",
                      hintStyle: TextStyle(
                        color: Colors.grey[400],
                      ),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                        borderSide: BorderSide(
                          color: Colors.cyan,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 10),
                  TextFormField(
                    controller: counterCtrl,
                    validator: (counter) {
                      if (counter!.isEmpty) {
                        return "Please enter a number";
                      }
                      if (int.tryParse(counter) == null) {
                        return "Counter should be a number";
                      }
                      if (int.parse(counter) < 1) {
                        return "Counter should be greater than 1";
                      }
                      return null;
                    },
                    decoration: InputDecoration(
                      hintText: "counter..",
                      hintStyle: TextStyle(
                        color: Colors.grey[400],
                      ),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                        borderSide: BorderSide(
                          color: Colors.cyan,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 30),
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                      backgroundColor: Colors.cyan,
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.all(15),
                    ),
                    onPressed: () {
                      _onPressedAddButton(zkrModel: zkrModel);
                    },
                    child: Text(zkrModel == null ? "Add New Zkr" : "Edit Zkr"),
                  ),
                  const SizedBox(height: 30),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  void _onPressedAddButton({ZkrModel? zkrModel}) {
    if (formKey.currentState!.validate()) {
      if (zkrModel == null) {
        if (azkar.isEmpty) {
          counter = int.parse(
            counterCtrl.text,
          );
        }
        azkar.add(
          ZkrModel(
            id: azkar.length + 1,
            zkr: titleCtrl.text,
            count: int.parse(
              counterCtrl.text,
            ),
          ),
        );
      } else {
        counter = int.parse(
          counterCtrl.text,
        );
        azkar.removeAt(currentIndex);
        azkar.insert(
            currentIndex,
            ZkrModel(
              id: currentIndex + 1,
              zkr: titleCtrl.text,
              count: int.parse(
                counterCtrl.text,
              ),
            ));
      }
      titleCtrl.clear();
      counterCtrl.clear();
      Navigator.pop(context);
      setState(() {});
    }
  }

  void _onPressedDeleteButton() {
    setState(() {
      azkar.removeAt(currentIndex);
      currentIndex--;
    });
  }
}

class RosaryItem extends StatelessWidget {
  const RosaryItem(this.zkrModel, this.counter, {this.onPressed, super.key});

  final ZkrModel zkrModel;
  final int counter;
  final Function()? onPressed;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Spacer(),
          GestureDetector(
            onTap: onPressed,
            child: Stack(
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
