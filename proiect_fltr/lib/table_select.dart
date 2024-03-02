///make it so when i connect and call this page in a navigator.push
///i send the role as a parameter to this class, so that i know which tables to display
/// INTREBARI PT BAIETI:
///- avem nevoie de vederi? sa stiu sa invat
// - cum dau call la o functie din sql?
// - niste date cu care sa populez tabelele? aveti sau imi fac eu?
/// make map of String aka the role to <String>[] of table names for generating the buttons with ListTile

import 'package:flutter/material.dart';
import 'package:mysql_client/mysql_client.dart';
import 'package:proiect_bd/StyledText.dart';
import 'package:proiect_bd/table.dart';
import 'package:proiect_bd/table_view.dart';
import 'Wallpaper.dart';

class Home extends StatefulWidget {
  const Home(this.role, {super.key, required this.idUser});

  final String idUser;
  final String role;

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {

  late int colNr;
  List<String> tableElements= [];

  final List<String> tables = <String>[
    'agent_vanzare',
    'angajat',
    'atelier',
    'client',
    'comanda',
    'depozit_distribuitor',
    'distribuitor',
    'factura_serviciu',
    'factura_vanzare',
    'inventar_masini',
    'inventar_piese',
    'lista_serviciu',
    'masina',
    'mecanic',
    'piesa',
    'piese_necesare_serviciu',
    'programare_atelier',
    'reprezentanta',
    'serviciu_programare',
    'user',
    'vanzare',
  ];

  final Map<String, List<int>> privileges = { // 0 is none, 1 is read, 2 is write
    // each index is mapped to the index of tables of the structure above
    //so that i can see the privilege each role has over each table

    //first element is number of visible tables
    'Mecanic':[0,0,0,2,0,0,0,1,0,0,1,1,0,0,0,1,2,0,2,0,0],
    'Agent_vanzari':[0,0,0,2,0,0,0,0,1,1,0,0,1,0,0,0,0,0,0,0,2],
    'Director_reprezentanta':[0,1,0,0,2,0,0,1,1,2,2,0,0,0,0,0,1,0,0,0,1],
    'Director_principal':[2,2,0,0,1,1,1,0,0,0,0,0,0,2,0,0,0,2,0,2,0]
  };

  final Map<String, List<int>> visibleTables = {
    'Mecanic':<int>[18, 16, 11, 15, 3, 7, 10],
    'Agent_vanzari':<int>[9, 12, 20, 8, 3],
    'Director_reprezentanta':<int>[1, 4, 9, 10, 7, 8, 16, 20],
    'Director_principal':<int>[1, 19, 17, 4, 6, 5, 13, 20]
  };

  Future<void> fetchTable(String tableName) async {

    // create connection
    final conn = await MySQLConnection.createConnection(
      host: 'localhost',
      port: 3306,
      userName: "root",
      password: "qwsdcvghyu123",
      databaseName: "mydb", // optional
    );
    await conn.connect();

    var result = await conn.execute("Select * FROM $tableName");
    print(result.numOfRows);

    colNr = result.numOfColumns;

    ResultSetColumn col;
    for(col in result.cols)
      {
        tableElements.add(col.name);
      }

    if(result.numOfRows > 0) {
      result.rowsStream.listen((row) {
      result.rows.first.assoc().entries.map((e){ return e.value;}).toList().toString();
      row.assoc().entries.map((e){return e.value;}).toList().forEach((element) {tableElements.add(element??'');});
    });
    } else
      {
        print("Select statement returned 0 rows!");
      }

    await conn.close();
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
          scrolledUnderElevation: 0,
        iconTheme: const IconThemeData(
          color: Colors.white, //change your color here
        ),
      ),
      backgroundColor: Colors.black,
      body: Wallpaper(
          stackChildren:<Widget>[
            Column(
              children: [
                const StyledText('Tabele', clr: Colors.white, size: 60),
                const SizedBox(height: 70),
                SizedBox(
                  height: MediaQuery.of(context).size.height * 0.6,
                  child: ListView.separated(padding: const EdgeInsets.all(8),
                      itemBuilder: (BuildContext context, int index){
                    return Align(
                      alignment: Alignment.center,
                      child: GestureDetector(
                          onTap: () async {
                            await fetchTable(tables[visibleTables[widget.role]![index]]);
                            Navigator.of(context).push(
                            MaterialPageRoute(builder: (context) => TableView(
                                                                    tables[visibleTables[widget.role]![index]],
                                                                    idUser: widget.idUser,
                                                                    role: widget.role,
                                                                    privilege: privileges[widget.role]![visibleTables[widget.role]![index]],
                                                                    colNr: colNr,
                                                                    tableElements: tableElements,)),
                          );
                            },
                          child: Container(
                            alignment: Alignment.center,
                            height: 45,
                              width: 300,
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(100.0),
                              ),
                              child: StyledText(tables[visibleTables[widget.role]![index]].replaceAll('_', ' ').toUpperCase(), clr: Colors.black, size: 20)
                          )
                      ),
                    );
                      },
                      separatorBuilder: (BuildContext context, int index) => const SizedBox(height: 25),
                      itemCount: visibleTables[widget.role]!.length),
                ),
                Expanded(
                  child: Align(
                    alignment: Alignment.bottomRight,
                    child: StyledText('Conectat ca ${widget.role}', clr:Colors.white, size:MediaQuery.of(context).size.height * 0.025),
                  ),
                )
              ],
            )
          ]
      ),
    );
  }
}
