import 'package:flutter/material.dart';
import 'package:proiect_bd/StyledText.dart';

///widget for displaying a table using a grid
///takes parameters the number of elements and the elements themselves


class DisplayTable extends StatefulWidget {
  const DisplayTable({super.key, required this.colNumber, required this.elements, required this.privilege});
  final int colNumber;
  final List<String> elements;
  final int privilege;

  @override
  State<DisplayTable> createState() => _DisplayTableState();
}

class _DisplayTableState extends State<DisplayTable> {
  @override
  Widget build(BuildContext context) {
    return Column(
      
      children: [
        Expanded(
          child: SizedBox(
            width: widget.colNumber*200,
            child: GridView.builder(itemCount: widget.elements.length,
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: widget.colNumber, mainAxisExtent: 75000/MediaQuery.of(context).size.width, crossAxisSpacing: 16, mainAxisSpacing: 16),
                itemBuilder: (context, index){
              return Container(
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(100.0),
                ),
                child: StyledText(widget.elements[index], clr: Colors.black, size: 15,),
              );
                }),
          ),
        ),
      ],
    );
  }
}
