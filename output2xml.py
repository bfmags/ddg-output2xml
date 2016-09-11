"""
 Generate a longtail XML dump of the Fathead output.txt
"""
import csv
import re

XML = """<?xml version="1.0" encoding="UTF-8"?>
<add allowDups="true">
{results}
</add>
"""

DOC = """<doc>
  <field name="title"><![CDATA[{title}]]></field>
    <field name="l2_sec"><![CDATA[{title_strip}]]></field>
  <field name="paragraph"><![CDATA[{abstract} <a href="{source_url}">{source_url}</a>]]></field>
  <field name="p_count">1</field>
  <field name="source"><![CDATA[mdn_js]]></field>
</doc>"""

class FatWriter(object):
    """ File writer class for DDG Fathead files @ericdens """

    FIELDS = [
      'title',
      'type',
      'redirect',
      'otheruses',
      'categories',
      'references',
      'see_also',
      'further_reading',
      'external_links',
      'disambiguation',
      'images',
      'abstract',
      'source_url'
    ]

    def __init__(self, outfile):
        self.outfile = outfile

    def writerow(self, outdict):
        """ Write the dict row. """
        row = []
        for field in FatWriter.FIELDS:
            col = outdict.get(field, '')
            col = col.replace('\t', '    ')
            col = col.replace('\n', '\\n')
            row.append(col)
        self.outfile.write('\t'.join(row) + '\n')

def run(infname, outfname):
    infile = open(infname)
    reader = csv.DictReader(infile, FatWriter.FIELDS, dialect='excel-tab')
    with open(outfname, 'w') as outfile:
        rows = []
        for line in reader:
            if line['type'] == "A":
                line['title_strip'] = re.sub(r'[^\w\s]',' ',line['title'])
                rows.append(DOC.format(**line))
        results = '\n'.join(rows)
        outfile.write(XML.format(results=results).replace('\\n', '\n'))

if __name__ == '__main__':
    infname = 'output.txt'
    outfname = 'output.xml'
    run(infname, outfname)