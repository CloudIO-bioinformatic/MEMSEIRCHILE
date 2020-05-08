import csv
import pymongo
from pymongo import MongoClient
import pprint
from random import randint


client = MongoClient('localhost',27017)
db = client['test-namverwan']
comunas = db['comunas']

with open('ready/datos_comunas.ready') as File:
    reader = csv.reader(File, delimiter='\t', quotechar='\t', quoting=csv.QUOTE_MINIMAL)
    for row in reader:
        comunas.insert_one({"nombre":row[1],"random int": randint(1,10)}).inserted_id

print(db.list_collection_names())
for comuna in comunas.find():
        pprint.pprint(comuna)

pprint.pprint(comunas.count_documents({}))
count = comunas.count_documents({})
print ("Hay: ",count," comunas")
pprint.pprint(comunas.find_one({"nombre":"Talca"}))
print ("Se cambia >Talca< por >Talca en cuarentena<")
comunas.update_one({"nombre":"Talca"}, {"$set":{"nombre":"Talca en cuarentena"}})

for comuna in comunas.find({'nombre':'Talca en cuarentena'}):
        pprint.pprint(comuna)
print("ok")

with open('ready/datos_comunas.ready') as File:
    reader = csv.reader(File, delimiter='\t', quotechar='\t', quoting=csv.QUOTE_MINIMAL)
    for row in reader:
        comunas.delete_many({"nombre":row[1]})
comunas.delete_many({"nombre":"Talca en cuarentena"})
pprint.pprint(comunas.count_documents({}))
count = comunas.count_documents({})
print ("Hay: ",count," comunas restantes, luego de la eliminación")
