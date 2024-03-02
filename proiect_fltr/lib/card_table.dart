import 'package:flutter/material.dart';
import 'package:mysql_client/mysql_client.dart';

import 'StyledText.dart';

///widget to display table with pictures
///as a grid of only one elem, that being the card

class CardTable extends StatelessWidget {
  const CardTable({super.key, required this.elements, required this.nrCol, required this.tabelName, required this.idUser});
  final List<String> elements;
  final int nrCol;
  final String tabelName;
  final String idUser;


  @override
  Widget build(BuildContext context) {
    print(elements);
    return ListView.builder(
      itemCount: elements.length~/nrCol-1,
      itemBuilder: (BuildContext context, int index) {
        return Card(
          margin: const EdgeInsets.all(8.0),
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      for(int i = 0; i < nrCol; i++)
                        Text('${elements[i]}: ${elements[(index+1)*nrCol+i]}')
                    ],
                  ),
                ),
                const SizedBox(width: 16.0), // Add some space between columns
                SizedBox(
                  width: MediaQuery.of(context).size.width * 0.9 * 0.4, // 40% of screen width
                  child: (tabelName != 'angajat')?
                  Image.asset('assets/img/img_$index.jpg', scale: 0.3):
                      Column(
                        children: [MaterialButton(
                          color: Colors.blue[500],
                          padding: const EdgeInsets.all(16),
                          shape: const CircleBorder(),
                          onPressed: () async {
                            final conn = await MySQLConnection.createConnection(
                              host: 'localhost',
                              port: 3306,
                              userName: "root",
                              password: "qwsdcvghyu123",
                              databaseName: "mydb", // optional
                            );
                            await conn.connect();

                            try
                            {
                              await conn.execute("CALL stergeAngajat(${int.parse(idUser)},${int.parse(elements[(index+1)*nrCol])}, @result);");
                              var result = await conn.execute("SELECT @result");
                              if(result.rows.first.assoc().values.first == '1') {
                                showDialog(context: context, builder: (context){
                                  return const AlertDialog(title: Text('Invalid Operation!'),
                                      content: Text('Nu detineti privilegiile pentru aceasta operatie!'));
                                });
                              }
                              else
                                {
                                  for(int i = 0; i < nrCol; i++) {
                                    elements.removeAt((index+1)*nrCol + i);
                                  }
                                }

                            }
                            on Exception catch (e)
                            {
                              print(e);
                              showDialog(context: context, builder: (context){
                                return const AlertDialog(title: Text('Invalid Operation!'),
                                    content: Text('Nu detineti privilegiile pentru aceasta operatie!'));
                              });
                            }
                          },
                          child: const Icon(
                            Icons.delete_forever,
                            size: 40,
                          ),
                        ),
                          SizedBox(height: 16),
                          MaterialButton(
                            color: Colors.blue[500],
                            padding: const EdgeInsets.all(16),
                            shape: const CircleBorder(),
                            onPressed: () async {
                              List<TextEditingController> controllers = [];
                              String _error ='';

                              for(int i = 0; i < nrCol; i++) {
                                controllers.add(TextEditingController());
                              }

                              showDialog(barrierDismissible: false, context: context, builder: (BuildContext context) {
                                return StatefulBuilder(
                                  builder: (BuildContext context, void Function(void Function()) setState) {
                                    return AlertDialog(
                                      backgroundColor: Colors.blue[500],
                                      title: StyledText(_error, clr: Colors.red, size: 24,),
                                      content: SizedBox(
                                        height: 100+nrCol*50,
                                        width: 200,
                                        child: GridView.builder(
                                          shrinkWrap: true,
                                          itemBuilder: (BuildContext context, int index) {
                                            return Container(
                                              alignment: Alignment.center,
                                              decoration: BoxDecoration(
                                                color: Colors.white,
                                                borderRadius: BorderRadius.circular(100.0),
                                              ),
                                              child: TextField(
                                                readOnly: (index==1 || index == 0)?true:false,
                                                controller: controllers[index],
                                                decoration: InputDecoration(
                                                  border: OutlineInputBorder(
                                                    borderRadius: BorderRadius.circular(100.0),
                                                  ),
                                                  filled: true,
                                                  hintStyle: TextStyle(color: Colors.grey[800]),
                                                  hintText: index==0? 'idDir':elements[index-1],
                                                  fillColor: Colors.white70,
                                                ),
                                                onChanged: (String value){},
                                              ),
                                            );
                                          },
                                          itemCount: nrCol,
                                          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 1, mainAxisExtent: 50, mainAxisSpacing: 16, crossAxisSpacing: 8),
                                        ),
                                      ),
                                      actions: <Widget>[
                                        TextButton(
                                          onPressed: () {
                                            for(int i = 0; i < nrCol; i++)
                                            {
                                              controllers[i].text ='';
                                              _error='';
                                            }
                                            Navigator.of(context).pop();
                                          },
                                          child: const StyledText('Cancel'),
                                        ),
                                        TextButton(
                                          onPressed: () async {
                                            final conn = await MySQLConnection.createConnection(
                                              host: 'localhost',
                                              port: 3306,
                                              userName: "root",
                                              password: "qwsdcvghyu123",
                                              databaseName: "mydb", // optional
                                            );
                                            await conn.connect();

                                            try
                                            {
                                              await conn.execute("CALL modificare_angajat("
                                                  "${int.parse(idUser)},"
                                                  "${int.parse(elements[(index+1)*nrCol])},"
                                                  "'${(controllers[2].text)}',"
                                                  "'${(controllers[3].text)}',"
                                                  "'${(controllers[4].text)}',"
                                                  "'${(controllers[5].text)}',"
                                                  "'${(controllers[6].text)}',"
                                                  "${double.parse(controllers[7].text)},"
                                                  "${int.parse(controllers[8].text)},"
                                                  "'${(controllers[9].text)}',"
                                                  "${int.parse(controllers[10].text)}, @result);");
                                              var result = await conn.execute("SELECT @result");
                                              if(result.rows.first.assoc().values.first == '1') {
                                                showDialog(context: context, builder: (context){
                                                  return const AlertDialog(title: Text('Invalid Operation!2'),
                                                      content: Text('Nu detineti privilegiile pentru aceasta operatie!'));
                                                });
                                              }

                                            }
                                            on Exception catch (e)
                                            {
                                              print(e);
                                              showDialog(context: context, builder: (context){
                                                return const AlertDialog(title: Text('Invalid Operation!'),
                                                    content: Text('Nu detineti privilegiile pentru aceasta operatie!'));
                                              });
                                            }


                                            setState(() {
                                              _error = _error;
                                            });
                                            if(_error.isEmpty)Navigator.of(context).pop();
                                          },
                                          child: const StyledText('ADD'),
                                        ),

                                      ],
                                    ); },

                                );
                              });

                            },
                            child: const Icon(
                              Icons.mode,
                              size: 40,
                            ),
                          )],
                      ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}

