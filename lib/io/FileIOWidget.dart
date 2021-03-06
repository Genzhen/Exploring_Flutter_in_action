import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_app/common/CommonShowModel.dart';
import 'package:path_provider/path_provider.dart';

///author: yang yi
///email: yangyirunning@163.com
class FileIOWidget extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return FileIOState();
  }
}

class FileIOState extends State<FileIOWidget> {
  String cacheDir = "";
  String packageDir = "";
  String sdCardDir = "";
  String content = "";

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    final arg = ModalRoute.of(context).settings.arguments;
    return Scaffold(
      appBar: getAppBar(arg),
      body: Column(
        children: <Widget>[
          Container(
            child: GridView.builder(
              padding: EdgeInsets.all(10),
              shrinkWrap: true,
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 3,
                mainAxisSpacing: 10,
                crossAxisSpacing: 1.5,
              ),
              itemBuilder: (BuildContext context, int index) {
                return getRaisedButtonList()[index];
              },
              itemCount: getRaisedButtonList().length,
            ),
          ),
          Expanded(
            child: Container(
              alignment: Alignment.center,
              margin: EdgeInsets.fromLTRB(10, 0, 10, 10),
              width: MediaQuery.of(context).size.width,
              color: Colors.blue[100],
              child: Text(
                content,
                style: TextStyle(fontSize: 20, color: Colors.grey),
              ),
            ),
          ),
        ],
      ),
    );
  }

  List<RaisedButton> getRaisedButtonList() {
    List<RaisedButton> raisedButtonList = [];

    RaisedButton cacheButton = RaisedButton(
      child: Text(
        "获取缓存路径",
        style: TextStyle(fontSize: 16),
      ),
      color: Colors.blue,
      textColor: Colors.white,
      onPressed: () {
        setState(() {
          //相当于Android中的getCacheDir()
          getCacheDir().then((v) {
            cacheDir = v;
          });
          content = cacheDir;
          print(content);
        });
      },
    );

    RaisedButton packageButton = RaisedButton(
      child: Text(
        "获取应用包路径",
        style: TextStyle(fontSize: 16),
      ),
      color: Colors.blue,
      textColor: Colors.white,
      onPressed: () {
        setState(() {
          getApplicationDocumentsDir().then((v) {
            packageDir = v;
          });
          content = packageDir;
          print(content);
        });
      },
    );

    RaisedButton sdCardButton = RaisedButton(
      child: Text(
        "获取SD卡路径",
        style: TextStyle(fontSize: 16),
      ),
      color: Colors.blue,
      textColor: Colors.white,
      onPressed: () {
        setState(() {
          //相当于Android的getExternalStorageDirectory()
          getExternalStorageDir().then((v) {
            sdCardDir = v;
          });
          content = sdCardDir;
          print(content);
        });
      },
    );

    RaisedButton writeToApplicationDirButton = RaisedButton(
      child: Text(
        '将"踩坑Fultter"写入应用包路径下(也可用SP)',
        style: TextStyle(fontSize: 16),
      ),
      color: Colors.blue,
      textColor: Colors.white,
      onPressed: () {
        setState(() {
          getApplicationDocumentsDir().then((v) {
            packageDir = v;
            return packageDir;
          }).then((v) {
            return new File(packageDir + "/踩坑Flutter.txt");
          }).then((v) {
            setState(() {
              content = "将内容写入 $v 中";
            });
            return v.writeAsString("踩坑Flutter " * 10);
          }).whenComplete(() {
            print("写入文件完成");
          });
        });
      },
    );

    RaisedButton readFromApplicationDirButton = RaisedButton(
      child: Text(
        '从应用包路径下读取写入的内容',
        style: TextStyle(fontSize: 16),
      ),
      color: Colors.blue,
      textColor: Colors.white,
      onPressed: () {
        setState(() {
          getApplicationDocumentsDir().then((v) {
            packageDir = v;
            return packageDir;
          }).then((v) {
            return new File(packageDir + "/踩坑Flutter.txt");
          }).then((v) {
            return v.readAsString();
          }).then((v) {
            content = "读取的内容为: $v";
          }).whenComplete(() {
            print("读取文件完成");
          });
        });
      },
    );

    RaisedButton clearFileButton = RaisedButton(
      child: Text(
        '清除文件',
        style: TextStyle(fontSize: 16),
      ),
      color: Colors.blue,
      textColor: Colors.white,
      onPressed: () {
        setState(() {
          getApplicationDocumentsDir().then((v) {
            packageDir = v;
            return packageDir;
          }).then((v) {
            return new File(packageDir + "/踩坑Flutter.txt");
          }).then((v) {
            setState(() {
              content = "清除 $v 文件";
            });
            return v.delete();
          }).whenComplete(() {
            print("清除文件完成");
          });
        });
      },
    );

    raisedButtonList.add(cacheButton);
    raisedButtonList.add(packageButton);
    raisedButtonList.add(sdCardButton);
    raisedButtonList.add(writeToApplicationDirButton);
    raisedButtonList.add(readFromApplicationDirButton);
    raisedButtonList.add(clearFileButton);

    return raisedButtonList;
  }

  Future<String> getCacheDir() async {
    return (await getTemporaryDirectory()).path;
  }

  Future<String> getApplicationDocumentsDir() async {
    return (await getApplicationDocumentsDirectory()).path;
  }

  Future<String> getExternalStorageDir() async {
    return (await getExternalStorageDirectory()).path;
  }

  File getFile(String fileName) {
    return new File(fileName);
  }
}
