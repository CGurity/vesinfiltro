lockfile="~/vesinfiltro/vesinfiltro.lock"
trap "rm -f $lockfile; exit" INT TERM EXIT
lockfile $lockfile
bash ~/vesinfiltro/sync_experiments.sh
centinel-dev
python ~/vesinfiltro/send_results.py
rm -f ~/vesinfiltro/vesinfiltro.lock
trap - INT TERM EXIT