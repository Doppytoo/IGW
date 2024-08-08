import json
from pathlib import Path
from pydantic import BaseModel


_DEFAULTS = {
    "PROMETHEUS_URL": {
        "value": "",
        "description": "Prometheus URL",
        "private": True,
    },
    "TG_BOT_TOKEN": {
        "value": "",
        "description": "Telegram bot token",
        "private": True,
    },
    "ping_interval": {
        "value": 10,
        "description": "Ping interval in minutes",
        "private": False,
    },
    "urgent_ping_interval": {
        "value": 5,
        "description": "Urgent ping interval in minutes",
        "private": False,
    },
}
BASE_DIR = str(Path(__file__).resolve().parent).replace("\\", "/")


class Setting(BaseModel):
    value: str | int | float | bool
    description: str
    private: bool


class Settings:
    data: dict[str, Setting]

    def __init__(self):
        self.data = {}

        try:
            with open(f"{BASE_DIR}/settings.json", "r") as f:
                raw_data = json.load(f)
        except FileNotFoundError:
            raw_data = _DEFAULTS.copy()

            with open(f"{BASE_DIR}/settings.json", "w") as f:
                json.dump(raw_data, f, indent=4)

        for key, value in raw_data.items():
            self.data[key] = Setting.model_validate(value)

    def __str__(self) -> str:
        return str(self.data)

    def update(self):
        json_data = {}
        for key, value in self.data.items():
            json_data[key] = value.model_dump()

        with open(f"{BASE_DIR}/settings.json", "w") as f:
            json.dump(json_data, f, indent=4)

    def refresh(self):
        try:
            with open(f"{BASE_DIR}/settings.json", "r") as f:
                raw_data = json.load(f)

            for key, value in raw_data.items():
                self.data[key] = Setting.model_validate(value)
        except FileNotFoundError:
            pass
        except json.JSONDecodeError:
            pass

    # def __getattr__(self, key: str):
    #     if key not in self.data.keys():
    #         raise KeyError(f"Setting '{key}' does not exist")
    #     return self.data[key]

    # def __setattr__(self, key: str, value: Setting) -> None:
    #     if key not in self.data.keys():
    #         raise KeyError(f"Setting '{key}' does not exist")
    #     self.data[key] = value

    # def __getitem__(self, key: str) -> Setting:
    #     if key not in self.data.keys():
    #         raise KeyError(f"Setting '{key}' does not exist")
    #     return self.data[key]

    # def __setitem__(self, key: str, value: Setting) -> None:
    #     if key not in self.data.keys():
    #         raise KeyError(f"Setting '{key}' does not exist")
    #     self.data[key] = value

    def get(self, key: str) -> str | int | float | bool:
        if key not in self.data.keys():
            raise KeyError(f"Setting '{key}' does not exist")
        return self.data[key].value

    def set(self, key: str, value) -> None:
        if key not in self.data.keys():
            raise KeyError(f"Setting '{key}' does not exist")
        self.data[key].value = value

        self.update()

    def is_private(self, key: str) -> bool:
        if key not in self.data.keys():
            raise KeyError(f"Setting '{key}' does not exist")
        return self.data[key].private

    def is_public(self, key: str) -> bool:
        if key not in self.data.keys():
            raise KeyError(f"Setting '{key}' does not exist")
        return not self.data[key].private

    def public(self):
        return {
            key: setting.value
            for key, setting in self.data.items()
            if not setting.private
        }


settings = Settings()

if __name__ == "__main__":
    print(settings)

    print(settings.get("ping_interval"))

    settings.set("ping_interval", 50)

    print(settings)
