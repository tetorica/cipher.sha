// Copyright (c) 2017, kyorohiro. All rights reserved. Use of this source code
// is governed by a BSD-style license that can be found in the LICENSE file.

import 'dart:typed_data' show Uint8List;
import 'package:crypto/crypto.dart' as cry;
import 'dart:math' as math;
import 'package:test/test.dart';
import 'package:cipher.sha/sha1.rfc3174.dart';
import 'package:cipher.sha/sha1.todo.dart' as shb;


void main() {
  test("10b", () {
    testbase(10,100);
  });
  test("16mb", () {
    testbase(16*1024 + 1345,100);
  });
  test("256mb", () {
    testbase(256* 1024*1024 + 1345,1);
  });
  test("512mb", () {
    testbase(512* 1024*1024 + 1345,1);
  });
}

void testbase(int size,int l){
  //
  // make data
  Uint8List data = new Uint8List(size);
  math.Random r = new math.Random();
  for (int i = 0; i < size; i++) {
    data[i] = r.nextInt(0xff) & 0xff;
  }

  //
  // check
  var exp = a(data,l);
  var ret1 = b(data,l);
  var ret2 = c(data,l);
  expect(exp,ret1);
  expect(exp,ret2);
}

List<int> a(Uint8List data,int l) {
  {
    int d1 = new DateTime.now().millisecondsSinceEpoch;
    cry.Digest v;
    for (int i = 0; i < l; i++) {
      cry.Sha1 hasher = cry.sha1;
      v = hasher.convert(data);
    }
    int d2 = new DateTime.now().millisecondsSinceEpoch;
    print(" ${v.bytes}  ${d2 - d1}");
    return v.bytes;
  }
}

List<int> b(Uint8List data,int l) {
  int size = data.length;
  {
    int d1 = new DateTime.now().millisecondsSinceEpoch;
    var v;
    SHA1 sha = new SHA1();
    Uint8List output = new Uint8List(20);
    for (int i = 0; i < l; i++) {
      sha.sha1Reset();
      //sha.sha1Input(data.sublist(0,size~/2),size~/2);
      //sha.sha1Input(data.sublist(size~/2),size~/2);
      sha.sha1Input(data, size);
      v = sha.sha1Result(output: output);
    }
    int d2 = new DateTime.now().millisecondsSinceEpoch;
    print(" ${v}  ${d2 - d1}");
    return v;
  }
}

List<int> c(Uint8List data,int l) {
  int size = data.length;

  {
    int d1 = new DateTime.now().millisecondsSinceEpoch;
    var v;
    shb.SHA1 sha = new shb.SHA1();
    Uint8List output = new Uint8List(20);
    for (int i = 0; i < l; i++)
    {
      sha.sha1Reset();
      sha.sha1Input(data,size);
//      sha.sha1Input(new Uint8List.fromList(data),size);
      v = sha.sha1Result(output: output);
    }
    int d2 = new DateTime.now().millisecondsSinceEpoch;
    print(" ${v}  ${d2-d1}");
    return v;
  }
}
