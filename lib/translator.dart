// @dart=2.9
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:translator2/services/authservice.dart';
import 'model/response.dart';
import 'services/api_services.dart';

class Translator extends StatefulWidget
{
  String email;

  Translator(this.email, {Key key}) : super(key: key);



  @override
  _TranslatorState createState() => _TranslatorState(email);
}

class _TranslatorState extends State<Translator> {
  List<List<Response>> responseList;

  /*@override
  void initState() {
    // TODO: implement initState
    super.initState();

    ApiServices.getResponse().then((response) {
      response = _responseList;
    });
  }*/

  String input, response = "", email = "";
  bool shouldDisplay = false;
  bool _loading = false;

  _TranslatorState(this.email);

  String callApi() {
    ApiServices.getResponse(input).then((responseFromApi) {
      responseList = responseFromApi;

      response = responseList.first.first.tgt;

      print("Response");
      print(response);
      print(responseList.first.first.tgt);
      print(responseList);

      setState(() {
        response = responseList.first.first.tgt;
        _loading = false;
      });
    });

    print("Response ...  " + response);

    return response;
  }

  bool _validate = false;
  final _textField = TextEditingController();
  Color orangeColor = Color(0xFFEF6C00);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text(
            'Translator',
          style: TextStyle(
              color: Colors.white, fontFamily: 'Trueno'),
        ),
        actions: <Widget>[
          _loadingBar(),
        ],
        backgroundColor: Colors.blue[60],
      ),
      resizeToAvoidBottomInset: false,
      body: Container(
        color: Colors.blue[50],
        child: Center(
          child: Column(
            children: [
              Container(
                margin: EdgeInsets.fromLTRB(20.0, 10.0, 20.0, 10.0),
                child: TextFormField(
                  controller: _textField,
                    decoration: InputDecoration(
                        errorText: _validate ? 'Please enter input' : null,
                        labelText: 'Enter Input',
                        labelStyle: TextStyle(
                            fontFamily: 'Trueno',
                            fontSize: 12.0,
                            color: Colors.blue[60]),
                        focusedBorder: UnderlineInputBorder(
                          borderSide: BorderSide(color: Colors.green),
                        )
                    ),
                    obscureText: false,
                    onChanged: (value) {
                      this.input = value;
                    },
                    ),

                /*validator: (value) =>
                value.isEmpty ? 'Password is required' : null*/
              ),
              SizedBox(
                  height: 30.0,
                width: 30.0,
              ),
              GestureDetector(
                onTap: () {
                  //if (checkFields()) AuthService().signIn(email, password, context);
                  print(email);
                  setState(() {
                    _textField.text.isEmpty ? _validate = true : _validate = false;
                  });
                  if(!_validate)
                  {
                    response = "Translating....";
                    setState(() {
                      _loading = true;
                    });

                    String responseData = callApi();
                    response = responseData;
                  }
                },
                child: Container(
                    height: 45.0,
                    width: 150.0,
                    child: Material(
                        borderRadius: BorderRadius.circular(25.0),
                        shadowColor: Colors.greenAccent,
                        color: orangeColor,
                        elevation: 7.0,
                        child: Center(
                            child: Text('Translate',
                                style: TextStyle(
                                    color: Colors.white, fontFamily: 'Trueno'))))),
              ),
              /*Container(
                margin: EdgeInsets.all(10.0),
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(primary: Colors.blue[60]),
                  onPressed: () {
                    setState(() {
                      _textField.text.isEmpty ? _validate = true : _validate = false;
                    });
                    if(!_validate)
                      {
                        response = "Translating....";
                        setState(() {
                          _loading = true;
                        });

                        String responseData = callApi();
                        response = responseData;
                      }

                  },
                  child: Text(
                    'Translate',
                    style: TextStyle(color: Colors.white),
                  ),
                ),
              ),*/

              Container(
                margin: EdgeInsets.all(20.0),
                  child: Text(
              '$response',
              style: TextStyle(
                  color: Colors.black, fontFamily: 'Trueno'))),
              Spacer(),
        Align(
            alignment: Alignment.bottomCenter,
          child: GestureDetector(
            onTap: () {
              AuthService().signOut(context);
            },
            child: Container(
              margin: EdgeInsets.fromLTRB(0, 0, 0, 10.0),
                height: 40.0,
                width: 150.0,
                child: Material(
                    borderRadius: BorderRadius.circular(25.0),
                    shadowColor: Colors.greenAccent,
                    color: Colors.grey,
                    elevation: 7.0,
                    child: Center(
                        child: Text('Logout',
                            style: TextStyle(
                                color: Colors.white, fontFamily: 'Trueno'))))),
          ),
        )],
          ),
        ),
      ),
    );
  }

  final formKey = new GlobalKey<FormState>();

  checkFields() {
    final form = formKey.currentState;
    if (form.validate()) {
      form.save();
      return true;
    }
    return false;
  }

  Widget _loadingBar() {
    return Visibility(
      child: SizedBox.fromSize(
          size: Size.fromRadius(30),
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: CircularProgressIndicator(
              valueColor: AlwaysStoppedAnimation<Color>(
                Colors.white,
              ),
            ),
          )),
      visible: _loading,
    );
  }
}
