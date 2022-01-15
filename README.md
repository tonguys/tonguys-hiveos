# Полезная инфа

кусок доки по построению пакетов (не слишком много инфы): https://forum.hiveos.farm/t/custom-miner-integration/4521

Описание базовой структуры пакета: https://github.com/minershive/hiveos-linux/blob/master/hive/miners/custom/README.md

Другие примеры построения кастомных пакетов: http://download.hiveos.farm/custom/

Пакет для хайвы для pow-miner-gpu: https://github.com/tontechio/pow-miner-gpu-hiveos

Пакет разработчиков пула tonuniverce: https://github.com/tonuniverse/miningPoolCli/releases/download/v2.1.18/miningPoolCli-2.1.18-linux.tar.gz

# Что уже готово:

* h-manifest.conf -- более-менее заполнен, скорее всего, изменяться уже не должен, только касательно версии проекта
* h-config.sh -- успешно генерирует стоку через которую должен запускться клиент
* h-run.sh -- уже должен запускать пул

# Что надо деделать:

* h-stats.sh -- должен отдавать стаитстику касательно загрузки видюх, частоты оборотов вентиляторов и прочее, подробное описание см. полезную инфу и код в пакетах других майнеров
* проверить работоспособность написанных скриптов

# Примечания

tonguys_client - бинарник с нашим клиентом
tonguys_miner - бинарник pow-miner-gpu
