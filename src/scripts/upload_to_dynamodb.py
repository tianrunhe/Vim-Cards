import boto3
import csv
import re

def main():
    dynamodb = boto3.resource('dynamodb')
    table = dynamodb.Table('Vim-commands')
    
    updated = 0
    inserted = 0

    with open('Learn Vim Progressively.csv', 'rb') as csvfile:
        command_reader = csv.reader(csvfile, delimiter=',', quotechar='"')
        for row in command_reader:
            title = row[0]
            usage = row[1]
            content = row[2]
            tags = re.split(',\s+', row[3])
            response = table.get_item(Key = {'title': title})
            item = {'title':title, 'usage':usage,'content':content,'tag':tags}
            if 'Item' not in response: # new item
                inserted = inserted + 1
            elif item != response['Item']: # existing item and needs update
                item['tag'] = list(set(response['Item']['tag'] + tags))
                updated = updated + 1
                print "Updating item %s" % item
            table.put_item(Item=item)

        print "Inserted %s row; Updated %s rows" % (inserted, updated)

if __name__ == '__main__':
    main()
