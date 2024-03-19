# Example IaC timeweb

Репозиторий для экспериментов с IaC Timeweb

**Цель:** Инфраструктура как код, создать сервер мониторинга, настроенный и готовый к работе, нажатием одной кнопки

- Заказать VPS
- Установить docker, docker compose
- Загрузить docker-compose.yaml и файлы конфигураций сервисов
- Запустить

## Описание

### Сервер для мониторинга

В качестве примера буду использовать сервис [Gatus](https://github.com/TwiN/gatus)

В отличии от **uptime-kuma** позволяет гибко настроить конфигурацию в `.yaml` формате

Дополнительно в нагрузку подниму сервисы **Prometheus** + **Grafana**, все сервисы будут в `docker-compose`

- **Terraform** - создание VPS
- **Ansible** - установка софта, передача конфигурациионных файлов и запуск сервисов



## Подготовка

### Установить

#### [Terraform](https://developer.hashicorp.com/terraform/install)
Использовать локально или внутри подготовленного образа docker

#### [Ansible](https://docs.ansible.com/ansible/latest/installation_guide/intro_installation.html)
Использовать локально или внутри подготовленного образа docker

#### [Taskfile](https://taskfile.dev/)
Удобное использование заготовленных команд

#### [Docker](https://docs.docker.com/engine/install) ⭐
Удобнее использовать **docker image** c уже подготовленным окружением и установленными:
- Ansible
- Terraform
- Taskfile

На локальной машине можно даже ничего не устанавливать кроме docker, но все равно рекомендовал бы Taskfile поставить

**Собрать docker image**
```bash
task build
```
или
```bash
docker build -t iactools .
```

> [!WARNING]  
> При локальной сборке Dockerfile возможны проблемы из-за ограничений доступа hashicorp (использовать VPN)

Или использовать готовый image: `docker pull iactools:latest` (пока недоступно исправлю как залью на github registry)



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

Использовать в `terraform/env.auto.tfvars`
```toml
twc_token = "eyJhbGcsaohjdshoaohgasgashod..."
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
> Если не попасть ни в один фильтр, сервер не создастся


#### Настройка сервисов

Основные настройки в файле `.env`

Тонкая настройка сервисов в `ansible/docker/` 

---

## Основные команды

### All in one

Сделать хорошо - одной командой

Использовать в CI или вручную

```bash
task all_in
```

Вариант без Taskfile 
```bash
docker run --rm -it -v .:/srv --env-file .env iactools task all_in
```

Если есть **API-key, ssh-key** и **название проекта в Timeweb**.
Все заработает с **default** переменными

Если запустить повторно, ничего не сломается


---

#### Dev/Debug команды

Перейти в контейнер **iac tools**

```bash
task bash
```
или
```bash
docker run --rm -it -v .:/srv --env-file .env iactools bash
```

### Terraform 

```bash
task terraform:all
```

### Ansible 

```bash
task ansible:play
```

## TODO:
- Добавить **domain name** через DNS **Cloudflare** и привязать к новому IP - SSL cert и proxy (nginx, traefik или caddy)
- Ansible **sync files** вместо **copy**
- Проверить **terragrount**
- Оповещение в **telegram** при завершении, что сервер поднялся и готов к работе (domain-name)