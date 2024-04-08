""" 
Переменные подготовлены для запуска в gitlab ci/cd
Этот скрипт создает файл .env для локального запуска docker c нужными переменными окружения
Пример: docker run --rm -it -v .:/srv --env-file .env ghcr.io/akmalovaa/iac-tools bash
"""

import yaml


def yaml_to_env(yaml_file, env_file):
    with open(yaml_file, "r") as f:
        data = yaml.safe_load(f)

    with open(env_file, "w") as f:
        for key, value in data["variables"].items():
            f.write(f"{key.upper()}={value}\n")


yaml_to_env(".gitlab-variables.yaml", ".env")