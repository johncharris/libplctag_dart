import 'package:flutter/material.dart';
import 'package:libplctag_dart/data_types/iplc_mapper.dart';
import 'package:libplctag_dart/data_types/tag_info.dart';
import 'package:libplctag_dart/data_types/tag_info_plc_mapper.dart';
import 'package:libplctag_dart/plc_type.dart';
import 'package:libplctag_dart/protocol.dart';
import 'package:libplctag_dart/tag_of_t.dart';
import 'package:libplctag_dart/data_types/int_plc_mapper.dart';
import 'package:libplctag_dart/data_types/bool_plc_mapper.dart';
import 'package:libplctag_dart/data_types/sint_plc_mapper.dart';
import 'package:libplctag_dart/data_types/real_plc_mapper.dart';
import 'package:libplctag_dart/data_types/lint_plc_mapper.dart';
import 'package:libplctag_dart/data_types/string_plc_mapper.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key}) : super(key: key);

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  List<TagInfo> tags = <TagInfo>[];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Lib Plc Tag"),
      ),
      body: Flex(
        direction: Axis.vertical,
        children: [
          ElevatedButton(onPressed: () => _getTags(), child: const Text("Get Tags")),
          Expanded(
            child: ListView.builder(
              itemBuilder: (_, index) => ListTile(
                title: Text(tags[index].name),
                trailing: Text(_getValue(tags[index])),
              ),
              itemCount: tags.length,
            ),
          )
        ],
      ),
    );
  }

  _getTags() async {
    var tag = Tag(TagInfoPlcMapper())
      ..gateway = "192.168.39.170"
      ..path = "1,0"
      ..plcType = PlcType.ControlLogix
      ..protocol = Protocol.AllenBradleyEIP
      ..name = "@tags"
      ..timeout = const Duration(seconds: 10);

    tag.Read();

    if (tag.Value != null) {
      setState(() {
        tags = tag.Value!;
        tags.sort((a, b) => a.name.compareTo(b.name));
      });
    }
  }

  String _getValue(TagInfo tagInfo) {
    IPlcMapper? mapper;
    if (tagInfo.type == 0xC1) {
      mapper = BoolPlcMapper();
      // else if (tagInfo.type == 0xD3) mapper = DwordPlcMapper();
    } else if (tagInfo.type == 0xC2) {
      mapper = SintPlcMapper();
    } else if (tagInfo.type == 0xC3) {
      mapper = IntPlcMapper();
    } else if (tagInfo.type == 0xCA) {
      mapper = RealPlcMapper();
    } else if (tagInfo.type == 0xC4) {
      mapper = LintPlcMapper();
    } else if (tagInfo.type == 36814) {
      mapper = StringPlcMapper();
    }

    if (mapper != null) {
      var tag = Tag(mapper)
        ..gateway = "192.168.39.170"
        ..path = "1,0"
        ..plcType = PlcType.ControlLogix
        ..protocol = Protocol.AllenBradleyEIP
        ..name = tagInfo.name
        ..timeout = const Duration(seconds: 10);

      tag.Read();
      return tag.Value.toString();
    } else {
      print(tagInfo);
    }

    return "";
  }
}
