import json
import yaml
import os


def read_yaml(file):
    with open(file) as f:
        return yaml.safe_load(f)


def write_json(file, data):
    with open(file, "w") as f:
        json.dump(data, f, indent=4)


def read_json(file):
    with open(file) as f:
        return json.load(f)


def convert_from(fr):
    d = {}

    for key, val in fr.items():
        if key == "modifiers":
            d[key] = {"mandatory": val}
        else:
            d[key] = val

    return d


def convert_conditions(conditions):
    if isinstance(conditions, list):
        return conditions
    else:
        # TODO: Support other types
        return [
            {"type": key, "bundle_identifiers": bunids}
            for key, bunids in conditions.items()
        ]


def convert_rule(rule):
    m = {
        "type": "basic",
        "from": convert_from(rule["from"]),
    }

    if "conditions" in rule:
        m["conditions"] = convert_conditions(rule["conditions"])

    for key, val in rule.items():
        if (key == "to" or key.startswith("to_")) and key not in m:
            m[key] = val

    return {"description": rule["desc"], "manipulators": [m]}


def convert(obj):
    for rule in obj["rules"]:
        yield convert_rule(rule)


configs_dir = os.path.dirname(os.path.realpath(__file__))

rules = []

for file in sorted(os.listdir(configs_dir)):
    if not file.endswith("karabiner.yml"):
        continue

    file = os.path.join(configs_dir, file)
    print(file)
    rules.extend(convert(read_yaml(file)))

karabiner_config_path = os.path.expanduser("~/.config/karabiner/karabiner.json")
karabiner_config = read_json(karabiner_config_path)
karabiner_config["profiles"][0]["complex_modifications"]["rules"] = rules
write_json(karabiner_config_path, karabiner_config)
