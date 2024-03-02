# Marca -> make
# Model -> model
# An_fabricatie -> year
# Tip_caroserie -> vclass           Sedan, HatchBack, Break, Suv, Coupe, Berlina, Cabrio
# Serie_sasiu -> id
# Culoare -> generate
# Cp-> generate
# Combustibil-> fueltype1
import random

from api import cars_dict

color = ['Alba', 'Gri', 'Neagra', 'Albastra', 'Rosie']
combustibil = ['Electric', 'Benzina', 'Diesel']
cp = range(100, 1001)
caroserie = ['Sedan', 'Hatchback', 'Break', 'Suv', 'Coupe', 'Berlina', 'Cabrio']
for id in cars_dict:
    if cars_dict[id]['Cp'] == 0:
        cars_dict[id]['Cp'] = random.choice(cp)
    if 'Gasoline' in cars_dict[id]['Combustibil']:
        cars_dict[id]['Combustibil'] = 'Benzina'
    elif cars_dict[id]['Combustibil'] in 'Electricity':
        cars_dict[id]['Combustibil'] = 'Electric'
    elif cars_dict[id]['Combustibil'] in 'Diesel':
        cars_dict[id]['Combustibil'] = 'Diesel'
    else:
        cars_dict[id]['Combustibil'] = random.choice(combustibil)

    cars_dict[id]['Culoare'] = random.choice(color)
    cars_dict[id]['Tip_caroserie'] = random.choice(caroserie)


for id in cars_dict:
    cars_dict[id]['Pret'] = int(cars_dict[id]['An_fabricatie']) * cars_dict[id]['Cp'] / 10


