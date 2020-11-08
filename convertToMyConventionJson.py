
import json


def makeObj(gu, la, en, pu):
    return {
        'line': {
            "gurmukhi": {
                "unicode": gu
            },
            "larivaar": {
                "unicode": la
            },
            "translation": {
                "english": {
                    "default": en
                },
                "punjabi": {
                    "default": {
                        "unicode": pu
                    }
                }
            }
        }
    }


with open('C:\\Users\\harde\\Downloads\\dukh.json', encoding="utf8") as f:
    _file = json.load(f)
    json_file = _file['verses']

new_json = []

for i in json_file:
    new_json.append(makeObj(i['verse']['verse']['unicode'], i['verse']['larivaar']['unicode'], i['verse']
                            ['translation']['en']['bdb'], i['verse']['translation']['pu']['ss']['unicode']))


complete_json = {
    'baniinfo': {
        'id': 8,
        'unicode': _file['baniInfo']['unicode'],
    },
    'bani': new_json
}

with open('dukh.json', 'w') as f:
    json.dump(complete_json, f)
