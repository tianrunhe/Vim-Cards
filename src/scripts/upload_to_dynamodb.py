import boto3
import csv
import re
import argparse

def main(overwrite=False, update=False):
    dynamodb = boto3.resource('dynamodb')
    table = dynamodb.Table('Vim-commands')
    
    updated = 0
    inserted = 0
    should_updated = 0

    with open('Learn Vim Progressively.csv', 'rb') as csvfile:
        command_reader = csv.reader(csvfile, delimiter=',', quotechar='"', quoting=csv.QUOTE_ALL, skipinitialspace=True)
        for row in command_reader:
            title = row[0]
            usage = row[1]
            content = row[2]
            tags = re.split(',\s+', row[3])
            response = table.get_item(Key = {'title': title})
            item = {'title':title, 'usage':usage,'content':content,'tags':tags}
            if 'Item' not in response: # new item
                inserted = inserted + 1
                should_updated = should_updated + 1
            elif item != response['Item']: # existing item and needs update
                if overwrite:
                    item['tags'] = response['Item']['tag']
                else:
                    item['tags'] = list(set(response['Item']['tag'] + tags))
                updated = updated + 1
                should_updated = should_updated + 1

            print "Updating/Inserting item as %s" % item
            if update:
                table.put_item(Item=item)
        if update:
            print "Inserted %s row; Updated %s rows" % (inserted, updated)
        else:
            print "%s rows needs to be updated/inserted." % should_updated

if __name__ == '__main__':
    parser = argparse.ArgumentParser(description='Read a CSV file containing rows of Vim commands, and upload them to dynamodb table')
    parser.add_argument('--overwrite', metavar='O', type=bool, nargs='?',
                   help="Override the row?", default=False)
    parser.add_argument('--update', metavar='U', type=bool, nargs='?',
                   help="Update the row?", default=False)

    args = parser.parse_args()
    print args.overwrite, args.update
    main(args.overwrite, args.update)
