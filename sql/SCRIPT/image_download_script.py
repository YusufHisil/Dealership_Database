import os.path
import requests
import json
from api import cars_dict
import re
from bs4 import BeautifulSoup
# TODO: NIGGER
# api_key = 'https://pixabay.com/api/?key=41201136-a284cd4047281cd88fc9a7cd2&q=audi+a6&image_type=photo'
# response = requests.get(api_key)
# response_json = json.loads(response.text)
#
# url = response_json['hits'][4]['previewURL']
#
CARS_NAME = ""
photo_url = f"https://www.google.com/search?q={CARS_NAME}&tbm=isch"


def name_parser(marca: str, model: str, color: str, messg: str) -> str:
    converted_to_search_name = f"{marca}%20"

    split_model = re.findall(r'\b\w+\b', model)
    for word in split_model:
        converted_to_search_name += f"{word}%20"

    # Add the color to the search name
    converted_to_search_name += f"{color}%20"
    converted_to_search_name += f"{messg}%20"
    print(converted_to_search_name)
    return converted_to_search_name


def img_download(url: str, car_ind: int):

    download_resp = requests.get(url)
    if download_resp.status_code == 200:
        print(f"Downloaded car at {car_ind}")
        with open(f"img2/img_{str(car_ind)}.jpg", "wb") as handler:
            handler.write(download_resp.content)
    else:
        print('ERROR AT DOWNLOAD')



for ind, car_dict in cars_dict.items():
    CARS_NAME = name_parser(car_dict['Marca'], car_dict['Model'], car_dict['Culoare'], 'hd')
    photo_url = f'https://www.google.com/search?q={CARS_NAME}&tbm=isch'

    print(photo_url)

    response = requests.get(photo_url)

    if response.status_code == 200:
        soup = BeautifulSoup(response.text, "html.parser")
        image_url = f'https://www.google.com/search?q={CARS_NAME}&tbm=isch' + soup.select_one("a:has(>img)")["href"]
        img_tag = soup.find_all("a")
        filtered_img_tags = [tag for tag in img_tag if tag.get('href') and tag['href'].startswith('https://unsplash.com/s/photos/audi-a4')]

        print(img_tag)
        tag_to_url = [img['href'] for img in img_tag]
        good_tag = tag_to_url[1]
        #print(good_tag)
        img_download(good_tag, ind)


