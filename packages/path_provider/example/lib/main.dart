// Copyright 2019 The Flutter Authors. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

import 'dart:async';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Path Provider',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: MyHomePage(title: 'Path Provider'),
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
  Future<Directory> _tempDirectory;
  Future<Directory> _appSupportDirectory;
  Future<Directory> _appDocumentsDirectory;
  Future<Directory> _externalDocumentsDirectory;
  Future<List<Directory>> _externalStorageDirectories;
  Future<List<Directory>> _externalCacheDirectories;

  void _requestTempDirectory() {
    setState(() {
      _tempDirectory = getTemporaryDirectory();
    });
  }

  Widget _buildDirectory(
      BuildContext context, AsyncSnapshot<Directory> snapshot) {
    Text text = const Text('');
    if (snapshot.connectionState == ConnectionState.done) {
      if (snapshot.hasError) {
        text = Text('Error: ${snapshot.error}');
      } else if (snapshot.hasData) {
        text = Text('path: ${snapshot.data.path}');
      } else {
        text = const Text('path unavailable');
      }
    }
    return Padding(padding: const EdgeInsets.all(16.0), child: text);
  }

  Widget _buildDirectories(
      BuildContext context, AsyncSnapshot<List<Directory>> snapshot) {
    Text text = const Text('');
    if (snapshot.connectionState == ConnectionState.done) {
      if (snapshot.hasError) {
        text = Text('Error: ${snapshot.error}');
      } else if (snapshot.hasData) {
        final String combined =
            snapshot.data.map((Directory d) => d.path).join(', ');
        text = Text('paths: $combined');
      } else {
        text = const Text('path unavailable');
      }
    }
    return Padding(padding: const EdgeInsets.all(16.0), child: text);
  }

  void _requestAppDocumentsDirectory() {
    setState(() {
      _appDocumentsDirectory = getApplicationDocumentsDirectory();
    });
  }

  void _requestAppSupportDirectory() {
    setState(() {
      _appSupportDirectory = getApplicationSupportDirectory();
    });
  }

  void _requestExternalStorageDirectory() {
    setState(() {
      _externalDocumentsDirectory = getExternalStorageDirectory();
    });
  }

  void _requestExternalStorageDirectories(String type) {
    setState(() {
      _externalStorageDirectories = getExternalStorageDirectories(type);
    });
  }

  void _requestExternalCacheDirectories() {
    setState(() {
      _externalCacheDirectories = getExternalCacheDirectories();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: <Widget>[
            Column(
              children: <Widget>[
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: RaisedButton(
                    child: const Text('Get Temporary Directory'),
                    onPressed: _requestTempDirectory,
                  ),
                ),
              ],
            ),
            FutureBuilder<Directory>(
                future: _tempDirectory, builder: _buildDirectory),
            Column(
              children: <Widget>[
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: RaisedButton(
                    child: const Text('Get Application Documents Directory'),
                    onPressed: _requestAppDocumentsDirectory,
                  ),
                ),
              ],
            ),
            FutureBuilder<Directory>(
                future: _appDocumentsDirectory, builder: _buildDirectory),
            Expanded(
              child: FutureBuilder<Directory>(
                  future: _appDocumentsDirectory, builder: _buildDirectory),
            ),
            Column(
              children: <Widget>[
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: RaisedButton(
                    child: const Text('Get Application Support Directory'),
                    onPressed: _requestAppSupportDirectory,
                  ),
                ),
              ],
            ),
            Expanded(
              child: FutureBuilder<Directory>(
                  future: _appSupportDirectory, builder: _buildDirectory),
            ),
            Column(children: <Widget>[
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: RaisedButton(
                  child: Text(
                      '${Platform.isIOS ? "External directories are unavailable " "on iOS" : "Get External Storage Directory"}'),
                  onPressed:
                      Platform.isIOS ? null : _requestExternalStorageDirectory,
                ),
              ),
            ]),
            FutureBuilder<Directory>(
                future: _externalDocumentsDirectory, builder: _buildDirectory),
            Column(children: <Widget>[
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: RaisedButton(
                  child: Text(
                      '${Platform.isIOS ? "External directories are unavailable " "on iOS" : "Get External Storage Directories"}'),
                  onPressed: Platform.isIOS
                      ? null
                      : () => _requestExternalStorageDirectories(null),
                ),
              ),
            ]),
            FutureBuilder<List<Directory>>(
                future: _externalStorageDirectories,
                builder: _buildDirectories),
            Column(children: <Widget>[
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: RaisedButton(
                  child: Text(
                      '${Platform.isIOS ? "External directories are unavailable " "on iOS" : "Get External Cache Directories"}'),
                  onPressed:
                      Platform.isIOS ? null : _requestExternalCacheDirectories,
                ),
              ),
            ]),
            FutureBuilder<List<Directory>>(
                future: _externalCacheDirectories, builder: _buildDirectories),
          ],
        ),
      ),
    );
  }
}
