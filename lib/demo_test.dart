import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class CounterScreenWrapper extends StatelessWidget {
  const CounterScreenWrapper({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => CounterProvider(),
      child: const CounterScreen(), // <- CounterScreen giờ chỉ lo phần UI thôi
    );
  }
}

class CounterProvider with ChangeNotifier {
  int _count = 0;

  int get count => _count;

  // Hàm init cần gọi lúc đầu
  void initCounter() {
    _count = 10; // Ví dụ: lấy giá trị mặc định
    notifyListeners();
  }

  void increment() {
    _count++;
    notifyListeners();
  }
}

class CounterScreen extends StatefulWidget {
  const CounterScreen({super.key});

  @override
  _CounterScreenState createState() => _CounterScreenState();
}

class _CounterScreenState extends State<CounterScreen> {
  @override
  void initState() {
    super.initState();

    // Đợi frame đầu tiên render xong rồi mới gọi init
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<CounterProvider>(context, listen: false).initCounter();
    });
  }

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => CounterProvider(),
      builder: (context, child) {
        WidgetsBinding.instance.addPostFrameCallback((_) {
          Provider.of<CounterProvider>(context, listen: false).initCounter();
        });

        return Scaffold(
          appBar: AppBar(title: Text('Counter Screen')),
          body: Center(
            child: Consumer<CounterProvider>(
              builder: (context, counterProvider, child) {
                return Text('Count: ${counterProvider.count}');
              },
            ),
          ),
          floatingActionButton: FloatingActionButton(
            onPressed: () {
              context.read<CounterProvider>().increment();
            },
            child: Icon(Icons.add),
          ),
        );
      },
    );
  }
}
