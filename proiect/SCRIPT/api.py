import requests
import json

#
api_key = ('https://public.opendatasoft.com/api/explore/v2.1/catalog/datasets/all-vehicles-model/records?limit=100'
           '&refine=make%3A%22Audi%22')
api_dict = {
    'audi': 'https://public.opendatasoft.com/api/explore/v2.1/catalog/datasets/all-vehicles-model/records?limit'
            '=100&refine=make%3A%22Audi%22',
    'porsche': 'https://public.opendatasoft.com/api/explore/v2.1/catalog/datasets/all-vehicles-model/records?limit'
               '=100&refine=make%3A%22Porsche%22',
    'mercedes': 'https://public.opendatasoft.com/api/explore/v2.1/catalog/datasets/all-vehicles-model/records?limit'
                '=100&refine=make%3A%22Mercedes-Benz%22',
    'volvo': 'https://public.opendatasoft.com/api/explore/v2.1/catalog/datasets/all-vehicles-model/records?limit'
             '=100&refine=make%3A%22Volvo%22',

}
cars_dict = {

}
cnt = 0
for car_name in api_dict:
    response = requests.get(api_dict[car_name])
    response_json = json.loads(response.text)
    for idx, car in enumerate(response_json['results']):
        cars_dict[idx + cnt] = {
            'Marca': car['make'],
            'Model': car['model'],
            'An_fabricatie': car['year'],
            'Tip_caroserie': car['vclass'],
            'Serie_sasiu': car['id'],
            'Culoare': '',
            'Cp': 0,
            'Combustibil': car['fueltype1'],
            'Pret': 0
        }
    cnt += 100
