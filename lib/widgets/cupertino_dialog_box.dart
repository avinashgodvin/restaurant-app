import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class MyStatefulWidget extends StatefulWidget {
  const MyStatefulWidget({Key? key}) : super(key: key);

  @override
  State<MyStatefulWidget> createState() => _MyStatefulWidgetState();
}

class _MyStatefulWidgetState extends State<MyStatefulWidget> {
  @override
  Widget build(BuildContext context) {
    return CupertinoPageScaffold(
      child: Center(
        child: CupertinoButton(
          onPressed: () {
            showCupertinoDialog<void>(
              context: context,
              builder: (BuildContext context) => CupertinoAlertDialog(
                title: const Text('Alert'),
                content: const Text('Proceed with destructive action?'),
                actions: <CupertinoDialogAction>[
                  CupertinoDialogAction(
                    child: const Text('No'),
                    onPressed: () {
                      Navigator.pop(context);
                    },
                  ),
                  CupertinoDialogAction(
                    child: const Text('Yes'),
                    isDestructiveAction: true,
                    onPressed: () {
                      // Do something destructive.
                    },
                  )
                ],
              ),
            );
          },
          child: const Text('CupertinoAlertDialog'),
        ),
      ),
    );
  }
}
