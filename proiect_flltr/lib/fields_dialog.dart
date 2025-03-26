import 'package:flutter/material.dart';

import 'StyledText.dart';
import 'add_procedures.dart';

void addDialog(String _error,
    int colNr,
    List<String> tableElements,
    List<TextEditingController> controllers,
    BuildContext context,
    String name,
    bool mod) {

  for(int i = 0; i < colNr; i++) {
    controllers.add(TextEditingController());
  }

  showDialog(barrierDismissible: false, context: context, builder: (BuildContext context) {
    return StatefulBuilder(
      builder: (BuildContext context, void Function(void Function()) setState) {
        return AlertDialog(
          backgroundColor: Colors.blue[500],
          title: StyledText(_error, clr: Colors.red, size: 24,),
          content: SizedBox(
            height: 100+colNr*50,
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
                    readOnly: (index==0 && name != 'user')?true:false,
                    controller: controllers[index],
                    decoration: InputDecoration(
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(100.0),
                      ),
                      filled: true,
                      hintStyle: TextStyle(color: Colors.grey[800]),
                      hintText: tableElements[index],
                      fillColor: Colors.white70,
                    ),
                    onChanged: (String value){},
                  ),
                );
              },
              itemCount: colNr,
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 1, mainAxisExtent: 50, mainAxisSpacing: 16, crossAxisSpacing: 8),
            ),
          ),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                for(int i = 0; i < colNr; i++)
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
                  _error = await addToTable(name, controllers, _error);

                  setState((){
                    _error = _error;
                  });

                if(_error.isEmpty)
                  {
                    Navigator.of(context).pop();
                    tableElements.add((int.parse(tableElements[tableElements.length - colNr])+1).toString());
                    for(int i = 1; i < colNr; i++)
                    {
                      tableElements.add(controllers[i].text);
                    }
                  }
              },
              child: const StyledText('ADD'),
            ),

          ],
        ); },

    );
  });
}
