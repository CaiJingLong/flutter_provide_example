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

  PageCounter pageCounter = PageCounter(0);
  PageCounter pageCounter2 = PageCounter(0);
  var scope1 = ProviderScope("1");
  var scope2 = ProviderScope("2");
  @override
  Widget build(BuildContext context) {
    return ProviderNode(
      providers: Providers()
        ..provide(Provider.value(pageCounter), scope: scope1)
        ..provide(Provider.value(pageCounter2), scope: scope2),
      child: Scaffold(
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
              Provide<PageCounter>(
                scope: scope1,
                builder:
                    (BuildContext context, Widget child, PageCounter counter) {
                  return Text(
                    '${counter.value}',
                    style: Theme.of(context).textTheme.display1,
                  );
                },
              ),
              Provide<PageCounter>(
                scope: scope2,
                builder:
                    (BuildContext context, Widget child, PageCounter counter) {
                  return Text(
                    '${counter.value}',
                    style: Theme.of(context).textTheme.display1,
                  );
                },
              ),
              StreamBuilder<Counter>(
                initialData: _counter,
                stream: Provide.stream<Counter>(context),
                builder:
                    (BuildContext context, AsyncSnapshot<Counter> snapshot) {
                  return Text(
                    '${snapshot.data.value}',
                    style: Theme.of(context).textTheme.display1,
                  );
                },
              ),
              FlatButton(
                child: Text("nextPage"),
                onPressed: () {
                  Navigator.push(context,
                      MaterialPageRoute(builder: (BuildContext context) {
                    return MyHomePage(
                      title: "new page",
                    );
                  }));
                },
              ),
            ],
          ),
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            _counter.inc();
            pageCounter.inc();
            pageCounter2.rec();
          },
          tooltip: 'Increment',
          child: Icon(Icons.add),
        ),
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

class PageCounter with ChangeNotifier {
  int _value;

  int get value => _value;

  PageCounter(this._value);

  void inc() {
    _value++;
    notifyListeners();
  }

  void rec() {
    _value--;
    notifyListeners();
  }
}
