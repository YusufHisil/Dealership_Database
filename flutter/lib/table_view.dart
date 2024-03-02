import 'package:flutter/material.dart';
import 'package:proiect_bd/table.dart';

import 'StyledText.dart';
import 'Wallpaper.dart';
import 'card_table.dart';
import 'fields_dialog.dart';

class TableView extends StatefulWidget {
  TableView(this.name, {super.key, required this.role, required this.privilege, required this.colNr, required this.tableElements, required this.idUser,});
  final String name;
  final String role;
  final int privilege;
  final int colNr;
  final List<String> tableElements;
  final String idUser;

  @override
  State<TableView> createState() => _TableViewState();
}

class _TableViewState extends State<TableView> {
  String _error ='';
  List<TextEditingController> controllers =[];

  @override
  void dispose() {
    super.dispose();
    controllers.forEach((element) {element.dispose();});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
          backgroundColor: Colors.transparent,
          elevation: 0,
          scrolledUnderElevation: 0,

        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: ()  {
            Navigator.of(context).pop();
            widget.tableElements.clear();
            },
        ),
      ),
        extendBodyBehindAppBar: true,
      body: Wallpaper(
        stackChildren: [
          Column(
            children: [
              StyledText(widget.name.replaceAll('_', ' ').toUpperCase(), clr: Colors.white, size: 60),
              SizedBox(height: MediaQuery.of(context).size.height*0.05),///search/sort,
              Expanded(
                  child: (widget.name == 'masina' || widget.name == 'angajat')?CardTable(idUser: widget.idUser,tabelName:widget.name, elements: widget.tableElements, nrCol: widget.colNr,):DisplayTable(colNumber: widget.colNr, elements: widget.tableElements, privilege: widget.privilege,)),
              Visibility(
                visible: widget.privilege>1?true:false,
                child:  Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    MaterialButton(
                        color: Colors.blue[500],
                        padding: const EdgeInsets.all(16),
                        shape: const CircleBorder(),
                        onPressed: () {
                          addDialog(_error, widget.colNr, widget.tableElements, controllers, context, widget.name, false);
                        },
                        child: const Icon(
                          Icons.add,
                          size: 40,
                        ),
                      ),
                    MaterialButton(
                      color: Colors.blue[500],
                      padding: const EdgeInsets.all(16),
                      shape: const CircleBorder(),
                      onPressed: () {
                        setState(() {});
                      },
                      child: const Icon(
                        Icons.refresh,
                        size: 40,
                      ),
                    )]
                  ),
                ),
              Align(
                  alignment: Alignment.bottomRight,
                  child: StyledText('Conectat ca ${widget.role}', clr:Colors.white, size:MediaQuery.of(context).size.height * 0.025),
                ),

            ],
          )
        ]
      )
    );
  }
}
