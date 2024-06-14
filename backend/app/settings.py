import json
from pathlib import Path

_DEFAULTS = {
    "PROMETHEUS_URL": "",
    "TG_BOT_TOKEN": "",
}
BASE_DIR = str(Path(__file__).resolve().parent).replace("\\", "/")

print(BASE_DIR)


class Settings:
    data: dict

    def __init__(self):
        self.data = {}

        try:
            with open(f"{BASE_DIR}/settings.json", "r") as f:
                self.data = json.load(f)

        except json.JSONDecodeError:
            with open(f"{BASE_DIR}/settings.json", "w") as f:
                json.dump(_DEFAULTS, open(f"{BASE_DIR}/settings.json", "w"))

            self.data = _DEFAULTS.copy()

        except FileNotFoundError:
            with open(f"{BASE_DIR}/settings.json", "w") as f:
                json.dump(_DEFAULTS, open(f"{BASE_DIR}/settings.json", "w"))

            self.data = _DEFAULTS.copy()

    def __str__(self) -> str:
        return str(self.data)

    def set(self, key: str, value) -> None:
        self.data[key] = value

        with open(f"{BASE_DIR}/settings.json", "w") as f:
            json.dump(self.data, open(f"{BASE_DIR}/settings.json", "w"))

    def get(self, key: str):
        return self.data.get(key, None)

    def __getitem__(self, key: str):
        return self.data[key]

    def __setitem__(self, key: str, value):
        self.data[key] = value
