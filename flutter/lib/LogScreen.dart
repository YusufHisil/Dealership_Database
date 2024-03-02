import 'package:flutter/material.dart';
import 'package:proiect_bd/Wallpaper.dart';
import 'package:mysql_client/mysql_client.dart';
import 'package:proiect_bd/table_select.dart';

import 'StyledText.dart';

class LogScreen extends StatefulWidget {
  const LogScreen({super.key});

  @override
  State<LogScreen> createState() => _LogScreenState();
}

class _LogScreenState extends State<LogScreen> {
  bool passVisibility = false;
  TextEditingController _userController = TextEditingController();
  TextEditingController _passController = TextEditingController();
  String _user ='';
  String _pass='';
  String _error = '';

  Future<void> tryConnect(BuildContext context) async {
    print("Connecting to mysql server...");

    String role ='';

    // create connection
    final conn = await MySQLConnection.createConnection(
      host: 'localhost',
      port: 3306,
      userName: "root",
      password: "qwsdcvghyu123",
      databaseName: "mydb", // optional
    );
    await conn.connect();

    var result = await conn.execute("SELECT * FROM user WHERE Username= '$_user' AND Password='$_pass'");
    //print(result.cols.first.name);
    if(result.numOfRows==0)
    {
      setState(() {
        _error = 'Invalid user or password';
      });
      await conn.close();
      print("invalid entry");
    }
    else {
      String idUser = result.rows.first.colByName('idUser')!;
      result = await conn.execute("SELECT * FROM angajat WHERE idAngajat='$idUser';");
      role = result.rows.first.colByName('Rol')!;
      //print(result.rows.first.assoc().entries.map((e){ return e.value;}).toList().toString());
      Navigator.of(context).push(
        MaterialPageRoute(builder: (context) => Home(role, idUser: idUser,)),
      );
    setState(() {
    _error = '';
    _user = '';
    _pass = '';
    _userController.clear();
    _passController.clear();
    });
      print("connected!");
      await conn.close();
    }

  }

  @override
  void dispose() {
    super.dispose();
    _userController.dispose();
    _passController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Wallpaper(
        stackChildren:[
        Column(
          mainAxisAlignment: MainAxisAlignment.center,
          mainAxisSize: MainAxisSize.max,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            //const SizedBox(height: 210),
            const StyledText(
              '     WELCOME TO AUTOWORLD', clr: Colors.white, size: 70

              ),
            const SizedBox(height: 30),
            Container(
              width: 200,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(100.0),
              ),
              child: TextField(
                controller: _userController,
                decoration: InputDecoration(
                  isDense: true,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(100.0),
                  ),
                  filled: true,
                  hintStyle: TextStyle(color: Colors.grey[800]),
                  hintText: "Username",
                  fillColor: Colors.white70,
                ),
                onChanged: (String value){_user = value;},
              ),
            ),
            const SizedBox(height: 10),
            Container(
              width: 200,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(100.0),
              ),
              child: TextField(
                controller: _passController,
                obscureText: !passVisibility,
                decoration: InputDecoration(
                  isDense: true,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(100.0),
                  ),
                  suffixIcon: IconButton(
                    icon: Icon(
                      // Based on passwordVisible state choose the icon
                      passVisibility ? Icons.visibility : Icons.visibility_off,
                      color: Theme.of(context).primaryColorDark,
                    ),
                    onPressed: () {
                      // Update the state i.e. toogle the state of passwordVisible variable
                      setState(() {
                        passVisibility = !passVisibility;
                      });
                    },
                  ),
                  filled: true,
                  hintStyle: TextStyle(color: Colors.grey[800]),
                  hintText: "Password",
                  fillColor: Colors.white70,
                ),
                onChanged: (String value){_pass = value;},
                onSubmitted: (String value) async {await tryConnect(context);},
              ),
            ),
            StatefulBuilder(builder: (BuildContext context, StateSetter setState) {
              return SizedBox(height: 25,child: Text(_error, style: const TextStyle(color: Colors.red, fontWeight: FontWeight.bold)));
            }),
            MaterialButton(
              color: Colors.blue[500],
              textColor: Colors.black,
              padding: const EdgeInsets.all(16),
              shape: const CircleBorder(),
              onPressed: () async {await tryConnect(context);},
              child: const Icon(
                Icons.arrow_forward,
                size: 30,
              ),
            ),
          ],
        )
      ]
      ),
    );
  }
}
