from ..data.db import get_session
from ..data.models import User, TelegramAccount


def main() -> None:
    with get_session() as sess:
        new_user = User(
            username="Artem",
            password="12345678",
        )

        new_user.telegram_accounts.append(
            TelegramAccount(
                token="asdfghjkl",
            )
        )

        sess.add(new_user)
        sess.commit()


if __name__ == "__main__":
    main()
