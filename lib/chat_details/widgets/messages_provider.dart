import 'package:flutter/material.dart';

class StringListProvider extends InheritedWidget {
  final StringListState data;

  const StringListProvider({
    required this.data,
    required super.child,
    super.key,
  });

  static StringListState of(BuildContext context) {
    final provider =
        context.dependOnInheritedWidgetOfExactType<StringListProvider>();
    assert(provider != null, 'No StringListProvider found in context');
    return provider!.data;
  }

  @override
  bool updateShouldNotify(StringListProvider oldWidget) => true;
}

class StringList extends StatefulWidget {
  final Widget child;

  const StringList({super.key, required this.child});

  @override
  State<StringList> createState() => StringListState();
}

class StringListState extends State<StringList> {
  List<String> strings = ['Apple', 'Banana', 'Cherry'];

  void addString(String newItem) {
    setState(() {
      strings.add(newItem);
    });
  }

  void removeString(String item) {
    setState(() {
      strings.remove(item);
    });
  }

  @override
  Widget build(BuildContext context) {
    return StringListProvider(
      data: this,
      child: widget.child,
    );
  }
}
