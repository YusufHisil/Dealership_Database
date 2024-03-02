import 'package:flutter/material.dart';
import 'package:mysql_client/mysql_client.dart';


Future<String> addToTable(String tableName, List<TextEditingController> controllers, String _error) async
{
    print("Connecting to mysql server...");

    // create connection
    final conn = await MySQLConnection.createConnection(
      host: 'localhost',
      port: 3306,
      userName: "root",
      password: "qwsdcvghyu123",
      databaseName: "mydb", // optional
    );
    await conn.connect();

    var result;
    if(tableName == 'programare_atelier')
      {
        try
        {
          await conn.execute("CALL programare(${int.parse(controllers[2].text)},${int.parse(controllers[1].text)},${int.parse(controllers[3].text)}, '${controllers[4].text}', @result);");
          result = await conn.execute("SELECT @result");
          if(result.rows.first.assoc().values.first == '1') return 'invalid input';

          return '';
        }
        on Exception catch (e)
        {
            return 'invalid input';
        }
      }
    else if( tableName == 'angajat')
      {
        try
        {
          await conn.execute("CALL adaugare_angajat("
              "'${(controllers[1].text)}',"
              "'${(controllers[2].text)}',"
              "'${(controllers[3].text)}',"
              "'${(controllers[4].text)}',"
              "'${(controllers[5].text)}',"
              "${double.parse(controllers[6].text)},"
              "${int.parse(controllers[7].text)},"
              "'${(controllers[8].text)}',"
              "${int.parse(controllers[9].text)},"
              "${int.parse(controllers[10].text)}, @result);");

          result = await conn.execute("SELECT @result");
          if(result.rows.first.assoc().values.first == '1') return 'invalid input';

          return '';
        }
        on Exception catch (e)
        {
          return 'invalid input';
        }
      }
    else if(tableName=="client")
      {
        try {
          await conn.execute(
              "CALL adaugare_client('${(controllers[1].text)}','${(controllers[2]
                  .text)}','${(controllers[3].text)}','${(controllers[4]
                  .text)}','${(controllers[5].text)}');");

          result = await conn.execute("SELECT @result");
          if(result.rows.first.assoc().values.first == '1') return 'invalid input';

          return '';
        }
        on Exception catch (e)
        {
          return 'invalid input';
        }
      }else if(tableName=='comanda')
        {
          try {
            await conn.execute(
                "CALL adaugare_comanda(${int.parse(controllers[1].text)},${int.parse(controllers[2]
                    .text)},${int.parse(controllers[3].text)},${int.parse(controllers[4]
                    .text)}, @result);");

            result = await conn.execute("SELECT @result");
            if(result.rows.first.assoc().values.first == '1') return 'invalid input';

            return '';
          }
          on Exception catch (e)
          {
            return 'invalid input';
          }
        }else if(tableName=='mecanic')
    {
      try {
        await conn.execute(
            "CALL adaugare_mecanic(${int.parse(controllers[1].text)},${int.parse(controllers[2]
                .text)},'${(controllers[3].text)}', @result);");

        result = await conn.execute("SELECT @result");
        if(result.rows.first.assoc().values.first == '1') return 'invalid input';

        return '';
      }
      on Exception catch (e)
      {
        return 'invalid input';
      }
    }else if(tableName=='user')
    {
      try {
        await conn.execute(
            "CALL adaugare_user(${(int.parse(controllers[0].text))},'${(controllers[2]
                .text)}','${(controllers[1].text)}', @result);");

        result = await conn.execute("SELECT @result");
        if(result.rows.first.assoc().values.first == '1') return 'invalid input';

        return '';
      }
      on Exception catch (e)
      {
        return 'invalid input';
      }
    }else if(tableName=='vanzare')
    {
      try {
        await conn.execute(
            "CALL adaugare_vanzare(${(int.parse(controllers[1].text))},${int.parse(controllers[2]
                .text)},${(int.parse(controllers[3].text))},'${controllers[4].text}', @result);");

        result = await conn.execute("SELECT @result");
        if(result.rows.first.assoc().values.first == '1') return 'invalid input2';

        return '';
      }
      on Exception catch (e)
      {
        print(e);
        return 'invalid input';
      }
    }else if(tableName=='serviciu_programare')
    {
      try {
        await conn.execute(
            "CALL programare_serviciu('${(controllers[1]
                .text)}',${int.parse(controllers[2].text)}, @result);");

        result = await conn.execute("SELECT @result");
        if(result.rows.first.assoc().values.first == '1') return 'invalid input';

        return '';
      }
      on Exception catch (e)
      {
        return 'invalid input';
      }
    }

      await conn.close();
      return '';
}