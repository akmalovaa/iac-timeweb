#!/bin/bash
# To quickly import the server status on other devices
# Сохранить название и id сервера для импорта при потере состояния
terraform import twc_server.${name} ${id}