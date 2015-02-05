lockfile=~/vesinfiltro.lock
trap "rm -f $lockfile; exit" INT TERM EXIT
lockfile $lockfile
bash ~/vesinfiltro/sync_experiments.sh
/usr/local/bin/centinel-dev
python ~/vesinfiltro/send_results.py
rm -f ~/vesinfiltro.lock
trap - INT TERM EXIT
