import json
import yaml
import os


def read_yaml(file):
    with open(file) as f:
        return yaml.safe_load(f)


def write_json(file, data):
    with open(file, 'w') as f:
        json.dump(data, f, indent=4)


def read_json(file):
    with open(file) as f:
        return json.load(f)


def convert_from(fr):
    d = {
        'key_code': fr['key_code'],
    }

    if 'modifiers' in fr:
        d['modifiers'] = {
            'mandatory': fr['modifiers']
        }

    return d


def convert_conditions(conditions):
    # TODO: Support other types
    return [{'type': key, 'bundle_identifiers': bunids} for key, bunids in conditions.items()]


def convert_rule(rule):
    m = {
        'type': 'basic',
        'from': convert_from(rule['from']),
        'to': rule['to'],
    }

    if 'conditions' in rule:
        m['conditions'] = convert_conditions(rule['conditions'])

    return {
        'description': rule['desc'],
        'manipulators': [m]
    }


def convert(obj):
    for rule in obj['rules']:
        yield convert_rule(rule)


configs_dir = os.path.dirname(os.path.realpath(__file__))

rules = []

for file in sorted(os.listdir(configs_dir)):
    if not file.endswith('karabiner.yml'):
        continue

    file = os.path.join(configs_dir, file)
    print(file)
    rules.extend(convert(read_yaml(file)))

karabiner_config_path = os.path.expanduser('~/.config/karabiner/karabiner.json')
karabiner_config = read_json(karabiner_config_path)
karabiner_config['profiles'][0]['complex_modifications']['rules'] = rules
write_json(karabiner_config_path, karabiner_config)
