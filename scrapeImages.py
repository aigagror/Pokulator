from bs4 import BeautifulSoup
import requests
import urllib2
import os
import sys
import json
import glob


# adapted from http://stackoverflow.com/questions/20716842/python-download-images-from-google-image-search

def get_soup(url, header):
    return BeautifulSoup(urllib2.urlopen(urllib2.Request(url, headers=header)), 'html.parser')


def main(query, directory, num_images):
    query = query.split()
    query = '+'.join(query)
    url = "https://www.google.co.in/search?q=" + query + "&source=lnms&tbm=isch"
    header = {
        'User-Agent': "Mozilla/5.0 (Windows NT 6.1; WOW64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/43.0.2357.134 Safari/537.36"}
    soup = get_soup(url, header)
    ActualImages = []  # contains the link for Large original images, type of  image
    for a in soup.find_all("div", {"class": "rg_meta"}):
        link, Type = json.loads(a.text)["ou"], json.loads(a.text)["ity"]
        ActualImages.append((link, Type))

    count = 0
    for i, (img, Type) in enumerate(ActualImages):
        try:
            # Check if we have already downloaded this file
            if glob.glob(os.path.join(directory, 'img_{}*'.format(i))):
                continue

            req = urllib2.Request(img, headers={'User-Agent': header})
            raw_img = urllib2.urlopen(req).read()
            if len(Type) == 0:
                f = open(os.path.join(directory, "img" + "_" + str(i) + ".jpg"), 'wb')
            else:
                f = open(os.path.join(directory, "img" + "_" + str(i) + "." + Type), 'wb')
            f.write(raw_img)
            f.close()
            count += 1

        except Exception as e:
            print("could not load : " + img)
            print(e)

        if count >= num_images:
            break


if __name__ == '__main__':
    values = ['ace', 'two', 'three', 'four', 'five', 'six', 'seven', 'eight', 'nine', 'ten', 'jack', 'queen', 'king']
    suits = ['hearts', 'spades', 'clubs', 'diamonds']
    training_directory = '/Users/eddie/Desktop/training_data/'
    testing_directory = '/Users/eddie/Desktop/testing_data/'

    num_images = 10

    try:
        for i, value in enumerate(values):
            for suit in suits:
                num_existing_images = 0

                # Check if training_directory exists with num_images images already
                card_directory = training_directory + '{}_{}/'.format(value, suit)
                if os.path.isdir(card_directory):
                    num_existing_images = len(os.listdir(card_directory))
                    if num_existing_images >= num_images:
                        # skip
                        print("{} {} is already full".format(value, suit))
                        continue

                search_query = '{} {} card'.format(value, suit)
                try:
                    os.mkdir(card_directory)
                except:
                    # ignore the error
                    var = 0
                main(search_query, card_directory, num_images - num_existing_images)

            # Print progress
            print('{}%'.format(i/len(values)))
    except KeyboardInterrupt:
        pass
    sys.exit()
