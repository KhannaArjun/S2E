// @dart=2.9
import 'package:http/http.dart' as http;
import 'package:translator2/model/response.dart';

class ApiServices
{
  static const String BASE_URL = "http://sanskrittranslator2.herokuapp.com/";

  static Future<List<List<Response>>> getResponse(String input) async
  {
    final response = await http.get(Uri.parse(BASE_URL + "/translate?enter_word=" + input));


    try
    {
      if(response.statusCode == 200)
      {
        List<List<Response>> responseList = responseFromJson(response.body);

        print("list");
        print(responseList);

        return responseList;
      }
      else
      {
        return List<List<Response>>();
      }
    }
    catch(e)
    {
      print("Error");
    }

  }
}