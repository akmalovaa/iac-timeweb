# Example IaC timeweb

Репозиторий для экспериментов с IaC Timeweb

**Цель:** 

Подготовить и запустить сервер с сервисами в docker-compose, используя простые подходы IaC для автоматизации

- Заказать VPS
- Установить docker, docker compose
- Загрузить docker-compose.yaml и файлы конфигураций сервисов
- Запустить

## Описание

### Сервер для мониторинга

В качестве примера сервиса в `docker-compose` буду использовать [Gatus](https://github.com/TwiN/gatus)

Дополнительно рядом добавлю сервисы **Prometheus** + **Grafana**



## Подготовка

### Установка

Для автотизации буду использовать:
- [Terraform](https://developer.hashicorp.com/terraform/install)
- [Ansible](https://docs.ansible.com/ansible/latest/installation_guide/intro_installation.html)
- [Taskfile](https://taskfile.dev/)

Можно установить локально или использовать готовый container image образ: `docker pull ghcr.io/akmalovaa/iac-tools`, где уже подготовил и собрал все необходимые компоненты

На локальной машине можно даже ничего не устанавливать кроме **docker**

Далее в примерах буду использовать именно данный способ

### Настройка

#### Учетная запись **timeweb**
Войти или зарегистрироваться [реф.ссылка](https://timeweb.cloud/r/cp14436)

#### Настройка проекта
В качестве названия проекта используется `homelab` нужно [создать](https://timeweb.cloud/my/projects) такой же или

поменять на свой проект в настройках `terraform/main.tf`
```
data "twc_projects" "terraform-project" {
  name = "homelab"
}
```


#### SSH key
Создать новые или использовать уже сгенерированные ранее ключи
- **private_key:** Используется для удобства подключения и работы Ansible 
- **public_key:** Добавляется на сервер при его создании

Необходимо свой **public_key** добавить в [панель управления](https://timeweb.cloud/my/sshkeys) назвал `monitoring`

Используется в `terraform/main.tf`
```
data "twc_ssh_keys" "ssh-key" {
  name = "monitoring"
}
```

**private_key** - для ansible использовать в > `ansible/ssh/id_rsa`


#### API keys

Создать здесь https://timeweb.cloud/my/api-keys

Использовать в переменных окружения `TF_VAR_TWC_TOKEN` или создать файл `terraform/env.auto.tfvars`
```toml
TWC_TOKEN = "eyJhbGcsaohjdshoaohgasgashod..."
```

#### Настройка сервера
Основные настройки в файле `terraform/main.tf`

Пример фиксированной настройки сервера по цене
```
data "twc_presets" "main-preset" {
  location = "ru-1"
  price_filter {
    from = 150
    to = 200
  }
```

> [!NOTE]
> Если по заданным критериям не обнаружит нужного тарифа, сервер создаваться не будет

Все доступные варианты, удобнее смотреть в интерфейсе Timeweb Cloud, на первых шагах создания сервера, в разделе выбор тарифа

Фильтровать можно не только по стоимости, но и по требуемым ресурсам (CPU, RAM, disk) и гео-расположению


#### Настройка сервисов

Конфигурационные файлы и `docker-compose.yaml` вынес в отдельную директорию

`./services/` 

Данную директорию сделал полностью независимым. 
Есть возможность даже без IaC автоматизаций вручную скопировать данную директорию и запустить локально или на сервере.

Для удобства настройки и конфигурирования основные переменные вынесены в файл:

- .gitab-variables.yaml


### Запуск 

Переменные подготовлены для запуска в gitlab ci/cd
Скрипт `variables-to-local.py` создает файл `.env` для локального запуска **docker** c нужными переменными окружения
```bash
python variables-to-local.py
```


Запуск контейнера в интерактивном режиме:

```bash
docker run --rm -it -v .:/srv --env-file .env ghcr.io/akmalovaa/iac-tools bash
```


#### Terraform 
```bash
task terraform:all
```

#### Ansible 
```bash
task ansible:play
```

> [!WARNING]  
> При запуске terraform возможны проблемы из-за ограничений доступа из РФ

В результате выполнения скрипта, должны получить готовый VPS сервер по выбранному тарифу и запущенные сервисы:
- {YOUR_IP}:8080 - Gatus
- {YOUR_IP}:9090 - Prometheus
- {YOUR_IP}:3000 - Grafana


## TODO:
- Добавить **domain name** через DNS **Cloudflare** и привязать к новому IP - SSL cert и proxy (nginx, traefik или caddy)
- Ansible **sync files** вместо **copy**
- Изучить **terragrount**
- Оповещение в **telegram** при завершении, что сервер поднялся и готов к работе (domain-name)