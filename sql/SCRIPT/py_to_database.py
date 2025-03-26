from cars_info import cars_dict
import mysql.connector

db_name = 'mydb'
try:
    mydb = mysql.connector.connect(
        host='localhost',
        user='root',
        password='qwsdcvghyu123',
        database=db_name
    )
    if mydb.is_connected():
        print("Connected")
        cursor = mydb.cursor()

        insert_query = "INSERT INTO masina VALUES (%s, %s, %s, %s, %s, %s, %s, %s, %s, %s)"
        for id in cars_dict:
            cursor.execute(insert_query, (
                int(id+1),
                cars_dict[id]['Marca'],
                cars_dict[id]['Model'],
                str(cars_dict[id]['An_fabricatie']),
                cars_dict[id]['Tip_caroserie'],
                str(cars_dict[id]['Serie_sasiu']),
                cars_dict[id]['Culoare'],
                cars_dict[id]['Cp'],
                cars_dict[id]['Combustibil'],
                float(cars_dict[id]['Pret'])
            )
                 )
        mydb.commit()
        cursor.close()
        mydb.close()
        print("Database closed")

except mysql.connector.Error as error:
    print("Error something went wrong")





