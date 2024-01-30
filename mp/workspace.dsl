workspace "МП" "Архитектура решения мобильного приложения" {

    model {

# Пользователи
        operator = person "Гражданин" "Использует МП для предоставления документов"


# Системы

        !include lib/czp.dsl
        !include lib/suu.dsl
        !include lib/splunk.dsl
        !include lib/mpandroid.dsl
        !include lib/mpios.dsl
        !include lib/mphuawei.dsl
        !include lib/mp.dsl

## Взаимодействия систем
        operator -> mpandroid "Взаимодействует с приложением" "Физически"
        operator -> mpios "Взаимодействует с приложением" "Физически"
        operator -> mphuawei "Взаимодействует с приложением" "Физически"
        1s = mp -> suu "1,2 Аутентификация и работа с токенами пользователей" "REST"
        4s = mp -> suu "4. Получение атрибутов пользователя системы учета пользователей" "REST"
        5s = mp -> czp "5. Запрос и предоставление сведений пользователя системы заявок пользователей" "REST"
        9s = mp -> splunk "9. Журналирование" "stdout"
        mpandroid -> suu "3. Аутентификация по редиректу" "HTTPS"
        mpios -> suu "3. Аутентификация по редиректу" "HTTPS"
        mphuawei -> suu "3. Аутентификация по редиректу" "HTTPS"

## Конец взаимодействия систем

# Взаимодействие контейнеров

        1c = mp_mpcore -> suu "1,2 Проверка сессии системы учета пользователей" "REST"

        5_1c = mp_czp -> czp "5. Запрос и предоставление сведений пользователя системы заявок пользователей" "REST"
        9c1 = mp_mpcore -> splunk "9. Журналирование" "stdout, json"
        9c2 = mp_profile -> splunk "9. Журналирование" "stdout, json"
        9c3 = mp_czp -> splunk "9. Журналирование" "stdout, json"

        mpandroid -> mp_mpcore "Запрос сведений пользователя для отображения" "REST"
        mpios -> mp_mpcore "Запрос сведений пользователя для отображения" "REST"
        mphuawei -> mp_mpcore "Запрос сведений пользователя для отображения" "REST"

        19c = mp_mpcore -> mp_session_redis "19. Обновление сведений о сессиях" "noSQL"
        20c = mp_mpcore -> mp_core_db "20. Сохраняет информацию о настройках пользователей, получает схему данных, журналирует входы пользователей" "SQL"

# Выделение микросервиса сбора данных
        4c1 = mp_suu_data -> suu "4. Получение атрибутов пользователя системы учета пользователей" "REST"
        21c1 = mp_profile -> mp_czp "21. Запрос сведений по пользователю" "REST"
        21c2 = mp_mpcore -> mp_profile "21. Запрос сведений по пользователю" "REST"
        23 = mp_profile -> mp_profile_db "23. Чтение, сохранение и удаление сведений пользователя" "noSQL"
        24c1 = mp_czp -> mp_czp_db "24. Получение/обновление схемы данных, справочников" "SQL"
        4c2 = mp_profile -> mp_suu_data "4. Запрос атрибутов пользователя системы учета пользователей" "REST"
        24c2 = mp_suu_data -> mp_suu_data_db "24. Получение/обновление схемы данных, справочников" "SQL"
        24c3 = mp_profile -> mp_profile_db "24. Получение/обновление схемы данных, справочников" "SQL"
        9c7 = mp_suu_data -> splunk "9. Журналирование" "stdout, json"

# Конец взаимодействия контейнеров

    }

    views {

        systemlandscape "mp-01-SystemLandscape" "Системный ландшафт" {
            title "[мобильное приложение-01] Схема системного ландшафта работы мобильного приложения"
            include *
        }

        container mp "mp-02-Containers" "Диаграмма контейнеров" {
            title "[мобильное приложение-02] Схема контейнеров бэкенда мобильного приложения"
            include *
        }


        styles {

            element "Person" {
                shape person
                background #08427b
                color #ffffff
            }

            element db {
                shape cylinder
                #background #08427b
                #color #ffffff
            }

            element Москва {
                background #CC2222
                color #ffffff
            }

            relationship problem {
                color #CC2222
            }
        }


        terminology {
            enterprise "Организация"
            person "Пользователь"
            softwareSystem "Информационная система"
            container "Контейнер"
            component "Компонент"
            deploymentNode "Нода"
            infrastructureNode "Хост"
            relationship "Взаимодействие"
        }
    }

}
