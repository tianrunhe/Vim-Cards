import boto3
import csv
import re
import argparse

def main(overwrite=False, update=False):
    dynamodb = boto3.resource('dynamodb')
    table = dynamodb.Table('Vim-commands')
    
    should_inserted = 0
    should_updated = 0
    inserted = 0
    updated = 0

    with open('Commands.csv', 'rb') as csvfile:
        command_reader = csv.reader(csvfile, delimiter=',', quotechar='"', quoting=csv.QUOTE_ALL, skipinitialspace=True)
        for row in command_reader:
            print "row = %s" % row
            title = row[0]
            usage = row[1]
            content = row[2]
            tags = re.split(',\s+', row[3])
            response = table.get_item(Key = {'title': title})
            item = {'title':title, 'usage':usage,'content':content,'tags':tags}
            will_insert = False
            if 'Item' not in response: # new item
                should_inserted = should_inserted + 1
                will_insert = True
                print "Should insert item as %s" % item
            elif item != response['Item']: # existing item and needs update
                if not overwrite:
                    item['tags'] = list(set(response['Item']['tags'] + tags))
                should_updated = should_updated + 1
                print "Should update item as %s" % item
            else: # no differences
                continue

            if update:
                table.put_item(Item=item)
                if will_insert:
                    inserted = inserted + 1
                    print "Inserted item as %s" % item
                else:
                    updated = updated + 1
                    print "Updated item as %s" % item
        if update:
            print "Inserted %s row; Updated %s rows" % (inserted, updated)
        else:
            print "%s rows need to be updated; %s rows need to be inserted." % (should_updated, should_inserted)

if __name__ == '__main__':
    parser = argparse.ArgumentParser(description='Read a CSV file containing rows of Vim commands, and upload them to dynamodb table')
    parser.add_argument('--overwrite', metavar='O', type=bool, nargs='?',
                   help="Override the row?", default=False)
    parser.add_argument('--update', metavar='U', type=bool, nargs='?',
                   help="Update the row?", default=False)

    args = parser.parse_args()
    print args.overwrite, args.update
    main(args.overwrite, args.update)
