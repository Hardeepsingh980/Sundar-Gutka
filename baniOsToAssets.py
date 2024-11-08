import json
import sqlite3
import os
from gurmukhiutils.unicode import unicode

# Create new_assets directory if it doesn't exist
if not os.path.exists('assets'):
    os.makedirs('assets')
if not os.path.exists('assets/data'):
    os.makedirs('assets/data')

# Connect to database
conn = sqlite3.connect('database.sqlite')
cursor = conn.cursor()

# Get all banis
cursor.execute('''
    SELECT id, name_gurmukhi, name_english 
    FROM banis
''')
banis = cursor.fetchall()

# Create bani.json
bani_json = []
for bani in banis:
    bani_json.append({
        'id': bani[0],
        'akhar': bani[1],
        'unicode': unicode(bani[1]),
        'english': bani[2]
    })

# Write bani.json
with open('assets/data/bani.json', 'w', encoding='utf-8') as f:
    json.dump(bani_json, f, ensure_ascii=False, indent=4)

# For each bani, get its lines and create individual JSON files
for bani in banis:
    bani_id = bani[0]
    
    # Get bani lines
    cursor.execute('''
        SELECT bl.line_id, bl.line_group, l.*,
               t_en.translation as english_translation,
               t_pu.translation as punjabi_translation,
               l.type_id
        FROM bani_lines bl
        JOIN lines l ON bl.line_id = l.id
        LEFT JOIN translations t_en ON bl.line_id = t_en.line_id AND t_en.translation_source_id = 1
        LEFT JOIN translations t_pu ON bl.line_id = t_pu.line_id AND t_pu.translation_source_id = 6
        WHERE bl.bani_id = ?
        ORDER BY bl.line_group, l.order_id
    ''', (bani_id,))
    
    bani_lines = cursor.fetchall()
    
    bani_data = {
        'baniinfo': {
            'id': bani[0],
            'akhar': bani[1],
            'unicode': unicode(bani[1]),
            'english': bani[2]
        },
        'lines': []
    }
    
    for line in bani_lines:
        gurmukhi_text = line[7] if line[7] else ''
        unicode_text = unicode(gurmukhi_text)

        
        line_data = {
            'line': {
                'id': line[0],  # id varchar(4)
                'type': line[15],  # type_id
                'shabadid': line[1],  # shabad_id varchar(3)
                'gurmukhi': {
                    'akhar': line[8],  # gurmukhi text
                    'unicode': unicode(line[8]) if line[8] else ''
                },
                'larivaar': {
                    'akhar': line[8].replace(' ', '\u200b') if line[8] else '',
                    'unicode': unicode(line[8]).replace(' ', '\u200b') if line[8] else ''
                },
                'translation': {
                    'english': {
                        'default': line[13] if line[13] else ''  # english_translation
                    },
                    'punjabi': {
                        'default': {
                            'akhar': line[14] if line[14] else '',  # punjabi_translation
                            'unicode': unicode(line[14]) if line[14] else ''
                        }
                    }
                },
                'transliteration': {
                    'english': {
                        'text': line[6],  # first_letters
                        'larivaar': line[7]  # vishraam_first_letters
                    },
                    'devanagari': {
                        'text': line[8],  # gurmukhi
                        'larivaar': line[8].replace(' ', '\u200b') if line[8] else ''
                    }
                },
                'pageno': line[2],  # source_page
                'lineno': line[3],  # source_line
            }
        }
        bani_data['lines'].append(line_data)

    # Write individual bani JSON file
    with open(f'assets/data/{bani_id}.json', 'w', encoding='utf-8') as f:
        json.dump(bani_data, f, ensure_ascii=False, indent=4)

conn.close()
