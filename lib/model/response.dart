// To parse this JSON data, do
//
//     final response = responseFromJson(jsonString);
// @dart=2.9
import 'dart:convert';

List<List<Response>> responseFromJson(String str) => List<List<Response>>.from(json.decode(str).map((x) => List<Response>.from(x.map((x) => Response.fromJson(x)))));

String responseToJson(List<List<Response>> data) => json.encode(List<dynamic>.from(data.map((x) => List<dynamic>.from(x.map((x) => x.toJson())))));

class Response {
  Response({
    this.nBest,
    this.src,
    this.tgt,
  });

  int nBest;
  String src;
  String tgt;

  factory Response.fromJson(Map<String, dynamic> json) => Response(
    nBest: json["n_best"],
    src: json["src"],
    tgt: json["tgt"],
  );

  Map<String, dynamic> toJson() => {
    "n_best": nBest,
    "src": src,
    "tgt": tgt,
  };

  @override
  String toString() {
    return 'Response{nBest: $nBest, src: $src, tgt: $tgt}';
  }
}
