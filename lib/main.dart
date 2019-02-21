import 'package:flutter/material.dart';
import 'package:provide/provide.dart';

void main() {
  var providers = Providers()..provide(Provider.function((ctx) => Counter(0)));

  runApp(
    ProviderNode(
      child: MyApp(),
      providers: providers,
    ),
  );
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  Counter get _counter => Provide.value<Counter>(context);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text(
              'You have pushed the button this many times:',
            ),
            Provide<Counter>(
              builder: (BuildContext context, Widget child, Counter counter) {
                return Text(
                  '${counter.value}',
                  style: Theme.of(context).textTheme.display1,
                );
              },
            ),
            StreamBuilder<Counter>(
              initialData: _counter,
              stream: Provide.stream<Counter>(context),
              builder: (BuildContext context, AsyncSnapshot<Counter> snapshot) {
                return Text(
                  '${snapshot.data.value}',
                  style: Theme.of(context).textTheme.display1,
                );
              },
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _counter.inc(),
        tooltip: 'Increment',
        child: Icon(Icons.add),
      ),
    );
  }
}

class Counter with ChangeNotifier {
  int _value;

  int get value => _value;

  Counter(this._value);

  void inc() {
    _value++;
    notifyListeners();
  }
}
