import boto3
import csv
import re
import argparse

def main(update=False):
    dynamodb = boto3.resource('dynamodb')
    table = dynamodb.Table('Vim-notations')
    
    should_inserted = 0
    should_updated = 0
    inserted = 0
    updated = 0

    with open('Notations.csv', 'rb') as csvfile:
        notation_reader = csv.reader(csvfile, delimiter=',', quotechar='"', quoting=csv.QUOTE_ALL, skipinitialspace=True)
        for row in notation_reader:
            print "row = %s" % row
            title = row[0]
            content = row[1]
            response = table.get_item(Key = {'title': title})
            item = {'title':title, 'content':content}
            will_insert = False
            if 'Item' not in response: # new item
                should_inserted = should_inserted + 1
                will_insert = True
                print "Should insert item as %s" % item
            elif item != response['Item']: # existing item and needs update
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
    parser = argparse.ArgumentParser(description='Read a CSV file containing rows of Vim notations, and upload them to dynamodb table')
    parser.add_argument('--update', metavar='U', type=bool, nargs='?',
                   help="Update the row?", default=False)

    args = parser.parse_args()
    print args.update
    main(args.update)
